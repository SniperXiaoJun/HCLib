//
//  CSIIUIMBProgressHUD.h
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-23.
//  Copyright (c) 2013年 科蓝公司. All rights reserved.
//
#import "CPMBProgressHUD.h"
//@class MBProgressHUD;
@interface CPUIActivityIndicator : NSObject {
  NSRecursiveLock *activityIndicatorLock;
  CPMBProgressHUD *activityIndicator;
  int activityIndicatorCount;
  UIButton *cancelButton;
}

@property(strong) NSRecursiveLock *activityIndicatorLock;
@property(assign, nonatomic) int activityIndicatorCount;
@property(nonatomic, strong) CPMBProgressHUD *activityIndicator;
@property(nonatomic, strong) UIButton *cancelButton;

+ (CPUIActivityIndicator *)sharedInstance;
- (void)addToShowView:(UIView *)showView;
- (void)show;
- (void)showWithLabelText:(NSString *)labelText;
- (void)showWithCanCancel:(BOOL)canCancel;
- (void)show:(BOOL)canCancel labelText:(NSString *)labelText;
- (void)hidden;
- (void)close;
@end
