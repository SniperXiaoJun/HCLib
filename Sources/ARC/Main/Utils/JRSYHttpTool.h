//
//  JRSYHttpTool.h
//  SYWeiBo
//
//  Created by Shen Yu on 15/10/27.
//  Copyright © 2015年 Shen Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYAFNetworking.h"
@interface JRSYHttpTool : NSObject
/**
 *  post方法发送请求
 *
 *  @param URLString  url地址
 *  @param parameters 要传递的参数
 *  @param success    请求成功执行的代码块
 *  @param failure    请求失败执行的代码块
 */
+ (void)post:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;
/**
 *  get方法发送请求
 *
 *  @param URLString  url地址
 *  @param parameters 要传递的参数
 *  @param success    请求成功执行的代码块
 *  @param failure    请求失败执行的代码块
 */
+ (void)get:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;

/** 无弹框的Post */
+ (void)post_no_alert:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;


+(void)getFileContentFromServerActionName:(NSString *)actionName WithArgument:(NSDictionary *)argument onSuccessAnyObjectBlock:(void(^)(id result))onSuccessBlock onFailureBlock:(void(^)(NSError* error))onFailureBlock;

@end
