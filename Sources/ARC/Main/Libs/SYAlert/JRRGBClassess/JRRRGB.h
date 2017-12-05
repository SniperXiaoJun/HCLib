//
//  JRRRGB.h
//  RGB
//
//  Created by roycms on 2016/10/19.
//  Copyright © 2016年 roycms. All rights reserved.
//

#define RGB(rgbValue) [JRRRGB colorWithRGBFromString:(rgbValue)]
#define RGB16(rgbValue) [JRRRGB colorWithRGB16:(rgbValue)]

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JRRRGB : NSObject
+ (UIColor *)colorWithRGB16:(int)rgb;
+ (UIColor *)colorWithRGBFromString:(NSString *)rgb;




//#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
//#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]
//
//
//+ (UIColor *)colorWithHexString:(NSString *)color;
//
////从十六进制字符串获取颜色，
////color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
//+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
