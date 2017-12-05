//
//  JRJumpIntercept.h
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/5/1.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRJumpIntercept : NSObject

/** 我要贷款 */
//+ (void)appLoanWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller;

+ (void)appLoanWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller success:(void(^)())success;


/** 个人贷款 */
+ (void)homeLoanWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller;


/** 设置 */
+ (void)settingWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller;

/** 帮助中心 */
+ (void)helpCenterWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller;

/** 电子发票 */
+ (void)InvoiceWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller;


//- (SYAFHTTPRequestOperation *)GETONE:(NSString *)URLString
//                          parameters:(id)parameters
//                             success:(void (^)(SYAFHTTPRequestOperation *operation, id responseObject))success


//+ (void)get:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void(^)(id json))success failure:(void(^)(NSError *error))failure{




/** 扫码支付 */
+ (void)consumeQrWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller;
@end
