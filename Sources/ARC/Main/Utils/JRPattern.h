//
//  JRPattern.h
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/4/30.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRPattern : NSObject
#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;

#pragma 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;

#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserId : (NSString *) userName;

#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;

#pragma 正则匹配用户身份证号 身份证格式校验
+ (BOOL)CheckIsIdentityCard:(NSString *)userID;

#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;


#pragma 正则匹配邮箱
-(BOOL)checkURLEmail:(NSString *)email;

@end

