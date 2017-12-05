//
//  UIBarButtonItem+Extension.m
//  SYWeiBo
//
//  Created by Shen Yu on 15/10/11.
//  Copyright © 2015年 Shen Yu. All rights reserved.
//

#import "UIBarButtonItem+JRExtension.h"
#import "UIView+JRExtension.h"
@implementation UIBarButtonItem (JRExtension)
/**
 *  创建一个UIBarButtonItem
 *
 *  @param target           监听器（控制器）
 *  @param action           点击后调用的方法
 *  @param image            图片名
 *  @param highlightedImage 高亮的图片名
 *
 *  @return UIBarButtonItem
 */
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightedImage:(NSString *)highlightedImage{


    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:JRBundeImage(image) forState:UIControlStateNormal];
    [btn setImage:JRBundeImage(image)  forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,btn.frame.size.width-JRBundeImage(image).size.width);

    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


+(UIBarButtonItem *)itemTarget:(id)target action:(SEL)action image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,btn.frame.size.width-image.size.width);

    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
