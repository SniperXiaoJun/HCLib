//
//  JRConsumeFirstViewController.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/3/28.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRConsumeFirstViewController.h"
#import "JRConsumeQRViewController.h"

#define IMAGE(Str) JRBundeImage(Str)

@interface JRConsumeFirstViewController (){

    UITextField *labelPW;
}

@end

@implementation JRConsumeFirstViewController

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DebugLog(@"login----viewWillAppear");
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated:(BOOL)animated{
    [super viewWillDisappear:animated];
    DebugLog(@"login----viewWillAppear");
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消费贷款";
    self.view.backgroundColor = BIGBGColor;
    
    
    UIView *viewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 90, ScreenWidth, 40)];
    viewOne.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewOne];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth/2 - 20, 40)];
    label.text = @"请输入交易密码:";
//    label.textColor = [UIColor whiteColor];
    [viewOne addSubview:label];
    
    labelPW = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, ScreenWidth - CGRectGetMaxX(label.frame), 40)];
    labelPW.keyboardType = UIKeyboardTypeNumberPad;
    [viewOne addSubview:labelPW];
    
    
    CGFloat cellW = ScreenWidth-40*SCALE;
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth - cellW)/2,CGRectGetMaxY(viewOne.frame)+40, cellW, 88 * scaleH)];
    [loginBtn setBackgroundImage:IMAGE(@"blue_bg") forState:UIControlStateNormal];
    [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchDown];
    loginBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:loginBtn];
}

- (void)loginClick{
    
    
    if (labelPW.text.length == 0) {
        alertView(@"请输入密码");
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
//    
//    [params setObject:@"17718501985" forKey:@"UserId"];
//    [params setObject:@"123" forKey:@"Password"];
//    [params setObject:@"" forKey:@"_vTokenName"];
//    [params setObject:@"D" forKey:@"LoginType"];
    
    new_transaction_caller
    caller.transactionId = @"GetTokenForConsumeLoan.do"; //交易名
    caller.webMethod = POST;                                   // POST  GET
    caller.responsType = ResponsTypeOfJson; //返回数据处理
    caller.transactionArgument = params;   //上传参数
    caller.isShowActivityIndicator = YES;
    execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
        if (TransactionIsSuccess) {
            
            DebugLog(@"returnCaller.transactionResult--%@",returnCaller.transactionResult);
//            JRConsumeQRViewController *vc = [[JRConsumeQRViewController alloc] init];
//            vc.TokenId = returnCaller.transactionResult[@"TokenId"];
//            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
//            {
//                _RejCode = 999999,
//                errType = defaultPublicError,
//                jsonError = 【PER999006】主机脱机请稍后再试或与银行联系,
//                _RejCode2 = pe.submit_failed
//            }
           alerErr
        }
    }));

    

}

@end
