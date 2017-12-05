//
//  CPUtility.m
//  CPBaseManager
//
//  Created by 刘任朋 on 15/11/25.
//  Copyright © 2015年 刘认朋. All rights reserved.
//

#import "CPUtility.h"

@implementation CPUtility
+ (NSString*)getFilePath:(NSString*)fileNmae
                inbundle:(NSString*)bundleName
                withPath:(NSString*)fileFlorder
{

    NSString* bundlePath =
        [[NSBundle mainBundle]
                .resourcePath stringByAppendingPathComponent:bundleName];
    NSBundle* bundle = [NSBundle bundleWithPath:bundlePath];
    if (fileFlorder) {

        NSString* filepath =
            [bundle pathForResource:fileNmae
                             ofType:@""
                        inDirectory:fileFlorder];
        return filepath;
    }
    NSString* filepath = [bundle pathForResource:fileNmae ofType:@""];
    return filepath;
}
+ (NSArray*)separatedString:(NSString*)aStr withString:(NSString*)aSegStr;
{
    NSArray* array =
        [NSArray arrayWithArray:[aStr componentsSeparatedByString:aSegStr]];
    return array;
}

+ (void)registerNotificationName:(NSString*)aName
                          object:(NSString*)pluginName
                        userInfo:(NSDictionary*)aUserInfo;
{

    [[NSNotificationCenter defaultCenter] postNotificationName:aName
                                                        object:pluginName
                                                      userInfo:aUserInfo];
}
+ (void)impObserver:(id)observer
           selector:(SEL)aSelector
         pluginName:(NSString*)aName
             object:(id)anObject;
{
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:aSelector
                                                 name:aName
                                               object:anObject];
}

+ (id)registerHandlerWithReturnObj:(NSString*)handlerName
{
    Class class = NSClassFromString(handlerName);
    id obj = [[class alloc] init];
    return obj;
}
+ (void)registerHandler:(NSString*)handlerName
             withObject:(id)object
               withData:(id)data;
{
    if (handlerName.length <= 0) {
        DebugLog(@"rootController hanlerNmae is nil");
        return;
    }
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if ([CPUtility judgeObjectIfnil:object]) {
        [dic setObject:object forKey:@"CPObject"];
    }
    if ([CPUtility judgeObjectIfnil:data]) {
        [dic setObject:data forKey:@"CPData"];
    }

    [dic setObject:handlerName forKey:@"CPPluginName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"registerHandler"
                                                        object:@"CPMajorManager"
                                                      userInfo:dic];
}

+ (void)registerHandler:(NSString*)handlerName
             withObject:(id)object
               withData:(id)data
               complete:(void (^)(id responseData))completeBlock;
{

    if (handlerName.length <= 0) {
        DebugLog(@"rootController hanlerNmae is nil");
        return;
    }
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if ([CPUtility judgeObjectIfnil:object]) {
        [dic setObject:object forKey:@"CPObject"];
    }
    if ([CPUtility judgeObjectIfnil:data]) {
        [dic setObject:data forKey:@"CPData"];
    }
    if ([CPUtility judgeObjectIfnil:completeBlock]) {
        [dic setObject:completeBlock forKey:@"CPBlock"];
    }
    [dic setObject:handlerName forKey:@"CPPluginName"];

    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"registerHandlerWithBlock"
                      object:@"CPMajorManager"
                    userInfo:dic];
}

+ (void)registerHandler:(NSString*)handlerName
             withObject:(id)object
                withWeb:(UIWebView*)webView
               withData:(id)data
               complete:(void (^)(id responseData))completeBlock;
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if ([CPUtility judgeObjectIfnil:object]) {
        [dic setObject:object forKey:@"CPObject"];
    }
    if ([CPUtility judgeObjectIfnil:data]) {
        [dic setObject:data forKey:@"CPData"];
    }
    if ([CPUtility judgeObjectIfnil:webView]) {
        [dic setObject:webView forKey:@"CPWeb"];
    }
    if ([CPUtility judgeObjectIfnil:completeBlock]) {
        [dic setObject:completeBlock forKey:@"CPBlock"];
    }
    [dic setObject:handlerName forKey:@"CPPluginName"];
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"registerHandlerWithWebAndBlock"
                      object:@"CPMajorManager"
                    userInfo:[dic mutableCopy]];
}

+ (BOOL)judgeObjectIfnil:(id)object
{
    if (object) {
        return YES;
    }
    return NO;
}
@end
