//
//  CSIIMADPNetworkUtil.m
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 10-12-13.
//  Copyright 2010 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import "CSIIMADPNetworkUtil.h"
#import "CSIIMADPAFHTTPRequestOperation.h"
#import "CSIIMADPReachability.h"
#import "CSIIConfigGlobalImport.h"
@implementation CSIIMADPNetworkUtil
static CSIIMADPNetworkUtil *_sharedInstance;
// static long currentTime;
- (id)init {
  self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(applicationDidEnterBackgroundNotification)
               name:UIApplicationDidEnterBackgroundNotification
             object:nil];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(applicationDidBecomeActiveNotification)
               name:UIApplicationDidBecomeActiveNotification
             object:nil];
  }
  return self;
}
- (void)applicationDidEnterBackgroundNotification {
  if ([[[NSUserDefaults standardUserDefaults]
          objectForKey:@"isListeningNetwork"] boolValue]) {
    [[NSNotificationCenter defaultCenter]
        removeObserver:self
                  name:kCSIIMADPReachabilityChangedNotification
                object:nil];
  }
}
- (void)applicationDidBecomeActiveNotification {
  if ([[[NSUserDefaults standardUserDefaults]
          objectForKey:@"isListeningNetwork"] boolValue]) {
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(reachabilityChanged:)
               name:kCSIIMADPReachabilityChangedNotification
             object:nil];
  }
}
+ (BOOL)isExistenceNetwork {

#ifdef DO_DATA_FROM_LOCAL
  return TRUE;
#endif

  BOOL isExistenceNetwork = FALSE;
  CSIIMADPReachability *reachability = [CSIIMADPReachability
      reachabilityWithHostname:
          [[NSURL URLWithString:[CSIIBusinessContext sharedInstance]
                                    .serverUrl] host]];
  NSString *msg = @"";
  switch ([reachability currentCSIIMADPReachabilityStatus]) {
  case CSIIMADPNotReachable:
    isExistenceNetwork = FALSE;
    msg = @"没有网络";
    break;
  case CSIIMADPReachableViaWWAN:
    isExistenceNetwork = TRUE;
    msg = @"正在使用3G网络";
    break;
  case CSIIMADPReachableViaWiFi:
    isExistenceNetwork = TRUE;
    msg = @"正在使用wifi网络";
    break;
  }
  return isExistenceNetwork;
}

- (void)listening;
{

#ifdef INNERSERVER_PORT
  return;
#endif

  [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES]
                                           forKey:@"isListeningNetwork"];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(reachabilityChanged:)
             name:kCSIIMADPReachabilityChangedNotification
           object:nil];

  //    hostReach = [CSIIReachability reachabilityWithHostname: [[NSURL
  //    URLWithString:[SERVER_SSL?@"https://":@"http://"
  //    stringByAppendingString:SERVER_IP]]host]];
  //	[hostReach startNotifier];
  //	[self updateInterfaceWithCSIIReachability: hostReach];

  internetReach = [CSIIMADPReachability reachabilityForInternetConnection];
  [internetReach startNotifier];
  [self updateInterfaceWithCSIIReachability:internetReach];

  //    wifiReach = [CSIIReachability reachabilityForLocalWiFi];
  //	[wifiReach startNotifier];
  //	[self updateInterfaceWithCSIIReachability: wifiReach];
}
- (void)reachabilityChanged:(NSNotification *)note {
  CSIIMADPReachability *curReach = [note object];
  NSParameterAssert([curReach isKindOfClass:[CSIIMADPReachability class]]);
  [self updateInterfaceWithCSIIReachability:curReach];
}

- (void)updateInterfaceWithCSIIReachability:(CSIIMADPReachability *)curReach {
  CSIIMADPNetworkStatus netStatus = [curReach currentCSIIMADPReachabilityStatus];
  BOOL connectionRequired = [curReach connectionRequired];
  switch (netStatus) {
  case CSIIMADPNotReachable: {
    DebugLog(@"没有网络");
    //网络不通的时候给出提示信息
    if ((((long)[[NSDate date] timeIntervalSince1970]) - Context.currentTime) >
        NETWORKERROR_TIME) {
      Context.currentTime = ((long)[[NSDate date] timeIntervalSince1970]);
      //                [[CSIIUIAlert
      //                sharedInstance]showAlert:[[CSIIBusinessCaller
      //                alloc]init] title:kNetworkErrorTitle
      //                message:kNetworkErrorMessage];
      //网络不通提示信息
    }

    connectionRequired = NO;
    break;
  }

  case CSIIMADPReachableViaWWAN: {
    break;
  }
  case CSIIMADPReachableViaWiFi: {
    break;
  }
  }
}

- (void)updateImage:(NSString *)path
            withDic:(NSDictionary *)dic
      withImageView:(UIImage *)image
         withParams:(NSString *)Identitys;
{
  DebugLog(@"%@", path);
  DebugLog(@"%@", dic);
  CSIIMADPAFHTTPClient *httpclient = [[CSIIMADPAFHTTPClient alloc]
      initWithBaseURL:[NSURL URLWithString:[CSIIBusinessContext sharedInstance]
                                               .serverUrl]];
  [httpclient setDefaultHeader:@"Accept" value:@"text/xml,application/json"];
  NSMutableURLRequest *request = [httpclient
      multipartFormRequestWithMethod:
          @"POST" path:[NSString
                           stringWithFormat:@"%@/%@",
                                            [CSIIBusinessContext sharedInstance]
                                                .serverPath,
                                            @"PreviewIdentity.do"]
                          parameters:dic
           constructingBodyWithBlock:^(id<AFCSIIMADPMultipartFormData> formData) {
             NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
             [formData appendPartWithFileURL:[NSURL fileURLWithPath:path]
                                        name:Identitys
                                       error:nil];
             [formData appendPartWithHeaders:[NSDictionary
                                                 dictionaryWithObjectsAndKeys:
                                                     @"image/jpeg",
                                                     @"Content-Type", nil]
                                        body:imageData];

           }];
  CSIIMADPAFHTTPRequestOperation *opertaion =
      [[CSIIMADPAFHTTPRequestOperation alloc] initWithRequest:request];
  [opertaion setCompletionBlockWithSuccess:^(CSIIMADPAFHTTPRequestOperation
                                                 *operation,
                                             id responseObject) {
    DebugLog(@"%@", operation.responseString);
    if ([[dic valueForKey:@"Type"] isEqualToString:@"1"]) {
      //            [[CSIIUIAlert sharedInstance]showAlert:nil title:@"提示信息"
      //            message:@"身份证正面上传成功，请上传身份证背面图片"];
    } else if ([[dic valueForKey:@"Type"] isEqualToString:@"2"]) {
      //            [[CSIIUIAlert sharedInstance]showAlert:nil title:@"提示信息"
      //            message:@"身份证背面上传成功，请上传银行卡图片"];
    } else if ([[dic valueForKey:@"Type"] isEqualToString:@"3"]) {
      //            [[CSIIUIAlert sharedInstance]showAlert:nil title:@"提示信息"
      //            message:@"银行卡图片上传成功"];
    }
  } failure:^(CSIIMADPAFHTTPRequestOperation *operation, NSError *error) {
    DebugLog(@"%@", error);
  }];
  [httpclient setAllowsInvalidSSLCertificate:SERVER_CHECKSSL];
  [httpclient setDefaultHeader:@"Content-Type" value:@"image/jpeg"];
  [httpclient enqueueHTTPRequestOperation:opertaion];
}

+ (CSIIMADPNetworkUtil *)sharedInstance;
{
  @synchronized(self) {
    if (!_sharedInstance)
      _sharedInstance = [[CSIIMADPNetworkUtil alloc] init];
    return _sharedInstance;
  }
}
@end
