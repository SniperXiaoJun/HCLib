//
//  UIButton+JRSY.m
//  buttonT
//
//  Created by Shen Yu on 15/12/21.
//  Copyright © 2015年 Shen Yu. All rights reserved.
//

#import "UIButton+JRSY.h"

@implementation UIButton (JRSY)

+ (UIButton *)buttonWithTitle:(NSString *)title titleFont:(UIFont *)titleFont image:(UIImage *)imageNormal selectedImage:(UIImage *)selectedImage frame:(CGRect)frame{
//+ (UIButton *)buttonWithTitle:(NSString *)title titleFont:(UIFont *)titleFont image:(NSString *)imageName frame:(CGRect)frame{

    
    // button imageView titleLabel 的宽高
    CGFloat buttonW = frame.size.width;
    CGFloat buttonH = frame.size.height;
    
    UIImage *image = imageNormal;
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // button 的属性
//    button.backgroundColor = [UIColor redColor];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = titleFont;
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = frame;
    
    
    NSDictionary *attrs = @{NSFontAttributeName : button.titleLabel.font};
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize titleSize= [button.titleLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    CGFloat titleH = titleSize.height;
    CGFloat titleW = titleSize.width;

    
    CGFloat marginH = (buttonH - imageH - titleH) / 3;
    
    // button 的属性
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    // button 的字体颜色
    [button setTitleColor:RGB_COLOR(34, 34, 34) forState:UIControlStateNormal];
    
//    button.titleLabel.backgroundColor = [UIColor purpleColor];
//    button.imageView.backgroundColor = [UIColor lightGrayColor];
    
    CGFloat titlePaddingL = (buttonW - titleW) / 2 - imageW;
    button.imageEdgeInsets = UIEdgeInsetsMake(marginH,(buttonW - imageW) / 2,0,0);
    button.titleEdgeInsets = UIEdgeInsetsMake(marginH * 2 + imageH, titlePaddingL, 0, 0);
    NSLog(@"++++++btn333  image edgeInset %@",NSStringFromUIEdgeInsets(button.imageEdgeInsets));
    NSLog(@"++++++btn333  title edgeInset %@",NSStringFromUIEdgeInsets(button.titleEdgeInsets));
    
    return button;
}

@end
