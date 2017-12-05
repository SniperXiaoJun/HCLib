//
//  UIImage+CPImageFromBundle.m
//  CPBaseManager
//
//  Created by 刘任朋 on 15/11/5.
//  Copyright © 2015年 刘认朋. All rights reserved.
//

#import "UIImage+CPExtensions.h"
#import "CPDebug.h"
#import "CPConfigGlobalDefine.h"
@implementation UIImage (CPExtensions)
+ (UIImage *)imageNamed:(NSString *)imageName
               inbundle:(NSString *)bundleName
               withPath:(NSString *)imageFlorder {
    
    UIImage *image;
    
    NSString *bundlePath =
    [[NSBundle mainBundle]
     .resourcePath stringByAppendingPathComponent:bundleName];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if (imageFlorder) {
        
        NSString *image_url = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@",bundleName,imageFlorder,imageName]];
        
        
        
        image = [UIImage
                 imageWithContentsOfFile:
                 [bundle
                  pathForResource:[NSString stringWithFormat:@"%@%@", imageName,
                                   [self imageWithType:IMAGE_TYPE  withPath:image_url]]
                  ofType:@".png"
                  inDirectory:imageFlorder]];
        return image;
    }
    NSString *image_url = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",bundleName,imageName]];
    
    image = [UIImage
             imageWithContentsOfFile:
             [bundle pathForResource:[NSString stringWithFormat:@"%@%@", imageName,
                                      [self imageWithType:IMAGE_TYPE  withPath:image_url]]
                              ofType:@".png"]];
    return image;
}
+(NSString *)imageWithType:(NSString *)type withPath:(NSString *)imagePath{
    
    if ([self imagefileExists:type withPath:imagePath]) {
        return type;
    }else{
        
        if ([type isEqualToString:@"@3x"]) {
            if ([self imagefileExists:@"@2x" withPath:imagePath]) {
                return @"@2x";
                
            }else
                return @"";
            
            
        }else if ([type isEqualToString:@"@2x"]){
            if ([self imagefileExists:@"@3x" withPath:imagePath]) {
                return @"@3x";
                
            }else
                return @"";
            
            
            
        }else if ([type isEqualToString:@""]){
            
            if ([self imagefileExists:@"@3x" withPath:imagePath]) {
                return @"@3x";
                
            }else
                return @"@2x";
            
        }
        
    }
    return @"";
}

+(BOOL)imagefileExists:(NSString *)type withPath:(NSString *)imagePath{
    
    NSString *image_url =[NSString stringWithFormat:@"%@%@.png",imagePath,type];
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:image_url]){
        return YES;
    }else{
        return NO;
    }
}
@end
