//
//  NSString+JRSY.m
//  JRSY-Lottery
//
//  Created by Shen Yu on 15/9/23.
//  Copyright (c) 2015年 Shen Yu. All rights reserved.
//

#import "NSString+JRSY.h"
#import <UIKit/UIKit.h>
@implementation NSString (JRSY)
/**
 *  计算文字尺寸
 *  @param font    文字的字体
 *  @param maxW 文字的最大宽度
 */
-(CGSize) sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
/**
 *  计算文字尺寸
 *  @param font    文字的字体
 */
-(CGSize) sizeWithFont:(UIFont *)font{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}
/**
 *  计算文字尺寸
 *
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
-(CGSize) sizeWithFont:(UIFont *)font maxSize:(CGSize )maxSize{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


/**
 *  非空判断
 */
- (BOOL) isEmptyOrNull{
    
    if(self.length == 0){
     return YES;
    }
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
- (NSString *)remixIdCard{
//    144999198998980101
    if (self.length == 0) {
        return @"";
    }
    return [self stringByReplacingCharactersInRange:NSMakeRange(4, self.length - 8) withString:@"**********"];
}


/** 手机 前三 后四 显示 ，中间*号 */
- (NSString *)remixPhoneNum{
    
    if (self.length == 0) {
        return @"";
    }
    return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}
/**
 处理字符串

 @param dict 交易传回来的一条信息
 @return remixStr
 */
- (NSString *)strRemixWithDict:(NSDictionary *)dict{
    /*
    {
        "term_k": "理财期限",
        "term_v": "120",
        "rate_k": "预期年化收益",
        "rate_v": "4.5",
        "startamount_k": "起购金额",
        "startamount_v": "1000",
        "product_name": "渤海通宝之共赢系列2016第2期理财产品",
    }*/
    __block NSString *remixStr = @"";
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *tagStr = [NSString stringWithFormat:@"{{%@}}",key];
        if ([self rangeOfString:tagStr].length != 0) {
            
            if ([key isEqualToString:@"term_v"]) {
                obj = [NSString stringWithFormat:@"%@天",obj];
            }else if ([key isEqualToString:@"rate_v"]){
                obj = [NSString stringWithFormat:@"%@%%",obj];
            }else if ([key isEqualToString:@"startamount_v"]){
                obj = [NSString stringWithFormat:@"%@万元",obj];
            }
            
           remixStr =  [self stringByReplacingOccurrencesOfString:tagStr withString:obj];
            *stop = YES;
        }
    }];
    return remixStr;
}

- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}
@end
