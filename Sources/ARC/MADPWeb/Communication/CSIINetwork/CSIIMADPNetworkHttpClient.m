//
//  CSIINetWorkTestRequest.m
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 11-7-27.
//  Copyright (c) 2011年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import "CSIIMADPNetworkHttpClient.h"
#import "CSIIMADPAFHTTPRequestOperation.h"
#import "CSIIConfigGlobalImport.h"

@interface CSIIMADPNetworkHttpClient ()
@end

@implementation CSIIMADPNetworkHttpClient
- (id)initWithTransaction:(CSIIBusinessCaller*)caller
           onSuccessBlock:(OnSuccessBlock)onSuccessBlock
           onFailureBlock:(OnFailureBlock)onFailureBlock;
{
    self = [super init];
    
    if (self != nil) {
        callerHttpHeader = caller.httpHeader;
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(applicationDidEnterBackgroundNotification)
                   name:UIApplicationDidEnterBackgroundNotification
                 object:nil];
        httpclient = [[CSIIMADPAFHTTPClient alloc]
            initWithBaseURL:[NSURL URLWithString:[CSIIBusinessContext sharedInstance].serverUrl]];
        [self addHTTPRequestHeader];
        httpclient.parameterEncoding = AFCSIIMADPJSONParameterEncoding;
        
        
        if (caller.responsType == ResponsTypeOfWeb) {
            httpMethod = GET;
            if (caller.webMethod) {
                httpMethod = caller.webMethod;
            }
#ifdef INNERSERVER_PORT
            caller.webMethod = GET;
            httpMethod = GET;
#endif
        }else if (caller.responsType == ResponsTypeOfString) {
            httpMethod = GET;
            if (caller.webMethod) {
                httpMethod = caller.webMethod;
            }
#ifdef INNERSERVER_PORT
            caller.webMethod = GET;
            httpMethod = GET;
#endif
        }
        else {
            httpMethod = POST;
#ifdef INNERSERVER_PORT
            httpMethod = GET;
#endif
        }

        if ([caller.transactionArgument
                isEqualToDictionary:[NSDictionary dictionary]]) {
            caller.transactionArgument = nil;
        }

        path = [NSString
            stringWithFormat:@"%@/%@", [CSIIBusinessContext sharedInstance].serverPath, caller.transactionId];
        
        
        //CSII客户端参数加密
        NSDictionary *transactionDict = [NSDictionary dictionary];
        transactionDict = [[LibAesSingle shareInstance] getTransactionEncryptDict:caller.transactionArgument currentUrl:path];

        
        NSURLRequest* request =
            [httpclient requestWithMethod:httpMethod
                                     path:path
                               parameters:transactionDict];//caller.transactionArgument
        Log_TransactionInfo(@"\nExecuteTransaction:URL    %@",
            [request.URL absoluteString]);
        CSIIMADPAFHTTPRequestOperation* operation = [httpclient
            HTTPRequestOperationWithRequest:request
            success:^(__unused CSIIMADPAFHTTPRequestOperation* operation, id JSON) {
//            TODO:去掉重复打印
//                Log_BasicMessage(
//                    @"BasicMessage Completion:%@",
//                    [[NSString alloc] initWithData:JSON
//                                          encoding:NSUTF8StringEncoding]);
                NSMutableDictionary* webInfo = [[NSMutableDictionary alloc]
                    initWithObjectsAndKeys:
                        [NSString stringWithFormat:@"%ld", (long)operation.response
                                                               .statusCode],
                    @"httpStatus",
                    [[NSString alloc] initWithData:JSON
                                          encoding:NSUTF8StringEncoding],
                    @"WebData", nil];
                
                
                
                
                onSuccessBlock([[NSString alloc] initWithData:JSON
                                                     encoding:NSUTF8StringEncoding],
                    webInfo);
            }
            failure:^(__unused CSIIMADPAFHTTPRequestOperation* operation,
                        NSError* error) {
                Log_BasicMessage(@"BasicMessage Error!");

                NSMutableDictionary* webInfo = [[NSMutableDictionary alloc]
                    initWithObjectsAndKeys:
                        [NSString stringWithFormat:@"%ld", (long)operation.response
                                                               .statusCode],
                    @"httpStatus", @"", @"WebData", nil];
                onFailureBlock(error, webInfo);
            }];

        [httpclient setAllowsInvalidSSLCertificate:SERVER_CHECKSSL];
        [httpclient enqueueHTTPRequestOperation:operation];
    }
    return self;
}

- (id)initWithTransactionforImage:(CSIIBusinessCaller*)caller
                   onSuccessBlock:(OnSuccessBlock)onSuccessBlock
                   onFailureBlock:(OnFailureBlock)onFailureBlock;
{
    self = [super init];
    if (self != nil) {
        callerHttpHeader = caller.httpHeader;
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(applicationDidEnterBackgroundNotification)
                   name:UIApplicationDidEnterBackgroundNotification
                 object:nil];
        httpclient = [[CSIIMADPAFHTTPClient alloc]
            initWithBaseURL:[NSURL URLWithString:[CSIIBusinessContext sharedInstance].serverUrl]];
        [self addHTTPRequestHeader];
        httpclient.parameterEncoding = AFCSIIMADPJSONParameterEncoding;

        if (caller.isWeb) {
            httpMethod = GET;
            if (caller.webMethod) {
                httpMethod = caller.webMethod;
            }
#ifdef INNERSERVER_PORT
            caller.webMethod = GET;
            httpMethod = GET;
#endif
        }
        else {
            httpMethod = POST;
#ifdef INNERSERVER_PORT
            httpMethod = GET;
#endif
        }

        //去掉无参数打印URL后面的“？”
        if ([caller.transactionArgument
                isEqualToDictionary:[NSDictionary dictionary]]) {
            caller.transactionArgument = nil;
        }

        path = [NSString
            stringWithFormat:@"%@/%@", [CSIIBusinessContext sharedInstance].serverPath, caller.transactionId];

        NSDictionary* fileDic = caller.transactionArgument[@"file"];
        [caller.transactionArgument removeObjectForKey:@"file"];
        NSMutableDictionary* mapDic = caller.transactionArgument;

        
        //CSII客户端参数加密
        NSDictionary *transactionDict = [NSDictionary dictionary];
        
        transactionDict = [[LibAesSingle shareInstance] getTransactionEncryptDict:mapDic currentUrl:path];

        
        NSURLRequest* request = [httpclient
            multipartFormRequestWithMethod:httpMethod
                                      path:path
                                parameters:transactionDict //mapDic
                 constructingBodyWithBlock:^(id<AFCSIIMADPMultipartFormData> formData) {

//                     for (NSString* key in fileDic.allKeys) {
//                         [formData
//                             appendPartWithFileURL:[NSURL fileURLWithPath:fileDic[key]]
//                                              name:key
//                                             error:nil];
//                     }
                     
                     for (NSString* key in fileDic.allKeys) {

//                         [formData
//                             appendPartWithFileURL:[NSURL fileURLWithPath:fileDic[key]]
//                                              name:key
//                                             error:nil];
                         NSString *str = fileDic[key];
                         NSArray *arr = [str componentsSeparatedByString:@"."];
                         NSInteger state = 0;
                          NSString *fileName;
                         
                         NSString *ss = [NSString string];
                         if ([arr[1] isEqualToString:@"png"])
                         {
                             state = 0;
                             ss = @"image/png";
                             fileName  = [NSString stringWithFormat:@"%@.png",key];
                         }
                         else// if ([arr[1] isEqualToString:@"jpeg"])
                         {
                             state = 1;
                             ss = @"image/jpeg";
                             fileName  = [NSString stringWithFormat:@"%@.jpeg",key];
                         }
                         
                         
                         NSString *imgPath = str;
                         NSData *data = [NSData dataWithContentsOfFile:imgPath];
                         UIImage *image = [UIImage imageWithData:data];


                         [formData appendPartWithFileData:[self imageWithImageSimple:image] name:key fileName:fileName  mimeType:ss];

                     }


                 }];

        CSIIMADPAFHTTPRequestOperation* operation = [httpclient
            HTTPRequestOperationWithRequest:request
            success:^(__unused CSIIMADPAFHTTPRequestOperation* operation, id JSON) {

                //测试 捕获交易数据
                //[self writeToDocumentFolder:caller.transactionId data:[operation
                // responseData]];

                Log_BasicMessage(
                    @"BasicMessage Completion:%@",
                    [[NSString alloc] initWithData:JSON
                                          encoding:NSUTF8StringEncoding]);
                NSMutableDictionary* webInfo = [[NSMutableDictionary alloc]
                    initWithObjectsAndKeys:
                        [NSString stringWithFormat:@"%ld", (long)operation.response
                                                               .statusCode],
                    @"httpStatus",
                    [[NSString alloc] initWithData:JSON
                                          encoding:NSUTF8StringEncoding],
                    @"WebData", nil];
                onSuccessBlock([[NSString alloc] initWithData:JSON
                                                     encoding:NSUTF8StringEncoding],
                    webInfo);
            }
            failure:^(__unused CSIIMADPAFHTTPRequestOperation* operation,
                        NSError* error) {
                Log_BasicMessage(@"BasicMessage Error!");

                NSMutableDictionary* webInfo = [[NSMutableDictionary alloc]
                    initWithObjectsAndKeys:
                        [NSString stringWithFormat:@"%ld", (long)operation.response
                                                               .statusCode],
                    @"httpStatus", @"", @"WebData", nil];
                onFailureBlock(error, webInfo);
            }];

        [httpclient setAllowsInvalidSSLCertificate:SERVER_CHECKSSL];
        [httpclient enqueueHTTPRequestOperation:operation];
    }
    return self;
}

- (NSData *)changeImageToData:(UIImage *)imageObj andState:(NSInteger)state
{
    //NSData* imageData = UIImageJPEGRepresentation(imageObj, 1.0);
    NSData *imageData = [[NSData alloc] init];

    imageData = UIImageJPEGRepresentation(imageObj, 1.0);
    if (!imageData) {
        imageData = [[NSData alloc] init];
    }
    
    return imageData;
}



//真·压缩图片, 按比例压缩
- (NSData *)imageWithImageSimple:(UIImage *)oldImage
{
    NSData *oldImageData = UIImageJPEGRepresentation(oldImage, 1.0);//原始图片Data
    NSUInteger sizeOrigin = [oldImageData length];//原始图片总字节（B）
    NSUInteger sizeOriginKB = sizeOrigin / 1024; //原始图片总字节（KB）
    NSLog(@"原图片的大小为%luKB",(unsigned long)sizeOriginKB);
    NSLog(@"原始图片的尺寸为宽:%f 高:%f",oldImage.size.width,oldImage.size.height);
    
    
    //服务器限制最大接收20M:20480KB, 这里限制每张最大800kB
    if (sizeOriginKB > 800)
    {
        //原始图片大于800KB时，需要压缩
        
        float a = 360.f;//KB
        float b = (float)sizeOriginKB;
        float q = sqrtf(a / b); //压缩比例因子
        
        CGSize sizeImage = [oldImage size]; //原始图片size
        CGFloat newWidth = sizeImage.width * q;
        CGFloat newHeigh = sizeImage.height * q;
        CGSize  newImageSize = CGSizeMake(newWidth, newHeigh);//新size
        
        UIGraphicsBeginImageContext(newImageSize);
        CGRect newImageRect = CGRectMake(0, 0, newImageSize.width, newImageSize.height);
        
        [oldImage drawInRect:newImageRect];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *newImageData = UIImageJPEGRepresentation(newImage, 1.0);
        NSUInteger newSizeOrigin = [newImageData length];
        NSUInteger newSizeOriginKB = newSizeOrigin / 1024;
        NSLog(@"压缩后的大小为%luKB",(unsigned long)newSizeOriginKB);
        
        NSLog(@"压缩后的尺寸为宽:%f 高:%f",newImageRect.size.width,newImageRect.size.height);
        
        return newImageData;//newImage; //压缩后图片
    }
    
    return oldImageData;//oldImage; //原始图片
}



- (id)initWithTransaction:(NSString*)transaction
                  message:(NSDictionary*)message
                   caller:(CSIIBusinessCaller*)caller
                 argument:(NSDictionary*)argument
           onSuccessBlock:(OnSuccessBlock)onSuccessBlock
           onFailureBlock:(OnFailureBlock)onFailureBlock;
{
    if (caller.responsType == ResponsTypeOfImageData) {
        caller.transactionId =
            [CSIIMADPNetworkHttpClient getURIWithTransaction:transaction
                                                argument:argument];
        return [self initWithTransactionforImage:caller
                                  onSuccessBlock:onSuccessBlock
                                  onFailureBlock:onFailureBlock];
    }
    caller.transactionId =
        [CSIIMADPNetworkHttpClient getURIWithTransaction:transaction
                                            argument:argument];
    return [self initWithTransaction:caller
                      onSuccessBlock:onSuccessBlock
                      onFailureBlock:onFailureBlock];
}

- (void)applicationDidEnterBackgroundNotification
{
    [self cancel];
}

- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter]
        removeObserver:self
                  name:UIApplicationDidEnterBackgroundNotification
                object:nil];
}

- (void)cancel
{
    [httpclient cancelAllHTTPOperationsWithMethod:httpMethod path:path];
}

- (void)addHTTPRequestHeader
{
    NSMutableDictionary* httpHeader = [Context addHTTPRequestHeader];
    for (NSString* key in [httpHeader keyEnumerator]) {
        [httpclient setDefaultHeader:key value:[httpHeader objectForKey:key]];
    }

    for (NSString* key in [callerHttpHeader keyEnumerator]) {
        [httpclient setDefaultHeader:key value:[callerHttpHeader objectForKey:key]];
    }
}

+ (NSString*)getURIWithTransaction:(NSString*)transactionId
                          argument:(NSDictionary*)argument;
{
    NSMutableString* URI = [[NSMutableString alloc] initWithString:transactionId];
    BOOL isFirst = YES;
    if (argument && [argument isKindOfClass:[NSDictionary class]]) {
        for (NSString* key in [argument allKeys]) {
            NSString* parameter = @"";
            if (isFirst) {
                parameter = [NSString
                    stringWithFormat:@"?%@=%@",
                    [key stringByAddingPercentEscapesUsingEncoding:
                                             NSUTF8StringEncoding],
                    [[argument objectForKey:key]
                                         stringByAddingPercentEscapesUsingEncoding:
                                             NSUTF8StringEncoding]];
                isFirst = NO;
            }
            else {
                parameter = [NSString
                    stringWithFormat:@"&%@=%@",
                    [key stringByAddingPercentEscapesUsingEncoding:
                                             NSUTF8StringEncoding],
                    [[argument objectForKey:key]
                                         stringByAddingPercentEscapesUsingEncoding:
                                             NSUTF8StringEncoding]];
            }
            [URI appendString:parameter];
        }
    }
    return URI;
}
+ (NSString*)getURLStringWithTransaction:(NSString*)transactionId
                                argument:(NSDictionary*)argument;
{
    return [NSString stringWithFormat:@"%@/%@/%@", [CSIIBusinessContext sharedInstance].serverUrl, [CSIIBusinessContext sharedInstance].serverPath,
                     [self getURIWithTransaction:transactionId
                                                       argument:argument]];
}

- (void)writeToDocumentFolder:(NSString*)actionName data:(id)data
{
    //捕获交易报文，来用于内部挡板,从本地文件读取数据

    //保存到Documents目录下的文件中
    NSString* fileName = [
        [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
        stringByAppendingPathComponent:[NSString
                                           stringWithFormat:@"%@", actionName]];
    DebugLog(@"writeToFile:%@", fileName);

    // 先删除已经存在的文件
    NSFileManager* defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:fileName error:nil];
    // 写入文件
    if ([data isKindOfClass:[NSString class]]) {
        [(NSString*)data writeToFile:fileName
                          atomically:YES
                            encoding:NSUTF8StringEncoding
                               error:nil];
    }
    else if ([data isKindOfClass:[NSData class]]) {
        [(NSData*)data writeToFile:fileName atomically:YES];
    }
}

@end
