//
//  UIBarButtonItem+Extension.h
//  SYWeiBo
//
//  Created by Shen Yu on 15/10/11.
//  Copyright © 2015年 Shen Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (JRExtension)
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highlightedImage:(NSString *)highlightedImage;

+(UIBarButtonItem *)itemTarget:(id)target action:(SEL)action image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;
@end
