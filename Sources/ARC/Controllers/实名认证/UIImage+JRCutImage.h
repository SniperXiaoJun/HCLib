//
//  UIImage+JRCutImage.h
//  尚信
//
//  Created by michael on 14-1-18.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JRCutImage)
-(UIImage*)getSubImage:(CGRect)rect;
- (UIImage *)fixOrientation;
@end
