//
//  CPQRFuncitonBundle.h
//  CPQRFunction
//
//  Created by liurenpeng on 8/4/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#define BUNDLE_NAME @ "CPQRFunction.bundle"
@interface CPQRFuncitonBundle : NSObject
+(NSString *)getFileWithName:(NSString *)filename;
+(NSString*)getBundleVersion;
@end
