//
//  CSIIBusinessUncaughtExceptionHandler.h
//  BankofYingkou
//
//  Created by 刘旺 on 12-7-30.
//  Copyright (c) 2012年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSIIBusinessUncaughtExceptionHandler : NSObject
void UncaughtExceptionHandler(NSException * exception);
+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;

@end
