//
//  CPUIBackButton.m
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-5-12.
//  Copyright (c) 2013年 科蓝公司. All rights reserved.

#import "CPUIBackButton.h"


@implementation CPUIBackButton

- (id)init
{
    self = [super init];
    if (self!=nil) {
        NSString *title = @"";
        
        CGSize labelsize = [title sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(320, 30)];
        labelsize.width = [title length]*17;
        
        UIImageView *backButtonLeft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 10, 20)];
        
//        [backButtonLeft setImage:[UIImage imageWithContentsOfFile:[CSIILibBundle getFileWithName:@"backButtonLeft.png"]]];
        
        [backButtonLeft setImage:JRBundeImage(@"left")];
        
        UIImageView *backButtonCenter = [[UIImageView alloc]initWithFrame:CGRectMake(30, 0, labelsize.width*2, 60)];
//        [backButtonCenter setImage:[UIImage imageWithContentsOfFile:[CSIILibBundle getFileWithName:@"backButtonCenter.png"]]];
        UIImageView *backButtonRight = [[UIImageView alloc]initWithFrame:CGRectMake(30+labelsize.width*2, 0, 18, 60)];
//        [backButtonRight setImage:[UIImage imageWithContentsOfFile:[CSIILibBundle getFileWithName:@"backButtonRight.png"]]];
        
        UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 48+(labelsize.width)*2, 60)];
        buttonView.backgroundColor = [UIColor clearColor];
        backButtonLeft.backgroundColor = [UIColor clearColor];
        [buttonView addSubview:backButtonLeft];
        backButtonCenter.backgroundColor = [UIColor clearColor];
        [buttonView addSubview:backButtonCenter];
        backButtonRight.backgroundColor = [UIColor clearColor];
        [buttonView addSubview:backButtonRight];
        
        UIImage *buttonImage = [self getImageFromView:buttonView];
        
        [self setFrame:CGRectMake(5, 7, 13+9+labelsize.width, 30)];
        [self setImage:buttonImage forState:UIControlStateNormal];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
        [label setNumberOfLines:0];
        label.frame = CGRectMake(13, 0, labelsize.width, 30);
        label.text = title;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:16];
        //设置高亮
        label.highlighted = YES;
        label.highlightedTextColor = [UIColor whiteColor];
        //设置阴影
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(0,-0.5);
        
        [self addSubview:label];

    }
    return self;
}

- (id)initWithTitle:(NSString*)title
{
    self = [super init];
    if (self!=nil) {
        if (title == nil || [title isEqualToString:@""]) {
            title = @"  ";
        }
        CGSize labelsize = [title sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(320, 30)];
        labelsize.width = [title length]*17;
        
        UIImageView *backButtonLeft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 60)];
        
//        [backButtonLeft setImage:[UIImage imageWithContentsOfFile:[CSIILibBundle getFileWithName:@"backButtonLeft.png"]]];
        
        [backButtonLeft setImage:JRBundeImage(@"left")];

        
        UIImageView *backButtonCenter = [[UIImageView alloc]initWithFrame:CGRectMake(30, 0, labelsize.width*2, 60)];
//        [backButtonCenter setImage:[UIImage imageWithContentsOfFile:[CSIILibBundle getFileWithName:@"backButtonCenter.png"]]];
        UIImageView *backButtonRight = [[UIImageView alloc]initWithFrame:CGRectMake(30+labelsize.width*2, 0, 18, 60)];
//        [backButtonRight setImage:[UIImage imageWithContentsOfFile:[CSIILibBundle getFileWithName:@"backButtonRight.png"]]];
        
        UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 48+(labelsize.width)*2, 60)];
        buttonView.backgroundColor = [UIColor clearColor];
        backButtonLeft.backgroundColor = [UIColor clearColor];
        [buttonView addSubview:backButtonLeft];
        backButtonCenter.backgroundColor = [UIColor clearColor];
        [buttonView addSubview:backButtonCenter];
        backButtonRight.backgroundColor = [UIColor clearColor];
        [buttonView addSubview:backButtonRight];
        
        UIImage *buttonImage = [self getImageFromView:buttonView];
        
        [self setFrame:CGRectMake(5, 7, 13+9+labelsize.width, 30)];
        [self setImage:buttonImage forState:UIControlStateNormal];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
        [label setNumberOfLines:0]; 
        label.frame = CGRectMake(13, 0, labelsize.width, 30);
        label.text = title;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:16];
        //设置高亮
        label.highlighted = YES;
        label.highlightedTextColor = [UIColor whiteColor];
        //设置阴影
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(0,-0.5);

        [self addSubview:label];
    }
    return self;
}
- (UIImage*)getImageFromView:(UIView*)view
{
    //支持retina高分的关键
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions([view bounds].size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext([view bounds].size);
    }
    
    BOOL hidden = [view isHidden];
    [view setHidden:NO];
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [view setHidden:hidden];
    return image;
}
@end
