//
//  JRPluginUtil.m
//  Double
//
//  Created by 何崇 on 2017/11/8.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "JRPluginUtil.h"
#import "UIBarButtonItem+JRExtension.h"
#import "JRBindCardViewController.h"
#import "JRUploadIdCardViewController.h"

@implementation JRPluginUtil

+ (instancetype)shareInstance{
    static JRPluginUtil *instances = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instances = [[JRPluginUtil alloc] init];
    });
    return instances;
}


+ (void)needReLogin{
    DebugLog(@"重新登录方法");
    //插件内部自登陆 登录失败走Singleton.SJJLoginBlock();
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"客户还未登录哦!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
//    Singleton.SJJLoginBlock(nil);
}

+ (BOOL)isCustmerOk{

    if (!Singleton.userInfo[@"CifName"] ||[Singleton.userInfo[@"CifName"] length] == 0) {
        DebugLog(@"您尚未进行实名认证");

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未进行实名认证" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"实名认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"ok");
            JRUploadIdCardViewController *bindCard = [[JRUploadIdCardViewController alloc] init];
            [Singleton.rootViewController pushViewController:bindCard animated:YES];
        }];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"cancel");
        }];


        [alertController addAction:okAction];
        [alertController addAction:cancelAction];

        [Singleton.rootViewController presentViewController:alertController animated:YES completion:nil];
        
        return NO;
    }


    return YES;
}

+ (BOOL)isCheckOk{


    if (!Singleton.userInfo[@"CifName"] ||[Singleton.userInfo[@"CifName"] length] == 0) {
        DebugLog(@"您尚未进行实名认证");

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未进行实名认证" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"实名认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"ok");
            JRUploadIdCardViewController *bindCard = [[JRUploadIdCardViewController alloc] init];
            [Singleton.rootViewController pushViewController:bindCard animated:YES];
        }];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"cancel");
        }];


        [alertController addAction:okAction];
        [alertController addAction:cancelAction];

        [Singleton.rootViewController presentViewController:alertController animated:YES completion:nil];

        return NO;
    }

    if (!Singleton.userInfo[@"Entitycard"] ||[Singleton.userInfo[@"Entitycard"] length] == 0) {
        DebugLog(@"您个人账户尚未绑卡");

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您个人账户尚未绑卡" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"绑卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"ok");
            JRBindCardViewController *bindCard = [[JRBindCardViewController alloc] init];
            [Singleton.rootViewController pushViewController:bindCard animated:YES];

        }];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"cancel");
        }];


        [alertController addAction:okAction];
        [alertController addAction:cancelAction];

        [Singleton.rootViewController presentViewController:alertController animated:YES completion:nil];
        return NO;
    }




    return YES;
}

+ (BOOL)checkApplyConsume{

    if ([Singleton.consumeInfoDict[@"applyInfo"][@"applyStatus"] isEqualToString:@"SQZT_NULL"]||
        [Singleton.consumeInfoDict[@"applyInfo"][@"applyStatus"] isEqualToString:@""] ||
        [Singleton.consumeInfoDict[@"applyInfo"][@"applyStatus"] isEqualToString:@"SQZT_SQ"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您尚未申请乐享消费贷" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"cancel");
        }];

        [alertController addAction:cancelAction];
        [Singleton.rootViewController presentViewController:alertController animated:YES completion:nil];

        return NO;

    }else{
        return YES;
    }

}


+ (BOOL)getConsumeValidLimit{

    if ([Singleton.consumeInfoDict[@"validAmt"] floatValue]>0){
        return YES;//validAmt
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的乐享消费贷可用额度为0" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"cancel");
        }];


        [alertController addAction:cancelAction];
        [Singleton.rootViewController presentViewController:alertController animated:YES completion:nil];

        return NO;
        return NO;
    }

}





+ (BOOL)checkApplyConsumeNoAlert {
    if ([Singleton.consumeInfoDict[@"applyInfo"][@"applyStatus"] isEqualToString:@"SQZT_NULL"]||
        [Singleton.consumeInfoDict[@"applyInfo"][@"applyStatus"] isEqualToString:@""] ||
        [Singleton.consumeInfoDict[@"applyInfo"][@"applyStatus"] isEqualToString:@"SQZT_SQ"]){
        return NO;

    }else{
        return YES;
    }

}

- (void)setLeftBarButton{
    UIImage *image_url = JRBundeImage( @"back_60_60");

    if ([Singleton.rootViewController isKindOfClass:[UINavigationController class]]) {
        SEL sel = Singleton.rootViewController.navigationItem.leftBarButtonItem.action;

        UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem itemTarget:self action:sel image:image_url highlightedImage:image_url];

        Singleton.rootViewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }


}

@end
