//
//  JRUploadIDCardSuccessViewController.m
//  CsiiMobileFinance
//
//  Created by Summer on 2017/3/27.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRSuccessViewController.h"
#import "JRBindCardViewController.h"
#import "CPNotifyClient.h"
@interface JRSuccessViewController ()

@end

@implementation JRSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CPNotifyClient *note = [[CPNotifyClient alloc] init];
    [note notifyClientRefresh];

    self.view.backgroundColor = RGB_COLOR(249,249,249);
    self.title = _titleName;

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DeviceWidth*DeviceScaleX, 199*DeviceScaleY)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];

    UIImageView *logoView = [[UIImageView alloc] initWithFrame:ScaleFrame(144, 20, 89, 89)];
    logoView.image = JRBundeImage(@"成功icon");
    [backView addSubview:logoView];

    UILabel *tipLabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 124, DeviceWidth, 17)];
    tipLabel.text = _bigTipsName;
    tipLabel.font =DeviceFont(16);
    tipLabel.textColor = RGB_COLOR(38,150,196);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:tipLabel];

    UILabel *smallTipLabel = [[UILabel alloc] initWithFrame:ScaleFrame(73, 150, DeviceWidth, 14)];
    smallTipLabel.text = _smallTipsName;
    smallTipLabel.font =DeviceFont(13);
    smallTipLabel.textColor = RGB_COLOR(122,123,135);
    smallTipLabel.textAlignment = NSTextAlignmentCenter;

    [backView addSubview:smallTipLabel];



    UIButton *nextButton = [[UIButton alloc]initWithFrame:ScaleFrame(25, 64+221, 325, 43)];
    [nextButton setBackgroundColor:RGB_COLOR(38,150,196)];
    nextButton.layer.cornerRadius = 3;
    nextButton.layer.masksToBounds = YES;
    nextButton.titleLabel.font = DeviceBoldFont(18);
    [nextButton setTitleColor:RGB_COLOR(255,255,255) forState:UIControlStateNormal];
    [nextButton setTitle:@"确定" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];

}

//返回钱包主页
- (void)backToMain{
    [self.navigationController popToViewController:Singleton.myWalletVC animated:YES];
}

-(void)rightButtonAction{
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

