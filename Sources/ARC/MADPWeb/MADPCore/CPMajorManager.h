//
//  majorManager.h
//  Product
//
//  Created by 刘任朋 on 15/11/5.
//  Copyright © 2015年 刘认朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^MAJResponseCallback)(id responseData);
typedef void (^MAJBHandler)(id responseData);
@interface CPMajorManager : NSObject
@property (nonatomic, strong) UIViewController* rootViewController;
@property (nonatomic, strong) NSMutableDictionary* pluginsDictionary;
@property (nonatomic, strong) UINavigationController* rootNavController;
+ (CPMajorManager*)sharedInstance;

/*!
 *  程序启动入口
 *  @param handler 对应 （插件名／ 方法名）
 *  @param serverIP 对应 服务器地址
 *  @param serverPath 对应 服务名
 *  @return loading 对象
 */
- (void)startApplication:(NSString*)handler
            withServerIP:(NSString*)serverIP
          withServerPath:(NSString*)serverPath;



- (void)setServerIP:(NSString*)serverIP withServerPath:(NSString*)serverPath;
/*!
 *   进入主视图
 *
 *  @param handler 插件名/方法名
 */
- (void)inRootController:(NSString*)handler;

/*!
 *  插件指令字符串截取
 *
 *  @param handler 插件名/方法名
 *
 *  @return 截取后的数组
 */
- (NSArray*)getPluginHandlerArray:(NSString*)handler;

/*!
 *  注册插件
 *
 *  @param handlerName 插件名 格式为（插件名/指令名）
 *  @param object      一个对象
 *  @param data        一个数据
 */
- (void)registerHandler:(NSString*)handlerName
             withObject:(id)object
               withData:(id)data;
/*!
 *  注册插件
 *
 *  @param handlerName   插件名 格式为（插件名/指令名）
 *  @param object        一个对象
 *  @param data          一个数据
 *  @param completeBlock 回调函数
 */
- (void)registerHandler:(NSString*)handlerName
             withObject:(id)object
               withData:(id)data
               complete:(void (^)(id responseData))completeBlock;

/*!
 *  注册插件
 *  @param handlerName   插件名 格式为（插件名/指令名）
 *  @param object        一个对象
 *  @param webView       UIWebView
 *  @param data          一个数据
 *  @param completeBlock 回调函数
 */
- (void)registerHandler:(NSString*)handlerName
             withObject:(id)object
                withWeb:(UIWebView*)webView
               withData:(id)data
               complete:(void (^)(id responseData))completeBlock;

/*!
 *  发送通知
 *
 *  @param aName      通知名
 *  @param pluginName 通知的执行的标识符
 *  @param aUserInfo  通知信息
 */
- (void)postNotificationName:(NSString*)aName
                      object:(NSString*)pluginName
                    userInfo:(NSDictionary*)aUserInfo;
/*!
 *  注册通知
 *  @param observer      通知名
 *  @param aName 通知的执行的标识符
 *  @param aSelector 调用方法
 *  @param anObject  对象
 */

- (void)addObserver:(id)observer
           selector:(SEL)aSelector
         pluginName:(NSString*)aName
             object:(id)anObject;
-(void)checkVersion;
@end
