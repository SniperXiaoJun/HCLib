//
//  JRAllSuccessViewController.m
//  CsiiMobileFinance
//
//  Created by Summer on 2017/3/31.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRAllSuccessViewController.h"

@interface JRAllSuccessViewController ()

@end

@implementation JRAllSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    self.rightButton.hidden = YES;
    [[self.navigationController.navigationBar
      viewWithTag:5000] removeFromSuperview];

    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64+10*SCALE, ScreenWidth,303*ScreenWidth/1125)];
    logoView.image = [UIImage imageNamed:@"修改成功"];
    [self.view addSubview:logoView];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(120*SCALE, 20*SCALE, ScreenWidth-100*SCALE, 40*SCALE)];
    l.text = self.content;
    l.textColor = [UIColor colorWithRed:20/255.0 green:124/255.0 blue:209/255.0 alpha:1];
    [logoView addSubview:l];
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(20*SCALE, CGRectGetMaxY(logoView.frame)+50*SCALE, ScreenWidth-40*SCALE, 40*SCALE)];
    nextButton.backgroundColor = [UIColor colorWithRed:20/255.0 green:124/255.0 blue:209/255.0 alpha:1];
    nextButton.layer.cornerRadius = 5;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [nextButton setTitle:@"确认" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}
- (void)leftButtonAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
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
