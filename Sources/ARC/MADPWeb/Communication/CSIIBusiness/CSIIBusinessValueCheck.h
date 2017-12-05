//
//  CSIIBusinessValueCheck.h
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-22.
//  Copyright (c) 2013年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSIIBusinessValueCheck : NSObject
+ (BOOL)isValidPassword:(NSString*)password;
+ (BOOL)isValidSMSPassword:(NSString*)password;
+ (BOOL)isValidOTPPassword:(NSString*)password;
+ (BOOL)isValidMoney:(NSString*)money;
+ (BOOL)isValidAccountNumber:(NSString*)accountNumber;
+ (BOOL)isValidAccountName:(NSString*)accountName;
+ (BOOL)isValidRemark:(NSString*)remark;
+ (BOOL)isCard:(NSString*)account;
+ (BOOL)isBankBook:(NSString*)account;
+ (BOOL)isIdNumber:(NSString*)account;
+ (BOOL)isPhoneNumber:(NSString*)account;
+ (BOOL)isAcAlias:(NSString*)acAlias;
+ (BOOL)isUserSecretNotice:(NSString*)userSecretNotice;
@end
