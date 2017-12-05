//
//  CSIIBusinessValueCheck.m
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-22.
//  Copyright (c) 2013年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import "CSIIBusinessValueCheck.h"

BOOL match(NSRegularExpression *regex, NSString *string)
{
    NSTextCheckingResult *match = [regex firstMatchInString:string
                                                    options:0
                                                      range:NSMakeRange(0, [string length])];
    if (match) {
        NSRange matchRange = [match range];
        if (matchRange.length == [string length]) {
            return TRUE;
        }
    }
    return FALSE;
}

@implementation CSIIBusinessValueCheck

+ (BOOL)isValidPassword:(NSString*)password
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(?![a-zA-Z]+$)(?![0-9]+$)[0-9a-zA-Z]{6,16}$"
                                                                           options:0 error:nil];
    return match(regex, password);
}

+ (BOOL)isValidSMSPassword:(NSString*)password
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{6}$"
                                                                           options:0 error:nil];
    return match(regex, password);
}

+ (BOOL)isValidOTPPassword:(NSString*)password
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d{6}$"
                                                                           options:0 error:nil];
    return match(regex, password);
}

+ (BOOL)isValidMoney:(NSString*)money
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"^(0*[1-9]\\d{0,12}(\\.\\d{0,2})?)|(0*\\.[1-9][0-9])|(0*\\.0[1-9])|(0*\\.[1-9])$"options:0 error:nil];
    return match(regex, money);
}

+ (BOOL)isValidAccountNumber:(NSString*)accountNumber
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9\\-]{1,32}$"
                                                                           options:0 error:nil];
    return match(regex, accountNumber);
}

+ (BOOL)isValidAccountName:(NSString*)accountName
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"^[a-zA-Z0-9（）\\(\\)《》<>\\-\\u4e00-\\u9fff]{1,30}" options:0 error:nil];
    return match(regex, accountName);
}

+ (BOOL)isValidRemark:(NSString*)remark
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"^[a-zA-Z0-9\\u4e00-\\u9fbb\\u3400-\\u4dbf\\uf900-\\ufad9\\u3000-\\u303f\\u2000-\\u206f\\uff00-\\uffff]{1,32}$" options:0 error:nil];
    return match(regex, remark);
}

+ (BOOL)isCard:(NSString*)account
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"^\\d{16}(\\-\\d{1,3})?$" options:0 error:nil];
    return match(regex, account);
}

+ (BOOL)isBankBook:(NSString*)account
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"^(\\d{15}(\\-\\d{1,3})?)|(\\d{10}(\\-\\d{1,3})?)$" options:0 error:nil];
    return match(regex, account);
}

+ (BOOL)isAcAlias:(NSString*)acAlias
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"^[A-Za-z0-9\\u4E00-\\u9FBB\\u3400-\\u4DBF\\uF900-\\uFAD9\\u3000-\\u303F\\u2000-\\u206F\\uFF00-\\uFFEF]{1,20}$" options:0 error:nil];
    return match(regex, acAlias);
}
+ (BOOL)isUserSecretNotice:(NSString*)userSecretNotice
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"^[A-Za-z0-9\\u4E00-\\u9FBF\\u007B\\u005B\\u0028\\u0029\\u005D]{1}[A-Za-z0-9\\u4E00-\\u9FBB\\u3400-\\u4DBF\\uF900-\\uFAD9\\u3000-\\u303F\\u2000-\\u206F\\uFF00-\\uFFEF\\(\\)\\（\\）\\《\\》\\。\\，\\-\\.\\,\\：\\—]{0,19}$" options:0 error:nil];
    return match(regex, userSecretNotice);
}

+ (BOOL)isIdNumber:(NSString*)account;
{
    return YES;
}

+ (BOOL)isPhoneNumber:(NSString*)phoneNumber;
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)" options:0 error:nil];
    return  match(regex, phoneNumber);
}
@end
