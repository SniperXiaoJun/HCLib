//
//  CSIIUIMBProgressHUD.m
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-23.
//  Copyright (c) 2013年 科蓝公司. All rights reserved.
//

#import "CPUIActivityIndicator.h"
#import "CPMBProgressHUD.h"
#import "UIImage+CPExtensions.h"
@implementation CPUIActivityIndicator
@synthesize activityIndicatorLock, activityIndicator, activityIndicatorCount;
@synthesize cancelButton;
static CPUIActivityIndicator* _sharedInstance;

- (void)addToShowView:(UIView*)showView;
{
    self.activityIndicator = [[CPMBProgressHUD alloc] initWithView:showView];
    self.activityIndicator.color = [UIColor clearColor];
    self.activityIndicator.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6f];

    UIImageView* backview =
        [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 53, 53)];
    backview.image = [UIImage imageNamed:@"bluecoloricon"
                                inbundle:@"MADPPluginSDKResource.bundle"
                                withPath:@"BaseController"];

    CAMediaTimingFunction* linearCurve =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    CABasicAnimation* animation =
        [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = @(0);
    animation.toValue = @(2 * M_PI);
    animation.duration = 1.f;
    animation.repeatCount = INFINITY;
    animation.removedOnCompletion = NO;
    animation.timingFunction = linearCurve;
    animation.fillMode = kCAFillModeForwards;
    animation.autoreverses = NO;
    UIImageView* cusView =
        [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 53, 53)];
    cusView.image = [UIImage imageNamed:@"bluecolor"
                               inbundle:@"MADPPluginSDKResource.bundle"
                               withPath:@"BaseController"];
    [cusView.layer addAnimation:animation forKey:@"keyFrameAnimation"];
    [backview addSubview:cusView];

    self.activityIndicator.labelColor = [UIColor blackColor];
    self.activityIndicator.labelFont = [UIFont systemFontOfSize:14];
    self.activityIndicator.customView = backview;
    self.activityIndicator.mode = CSIIMBProgressHUDModeCustomView;

    self.activityIndicator.delegate = (id<CSIIMBProgressHUDDelegate>)self;
    [showView addSubview:self.activityIndicator];
    self.activityIndicator.labelText = @"请稍候...";
    self.cancelButton = [[UIButton alloc]
        initWithFrame:CGRectMake(self.activityIndicator.center.x + 30,
                          self.activityIndicator.center.y - 60, 30, 30)];
    //    [self.cancelButton setImage:[UIImage
    //    imageWithContentsOfFile:[CSIILibBundle getFileWithName:@"cancel.png"]]
    //    forState:UIControlStateNormal];
    self.cancelButton.hidden = YES;
    [self.cancelButton addTarget:self
                          action:@selector(cancelButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.activityIndicator addSubview:self.cancelButton];
}
- (id)init
{
    self = [super init];
    if (self) {
        self.activityIndicatorCount = 0;
    }
    return self;
}
+ (CPUIActivityIndicator*)sharedInstance;
{
    @synchronized(self)
    {
        if (!_sharedInstance)
            _sharedInstance = [[CPUIActivityIndicator alloc] init];
        return _sharedInstance;
    }
}
- (void)cancelButtonAction:(UIButton*)sender;
{
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"kCancelTransaction"
                      object:nil];
}

- (void)show;
{
    self.cancelButton.hidden = YES;
//    self.activityIndicator.labelText = @"请稍候...";
//    self.activityIndicatorCount++;
    [self.activityIndicator show:YES];
}

- (void)showWithLabelText:(NSString*)labelText;
{
    self.cancelButton.hidden = YES;
    if (labelText != nil && ![labelText isEqualToString:@""]) {
        self.activityIndicator.labelText = labelText;
    }
    else {
        self.activityIndicator.labelText = @"请稍候...";
    }
    self.activityIndicatorCount++;
    [self.activityIndicator show:YES];
}

- (void)showWithCanCancel:(BOOL)canCancel;
{
    if (canCancel) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            self.cancelButton.hidden = NO;
        }
    }
    else {
        self.cancelButton.hidden = YES;
    }
    self.activityIndicator.labelText = @"请稍候...";
    self.activityIndicatorCount++;
    [self.activityIndicator show:YES];
}

- (void)show:(BOOL)canCancel labelText:(NSString*)labelText;
{
    if (canCancel) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            self.cancelButton.hidden = NO;
        }
    }
    else {
        self.cancelButton.hidden = YES;
    }
    if (labelText != nil && ![labelText isEqualToString:@""]) {
        self.activityIndicator.labelText = labelText;
    }
    else {
        self.activityIndicator.labelText = @"请稍候...";
    }
    self.activityIndicatorCount++;
    [self.activityIndicator show:YES];
}

- (void)hidden;
{
//    self.activityIndicatorCount--;
//    if (self.activityIndicatorCount < 0) {
//        self.activityIndicatorCount = 0;
//    }
//    if (self.activityIndicatorCount == 0) {
        [self.activityIndicator hide:YES];
//    }
}

- (void)close;
{
//    self.activityIndicatorCount = 0;
//    if (self.activityIndicatorCount == 0) {
        [self.activityIndicator hide:YES];
//    }
}

- (void)hudWasHidden:(CPMBProgressHUD*)hud;
{
    self.activityIndicator.labelText = @"请稍候...";
    self.cancelButton.hidden = YES;
}
@end
