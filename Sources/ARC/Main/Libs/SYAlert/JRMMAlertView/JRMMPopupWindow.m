//
//  JRMMPopupWindow.m
//  JRMMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "JRMMPopupWindow.h"
#import "JRMMPopupCategory.h"
#import "JRMMPopupDefine.h"
#import "JRMMPopupView.h"

@interface JRMMPopupWindow()
<
UIGestureRecognizerDelegate
>

@end

@implementation JRMMPopupWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
        gesture.cancelsTouchesInView = NO;
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
    }
    return self;
}

+ (JRMMPopupWindow *)sharedWindow
{
    static JRMMPopupWindow *window;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        window = [[JRMMPopupWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        window.rootViewController = [UIViewController new];
    });
    
    return window;
}

- (void)cacheWindow
{
    [self makeKeyAndVisible];
    [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];
    
    [self attachView].mm_dimBackgroundView.hidden = YES;
    self.hidden = YES;
}

- (void)actionTap:(UITapGestureRecognizer*)gesture
{
    if ( self.touchWildToHide && !self.mm_dimBackgroundAnimating )
    {
        for ( UIView *v in [self attachView].mm_dimBackgroundView.subviews )
        {
            if ( [v isKindOfClass:[JRMMPopupView class]] )
            {
                JRMMPopupView *popupView = (JRMMPopupView*)v;
                [popupView hide];
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ( touch.view == self.attachView.mm_dimBackgroundView );
}

- (UIView *)attachView
{
    return self.rootViewController.view;
}

@end
