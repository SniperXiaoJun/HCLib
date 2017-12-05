//
//  CSIIMJTypeEncoding.m
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//
#import <Foundation/Foundation.h>
/**
 *  成员变量类型（属性类型）
 */
NSString *const CSIIMJTypeInt = @"i";
NSString *const CSIIMJTypeFloat = @"f";
NSString *const CSIIMJTypeDouble = @"d";
NSString *const CSIIMJTypeLong = @"q";
NSString *const CSIIMJTypeLongLong = @"q";
NSString *const CSIIMJTypeChar = @"c";
NSString *const CSIIMJTypeBOOL = @"c";
NSString *const CSIIMJTypePointer = @"*";

NSString *const CSIIMJTypeIvar = @"^{objc_ivar=}";
NSString *const CSIIMJTypeMethod = @"^{objc_method=}";
NSString *const CSIIMJTypeBlock = @"@?";
NSString *const CSIIMJTypeClass = @"#";
NSString *const CSIIMJTypeSEL = @":";
NSString *const CSIIMJTypeId = @"@";

/**
 *  返回值类型(如果是unsigned，就是大写)
 */
NSString *const CSIIMJReturnTypeVoid = @"v";
NSString *const CSIIMJReturnTypeObject = @"@";



