//
//  CSIIUIVXWebView.m
//  CSIIPlatformLib
//
//  Created by liurenpeng on 6/24/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CPWebView.h"
#import "CPWebViewJavascriptBridge.h"
#import "CPPlugin.h"
#import "CPPluginsUtility.h"
#import "CPCacheUtility.h"
#import "CPUIVXWebCachingURLProtocol.h"
#import "CPWebViewDelegate.h"
#import "CPContacts.h"
#import "CPContext.h"
#import "CPBase64.h"
#import "CPDebug.h"
#import "CPUtility.h"
@interface CPWebView () <CPWebViewDelegate> {
    CPWebViewJavascriptBridge* bridge;
}
@property (nonatomic, strong) CPWebViewJavascriptBridge* bridge;
;
@end
@implementation CPWebView {

    CPPlugin* _plugin;
    Class class;
}

@synthesize actionId;
@synthesize viewController;
//@synthesize pluginsDic;
@synthesize urlPath;
@synthesize bridge;
@synthesize params;
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {

        self.delegate = delegate;
        if ([delegate isKindOfClass:[UIViewController class]]) {
            self.viewController = delegate;
        }
        // set an empty cache
        // ,可禁止在沙盒Library/Caches/com.ghbank.ios目录下Cache.db,Cache.db-shm,Cache.db-wal，以及fsCachedData文件夹下服务器响应数据的生成
        NSURLCache* sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                                diskCapacity:0
                                                                    diskPath:nil];
        [NSURLCache setSharedURLCache:sharedCache];

        //只能清除fsCachedData文件夹下生成的服务器的响应
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        // 注册request监听
        [NSURLProtocol registerClass:[CPUIVXWebCachingURLProtocol class]];

        self.opaque = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
    }
    return self;
}
- (void)callHandler:(NSString*)handlerName data:(id)data
{

    CPDLog(@"callHandlerVXName:%@", handlerName);
    [bridge callHandler:handlerName data:data];
}

- (void)callHandler:(NSString*)handlerName
               data:(id)data
   responseCallback:(BackCallback)backResponseData
{
    CPDLog(@"callHandlerVXName:%@", handlerName);
    [bridge callHandler:handlerName
                    data:data
        responseCallback:^(id response) {

            NSData * data = [CPBase64 decode:response];
            NSString* aStr =
                [[NSString alloc] initWithData:data
                                      encoding:NSASCIIStringEncoding];
//            CPDLog(@"callHandlerCallBack:%@", aStr);
            backResponseData(aStr);
        }];
}

- (void)registerPlugins;
{
//    if ([CPContext sharedInstance].pluginsDictionary) {
//        self.pluginsDic = [CPContext sharedInstance].pluginsDictionary;
//    }
    [CPWebViewJavascriptBridge enableLogging];
    __weak typeof(self) weakSelf = self;
    self.bridge = [CPWebViewJavascriptBridge
        bridgeForWebView:self
         webViewDelegate:self.delegate
                 handler:^(id data, WVJBResponseCallback responseCallback) {

                     CPDLog(@"ObjC received message from JS:%@", data);
                     
                     
                     if ([data objectForKey:@"callbackId"]) {
                         
                         NSDictionary *msg = @{
                                               @"responseId" : [data objectForKey:@"callbackId"],
                                               @"responseData" : @"Response for message from ObjC"
                                               };
                         responseCallback(msg);
                         
                     }else{
                         responseCallback(@"Response for message from ObjC");
                         
                     }

                     

                 }];

//    CPDLog(@"PluginHandler:%@", @"PluginHandler");

    [bridge
        registerHandler:@"PluginHandler"
                handler:^(id data, WVJBResponseCallback responseCallback) {

                    CPDLog(@"egistPluginName:%@", data[@"data"][@"PluginName"]);
                    
                        [weakSelf.bridge
                         registerHandler:data[@"data"][@"PluginName"]
                         handler:^(id data,
                                   WVJBResponseCallback responseCallback) {
                             class = NSClassFromString(data[@"handlerName"]);
                             
//                             CPDLog(@"PluginHandlerName:%@",
//                                    self.pluginsDic[data[@"handlerName"]]);
                             
                             CPDLog(@"plugindataFromJs:%@", data);
                             NSString* handlerName = [NSString
                                                      stringWithFormat:@"%@/%@",
                                                      data[@"handlerName"],
                                                      data[@"data"][@"Command"]];
                             
                             
                             CPDLog(@"responseCallback=====%@",responseCallback);
                             
                                 [CPUtility
                                  registerHandler:handlerName
                                  withObject:weakSelf.viewController
                                  withWeb:weakSelf
                                  withData:data
                                  complete:^(id responseData){
                                      
                                      responseCallback(responseData);
                                      
                                  }];
                             
                         }];



                    if ([data objectForKey:@"callbackId"]) {
                        
                        NSDictionary *msg = @{
                                              @"responseId" : [data objectForKey:@"callbackId"],
                                              @"responseData" : @"true"
                                              };
                        responseCallback(msg);
                        
                    }else{
                        responseCallback(@"true");
                        
                    }
                    

                }];
}

- (NSString*)otherTojson:(id)other
{

    if (other != nil) {
        BOOL isTurnableToJSON = [NSJSONSerialization isValidJSONObject:other];
        if (isTurnableToJSON) {

            NSData* jsondata =
                [NSJSONSerialization dataWithJSONObject:other
                                                options:NSJSONWritingPrettyPrinted
                                                  error:nil];
            NSString* jsonStr = [[NSString alloc] initWithData:jsondata
                                                      encoding:NSUTF8StringEncoding];

            return jsonStr;
        }
        else {

            return other;
        }
    }
    return nil;
}

- (void)loadUrl:(NSString*)_urlPath;
{
    NSURLRequest* request = [CPPluginsUtility managerUrlPath:urlPath];
    [self loadRequest:request];
}

- (void)reloadWebView;
{
    [super reload];
    [self loadUrl:self.urlPath];
}

- (void)clearWebCache;
{
    self.bridge = nil;
    self.delegate = nil;
    self.viewController = nil;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
- (void)dealloc
{
    self.viewController = nil;
    self.BackCallback = nil;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
#pragma mark - CPPluginDelegate
- (NSString*)getActionIdWithWebView
{
    return actionId;
}
- (NSDictionary*)getParamsWithWebView
{
    return params;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
