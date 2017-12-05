//
//  JRSYNavigationController.m
//  SYWeiBo
//
//  Created by Shen Yu on 15/10/11.
//  Copyright © 2015年 Shen Yu. All rights reserved.
//

#import "JRSYNavigationController.h"
#import "UIView+JRExtension.h"
#import "UIBarButtonItem+JRExtension.h"
//#import "JRUploadIdCardViewController.h"
//#import "JRBindCardViewController.h"
#import "CSIILabelButton.h"
@interface JRSYNavigationController ()<UIAlertViewDelegate>

@end

@implementation JRSYNavigationController

//+(void)initialize{
//    
//}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] removeObserver:Singleton.rootViewController name:@"NotCanJumpShowAlert" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:Singleton.rootViewController selector:@selector(showALert:) name:@"NotCanJumpShowAlert" object:nil];
}
/**tui
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */




-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {
        //左边的barButtonItem
        UIImage *image_url = JRBundeImage( @"back_60_60");

        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemTarget:self action:@selector(back) image:image_url highlightedImage:image_url];
        
    }
    [super pushViewController:viewController animated:YES];
}
-(void)back{
    //这里要用self，不是self.navigationController
    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
    [self popViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // 实名认证
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            // 取消
            DebugLog(@"000");
        }else{
            // 确定
            DebugLog(@"111");
//            JRUploadIdCardViewController *r = [[JRUploadIdCardViewController alloc]init];
//            r.phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kUserId];
//            [self pushViewController:r animated:YES];
        }
        
    }
    
    // 绑卡
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            // 取消
            DebugLog(@"000");
        }else{
            // 确定
            DebugLog(@"111");
//            JRBindCardViewController *p = [[JRBindCardViewController alloc]init];
//            [self pushViewController:p animated:YES];
        }
        
    }
    
}


- (void)showALert:(NSNotification *)notifi
{
    NSDictionary *dict = notifi.userInfo;
    NSString *alertMsg = @"";
    
    //    if ([dict[@"showStyle"] isEqualToString:@"0"])
    //    {
    //        alertMsg = @"您尚未进行实名认证";
    //    }
    //    else if ([dict[@"showStyle"] isEqualToString:@"1"])
    //    {
    //        alertMsg = @"您尚未绑定银行卡";
    //    }
    //    else if ([dict[@"showStyle"] isEqualToString:@"2"])
    //    {
    //        alertMsg = @"您还不是企业用户,请前往PC端进行企业注册";
    //    }
    //    else if ([dict[@"showStyle"] isEqualToString:@"3"])
    //    {
    //        alertMsg = @"您的企业账户尚未绑卡,无法申请乐商流水贷";
    //    }
    //    else if ([dict[@"showStyle"] isEqualToString:@"4"])
    //    {
    //        alertMsg = @"您不是居然集团内部员工或暂无员工贷申请资格，无法申请员工贷款";
    //    }
    //    else
    //    {
    //        alertMsg = dict[@"showMessage"];
    //    }
    alertMsg = dict[@"showMessage"];
    UIAlertView *alertAcNo = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertAcNo show];
}


@end
