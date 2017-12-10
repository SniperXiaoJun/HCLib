//
//  JRPluginUtil.h
//  Double
//
//  Created by 何崇 on 2017/11/8.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRPluginUtil : NSObject

+ (instancetype)shareInstance;

+ (UIImage *)imageNamedFromMyBundle:(NSString *)name;

//重新登录
+ (void)needReLogin;

+ (BOOL)isCheckOk;

+ (BOOL)isCustmerOk;

//是否有可用额度
+ (BOOL)getConsumeValidLimit;

//是否申请消费贷   弹窗
+ (BOOL)checkApplyConsume;

//是否申请消费贷  不弹窗
+ (BOOL)checkApplyConsumeNoAlert;

- (void)setLeftBarButton;

@end
