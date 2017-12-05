//
//  CPMask.m
//  CSIIPlatformLib
//
//  Created by 任兴 on 15/6/30.
//  Copyright (c) 2015年 刘任朋. All rights reserved.
//

#import "CPMask.h"
#import "CPContext.h"
#import "CPUIActivityIndicator.h"
#define kSplashScreenDurationDefault 0.25f

@implementation CPMask
static CPMask *_sharedInstance;

//+ (CPMask *)sharedInstance;
//{
//  @synchronized(self) {
//    if (!_sharedInstance) {
//      _sharedInstance = [[CPMask alloc] init];
//    }
//    return _sharedInstance;
//  }
//}
//
//- (void)addWindowMask {
//  [[CPUIActivityIndicator sharedInstance]
//      addToShowView:[UIApplication sharedApplication].keyWindow];
//}
/**
 @method
 @abstract 显示遮罩层
 @result 返回值通过pluginResponseCallback  类型 string
 */
- (void)ShowMask {

  [[CPUIActivityIndicator sharedInstance] show];
}

/**
 @method
 @abstract 隐藏遮罩层
 @result 返回值通过pluginResponseCallback  类型 string
 */
- (void)HideMask {

  [[CPUIActivityIndicator sharedInstance] hidden];
}

@end
