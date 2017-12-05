//
//  JRBindCardSuccessViewController.m
//  CsiiMobileFinance
//
//  Created by Summer on 2017/3/28.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRBindCardSuccessViewController.h"
#import "CPNotifyClient.h"

@interface JRBindCardSuccessViewController ()

@end

@implementation JRBindCardSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = nil;
    
    CPNotifyClient *note = [[CPNotifyClient alloc] init];
    [note notifyClientRefresh];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    self.title = @"绑定银行卡";
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64+10*SCALE, ScreenWidth,303*ScreenWidth/1125)];
    logoView.image = JRBundeImage(@"绑卡成功");
    [self.view addSubview:logoView];
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(20*SCALE, CGRectGetMaxY(logoView.frame)+50*SCALE, ScreenWidth-40*SCALE, 40*SCALE)];
    nextButton.backgroundColor = [UIColor colorWithRed:20/255.0 green:124/255.0 blue:209/255.0 alpha:1];
    nextButton.layer.cornerRadius = 5;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [nextButton setTitle:@"确定" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setTitleColor:[UIColor colorWithRed:20/255.0 green:124/255.0 blue:209/255.0 alpha:1]
//                      forState:UIControlStateNormal];
//    [rightButton setTitle:@"跳过" forState:UIControlStateNormal];
//    [rightButton addTarget:self
//                    action:@selector(rightButtonAction)
//          forControlEvents:UIControlEventTouchUpInside];
//    rightButton.frame = CGRectMake(ScreenWidth - 50, 5, 50, 35);
//    UIBarButtonItem* rightItem =
//    [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}
//-(void)rightButtonAction{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

-(void)nextButtonAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
