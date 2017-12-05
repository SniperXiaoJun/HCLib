//
//  JRChangeTransactionPasswordViewController.m
//  CsiiMobileFinance
//
//  Created by Summer on 2017/3/22.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRChangeTransactionPasswordViewController.h"
#import "PowerEnterUITextField.h"
#import "JRForgetTransactionPasswordViewController.h"
#import "JRSuccessViewController.h"

@interface JRChangeTransactionPasswordViewController ()<UITextFieldDelegate>
{
    PowerEnterUITextField *phoneTF;
    PowerEnterUITextField *userNameTF;
    PowerEnterUITextField *userNameTF1;
}

@end

@implementation JRChangeTransactionPasswordViewController
-(void)rightButtonAction{
    JRForgetTransactionPasswordViewController *f = [[JRForgetTransactionPasswordViewController alloc] init];
    [self.navigationController pushViewController:f animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    self.title = @"修改交易密码";
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitleColor:RGB_COLOR(34,34,34)
                      forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(rightButtonAction)
          forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(ScreenWidth - 70, 5, 70, 35);
    UIBarButtonItem* rightItem =
    [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;


    NSInteger heightCount = 64;
    if (IPHONEX) {
        heightCount = 84;
    }
    
    UIImageView *lineOne = [[UIImageView alloc] initWithFrame:ScaleFrame(0, heightCount+10, DeviceWidth, 50)];
    [self.view addSubview:lineOne];
    lineOne.backgroundColor = [UIColor whiteColor];
    lineOne.userInteractionEnabled = YES;
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 50-1, DeviceWidth, 1)];
    line.backgroundColor = RGB_COLOR(235,236,237);
    [lineOne addSubview:line];
    
    UILabel *l = [[UILabel alloc] initWithFrame:ScaleFrame(15, 0, 110, 50)];
    l.text = @"原交易密码：";
    l.textColor = AllTextColorTit;
    l.font = DeviceFont(15);
    [lineOne addSubview:l];
    
    phoneTF = [[PowerEnterUITextField alloc]
               initWithFrame:ScaleFrame(109,0, DeviceWidth-109,50)];
    phoneTF.delegate = self;
    phoneTF.minLength = 6;                    //设置输入最小长度为2
    phoneTF.maxLength =6;                    //设置输入最大长度为20
    phoneTF.backgroundColor = [UIColor clearColor];
    phoneTF.borderStyle = UITextBorderStyleNone;
    phoneTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入原交易密码" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    phoneTF.isSound = NO;
    phoneTF.passwordKeyboardType = Number;
    [lineOne addSubview:phoneTF];
    [self.view addSubview:lineOne];
    
    phoneTF.timestamp = @"1234567890";

    UIImageView *lineTwo = [[UIImageView alloc] initWithFrame:ScaleFrame(0, heightCount+10+50, DeviceWidth, 50)];
    lineTwo.backgroundColor = [UIColor whiteColor];
    lineTwo.userInteractionEnabled = YES;
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 50-1, DeviceWidth, 1)];
    line2.backgroundColor = RGB_COLOR(235,236,237);
    [lineTwo addSubview:line2];
    
    UILabel *l2 = [[UILabel alloc] initWithFrame:ScaleFrame(15, 0, 110, 50)];
    l2.text = @"新交易密码：";
    l2.textColor = AllTextColorTit;
    l2.font = DeviceFont(15);
    [lineTwo addSubview:l2];
    
    userNameTF = [[PowerEnterUITextField alloc]
                  initWithFrame:ScaleFrame(109,0, DeviceWidth-109,50)];
    userNameTF.delegate = self;
    userNameTF.backgroundColor = [UIColor clearColor];
    userNameTF.borderStyle = UITextBorderStyleNone;
    userNameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新交易密码" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    userNameTF.minLength = 6;                    //设置输入最小长度为2
    userNameTF.maxLength =6;                    //设置输入最大长度为20
    userNameTF.timestamp = @"1234567890";

    userNameTF.isSound = NO;
    userNameTF.passwordKeyboardType = Number;
    userNameTF.isHighlightKeybutton = YES;
    [lineTwo addSubview:userNameTF];
    
    [self.view addSubview:lineTwo];
    
    
    UIImageView *lineThree = [[UIImageView alloc] initWithFrame:ScaleFrame(0, heightCount+10+50*2, DeviceWidth, 50)];
    lineThree.backgroundColor = [UIColor whiteColor];
    lineThree.userInteractionEnabled = YES;

//    UIImageView *line3 = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 50-1, DeviceWidth, 1)];
//    line3.backgroundColor = RGB_COLOR(235,236,237);
//    [lineThree addSubview:line3];
    
    UILabel *l3 = [[UILabel alloc] initWithFrame:ScaleFrame(15, 0, 110, 50)];
    l3.text = @"确认新密码：";
    l3.textColor = AllTextColorTit;
    l3.font = DeviceFont(15);
    [lineThree addSubview:l3];
    
    userNameTF1 = [[PowerEnterUITextField alloc]
                   initWithFrame:ScaleFrame(109,0, DeviceWidth-109,50)];
    userNameTF1.delegate = self;
    userNameTF1.minLength = 6;                    //设置输入最小长度为2
    userNameTF1.maxLength =6;                    //设置输入最大长度为20
    userNameTF1.backgroundColor = [UIColor clearColor];
    userNameTF1.borderStyle = UITextBorderStyleNone;
    userNameTF1.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameTF1.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"再次输入新交易密码" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    userNameTF1.isSound = NO;
    userNameTF1.passwordKeyboardType = Number;
    userNameTF1.isHighlightKeybutton = YES;
    [lineThree addSubview:userNameTF1];
    userNameTF1.timestamp = @"1234567890";
    
    [self.view addSubview:lineThree];
    
    
    UILabel *tips = [[UILabel alloc] initWithFrame:ScaleFrame(15, heightCount+10+50*3+kTipMarginTop, DeviceWidth-20, 20)];
    tips.text = kTipTransPWD;
    tips.font = DeviceFont(13);
    tips.textColor = AllTextColorTit;
    [self.view addSubview:tips];
    
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:ScaleFrame(15, 281, DeviceWidth-30, 43)];
    if (IPHONEX) {
        nextButton.frame = ScaleFrame(15, 281+20, DeviceWidth-30, 43);
    }

    nextButton.backgroundColor = RGB_COLOR(38,150,196);
    nextButton.layer.cornerRadius = 5;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [nextButton setTitle:@"确定" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}
-(void)nextButtonAction{

    int errorCode = [userNameTF verify];
    if (errorCode==-1) {
        alertView(@"密码为空！");
    }else if(errorCode == -2){
        alertView(@"密码长度不够！");
    }else if(errorCode == -3){
        alertView(@"密码格式错误！");
    }
    
    int errorCode1 = [phoneTF verify];
    if (errorCode1==-1) {
        alertView(@"密码为空！");
    }else if(errorCode1 == -2){
        alertView(@"密码长度不够！");
    }else if(errorCode1 == -3){
        alertView(@"密码格式错误！");
    }
    
    NSString *digest1 = [userNameTF getPasswordDigest];
    NSString *digest2 = [userNameTF1 getPasswordDigest];
    if([digest1 compare:digest2] != NSOrderedSame){
        alertView(@"两次密码输入不一致");
    }

    //发时间戳
    new_transaction_caller
    caller.transactionId = @"Timestamp.do"; //交易名
    caller.responsType = ResponsTypeOfString; //返回数据处理
    caller.transactionArgument = nil;   //上传参数
    execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
        if (TransactionIsSuccess) {
            phoneTF.timestamp = returnCaller.webData;
            userNameTF.timestamp = returnCaller.webData;
            userNameTF1.timestamp = returnCaller.webData;
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
            [params setObject:phoneTF.value forKey:@"TrsPassword"];
            [params setObject:userNameTF.value forKey:@"NewTranPassword"];
            [params setObject:userNameTF1.value forKey:@"ConfirmNewTranPassword"];
            new_transaction_caller
            caller.transactionId = @"ChangeTranPassword.do"; //交易名
            caller.webMethod = POST;                                   // POST  GET
            caller.responsType = ResponsTypeOfJson; //返回数据处理
            caller.transactionArgument = params;   //上传参数
            caller.isShowActivityIndicator = YES;
            execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
                if (TransactionIsSuccess) {
                    JRSuccessViewController *r = [[JRSuccessViewController alloc]init];
                    r.bigTipsName = @"交易密码修改成功";
                    r.titleName = @"交易密码修改";
                    [self.navigationController pushViewController:r animated:YES];
                    
                }else{
                  alerErr
                }
            }));
        }else{
            
        }
    }));

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
