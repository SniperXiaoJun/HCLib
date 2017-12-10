//
//  CPLogin.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/2/23.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "CPLogin.h"
#import "CPUtility.h"
//#import "LoginViewController.h"

@implementation CPLogin
- (void)isLogin{
    
//    LoginViewController *loginVc = [[LoginViewController alloc] init];
//    UINavigationController* nav = (UINavigationController*)[self.aObject navigationController];
//    loginVc.LoginBlock = ^(NSString *str){
//        
//        DebugLog(@"CPLogin 收到 登录回调");
//        self.pluginResponseCallback(@"login_now");
//    };
//    [nav pushViewController:loginVc animated:YES];
    
    
    
    
//    [CPUtility impObserver:self
//                  selector:@selector(loginNow)
//                pluginName:Login_Notification
//                    object:nil];
//    
//    
//    [[Routable sharedRouter] open:@"login" animated:YES extraParams:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNow) name:Login_Notification object:nil];

    [JRPluginUtil needReLogin];;

}
- (void)loginNow{
    DebugLog(@"CPLogin 收到 登录通知");
    self.pluginResponseCallback(@"login_now");
}
@end
