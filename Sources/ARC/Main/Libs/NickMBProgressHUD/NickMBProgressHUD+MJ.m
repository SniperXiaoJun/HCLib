//
//  NickMBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//



/*
   add by shenyu
 
   目前还是用的之前的hud，github新版使用异步线程gcd的方式显示，在主线程关闭，最好以后可以切换过去
 */
#import "NickMBProgressHUD+MJ.h"

@implementation NickMBProgressHUD (MJ)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    if (view == nil) view = Singleton.rootViewController.view;

    // 快速显示一个提示信息
    NickMBProgressHUD *hud = [NickMBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"NickMBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = NickMBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 0.7秒之后再消失
    [hud hide:YES afterDelay:0.7];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"errorjr.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"successjr.png" view:view];
}

#pragma mark 显示一些信息
+ (NickMBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    if (view == nil) view = Singleton.rootViewController.view;
    
    DebugLog(@"HUD: show Message %@",message);
    // 快速显示一个提示信息
    NickMBProgressHUD *hud = [NickMBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (NickMBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
//    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
     if (view == nil) view = Singleton.rootViewController.view;
    
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
//    DebugLog(@"HUD: hide Message ");

    [self hideHUDForView:nil];
}
@end
