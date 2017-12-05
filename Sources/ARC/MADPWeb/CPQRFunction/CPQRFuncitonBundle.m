//
//  CPQRFuncitonBundle.m
//  CPQRFunction
//
//  Created by liurenpeng on 8/4/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CPQRFuncitonBundle.h"

@implementation CPQRFuncitonBundle
+ (NSString*)getFileWithName:(NSString*)filename
{
    NSBundle* libBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:BUNDLE_NAME]];
    if (libBundle && filename) {
        NSString* s = [[[libBundle resourcePath] stringByAppendingPathComponent:@"resource"] stringByAppendingPathComponent:filename];
#ifdef DEBUG
//        NSLog(@"filePath:%@", s);
#endif
        return s;
    }
    return nil;
}
+ (NSString*)getBundleVersion
{
    NSBundle* libBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:BUNDLE_NAME]];
    return [libBundle objectForInfoDictionaryKey:@"CFBundleVersion"];
}
@end
