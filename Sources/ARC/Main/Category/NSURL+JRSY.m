//
//  NSURL+JRSY.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/4/12.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "NSURL+JRSY.h"

@implementation NSURL (JRSY)
/** 解决SDWebImage 中文路径无法读取的问题 */
+ (nullable instancetype)imageURLWithString_SD:(NSString *)URLString{

    NSString *encodedString = (NSString *)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)URLString,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,kCFStringEncodingUTF8));
    
//    NSString *imageUrl = [imgStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:encodedString];
    
}

@end
