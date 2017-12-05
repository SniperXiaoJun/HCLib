//
//  JRJumpClientToVx.h
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/4/7.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRJumpClientToVx : NSObject
+ (void)jumpWithZipID:(NSString *)zipID controller:(UIViewController *)controller;

+ (void)jumpWithZipID:(NSString *)zipID controller:(UIViewController *)controller params:(NSDictionary *)params;

@end
