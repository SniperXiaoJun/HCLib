//
//  JRUploadIDCardSuccessViewController.m
//  CsiiMobileFinance
//
//  Created by Summer on 2017/3/27.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRUploadIDCardSuccessViewController.h"
#import "JRBindCardViewController.h"
#import "CPNotifyClient.h"
@interface JRUploadIDCardSuccessViewController ()

@end

@implementation JRUploadIDCardSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    
    CPNotifyClient *note = [[CPNotifyClient alloc] init];
    [note notifyClientRefresh];
    
    self.view.backgroundColor = RGB_COLOR(249,249,249);
    self.title = @"实名认证";


    if (_isSuccess == YES) {
        [self.navigationItem setHidesBackButton:YES];
        self.navigationItem.leftBarButtonItem = nil;
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 64, 375, 199)];
        logoView.image = JRBundeImage(@"实名认证成功");
        [self.view addSubview:logoView];

        UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(20*SCALE, CGRectGetMaxY(logoView.frame)+50*SCALE, ScreenWidth-40*SCALE, kSubmitBtnH)];
        nextButton.backgroundColor = [UIColor colorWithRed:20/255.0 green:124/255.0 blue:209/255.0 alpha:1];
        nextButton.layer.cornerRadius = 5;
        nextButton.titleLabel.font = kSubmitBtnFont;
        [nextButton setTitle:@"绑定银行卡" forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nextButton];

        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setTitleColor:[UIColor colorWithRed:20/255.0 green:124/255.0 blue:209/255.0 alpha:1]
                          forState:UIControlStateNormal];
        [rightButton setTitle:@"跳过" forState:UIControlStateNormal];
        [rightButton addTarget:self
                        action:@selector(rightButtonAction)
              forControlEvents:UIControlEventTouchUpInside];
        rightButton.frame = CGRectMake(ScreenWidth - 50, 5, 50, 35);
        UIBarButtonItem* rightItem =
        [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
    }else{
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DeviceWidth*DeviceScaleX, 199*DeviceScaleY)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backView];

        UIImageView *logoView = [[UIImageView alloc] initWithFrame:ScaleFrame(153, 29, 72, 63)];
        logoView.image = JRBundeImage(@"失败icon");
        [backView addSubview:logoView];

        UILabel *tipLabel = [[UILabel alloc] initWithFrame:ScaleFrame(100, 124, 180, 17)];
        tipLabel.text = @"提交失败，网络状况不佳";
        tipLabel.font =DeviceFont(16);
        tipLabel.textColor = RGB_COLOR(34,34,34);
        [backView addSubview:tipLabel];

        UILabel *smallTipLabel = [[UILabel alloc] initWithFrame:ScaleFrame(91, 150, 200, 14)];
        smallTipLabel.text = @"请检查网络后，点击下方按钮重试";
        smallTipLabel.font =DeviceFont(13);
        smallTipLabel.textColor = RGB_COLOR(34,34,34);
        [backView addSubview:smallTipLabel];



        UIButton *nextButton = [[UIButton alloc]initWithFrame:ScaleFrame(25, 64+221, 154, 43)];
        [nextButton setBackgroundColor:[UIColor whiteColor]];
        nextButton.layer.borderColor = RGB_COLOR(38,150,196).CGColor;
        nextButton.layer.borderWidth = 1;
        nextButton.layer.cornerRadius = 3;
        nextButton.layer.masksToBounds = YES;
        nextButton.titleLabel.font = DeviceFont(18);
        [nextButton setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
        [nextButton setTitle:@"返回" forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(reTry) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nextButton];

        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton setTitle:@"重试" forState:UIControlStateNormal];
        [rightButton setBackgroundColor:RGB_COLOR(38,150,196)];
        rightButton.layer.cornerRadius = 3;
        rightButton.layer.masksToBounds = YES;
        [rightButton addTarget:self action:@selector(reTry) forControlEvents:UIControlEventTouchUpInside];
        rightButton.frame = ScaleFrame(196, 64+221, 154, 43);
        rightButton.titleLabel.font = DeviceFont(18);

        [self.view addSubview:rightButton];
    }

}

//重试 返回
- (void)reTry{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)rightButtonAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)nextButtonAction{
    JRBindCardViewController *p = [[JRBindCardViewController alloc]init];
    [self.navigationController pushViewController:p animated:YES];
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
