//
//  CPUIBackButton.h
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-5-12.
//  Copyright (c) 2013年 科蓝公司. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface CPUIBackButton : UIButton {
    
}
/*!
 * @method
 * @abstract 初始化导航栏左侧按钮
 * @param title 按钮的title
 * @result 返回值通过pluginResponseCallback  类型 string
 */

- (id)initWithTitle:(NSString*)title;

/*!
 * @method
 * @abstract 从view上获取图片
 * @param view
 * @result image
 */
-(UIImage *)getImageFromView:(UIView *)view;
@end