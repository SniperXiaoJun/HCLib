//
//  JRRRGB.m
//  RGB
//
//  Created by roycms on 2016/10/19.
//  Copyright © 2016年 roycms. All rights reserved.
//

#import "JRRRGB.h"
@implementation JRRRGB

+ (UIColor *)colorWithRGB16:(int)rgb {
    return [UIColor colorWithRed:((rgb & 0xFF0000) >> 16) / 255.0f
                           green:((rgb & 0xFF00) >> 8) / 255.0f
                            blue:((rgb & 0xFF)) / 255.0f
                           alpha:1.0f];
}
+ (UIColor *)colorWithRGBFromString:(NSString *)rgb {
    if ([rgb rangeOfString:@"#"].location != NSNotFound) {
        rgb = [rgb substringFromIndex:1];
    }
    rgb = [NSString stringWithFormat:@"0x%@",rgb];
    unsigned long rgb16 = strtoul([rgb UTF8String],0,16);
    
    return [self colorWithRGB16:(int)rgb16];
}


//+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
//{
//    //删除字符串中的空格
//    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
//    // String should be 6 or 8 characters
//    if ([cString length] < 6)
//    {
//        return [UIColor clearColor];
//    }
//    // strip 0X if it appears
//    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
//    if ([cString hasPrefix:@"0X"])
//    {
//        cString = [cString substringFromIndex:2];
//    }
//    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
//    if ([cString hasPrefix:@"#"])
//    {
//        cString = [cString substringFromIndex:1];
//    }
//    if ([cString length] != 6)
//    {
//        return [UIColor clearColor];
//    }
//    
//    // Separate into r, g, b substrings
//    NSRange range;
//    range.location = 0;
//    range.length = 2;
//    //r
//    NSString *rString = [cString substringWithRange:range];
//    //g
//    range.location = 2;
//    NSString *gString = [cString substringWithRange:range];
//    //b
//    range.location = 4;
//    NSString *bString = [cString substringWithRange:range];
//    
//    // Scan values
//    unsigned int r, g, b;
//    [[NSScanner scannerWithString:rString] scanHexInt:&r];
//    [[NSScanner scannerWithString:gString] scanHexInt:&g];
//    [[NSScanner scannerWithString:bString] scanHexInt:&b];
//    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
//}
//
////默认alpha值为1
//+ (UIColor *)colorWithHexString:(NSString *)color
//{
//    return [self colorWithHexString:color alpha:1];
//}


@end
