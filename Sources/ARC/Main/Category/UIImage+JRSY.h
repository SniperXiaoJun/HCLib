//
//  UIImage+capture.h
//  sy-截图
//
//  Created by Shen Yu on 15/9/21.
//  Copyright (c) 2015年 Shen Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JRSY)
+ (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color ;
- (UIImage *)imageWithColor:(UIColor *)color;

/** 使用字符串生成二维码 */
+ (UIImage *)imageWithQrStr:(NSString *)str;
/** 生成条形码 */
+ (UIImage *)imageWithBarCodeStr:(NSString *)str;
@end

