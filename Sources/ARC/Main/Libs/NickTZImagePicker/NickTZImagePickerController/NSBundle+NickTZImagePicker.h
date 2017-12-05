//
//  NSBundle+NickTZImagePicker.h
//  NickTZImagePickerController
//
//  Created by 谭真 on 16/08/18.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (NickTZImagePicker)

+ (NSBundle *)tz_imagePickerBundle;

+ (NSString *)tz_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)tz_localizedStringForKey:(NSString *)key;

@end

