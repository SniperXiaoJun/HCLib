//
//  CSIIUIVXWebCachingURLProtocol.m
//  LibCommcation
//
//  Created by 刘旺 on 13-5-14.
//  Copyright (c) 2013年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import "CPUIVXWebCachingURLProtocol.h"
#import "CPCacheUtility.h"
#import "CPContext.h"
#import "CPDebug.h"
static NSString* CSIICachingURLHeader = @"X-CSIICache";

static NSArray* fileInfos = nil;
static CSIIMADPZipFile * unzipFile = nil;
static NSString* curZipFile = nil;
static NSString* zipFileName = nil;
static NSString* zipPasscode = nil;
#define CPLIBRARY_FOLDER(fileName)                                        \
    [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/CPMenu"] \
        stringByAppendingPathComponent:fileName]
@interface CPUIVXWebCachingURLProtocol ()
@property (nonatomic, readwrite, strong) NSURLRequest* request;
@property (nonatomic, readwrite, strong) NSURLConnection* connection;
@property (nonatomic, readwrite, strong) NSMutableData* data;
@property (nonatomic, readwrite, strong) NSURLResponse* response;
- (void)appendData:(NSData*)newData;
@end

@implementation CPUIVXWebCachingURLProtocol {
}
@synthesize request = request_;
@synthesize connection = connection_;
@synthesize data = data_;
@synthesize response = response_;

+ (BOOL)canInitWithRequest:(NSURLRequest*)request
{

    if (([[[request URL] scheme] isEqualToString:@"http"] ||
            [[[request URL] scheme] isEqualToString:@"https"] ||
            [[[request URL] scheme] isEqualToString:@"file"]) &&
        [request valueForHTTPHeaderField:CSIICachingURLHeader] == nil &&
        [[[request URL] absoluteString] rangeOfString:@".apple.com"].location == NSNotFound &&
        [[[request URL] absoluteString] rangeOfString:@".do"].location == NSNotFound /*过滤掉.do交易*/
        &&
        [[[request URL] absoluteString] rangeOfString:@".json"].location == NSNotFound /*过滤掉.do交易*/ &&
        [[[request URL] absoluteString] rangeOfString:@".zip"].location == NSNotFound /*过滤掉.do交易*/) {

        return YES;
    }
    return NO;
}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)request
{
    return request;
}
- (id)initWithRequest:(NSURLRequest*)request
       cachedResponse:(NSCachedURLResponse*)cachedResponse
               client:(id<NSURLProtocolClient>)client
{
    NSMutableURLRequest* myRequest = [request mutableCopy];
    [myRequest setValue:@"" forHTTPHeaderField:CSIICachingURLHeader];

    self = [super initWithRequest:myRequest
                   cachedResponse:cachedResponse
                           client:client];

    if (self) {
        [self setRequest:myRequest];
    }
    return self;
}

- (NSString*)cachePathForRequest:(NSURLRequest*)aRequest
{
    NSString* cachesPath = [NSSearchPathForDirectoriesInDomains(
        NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [cachesPath
        stringByAppendingPathComponent:
            [NSString stringWithFormat:@"%lx",
                      (unsigned long)[[
                          [aRequest URL] absoluteString] hash]]];
}

- (void)startLoading
{

    NSString* url = [[[self request] URL] absoluteString];
//     TODO: 去掉注释
//    CPDLog(@"CSIIWebProtocol_url:%@", url);

    //去掉scheme和ip，只保留路径部分
    NSString* filePath = [[[self request] URL] path];

//     TODO: 去掉注释
//    CPDLog(@"CPWebProtocol_filePath:%@", filePath);

    NSString* mimeType = @"application/octet-stream";
    if ([url rangeOfString:@".js"].location != NSNotFound) {
        mimeType = @"text/javascript";
    }
    else if ([url rangeOfString:@".css"].location != NSNotFound) {
        mimeType = @"text/css";
    }
    else if ([url rangeOfString:@".html"].location != NSNotFound) {
        mimeType = @"text/html";
    }
    else if ([url rangeOfString:@".txt"].location != NSNotFound) {
        mimeType = @"text/plain";
    }
    else if ([url rangeOfString:@".xml"].location != NSNotFound) {
        mimeType = @"text/xml";
    }
    else if ([url rangeOfString:@".ttf"].location != NSNotFound) {
        mimeType = @"application/x-font-ttf";
    }
    else if ([url rangeOfString:@".png"].location != NSNotFound) {
        mimeType = @"image/png";
    }
    else if ([url rangeOfString:@".json"].location != NSNotFound) {
        mimeType = @"text/plain";
    }
    else if ([url rangeOfString:@".gif"].location != NSNotFound) {
        mimeType = @"image/png";
    }

    NSString* filePath1 = filePath;
    NSString* bundlePath = [[NSBundle mainBundle] resourcePath];

    if ([url hasPrefix:@"file:"] &&
        [url hasPrefix:[NSString stringWithFormat:@"file://%@", bundlePath]]) {

        filePath1 = [filePath substringFromIndex:bundlePath.length + 1];
    }
    else if ([url hasPrefix:@"file:"]) {
        filePath1 = [filePath substringFromIndex:10];
    }
    else {
        filePath1 = [filePath substringFromIndex:1];
    }

    //     TODO: 去掉注释
//    CPDLog(@"path_url1:--------%@", filePath1);
    NSData* data;

    zipFileName = [[CPCacheUtility sharedInstance] readZipName:filePath1];
    if ([CPCacheUtility sharedInstance].isCacheProtocol) {

        //要查找的zip包
        if (![curZipFile isEqualToString:zipFileName] && zipFileName) {

//            CPDLog(@"zipFileName:%@", zipFileName);

            zipPasscode = [[CPCacheUtility sharedInstance] readInfoToSql:zipFileName
                                                                withType:@"passcode"];
            curZipFile = zipFileName;
            NSString* zipFilePath = CPLIBRARY_FOLDER(zipFileName);
            // TODO:注释打印
//            CPDLog(@"path_zipurl:%@", zipFilePath);
            unzipFile =
                [[CSIIMADPZipFile alloc] initWithFileName:zipFilePath
                                             mode:CSIIMADPZipFileModeUnzip];

            if (unzipFile) {
                fileInfos = [unzipFile listFileInZipInfos];
            }
        }

        BOOL isGetFromServer = YES;

        if (([filePath1 length] == 0) || ([url rangeOfString:@".do"].length != 0)) {
            //.do交易要从服务器读取
            isGetFromServer = YES;
        }
        else { //其他情况
            isGetFromServer = NO;
        }

        if (isGetFromServer == YES) {
            //从服务器读取。

            NSMutableURLRequest* myRequest = [[self request] mutableCopy];
            [myRequest setValue:@"" forHTTPHeaderField:CSIICachingURLHeader];
            NSURLConnection* connection =
                [NSURLConnection connectionWithRequest:myRequest
                                              delegate:self];
            [self setConnection:connection];
        }
        else {

            for (CSIIMADPFileInZipInfo* info in fileInfos) {

                if ([info.name isEqualToString:filePath1]) {
                    [unzipFile locateFileInZip:info.name];
                    if ([zipPasscode isEqualToString:@""] || zipPasscode == nil ||
                        [zipPasscode isEqualToString:@"<null>"]) {
                        readStream = [unzipFile readCurrentFileInZip];
                        ;
                    }
                    else {

                        readStream =
                            [unzipFile readCurrentFileInZipWithPassword:zipPasscode];
                    }

                    data = [readStream readDataOfLength:info.length];
                }
            }
            [self disposeData:data mimeType:mimeType];
        }
    }
    else {

        NSString* resourcePath = nil;
        if ([[NSFileManager defaultManager]
                fileExistsAtPath:[[[NSBundle mainBundle] resourcePath]
                                     stringByAppendingPathComponent:filePath1]]) {
            resourcePath = [[[NSBundle mainBundle] resourcePath]
                stringByAppendingPathComponent:filePath1];
        }

        CPDLog(@"resourcePath:%@", resourcePath);

        if (resourcePath == nil) {
            //路径为nil，说明本地找不到该资源，需要从服务器读取。

            NSMutableURLRequest* myRequest = [[self request] mutableCopy];
            [myRequest setValue:@"" forHTTPHeaderField:CSIICachingURLHeader];
            NSURLConnection* connection =
                [NSURLConnection connectionWithRequest:myRequest
                                              delegate:self];
            [self setConnection:connection]; //连接网络，从服务器读取
        }
        else {

            data = [NSData dataWithContentsOfFile:resourcePath];

            [self disposeData:data mimeType:mimeType];
        }
    }
}
- (void)disposeData:(NSData*)data mimeType:(NSString*)mimeType
{
    if (data == nil || data == NULL) {
        NSMutableURLRequest* myRequest = [[self request] mutableCopy];
        [myRequest setValue:@"" forHTTPHeaderField:CSIICachingURLHeader];
        NSURLConnection* connection =
            [NSURLConnection connectionWithRequest:myRequest
                                          delegate:self];
        [self setConnection:connection];
    }
    else {

        NSURLResponse* response;
        response = [[NSHTTPURLResponse alloc] initWithURL:[[self request] URL]
                                               statusCode:200
                                              HTTPVersion:@"1.1"
                                             headerFields:nil];
        [[self client] URLProtocol:self
                didReceiveResponse:response
                cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [[self client] URLProtocol:self didLoadData:data];
        [[self client] URLProtocolDidFinishLoading:self];
    }
}

- (void)stopLoading
{
    [[self connection] cancel];
}

#pragma mark NSURLConnection Delegate
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [[self client] URLProtocol:self didLoadData:data];
    [self appendData:data];
}

- (void)connection:(NSURLConnection*)connection
  didFailWithError:(NSError*)error
{
    [[self client] URLProtocol:self didFailWithError:error];
    [self setConnection:nil];
    [self setData:nil];
}

- (void)connection:(NSURLConnection*)connection
didReceiveResponse:(NSURLResponse*)response
{
    [self setResponse:response];
    [[self client] URLProtocol:self
            didReceiveResponse:response
            cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    [[self client] URLProtocolDidFinishLoading:self];
    [self setConnection:nil];
    [self setData:nil];
}

- (void)appendData:(NSData*)newData;
{
    if ([self data] == nil) {
        [self setData:[[NSMutableData alloc] initWithData:newData]];
    }
    else {
        [[self data] appendData:newData];
    }
}

- (NSURLRequest*)connection:(NSURLConnection*)connection
            willSendRequest:(NSURLRequest*)request
           redirectResponse:(NSURLResponse*)response
{
    if (response != nil) {
        [[self client] URLProtocol:self
            wasRedirectedToRequest:request
                  redirectResponse:response];
    }
    return request;
}

- (void)connection:(NSURLConnection*)connection
    willSendRequestForAuthenticationChallenge:
        (NSURLAuthenticationChallenge*)challenge
{

    [[self client] URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

#pragma mark - NSURLConnection Delegate Methods
#ifdef SKIP_SSLCERTCHECK
- (BOOL)connection:(NSURLConnection*)connection
    canAuthenticateAgainstProtectionSpace:
        (NSURLProtectionSpace*)protectionSpace
{
    return [protectionSpace.authenticationMethod
        isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection*)connection
    didReceiveAuthenticationChallenge:
        (NSURLAuthenticationChallenge*)challenge
{

    if ([challenge.protectionSpace.authenticationMethod
            isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential
                                            credentialForTrust:challenge
                                                                   .protectionSpace
                                                                   .serverTrust]
             forAuthenticationChallenge:challenge];
    }
    else {
        [challenge.sender
            continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}
#endif

@end

static NSString* const kDataKey = @"data";
static NSString* const kResponseKey = @"response";

@interface CSIICachedData : NSObject <NSCoding>
@property (nonatomic, readwrite, strong) NSData* data;
@property (nonatomic, readwrite, strong) NSURLResponse* response;
@end

@implementation CSIICachedData
@synthesize data = data_;
@synthesize response = response_;

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:[self data] forKey:kDataKey];
    [aCoder encodeObject:[self response] forKey:kResponseKey];
}
- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    if (self != nil) {
        [self setData:[aDecoder decodeObjectForKey:kDataKey]];
        [self setResponse:[aDecoder decodeObjectForKey:kResponseKey]];
    }
    return self;
}

@end
