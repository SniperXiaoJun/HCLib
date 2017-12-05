//
//  majorManager.m
//  Product
//
//  Created by 刘任朋 on 15/11/5.
//  Copyright © 2015年 刘认朋. All rights reserved.
//

#import "CPMajorManager.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "CSIIUINavigationController.h"
#import "CPUIActivityIndicator.h"
#import "CPUtility.h"
#import "CPCacheUtility.h"
#import <UIKit/UIKit.h>
#import "CSIIBusinessContext.h"
#import "CPConfigGlobalDefine.h"

NSString* const CPPluginHandler = @"registPluginWithObject:withData:";

NSString* const CPPluginHandlerWithComplete =
    @"registPluginWithObject:withData:complete:";

NSString* const CPPluginHandlerWithWebWithComplete =
    @"registPluginWithObject:withWebView:withData:complete:";

NSString* const CPReciveWithDatawithComplete = @"reciveWithData:withComplete:";

@interface CPMajorManager () {
    NSMutableArray* _messageHandlersArray;
    NSMutableArray* _startupMessageQueue;
    NSMutableDictionary* _responseCallbacks;
    NSMutableDictionary* _messageHandlers;
    MAJBHandler _messageHandler;
}
@end
@implementation CPMajorManager
@synthesize rootViewController;
@synthesize pluginsDictionary;
@synthesize rootNavController;

#pragma mark - LifeCircle
- (id)init
{
    self = [super init];
    if (self) {

        self.pluginsDictionary = [NSMutableDictionary dictionary];

        [self addObserver:self selector:@selector(screenLock) pluginName:UIApplicationDidBecomeActiveNotification object:nil];

        [self addObserver:self
                 selector:@selector(registerHandlerNotification:)
               pluginName:@"registerHandler"
                   object:@"CPMajorManager"];

        [self addObserver:self
                 selector:@selector(registerHandlerWithBlockNotification:)
               pluginName:@"registerHandlerWithBlock"
                   object:@"CPMajorManager"];

        [self addObserver:self
                 selector:@selector(registerHandlerWithWebAndBlockNotification:)
               pluginName:@"registerHandlerWithWebAndBlock"
                   object:@"CPMajorManager"];

        _messageHandlersArray = [[NSMutableArray alloc] init];
        _messageHandlers = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (CPMajorManager*)sharedInstance;
{

    static CPMajorManager* _sharedInstance = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        _sharedInstance = [[CPMajorManager alloc] init];

    });

    return _sharedInstance;
}
- (void)startApplication:(NSString*)handler
            withServerIP:(NSString*)serverIP
          withServerPath:(NSString*)serverPath;
{
    CSIIUINavigationController* nav = [[CSIIUINavigationController alloc] init];
    nav.navigationBarHidden = YES;
    [[[[UIApplication sharedApplication] delegate] window]
        setRootViewController:nav];
    [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];

    
    [[CPUIActivityIndicator sharedInstance]
     addToShowView:[UIApplication sharedApplication].keyWindow];
    ;

    
    UIViewController* loadingView = [self registerHandlerWithReturnObj:handler];

    //    [[[UIApplication sharedApplication] delegate] window].backgroundColor=[UIColor whiteColor];

    self.rootNavController = nav;
    [nav pushViewController:loadingView animated:YES];
    [self setServerIP:serverIP withServerPath:serverPath];
    [CPCacheUtility sharedInstance].isCacheProtocol = YES;

//    [self saveSourceToCache];
    
    if ([CPCacheUtility sharedInstance].isDebug) {
        [self inRootController:@"CPInterface/cpRootInterface"];
    }else
        [self checkVersion];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Picture"] ;
    DebugLog(@"documentsDirectory=======%@",documentsDirectory);
    if ([fileManager fileExistsAtPath:documentsDirectory]) {
        [fileManager removeItemAtPath:documentsDirectory error:nil];
    }

}
- (void)inRootController:(NSString*)handler;
{
    NSString* pluginName = handler;
    UIViewController* controller = [self registerHandlerWithReturnObj:pluginName];
    NSArray* array = @[ controller, self.rootNavController.viewControllers[0] ];
    self.rootNavController.viewControllers = array;
    [CPUtility
        registerNotificationName:NTF_LOADING_FINISH
                          object:nil
                        userInfo:nil];
}

#pragma mark -检测版本更新
- (void)checkVersion;
{
    
    __weak typeof(self) weakself = self;
    [self registerHandler:@"CPVersionPlugin/checkVersion"
               withObject:@""
                 withData:@""
                 complete:^(id responseData) {

                     [weakself inRootController:@"CPInterface/cpRootInterface"];

                 }];
}
// 预制资源到缓存目录
- (void)saveSourceToCache
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstRun"]) {

        NSString* pwebPath = [CPUtility getFilePath:@"sample"
                                           inbundle:@"MADPPluginSDKResource.bundle"
                                           withPath:@"CPMenu"];

        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setValue:pwebPath forKey:@"zipFilePath"];
        [dic setValue:@"" forKey:@"zipPassWord"];
        [dic setValue:@"1.0.0" forKey:@"ZipVersionId"];
        [dic setObject:@"sample" forKey:@"ZipId"];

        //保存

        [[CPCacheUtility sharedInstance] saveZipToCacheFileWithZipPath:dic];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstRun"];
    }
}

#pragma mark - 动态加载类
// 将字符串转换成对象
- (id)classFromString:(NSString*)className;
{
    NSAssert(className, @"className is nil", className);
    DebugLog(@"className:%@ ---- pluginsDictionary:%@",className, self.pluginsDictionary);
    
//    if(self.pluginsDictionary[className]) {
//        id obj = (id)self.pluginsDictionary[className];
//        return obj;
//    }
    
    Class class = NSClassFromString(className);
    id objc = [[class alloc] init];
//    if (objc && (![[objc class] isSubclassOfClass:[UIViewController class]])) {
//        [self.pluginsDictionary setObject:objc forKey:className];
//    }

    return objc;
}
// 获取bundle里的资源
- (NSBundle*)bundleWithBundleName:(NSString*)bundleName
{
    NSString* bundlePath =
        [[NSBundle mainBundle]
                .resourcePath stringByAppendingPathComponent:bundleName];
    NSBundle* bundle = [NSBundle bundleWithPath:bundlePath];
    return bundle;
}
- (void)setServerIP:(NSString*)serverIP withServerPath:(NSString*)serverPath
{
    NSDictionary* dictionary = @{
        @"serverurl" : serverIP,
        @"serverpath" : serverPath
    };
    [self registerHandler:@"CPServer/setRequestUrl"
               withObject:nil
                 withData:dictionary];
}
// 根基字符截取字符串得到截取后的数组
- (NSArray*)getPluginHandlerArray:(NSString*)handler
{

    NSArray* handlerArr =
        [NSArray arrayWithArray:[handler componentsSeparatedByString:@"/"]];
    if (handlerArr.count < 2) {
        NSMutableString* handlerName = [NSMutableString stringWithString:handler];
        NSRange range = [handlerName rangeOfString:@"_"];
        if (range.location == NSNotFound) {
            DebugLog(@"not find %@ ahandlerName with %@", handler, @"'_'");
            return nil;
        }
        [handlerName deleteCharactersInRange:range];
        handlerName = [NSMutableString stringWithFormat:@"%@%@", handlerName, @"ViewController"];
        NSArray* handlerArr =
            @[ handlerName ];

        return handlerArr;
    }
    return handlerArr;
}
#pragma mark - objc_msgSend 反射
- (id)messageWithHandler:(NSString*)handler withMethod:(NSString*)methodName;
{

    id returnObj = nil;
    id obj = [self classFromString:handler];
    SEL selector = NSSelectorFromString(methodName);
    if ([obj respondsToSelector:selector]) {
        id (*func)(id, SEL) = (id (*)(id, SEL))objc_msgSend;
        returnObj = func(obj, selector);
    }
    return returnObj;
}

- (void)messageWithHandler:(NSString*)className
                withMethod:(NSString*)methodName
                withObject:(id)object
                  withData:(id)data;
{
    @synchronized(self)
    {

        id obj = [self classFromString:className];

        SEL superSelector = NSSelectorFromString(CPPluginHandler);
        SEL subSelector = NSSelectorFromString(methodName);
        if ([obj respondsToSelector:superSelector]) {
            void (*func)(id, SEL, id, id) = (void (*)(id, SEL, id, id))objc_msgSend;
            func(obj, superSelector, object, data);
        }
        if ([obj respondsToSelector:subSelector]) {
            void (*func)(id, SEL) = (void (*)(id, SEL))objc_msgSend;
            func(obj, subSelector);
        }
    }
}
- (void)messageWithHandler:(NSString*)className
                withMethod:(NSString*)methodName
                withObject:(id)object
                  withData:(id)data
                  complete:(void (^)(id responseData))completeBlock;
{
    @synchronized(self)
    {

        id obj = [self classFromString:className];

        SEL superSelector = NSSelectorFromString(CPPluginHandlerWithComplete);
        SEL subSelector = NSSelectorFromString(methodName);
        if ([obj respondsToSelector:superSelector]) {
            void (*func)(id, SEL, id, id, id) = (void (*)(id, SEL, id, id, id))objc_msgSend;
            func(obj, superSelector, object, data, completeBlock);
        }
        if ([obj respondsToSelector:subSelector]) {
            void (*func)(id, SEL) = (void (*)(id, SEL))objc_msgSend;
            func(obj, subSelector);
        }
    }
}

- (void)jumpOtherModuleWithHandler:(NSString*)className
                        withObject:(id)object
                          withData:(id)data
{
    if (!Context.isLoginFlag && ([className isEqualToString:@"LoginViewController"] || [className isEqualToString:@"GestureLoginViewController"] || [[data objectForKey:@"LoginType"] isEqualToString:@"T"])) {

        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"GesturePasswordFlg"] isEqualToString:@"Y"]) {

            [self jumpOtherModuleWithHandler:@"GestureLoginViewController"
                                  withObject:object
                                    withData:data
                                    complete:^(id responseData) {

                                        if (![className isEqualToString:@"LoginViewController"] && ![className isEqualToString:@"GestureLoginViewController"]) {
                                            __weak typeof(self) weakself = self;
                                            [weakself jumpOtherModuleWithHandler:className
                                                                      withObject:object
                                                                        withData:data
                                                                        complete:^(id responseData){

                                                                        }];
                                        }
                                    }];
        }
        else {

            [self jumpOtherModuleWithHandler:@"LoginViewController"
                                  withObject:object
                                    withData:data
                                    complete:^(id responseData) {

                                        if (![className isEqualToString:@"LoginViewController"]) {
                                            __weak typeof(self) weakself = self;
                                            [weakself jumpOtherModuleWithHandler:className
                                                                      withObject:object
                                                                        withData:data
                                                                        complete:^(id responseData){

                                                                        }];
                                        }
                                    }];
        }
    }
    else {
        [self jumpOtherModuleWithHandler:className
                              withObject:object
                                withData:data
                                complete:^(id responseData){

                                }];
    }
}
- (void)jumpOtherModuleWithHandler:(NSString*)className
                        withObject:(id)object
                          withData:(id)data
                          complete:(void (^)(id responseData))completeBlock;
{

    id obj = [self classFromString:className];
    SEL selector = NSSelectorFromString(CPReciveWithDatawithComplete);
    if ([obj respondsToSelector:selector]) {
        void (*func)(id, SEL, id, id) = (void (*)(id, SEL, id, id))objc_msgSend;
        func(obj, selector, data, completeBlock);
    }

    if ([object isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nav = object;
        [nav pushViewController:obj animated:YES];
    }
    else if ([object isKindOfClass:[UIViewController class]]) {

        UIViewController* viewContrl = object;
        if ([className isEqualToString:@"LoginViewController"] || [className isEqualToString:@"GestureLoginViewController"]) {
            [viewContrl presentViewController:obj animated:YES completion:NULL];
        }
        else {
            [viewContrl.navigationController pushViewController:obj animated:YES];
        }
    }
}
- (void)messageWithHandler:(NSString*)className
                withMethod:(NSString*)methodName
                withObject:(id)object
                   withWeb:(UIWebView*)webView
                  withData:(id)data
                  complete:(void (^)(id responseData))completeBlock;
{
    @synchronized(self)
    {
        id obj = [self classFromString:className];
        SEL superSelector = NSSelectorFromString(CPPluginHandlerWithWebWithComplete);
        SEL subSelector = NSSelectorFromString(methodName);
        if ([obj respondsToSelector:superSelector]) {
            void (*func)(id, SEL, id, id, UIWebView*, id) = (void (*)(id, SEL, id, UIWebView*, id, id))objc_msgSend;
            func(obj, superSelector, object, webView, data, completeBlock);
        }
        if ([obj respondsToSelector:subSelector]) {
            void (*func)(id, SEL) = (void (*)(id, SEL))objc_msgSend;
            func(obj, subSelector);
        }
    }
}
#pragma mark - objc_msgSend 注册
- (id)registerHandlerWithReturnObj:(NSString*)handlerName
{
    @synchronized(self)
    {
        NSArray* handlerArr = [self getPluginHandlerArray:handlerName];
        if (handlerArr.count >= 2) {
            return [self messageWithHandler:handlerArr[0]
                                 withMethod:handlerArr[1]];
        }
        else {
            DebugLog(@"object return is nil");
            return nil;
        }
    }
}
- (void)registerHandler:(NSString*)handlerName
             withObject:(id)object
               withData:(id)data;
{
    @synchronized(self)
    {
        NSArray* handlerArr = [self getPluginHandlerArray:handlerName];
        if (handlerArr.count >= 2) {
            [self messageWithHandler:handlerArr[0]
                          withMethod:handlerArr[1]
                          withObject:object
                            withData:data];
        }
        else if (handlerArr) {
            [self jumpOtherModuleWithHandler:handlerArr[0] withObject:object withData:data];
        }
    }
}

- (void)registerHandler:(NSString*)handlerName
             withObject:(id)object
               withData:(id)data
               complete:(void (^)(id responseData))completeBlock;
{
    @synchronized(self)
    {
        NSArray* handlerArr = [self getPluginHandlerArray:handlerName];
        if (handlerArr.count >= 2) {
            [self messageWithHandler:handlerArr[0]
                          withMethod:handlerArr[1]
                          withObject:object
                            withData:data
                            complete:completeBlock];
        }
        else if (handlerArr) {
            [self jumpOtherModuleWithHandler:handlerArr[0] withObject:object withData:data complete:completeBlock];
        }
    }
}

- (void)registerHandler:(NSString*)handlerName
             withObject:(id)object
                withWeb:(UIWebView*)webView
               withData:(id)data
               complete:(void (^)(id responseData))completeBlock;
{
    @synchronized(self)
    {
        NSArray* handlerArr = [self getPluginHandlerArray:handlerName];
        if (handlerArr.count >= 2) {
            [self messageWithHandler:handlerArr[0]
                          withMethod:handlerArr[1]
                          withObject:object
                             withWeb:webView
                            withData:data
                            complete:completeBlock];
        }
        else if (handlerArr) {
            [self jumpOtherModuleWithHandler:handlerArr[0] withObject:object withData:data complete:completeBlock];
        }
    }
}
- (void)postNotificationName:(NSString*)aName
                      object:(NSString*)pluginName
                    userInfo:(NSDictionary*)aUserInfo;
{

    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    if (!aUserInfo) {
        userInfo = [NSMutableDictionary dictionaryWithDictionary:aUserInfo];
    }
    [userInfo setObject:aName forKey:@"pluginName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:aName
                                                        object:pluginName
                                                      userInfo:userInfo];
}
- (void)addObserver:(id)observer
           selector:(SEL)aSelector
         pluginName:(NSString*)aName
             object:(id)anObject;
{
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:aSelector
                                                 name:aName
                                               object:anObject];
}
#pragma - mark - 指令执行方法

- (void)registerHandlerNotification:(NSNotification*)notifInfo
{
    id object = notifInfo.userInfo[@"CPObject"];
    NSString* pluginName = notifInfo.userInfo[@"CPPluginName"];
    id data = notifInfo.userInfo[@"CPData"];

    [self registerHandler:pluginName withObject:object withData:data];
}
- (void)registerHandlerWithBlockNotification:(NSNotification*)notifInfo
{
    id object = notifInfo.userInfo[@"CPObject"];
    NSString* pluginName = notifInfo.userInfo[@"CPPluginName"];
    id data = notifInfo.userInfo[@"CPData"];

    [self registerHandler:pluginName
               withObject:object
                 withData:data
                 complete:notifInfo.userInfo[@"CPBlock"]];
}
- (void)registerHandlerWithWebAndBlockNotification:(NSNotification*)notifInfo
{
    id object = notifInfo.userInfo[@"CPObject"];
    NSString* pluginName = notifInfo.userInfo[@"CPPluginName"];
    id data = notifInfo.userInfo[@"CPData"];
    UIWebView* web = notifInfo.userInfo[@"CPWeb"];
    [self registerHandler:pluginName
               withObject:object
                  withWeb:web
                 withData:data
                 complete:notifInfo.userInfo[@"CPBlock"]];
}
#pragma mark - 系统通知
- (void)screenLock
{
//    if (Context.isLoginFlag) {
//        [self registerHandler:@"CPScreenLock/lockScreen" withObject:nil withData:nil];
//    }
}

@end
