//
//  CSIIUINavigationController.m
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-2-27.
//  Copyright (c) 2013年 科蓝公司. All rights reserved.
//

#import "CSIIUINavigationController.h"
#import "CPContacts.h"
#import "CSIIConfigGlobalImport.h"
@interface CSIIUINavigationController ()

@end

@implementation CSIIUINavigationController
- (id)init;
{
    self = [super init];
    if (self) {
        // TODO:4.3.3
        if ([[[UIDevice currentDevice] systemVersion] intValue] < 5) {
            self.delegate = self;
        }
    }
    return self;
}

+ (NSMutableDictionary*)getAnimationConfig;
{
    return nil;
    //    return [[NSData
    //    dataWithContentsOfFile:DOCUMENT_FOLDER(ANIMATIONFILENAME)]
    //    objectFromJSONData];
}
// TODO:4.3.3
- (void)navigationController:(UINavigationController*)navigationController
      willShowViewController:(UIViewController*)viewController
                    animated:(BOOL)animated
{
    if ([[[UIDevice currentDevice] systemVersion] intValue] < 5) {
        [viewController viewWillAppear:animated];
        [viewController viewDidAppear:animated];
    }
}
//推入某一控制类
- (void)pushViewController:(UIViewController*)viewController
                  animated:(BOOL)animated
{
    //    if (![Context checkPowerWithPageId:NSStringFromClass([viewController
    //    class])]) {
    //
    ////        UIAlertView * alert=[UIAlertView alloc]
    ////
    ////        [[CSIIUIAlert sharedInstance]showAlert:[[CSIIBusinessCaller
    ///alloc]init] title:kNetworkErrorTitle message:kPageNoOTPPowerMessage];
    //        return;
    //    }
    //    if([CSIIBusinessContext
    //    isNoPowerOnNoNetwork:NSStringFromClass([viewController class])]){
    //        return;
    //    }else{
    if (Context.isNoAnimationFlag) {
        [super pushViewController:viewController animated:NO];
    }
    else {
        if (animated) {
            NSString* animationType = [[[self class] getAnimationConfig]
                objectForKey:NSStringFromClass([viewController class])];
            if (Context.tempAnimationType) {
                animationType = Context.tempAnimationType;
            }
            if (animationType) {
                if ([animationType isEqualToString:@"kAnimationTypeDefault"]) {
                    [super pushViewController:viewController animated:YES];
                }
                else if ([animationType isEqualToString:@"kAnimationTypeNone"]) {
                    [super pushViewController:viewController animated:NO];
                }
                else if ([animationType isEqualToString:@"kAnimationTypePage"]) {
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:ANIMATE_DURATION];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationRepeatAutoreverses:NO];
                    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
                                           forView:self.view
                                             cache:NO];
                    [UIView commitAnimations];
                    [super pushViewController:viewController animated:NO];
                }
                else if ([animationType isEqualToString:@"kAnimationTypeFlip"]) {
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:ANIMATE_DURATION];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationRepeatAutoreverses:NO];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                                           forView:self.view
                                             cache:NO];
                    [UIView commitAnimations];
                    [super pushViewController:viewController animated:NO];
                }
            }
            else {
                //                    [UIView beginAnimations:nil context:nil];
                //                    [UIView setAnimationDuration:ANIMATE_DURATION];
                //                    [UIView
                //                    setAnimationCurve:UIViewAnimationCurveEaseInOut];
                //                    [UIView setAnimationRepeatAutoreverses:NO];
                //                    [UIView
                //                    setAnimationTransition:UIViewAnimationTransitionCurlUp
                //                    forView:self.view cache:NO];
                //                    [UIView commitAnimations];
                [super pushViewController:viewController animated:YES];
            }
        }
        else {
            [super pushViewController:viewController animated:NO];
        }
    }
    //    }
}

//返回上一页
- (UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    // NSStringFromClass([self.topViewController class])
    if (Context.isNoAnimationFlag) {
        return [super popViewControllerAnimated:NO];
    }
    else {
        if (animated) {
            NSString* animationType = [[[self class] getAnimationConfig]
                objectForKey:NSStringFromClass([self.topViewController class])];
            if (Context.tempAnimationType) {
                animationType = Context.tempAnimationType;
            }
            if (animationType) {
                if ([animationType isEqualToString:@"kAnimationTypeDefault"]) {
                    return [super popViewControllerAnimated:YES];
                }
                else if ([animationType isEqualToString:@"kAnimationTypeNone"]) {
                    return [super popViewControllerAnimated:NO];
                }
                else if ([animationType isEqualToString:@"kAnimationTypePage"]) {
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:ANIMATE_DURATION];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationRepeatAutoreverses:NO];
                    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
                                           forView:self.view
                                             cache:NO];
                    [UIView commitAnimations];
                    return [super popViewControllerAnimated:NO];
                }
                else if ([animationType isEqualToString:@"kAnimationTypeFlip"]) {
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:ANIMATE_DURATION];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationRepeatAutoreverses:NO];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                                           forView:self.view
                                             cache:NO];
                    [UIView commitAnimations];
                    return [super popViewControllerAnimated:NO];
                }
            }
            else {
                //                [UIView beginAnimations:nil context:nil];
                //                [UIView setAnimationDuration:ANIMATE_DURATION];
                //                [UIView
                //                setAnimationCurve:UIViewAnimationCurveEaseInOut];
                //                [UIView setAnimationRepeatAutoreverses:NO];
                //                [UIView
                //                setAnimationTransition:UIViewAnimationTransitionCurlDown
                //                forView:self.view cache:NO];
                //                [UIView commitAnimations];
                return [super popViewControllerAnimated:YES];
            }
        }
        else {
            return [super popViewControllerAnimated:NO];
        }
        return nil;
    }
}

//返回根控制类
- (NSArray*)popToRootViewControllerAnimated:(BOOL)animated
{
    if (Context.isNoAnimationFlag) {
        return [super popToRootViewControllerAnimated:NO];
    }
    else {
        if (animated) {
            NSString* animationType = [[[self class] getAnimationConfig]
                objectForKey:NSStringFromClass([self.topViewController class])];
            if (Context.tempAnimationType) {
                animationType = Context.tempAnimationType;
            }
            if (animationType) {
                if ([animationType isEqualToString:@"kAnimationTypeDefault"]) {
                    return [super popToRootViewControllerAnimated:YES];
                }
                else if ([animationType isEqualToString:@"kAnimationTypeNone"]) {
                    return [super popToRootViewControllerAnimated:NO];
                }
                else if ([animationType isEqualToString:@"kAnimationTypePage"]) {
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:ANIMATE_DURATION];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationRepeatAutoreverses:NO];
                    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
                                           forView:self.view
                                             cache:NO];
                    [UIView commitAnimations];
                    return [super popToRootViewControllerAnimated:NO];
                }
                else if ([animationType isEqualToString:@"kAnimationTypeFlip"]) {
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:ANIMATE_DURATION];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationRepeatAutoreverses:NO];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                                           forView:self.view
                                             cache:NO];
                    [UIView commitAnimations];
                    return [super popToRootViewControllerAnimated:NO];
                }
            }
            else {
                //                [UIView beginAnimations:nil context:nil];
                //                [UIView setAnimationDuration:ANIMATE_DURATION];
                //                [UIView
                //                setAnimationCurve:UIViewAnimationCurveEaseInOut];
                //                [UIView setAnimationRepeatAutoreverses:NO];
                //                [UIView
                //                setAnimationTransition:UIViewAnimationTransitionCurlDown
                //                forView:self.view cache:NO];
                //                [UIView commitAnimations];
                return [super popToRootViewControllerAnimated:YES];
            }
        }
        else {
            return [super popToRootViewControllerAnimated:YES];
        }
        return nil;
    }
}

//返回某一控制类
- (NSArray*)popToViewController:(UIViewController*)viewController
                       animated:(BOOL)animated
{

    if (Context.isNoAnimationFlag) {
        return [super popToViewController:viewController animated:NO];
    }
    else {
        if (animated) {
            NSString* animationType = [[[self class] getAnimationConfig]
                objectForKey:NSStringFromClass([self.topViewController class])];
            if (Context.tempAnimationType) {
                animationType = Context.tempAnimationType;
            }
            if (animationType) {
                if ([animationType isEqualToString:@"kAnimationTypeDefault"]) {
                    return [super popToViewController:viewController animated:YES];
                }
                else if ([animationType isEqualToString:@"kAnimationTypeNone"]) {
                    return [super popToViewController:viewController animated:NO];
                }
                else if ([animationType isEqualToString:@"kAnimationTypePage"]) {
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:ANIMATE_DURATION];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationRepeatAutoreverses:NO];
                    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
                                           forView:self.view
                                             cache:NO];
                    [UIView commitAnimations];
                    return [super popToViewController:viewController animated:NO];
                }
                else if ([animationType isEqualToString:@"kAnimationTypeFlip"]) {
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:ANIMATE_DURATION];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationRepeatAutoreverses:NO];
                    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                                           forView:self.view
                                             cache:NO];
                    [UIView commitAnimations];
                    return [super popToViewController:viewController animated:NO];
                }
            }
            else {
                //                [UIView beginAnimations:nil context:nil];
                //                [UIView setAnimationDuration:ANIMATE_DURATION];
                //                [UIView
                //                setAnimationCurve:UIViewAnimationCurveEaseInOut];
                //                [UIView setAnimationRepeatAutoreverses:NO];
                //                [UIView
                //                setAnimationTransition:UIViewAnimationTransitionCurlDown
                //                forView:self.view cache:NO];
                //                [UIView commitAnimations];
                return [super popToViewController:viewController animated:YES];
            }
        }
        else {
            return [super popToViewController:viewController animated:NO];
        }
        return nil;
    }
}
@end
