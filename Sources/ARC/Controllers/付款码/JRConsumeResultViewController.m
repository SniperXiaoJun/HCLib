//
//  JRConsumeResultViewController.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/3/28.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRConsumeResultViewController.h"
#import "JRJumpTool.h"
@interface JRConsumeResultViewController ()
{

    UILabel *loanNumber;
    UILabel *loanTime;
    
//    UILabel *loanDate;
    
}

@end

@implementation JRConsumeResultViewController
#define IMAGE(Str)  JRBundeImage(Str)

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DebugLog(@"login----viewWillAppear");
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    DebugLog(@"login----viewWillDisappear");
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    DebugLog(@"viewControllers:%@",viewControllers);
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        // View is disappearing because a new view controller was pushed onto the stack
        NSLog(@"New view controller was pushed");
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        // View is disappearing because it was popped from the stack
        NSLog(@"View controller was popped");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消费贷款";
    self.view.backgroundColor = BIGBGColor;
    
    CGFloat topImgH = 110;
    UIImageView *iv_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth,topImgH)];
    iv_1.image = JRBundeImage(@"result_bg");
    iv_1.backgroundColor = [UIColor whiteColor];
    iv_1.userInteractionEnabled = YES;
    [self.view addSubview:iv_1];
    
    
    CGFloat iconWH = topImgH / 3;
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/3-15, (topImgH - iconWH)/2, iconWH, iconWH)];
    icon.image = JRBundeImage(@"right_arr");
    [iv_1 addSubview:icon];
    
    CGFloat tipH = 40;
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+15, (topImgH - tipH) /2, ScreenWidth/3, tipH)];
    tip.text = @"支付成功";
    tip.font = [UIFont systemFontOfSize:22];
    tip.textColor = RGB_COLOR(16, 100, 217);
    [iv_1 addSubview:tip];
    
    CGFloat cellH = 50;
//    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iv_1.frame) +20, ScreenWidth,cellH * 5)];
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iv_1.frame) +20, ScreenWidth,cellH * 4)];

    midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:midView];
    
    
    UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth/2 - 20, cellH)];
    labelNum.text = @"消费金额";
    [midView addSubview:labelNum];
    
    
    loanNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelNum.frame), 0, ScreenWidth - CGRectGetMaxX(labelNum.frame)-20, cellH)];
    if (self.amount) {
        loanNumber.text = self.amount;
    }
    loanNumber.textAlignment = NSTextAlignmentRight;
    [midView addSubview:loanNumber];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellH, ScreenWidth, 1)];
    
//    //增加    贷款期限 20170914 by hechong
//    UIImageView *lineZero = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellH, ScreenWidth, 1)];
//    lineZero.image = [UIImage imageNamed:@"line"];
//    [midView addSubview:lineZero];
//    
//    UILabel *labelLoanDate = [[UILabel alloc] initWithFrame:CGRectMake(20, cellH, ScreenWidth/2 - 20, cellH)];
//    labelLoanDate.text = @"贷款期限";
//    [midView addSubview:labelLoanDate];
//    
//    
//    loanDate = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelNum.frame), cellH, ScreenWidth - CGRectGetMaxX(labelNum.frame)-20, cellH)];
//    if (self.loanDate) {
//        loanDate.text = self.loanDate;
//    }
//    loanDate.textAlignment = NSTextAlignmentRight;
//    [midView addSubview:loanDate];
    

    
//    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellH*2, ScreenWidth, 1)];
    line.image = JRBundeImage(@"line");
    [midView addSubview:line];
    
    
    UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(20, cellH, ScreenWidth/2 - 20, cellH)];
//    UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(20, cellH*2, ScreenWidth/2 - 20, cellH)];
    labelTime.text = @"消费日期";
    [midView addSubview:labelTime];
    
    loanTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelTime.frame), cellH, ScreenWidth - CGRectGetMaxX(labelTime.frame)-20, cellH)];
//    loanTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelTime.frame), cellH*2, ScreenWidth - CGRectGetMaxX(labelTime.frame)-20, cellH)];
    [midView addSubview:loanTime];
    if (self.time) {
        loanTime.text = self.time;
    }
    loanTime.textAlignment = NSTextAlignmentRight;
    
    
    
    UIImageView *line_2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellH*2, ScreenWidth, 1)];
    
//    UIImageView *line_2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellH*3, ScreenWidth, 1)];
    line_2.image = JRBundeImage(@"line");
    [midView addSubview:line_2];
    
    UILabel *labelTime_2 = [[UILabel alloc] initWithFrame:CGRectMake(20, cellH*2, ScreenWidth/2 - 20, cellH)];
//    UILabel *labelTime_2 = [[UILabel alloc] initWithFrame:CGRectMake(20, cellH*3, ScreenWidth/2 - 20, cellH)];
    labelTime_2.text = @"订单号";
    [midView addSubview:labelTime_2];
    
    UILabel *loanTime_2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelTime.frame), cellH*2, ScreenWidth - CGRectGetMaxX(labelTime.frame)-20, cellH)];
//    UILabel *loanTime_2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelTime.frame), cellH*3, ScreenWidth - CGRectGetMaxX(labelTime.frame)-20, cellH)];
    [midView addSubview:loanTime_2];
    if (self.orderId) {
        loanTime_2.text = self.orderId;
    }
    loanTime_2.textAlignment = NSTextAlignmentRight;
    
    UIImageView *line_3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellH*3, ScreenWidth, 1)];
//    UIImageView *line_3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellH*4, ScreenWidth, 1)];
    line_3.image = JRBundeImage(@"line");
    [midView addSubview:line_3];
    
    UILabel *labelTime_3 = [[UILabel alloc] initWithFrame:CGRectMake(20, cellH*3, 70, cellH)];
//    UILabel *labelTime_3 = [[UILabel alloc] initWithFrame:CGRectMake(20, cellH*4, 70, cellH)];
    labelTime_3.text = @"参考号";
//    labelTime_3.backgroundColor = [UIColor grayColor];
    [midView addSubview:labelTime_3];
    
    UILabel *loanTime_3 = [[UILabel alloc] initWithFrame:CGRectMake(70, cellH*3, ScreenWidth - 70-20, cellH)];
//    UILabel *loanTime_3 = [[UILabel alloc] initWithFrame:CGRectMake(70, cellH*4, ScreenWidth - 70-20, cellH)];
    [midView addSubview:loanTime_3];
    if (self.tokenID) {
        loanTime_3.text = self.tokenID;
    }
//    loanTime_3.numberOfLines = 0;
    loanTime_3.textAlignment = NSTextAlignmentRight;
    
    
    
   
    UILabel *labelTip = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(midView.frame), ScreenWidth - 20, 60)];
    labelTip.text = @"提示：请您于今日24:00前选择还款计划，否则将默认按12期还款。";
    labelTip.numberOfLines = 0;
    labelTip.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:labelTip];
    
    CGFloat cellW = ScreenWidth-40*SCALE;
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth - cellW)/2, CGRectGetMaxY(labelTip.frame) + 30, cellW, 88 * scaleH)];
    [loginBtn setBackgroundImage:IMAGE(@"consume_result_4") forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchDown];
    loginBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:loginBtn];
    
    
}

- (void)loginClick{
    if (self.NotiDic) {
        [JRJumpClientToVx jumpWithZipID:kZipQRCode controller:self params:self.NotiDic ];
    }
}


@end
