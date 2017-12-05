//
//  CPUIRefresh.m
//  CSIIPlatformLib
//
//  Created by 任兴 on 15/6/30.
//  Copyright (c) 2015年 刘任朋. All rights reserved.
//

#import "CPUIRefresh.h"

@implementation CPUIRefresh

- (void)HideBackButton {
  SEL m1 = NSSelectorFromString(@"HideBackButton");
  [self.curViewController performSelector:m1 withObject:nil];
}

- (void)ShowBackButton {

  SEL m1 = NSSelectorFromString(@"ShowBackButton");
  [self.curViewController performSelector:m1 withObject:nil];
}

- (void)SetTitle {
    
  self.curViewController.navigationItem.title =
      self.curData[@"data"][@"Params"];
//    [MBProgressHUD hideHUD];
}

- (void)showRightText{
    SEL m1 = NSSelectorFromString(@"ShowRightButton:");
    [self.curViewController performSelector:m1 withObject:self.curData];
}

- (void)hideRightText{
    SEL m1 = NSSelectorFromString(@"HideRightButton");
    [self.curViewController performSelector:m1 withObject:nil];
}

@end
