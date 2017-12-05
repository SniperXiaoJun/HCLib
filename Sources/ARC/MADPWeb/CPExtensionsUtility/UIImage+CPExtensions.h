//
//  UIImage+CPImageFromBundle.h
//  CPBaseManager
//
//  Created by 刘任朋 on 15/11/5.
//  Copyright © 2015年 刘认朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CPExtensions)
+ (UIImage *)imageNamed:(NSString *)imageName inbundle:(NSString *)bundleName withPath :(NSString *)imageFlorder;
@end

