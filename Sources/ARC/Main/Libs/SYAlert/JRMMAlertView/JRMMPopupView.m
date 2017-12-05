//
//  JRMMPopupView.m
//  JRMMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "JRMMPopupView.h"
#import "JRMMPopupWindow.h"
#import "JRMMPopupDefine.h"
#import "JRMMPopupCategory.h"
#import "NickMasonry.h"

static NSString * const JRMMPopupViewHideAllNotification = @"JRMMPopupViewHideAllNotification";

@implementation JRMMPopupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.type = JRMMPopupTypeAlert;
    self.animationDuration = 0.3f;
    self.attachedView = [JRMMPopupWindow sharedWindow].attachView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHideAll:) name:JRMMPopupViewHideAllNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JRMMPopupViewHideAllNotification object:nil];
}

- (void)notifyHideAll:(NSNotification*)n
{
    if ( [self isKindOfClass:n.object] )
    {
        [self hide];
    }
}

+ (void)hideAll
{
    [[NSNotificationCenter defaultCenter] postNotificationName:JRMMPopupViewHideAllNotification object:[self class]];
}

- (BOOL)visible
{
    if ( self.attachedView )
    {
        return !self.attachedView.mm_dimBackgroundView.hidden;
    }
    
    return NO;
}

- (void)setType:(JRMMPopupType)type
{
    _type = type;
    
    switch (type)
    {
        case JRMMPopupTypeAlert:
        {
            self.showAnimation = [self alertShowAnimation];
            self.hideAnimation = [self alertHideAnimation];
            break;
        }
        case JRMMPopupTypeSheet:
        {
            self.showAnimation = [self sheetShowAnimation];
            self.hideAnimation = [self sheetHideAnimation];
            break;
        }
        case JRMMPopupTypeCustom:
        {
            self.showAnimation = [self customShowAnimation];
            self.hideAnimation = [self customHideAnimation];
            break;
        }
            
        default:
            break;
    }
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
    _animationDuration = animationDuration;
    
    self.attachedView.mm_dimAnimationDuration = animationDuration;
}

- (void)show
{
    [self showWithBlock:nil];
}

- (void)showWithBlock:(JRMMPopupCompletionBlock)block
{
    if ( block )
    {
        self.showCompletionBlock = block;
    }
    
    if ( !self.attachedView )
    {
        self.attachedView = [JRMMPopupWindow sharedWindow].attachView;
    }
    [self.attachedView mm_showDimBackground];
    
    JRMMPopupBlock showAnimation = self.showAnimation;
    
    NSAssert(showAnimation, @"show animation must be there");
    
    showAnimation(self);
    
    if ( self.withKeyboard )
    {
        [self showKeyboard];
    }
}

- (void)hide
{
    [self hideWithBlock:nil];
}

- (void)hideWithBlock:(JRMMPopupCompletionBlock)block
{
    if ( block )
    {
        self.hideCompletionBlock = block;
    }
    
    if ( !self.attachedView )
    {
        self.attachedView = [JRMMPopupWindow sharedWindow].attachView;
    }
    [self.attachedView mm_hideDimBackground];
    
    if ( self.withKeyboard )
    {
        [self hideKeyboard];
    }
    
    JRMMPopupBlock hideAnimation = self.hideAnimation;
    
    NSAssert(hideAnimation, @"hide animation must be there");
    
    hideAnimation(self);
}

- (JRMMPopupBlock)alertShowAnimation
{
    JRMMWeakify(self);
    JRMMPopupBlock block = ^(JRMMPopupView *popupView){
        JRMMStrongify(self);
        
        if ( !self.superview )
        {
            [self.attachedView.mm_dimBackgroundView addSubview:self];
            [self mas_updateConstraints:^(NickMASConstraintMaker *make) {
                make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, self.withKeyboard?-216/2:0));
            }];
            [self layoutIfNeeded];
        }
        
        self.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
        self.alpha = 0.0f;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.layer.transform = CATransform3DIdentity;
                             self.alpha = 1.0f;
                             
                         } completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self, finished);
                             }
                         }];
    };
    
    return block;
}

- (JRMMPopupBlock)alertHideAnimation
{
    JRMMWeakify(self);
    JRMMPopupBlock block = ^(JRMMPopupView *popupView){
        JRMMStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options: UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.alpha = 0.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( finished )
                             {
                                 [self removeFromSuperview];
                             }
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (JRMMPopupBlock)sheetShowAnimation
{
    JRMMWeakify(self);
    JRMMPopupBlock block = ^(JRMMPopupView *popupView){
        JRMMStrongify(self);
        
        if ( !self.superview )
        {
            [self.attachedView.mm_dimBackgroundView addSubview:self];
            
            [self mas_updateConstraints:^(NickMASConstraintMaker *make) {
                make.centerX.equalTo(self.attachedView);
                make.bottom.equalTo(self.attachedView.mas_bottom).offset(self.attachedView.frame.size.height);
            }];
            [self layoutIfNeeded];
        }
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(NickMASConstraintMaker *make) {
                                 make.bottom.equalTo(self.attachedView.mas_bottom).offset(0);
                             }];
                             
                             [self.superview layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (JRMMPopupBlock)sheetHideAnimation
{
    JRMMWeakify(self);
    JRMMPopupBlock block = ^(JRMMPopupView *popupView){
        JRMMStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(NickMASConstraintMaker *make) {
                                 make.bottom.equalTo(self.attachedView.mas_bottom).offset(self.attachedView.frame.size.height);
                             }];
                             
                             [self.superview layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( finished )
                             {
                                 [self removeFromSuperview];
                             }
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (JRMMPopupBlock)customShowAnimation
{
    JRMMWeakify(self);
    JRMMPopupBlock block = ^(JRMMPopupView *popupView){
        JRMMStrongify(self);
        
        if ( !self.superview )
        {
            [self.attachedView.mm_dimBackgroundView addSubview:self];
            [self mas_updateConstraints:^(NickMASConstraintMaker *make) {
                make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, -self.attachedView.bounds.size.height));
            }];
            [self layoutIfNeeded];
        }
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:1.5
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(NickMASConstraintMaker *make) {
                                 make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, self.withKeyboard?-216/2:0));
                             }];
                             
                             [self.superview layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (JRMMPopupBlock)customHideAnimation
{
    JRMMWeakify(self);
    JRMMPopupBlock block = ^(JRMMPopupView *popupView){
        JRMMStrongify(self);
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(NickMASConstraintMaker *make) {
                                 make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, self.attachedView.bounds.size.height));
                             }];
                             
                             [self.superview layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             
                             if ( finished )
                             {
                                 [self removeFromSuperview];
                             }
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self, finished);
                             }
                         }];
    };
    
    return block;
}

- (void)showKeyboard
{
    
}

- (void)hideKeyboard
{
    
}

@end
