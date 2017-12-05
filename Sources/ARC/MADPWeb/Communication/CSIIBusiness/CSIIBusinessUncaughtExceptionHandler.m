//
//  CSIIBusinessUncaughtExceptionHandler.m
//  BankofYingkou
//
//  Created by 刘旺 on 12-7-30.
//  Copyright (c) 2012年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import "CSIIBusinessUncaughtExceptionHandler.h"

// 沙盒的地址
NSString * applicationDocumentsDirectory() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


void UncaughtExceptionHandler(NSException * exception)
{
//    NSArray * arr = [exception callStackSymbols];
//    NSString * reason = [exception reason];
//    NSString * name = [exception name];
//    NSString * url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
////    [url writeToFile:DOCUMENT_FOLDER(@"Exception.txt") atomically:YES encoding:NSUTF8StringEncoding error:nil];
//
//    
//	NSString *urlStr = [NSString stringWithFormat:@"mailto:liuwang68@126.com?subject=重庆银行客户端bug报告&body=很抱歉应用出现故障,感谢您的配合!发送这封邮件可协助我们改善此应用<br>"
//						"错误详情:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@", 
//						name,reason,[arr componentsJoinedByString:@"<br>"]];
	
//	NSURL *url2 = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//	[[UIApplication sharedApplication] openURL:url2];
    
    
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason]; // // 崩溃的原因  可以有崩溃的原因(数组越界,字典nil,调用未知方法...) 崩溃的控制器以及方法
    NSString * name = [exception name];
    NSString * url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    NSString * path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    // 将一个txt文件写入沙盒
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
}

@implementation CSIIBusinessUncaughtExceptionHandler
+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler *)getHandler
{
    return NSGetUncaughtExceptionHandler();
}

+ (void)TakeException:(NSException *)exception
{
    UncaughtExceptionHandler(exception);
}

@end
/*
 @try{
    NSMutableDictionary *s = [[NSMutableDictionary alloc]init];
    [s setObject:nil forKey:@"sdf"];
 }
 @catch (NSException *exception) {
    [CSIIBusinessUncaughtExceptionHandler TakeException:exception];
 }
 @finally {
 }
 */
