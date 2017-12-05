//
//  NSString+JRSY.h
//  JRSY-Lottery
//
//  Created by Shen Yu on 15/9/23.
//  Copyright (c) 2015年 Shen Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (JRSY)
/** 计算文字尺寸 maxW 文字的最宽度*/
- (CGSize) sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

/** 计算文字尺寸*/
- (CGSize) sizeWithFont:(UIFont *)font;

/** 计算文字尺寸 maxSize 文字的最大尺寸*/
- (CGSize) sizeWithFont:(UIFont *)font maxSize:(CGSize )maxSize;

/* 非空判断 */
- (BOOL) isEmptyOrNull;

- (NSString *)strRemixWithDict:(NSDictionary *)dict;

/** 身份证 前四 后四 显示 ，中间*号 */
- (NSString *)remixIdCard;
/** 手机 前三 后四 显示 ，中间*号 */
- (NSString *)remixPhoneNum;


- (BOOL)isChinese;//判断是否是纯汉字

- (BOOL)includeChinese;//判断是否含有汉字
@end
