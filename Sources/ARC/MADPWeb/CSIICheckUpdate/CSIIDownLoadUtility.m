//
//  CSIIDownLoadUtility.m
//  CSIIPlatformLib
//
//  Created by liurenpeng on 8/19/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CSIIDownLoadUtility.h"
#import "CPCacheUtility.h"
#import "CSIIMADPAFHTTPRequestOperation.h"
#import "CSIIMADPAFHTTPClient.h"
@interface CSIIDownLoadUtility () {
    UIProgressView* downloadProgessBar;
    NSMutableArray* operationArr;
    int listCount;
    NSArray* zipListArray;
    NSMutableArray* zipfileArray;
}

@end

@implementation CSIIDownLoadUtility
@synthesize downLoadFinishBlock;
- (id)init
{
    self = [super init];
    if (self) {
        operationArr = [NSMutableArray array];
    }
    return self;
}

- (void)addDownLoadView
{
    self.backgroundColor = [UIColor clearColor];

    //半透明层
    UIView* backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.3;
    [self addSubview:backgroundView];

    UIView* infoView = [[UIView alloc]
        initWithFrame:CGRectMake(20, self.frame.size.height/2-50, self.frame.size.width - 40, 100)];
    infoView.backgroundColor =
        [UIColor colorWithRed:0.95f
                        green:0.95f
                         blue:0.96f
                        alpha:1.0f];
    infoView.layer.masksToBounds = YES;
    infoView.layer.cornerRadius = 6.0;
    [self addSubview:infoView];


    UILabel* infoLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(5, 10, infoView.frame.size.width - 10, 50)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.numberOfLines = 0;
    infoLabel.font = [UIFont systemFontOfSize:15];
    infoLabel.text = @"正在加载，请稍候..."; //[NSString
    // stringWithFormat:@"%@正在更新，请稍候...",
    // self.downloadFileName];
    [infoView addSubview:infoLabel];

    downloadProgessBar = [[UIProgressView alloc]
        initWithFrame:CGRectMake((infoView.frame.size.width - 180) / 2, 80, 180,
                          20)];
    [infoView addSubview:downloadProgessBar];
}
- (void)downLoadWithUrl:(NSString *)zipUrl downLoadFinish:(CSIIDownLoadUtilityCallback)downLoadResultBlock
{
    listCount = 0;
    self.downLoadFinishBlock = downLoadResultBlock;
    [self addDownLoadView];
    [self downLoadWithUrl:zipUrl
          responsCallback:^(BOOL isSuccess, id respons) {
            if (isSuccess) {
               NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
               [dic setValue:@"" forKey:@"zipPassWord"];
               [dic setObject:respons forKey:@"zipFilePath"];
                
                [CPCacheUtility sharedInstance].isCacheProtocol  =YES;
                [[CPCacheUtility sharedInstance] saveZipToCacheFileWithZipPath:dic];
                [self removezipFileWithPath:respons];
                [self hidenDownLoadView:listCount];
              }
          }];

}
- (void)downLoadWithList:(NSArray*)zipList
          downLoadFinish:(CSIIDownLoadUtilityCallback)downLoadResultBlock;
{

    if (zipList.count <= 0) {
        return;
    }
    self.downLoadFinishBlock = downLoadResultBlock;
    [self addDownLoadView];
    listCount = 0;
    zipListArray = zipList;
    zipfileArray = [NSMutableArray arrayWithCapacity:zipListArray.count];
    [self downLoadWithUrl:[self getZipListUrl:listCount]
          responsCallback:^(BOOL isSuccess, id respons) {

              if (isSuccess) {
                  NSDictionary* dic = @{
                      @"ZipVersionId" : zipListArray[listCount][@"ZipVersionId"],
                      @"zipPassWord" : zipListArray[listCount][@"ZipPassword"],
                      @"zipFilePath" : respons
                  };
                  DebugLog(@"respons-------:%@", respons);
                  [[CPCacheUtility sharedInstance] saveZipToCacheFileWithZipPath:dic];
                  [self removezipFileWithPath:respons];
                  [self hidenDownLoadView:listCount];
              }
          }];
}

/**
 *  根据url下载zip包
 *
 *  @param url   zip对应的url
 *  @param block 返回下载结果和下载后的zip路径
 */
- (void)downLoadWithUrl:(NSString*)url
        responsCallback:(void (^)(BOOL isSuccess, id respons))block
{
    NSArray *array = [url componentsSeparatedByString:@"/"]; //从字符A中分隔成2个元素的数组
    //获取沙盒路径  //自定义的方法 需要自己修改
    NSArray *ar = [array.lastObject componentsSeparatedByString:@"."];
    
    NSString* fileName = ar[0];

    NSString* savePath =
        [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
            stringByAppendingPathComponent:fileName];

     DebugLog(@"savePath: %@", savePath);
    NSURL* requestUrl = [NSURL URLWithString:url];
    NSMutableURLRequest* request =
        [NSMutableURLRequest requestWithURL:requestUrl];
    NSString* charset = (__bridge NSString*)CFStringConvertEncodingToIANACharSetName(
        CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    [request setValue:[NSString
                          stringWithFormat:
                              @"application/x-www-form-urlencoded; charset=%@",
                          charset]
        forHTTPHeaderField:@"Content-Type"];

    [request setHTTPMethod:@"GET"];
    NSDictionary* paramaterDic = [NSDictionary dictionary];

    downloadProgessBar.progress = 0.f;

    [request setHTTPBody:[AFCSIIMADPQueryStringFromParametersWithEncoding(
                             paramaterDic, NSUTF8StringEncoding)
                             dataUsingEncoding:NSUTF8StringEncoding]];
    CSIIMADPAFHTTPRequestOperation* operation =
        [[CSIIMADPAFHTTPRequestOperation alloc] initWithRequest:request];

    [operationArr addObject:operation];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savePath
                                                                 append:NO]];
    [operation
        setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead,
                                     long long totalBytesExpectedToRead) {
            float progress = (float)totalBytesRead / totalBytesExpectedToRead;
            downloadProgessBar.progress = progress;
        }];

    [operation setCompletionBlockWithSuccess:^(CSIIMADPAFHTTPRequestOperation* operation,
                                                 id responseObject) {

        block(YES, savePath);

//        listCount = listCount + 1;
//        if (listCount < zipListArray.count) {
//            DebugLog(@"operation------:%@", [self getZipListUrl:listCount]);

//            [self downLoadWithUrl:[self getZipListUrl:listCount]
//                  responsCallback:block];
//        }
//        [operationArr removeObject:operation];

         DebugLog(@"下载成功");

    } failure:^(CSIIMADPAFHTTPRequestOperation* operation, NSError* error) {
        [operationArr removeObject:operation];

        [self removeFromSuperview];
        self.downLoadFinishBlock(error, NO);

        DebugLog(@"下载失败");

    }];
    [operation start];
}

/**
 *  获取下载url
 *
 *  @param count 当前url索引
 *
 *  @return 下载url
 */
- (NSString*)getZipListUrl:(NSInteger)count
{

    NSString* url = zipListArray[count][@"ZipVersionURL"];
    return url;
}

/*!
 *  当全部下载完成后 移除遮罩
 */
- (void)hidenDownLoadView:(int)index
{
    if (index == 0) {
        self.downLoadFinishBlock(@"完成", YES);
        [self removeFromSuperview];
        listCount = -1;
    }
}
/*!
 *  清除下载缓存路径下的文件
 *
 *  @param path 下载路径
 */
- (void)removezipFileWithPath:(NSString*)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}
/*!
 *  取消下载
 */
- (void)cancelDownload;
{
    for (NSOperation* operation in operationArr) {
        if (![operation isKindOfClass:[CSIIMADPAFHTTPRequestOperation class]]) {
            continue;
        }

        [operation cancel];
    }
}

@end
