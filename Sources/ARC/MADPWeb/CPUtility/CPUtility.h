//
//  CPUtility.h
//  CPBaseManager
//
//  Created by 刘任朋 on 15/11/25.
//  Copyright © 2015年 刘认朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPUtility : NSObject

/*!
 * @method
 * @abstract 从bundle读取文件路径
 * @param fileNmae 文件名
 * @param bundleName bundle名
 * @param fileFlorder 所在文件夹
 * @result 路径字符串
 */
+ (NSString*)getFilePath:(NSString*)fileNmae
                inbundle:(NSString*)bundleName
                withPath:(NSString*)fileFlorder;
/*!
 * @method
 * @abstract 分割字符串
 * @param aStr 字符串
 * @param aSegStr 分割标示
 * @result 数组
 */
+ (NSArray*)separatedString:(NSString*)aStr withString:(NSString*)aSegStr;

/*!
 *  发送通知
 *
 *  @param aName      通知名
 *  @param pluginName 通知的执行的标识符
 *  @param aUserInfo  通知信息
 */
+ (void)registerNotificationName:(NSString*)aName
                          object:(NSString*)pluginName
                        userInfo:(NSDictionary*)aUserInfo;

/*!
 *  注册通知
 *
 *  @param observer  注册对象
 *  @param aSelector SEL
 *  @param aName     通知名 唯一标识
 *  @param anObject  一个对象
 */
+ (void)impObserver:(id)observer
           selector:(SEL)aSelector
         pluginName:(NSString*)aName
             object:(id)anObject;
/*!
 *  注册插件
 *
 *  @param handlerName 插件名 格式为（插件名/指令名）
 *  @return 返回一个对象
 */
+ (id)registerHandlerWithReturnObj:(NSString*)handlerName;

/*!
 *  注册插件
 *
 *  @param handlerName 插件名 格式为（插件名/指令名）
 *  @param object      一个对象
 *  @param data        一个数据
 */
+ (void)registerHandler:(NSString*)handlerName
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
+ (void)registerHandler:(NSString*)handlerName
             withObject:(id)object
               withData:(id)data
               complete:(void (^)(id responseData))completeBlock;

/*!
 *  注册插件
 *
 *  @param handlerName   插件名 格式为（插件名/指令名）
 *  @param object        一个对象
 *  @param webView       UIWebView
 *  @param data          一个数据
 *  @param completeBlock 回调函数
 */
+ (void)registerHandler:(NSString*)handlerName
             withObject:(id)object
                withWeb:(UIWebView*)webView
               withData:(id)data
               complete:(void (^)(id responseData))completeBlock;
@end
