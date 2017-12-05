//
//  JRCheckAcNo.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/5/17.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRCheckAcNo.h"

@implementation JRCheckAcNo
+ (BOOL)isCheckOk{

    
    if (!Singleton.userInfo[@"CifName"] ||[Singleton.userInfo[@"CifName"] length] == 0) {
        DebugLog(@"您尚未进行实名认证");
        UIAlertView *alertCif = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未进行实名认证" delegate:Singleton.rootViewController cancelButtonTitle:@"取消" otherButtonTitles:@"实名认证", nil];
        alertCif.tag = 1;
        [alertCif show];
        return NO;
    }
    
    if (!Singleton.userInfo[@"Entitycard"] ||[Singleton.userInfo[@"Entitycard"] length] == 0) {
        DebugLog(@"您个人账户尚未绑卡");
        UIAlertView *alertAcNo = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您个人账户尚未绑卡" delegate:Singleton.rootViewController cancelButtonTitle:@"取消" otherButtonTitles:@"绑卡", nil];
        alertAcNo.tag = 2;
        [alertAcNo show];
        return NO;
    }
    return YES;
}



+ (BOOL)isCheckAcNoOk{
    if (!Singleton.userInfo[@"Entitycard"] ||[Singleton.userInfo[@"Entitycard"] length] == 0) {
        DebugLog(@"您个人账户尚未绑卡");
        UIAlertView *alertAcNo = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您个人账户尚未绑卡" delegate:Singleton.rootViewController cancelButtonTitle:@"取消" otherButtonTitles:@"绑卡", nil];
        alertAcNo.tag = 2;
        [alertAcNo show];
        return NO;
    }
    return YES;

}

@end
