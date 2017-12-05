//
//  UIButton+JRSY.h
//  buttonT
//
//  Created by Shen Yu on 15/12/21.
//  Copyright © 2015年 Shen Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JRSY)
/** button  图片在上，文字在下，文字颜色默认红色 */
+ (UIButton *)buttonWithTitle:(NSString *)title titleFont:(UIFont *)titleFont image:(UIImage *)image selectedImage:(UIImage *)selectedImage frame:(CGRect)frame;
@end
