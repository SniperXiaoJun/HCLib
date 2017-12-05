//
//  NSObject+CSIIMJMember.h
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSIIMJIvar.h"
#import "CSIIMJMethod.h"

/**
 *  遍历所有类的block（父类）
 */
typedef void (^CSIIMJClassesBlock)(Class c, BOOL *stop);

@interface NSObject (CSIIMJMember)

/**
 *  遍历所有的成员变量
 */
- (void)enumerateIvarsWithBlock:(CSIIMJIvarsBlock)block;

/**
 *  遍历所有的方法
 */
- (void)enumerateMethodsWithBlock:(CSIIMJMethodsBlock)block;

/**
 *  遍历所有的类
 */
- (void)enumerateClassesWithBlock:(CSIIMJClassesBlock)block;
@end
