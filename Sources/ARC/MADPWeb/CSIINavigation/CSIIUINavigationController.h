//
//  CSIIUINavigationController.h
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-2-27.
//  Copyright (c) 2013年 科蓝公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface CSIIUINavigationController
    : UINavigationController <UINavigationControllerDelegate> {
  NSMutableDictionary *animationConfig;
}
+ (NSMutableDictionary *)getAnimationConfig;

@end
