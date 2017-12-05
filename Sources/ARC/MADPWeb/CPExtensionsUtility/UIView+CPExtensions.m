//
//  UIView+CPExtensions.m
//  CPBaseManager
//
//  Created by 刘任朋 on 15/11/5.
//  Copyright © 2015年 刘认朋. All rights reserved.
//

#import "UIView+CPExtensions.h"

@implementation UIView (CPExtensions)

- (void)setX:(CGFloat)x;
{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setY:(CGFloat)y;
{
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.height, self.frame.size.height);
}

- (void)setWidth:(CGFloat)width;
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setHeight:(CGFloat)height;
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}


- (CGFloat)getX;
{
    return self.frame.origin.x;
}

- (CGFloat)getY;
{
    return self.frame.origin.y;
    
}

- (CGFloat)getWidth;
{
    return self.frame.size.width;
}

- (CGFloat)getHeight;
{
    return  self.frame.size.height;
    
}

@end
