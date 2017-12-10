//
//  CPPassword.m
//  ZXBAuthentication
//
//  Created by Summer on 2016/12/28.
//  Copyright © 2016年 Shen Yu. All rights reserved.
//

#import "CPPassword.h"
#import "JRAlertPassWord.h"
@implementation CPPassword
-(void)showTrsPassword{
    NSLog(@"%@",self.curData);//VX 传过来的参数
    //self.curViewController 当前viewcontroller
    Context.sendDictionaryData = self.curData;
    JRAlertPassWord *pwdView = [[JRAlertPassWord alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
     [((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]).rootViewController.view addSubview:pwdView];
    [pwdView show:^{
        NSLog(@"context.pass %@",Context.sendStringData);
        pluginResponseCallback(Context.sendStringData);//回调给vx值
    }];
}
@end
