//
//  CSIIUIPickerViewObject.m
//  iPhoneTZBankClient
//
//  Created by 刘旺 on 12-5-31.
//  Copyright (c) 2012年 科蓝公司. All rights reserved.
//

#import "CSIIUIPickerViewObject.h"

@implementation CSIIUIPickerViewObject
@synthesize titleLabelLayer;
@synthesize titleLabel;
@synthesize isRun;
- (id)initWithTitle:(NSString*)titleStr;
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 40)];
    if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 600,40)];
        self.titleLabel.text = titleStr;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        //设置高亮  
        self.titleLabel.highlighted = YES;  
        self.titleLabel.highlightedTextColor = [UIColor blackColor];  
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        if ([titleStr lengthOfBytesUsingEncoding:enc]<=28) {
            self.isRun = NO;
            [self addSubview:self.titleLabel];
        }else {
            self.isRun = YES;
            self.titleLabelLayer = [self.titleLabel layer]; 
            [self.layer addSublayer:self.titleLabelLayer];//将层加到当前View的默认layer下 
        }        
    }
    return self;
}
-(void) endAnimation;
{
    if (self.isRun) {
        [self.titleLabelLayer removeAllAnimations];
    }
}
-(void) startAnimation;
{	
    if (self.isRun) {
        //判断文本实际长度（半角占用一位，全角占用两位）
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        int moveLength = 0;
        float moveTime = 0;
        moveLength = ([self.titleLabel.text lengthOfBytesUsingEncoding:enc]-28)*10;
        moveTime = ([self.titleLabel.text lengthOfBytesUsingEncoding:enc]-28)*0.5;
        //运动轨迹
        CGMutablePathRef thePath=CGPathCreateMutable();
        CGPathMoveToPoint(thePath,NULL,316,20);
        CGPathAddLineToPoint(thePath, NULL, 316-moveLength, 20);
        CGPathAddLineToPoint(thePath, NULL, 316, 20);
        CGPathAddLineToPoint(thePath, NULL, 316, 20);
        
        //添加动画
        CAKeyframeAnimation * animation;
        animation=[CAKeyframeAnimation animationWithKeyPath:@"position"]; 
        animation.path=thePath; 
        animation.duration=moveTime;
        animation.repeatCount=99999999;
        CFRelease(thePath);
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [self.titleLabelLayer addAnimation:animation forKey:kCATransition];
    }    	
}


@end
