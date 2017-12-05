//
//  JRForgetTransactionPassword2ViewController.m
//  CsiiMobileFinance
//
//  Created by Summer on 2017/4/5.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRForgetTransactionPassword2ViewController.h"
#import "PowerEnterUITextField.h"
#import "JRSuccessViewController.h"
@interface JRForgetTransactionPassword2ViewController ()
{
    PowerEnterUITextField *phoneTF;
    PowerEnterUITextField *userNameTF;
    
}

@end

@implementation JRForgetTransactionPassword2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    self.title = @"重置交易密码";

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
    l.text = @"新交易密码：";
    l.font = DeviceFont(15);
    l.textColor = AllTextColorTit;
    [lineOne addSubview:l];
    
    phoneTF = [[PowerEnterUITextField alloc]
               initWithFrame:ScaleFrame(109,0, DeviceWidth-109,50)];
    phoneTF.delegate = self;
    phoneTF.minLength = 6;                    //设置输入最小长度为2
    phoneTF.maxLength =6;                    //设置输入最大长度为20
    phoneTF.backgroundColor = [UIColor clearColor];
    phoneTF.borderStyle = UITextBorderStyleNone;
    phoneTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入交易密码" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    phoneTF.isSound = NO;
    phoneTF.passwordKeyboardType = Number;
    [lineOne addSubview:phoneTF];
    [self.view addSubview:lineOne];
    phoneTF.timestamp = @"1234567890";

    
    
    
    UIImageView *lineTwo = [[UIImageView alloc] initWithFrame:ScaleFrame(0, heightCount+10+50, DeviceWidth, 50)];
    [self.view addSubview:lineOne];
    lineTwo.backgroundColor = [UIColor whiteColor];
    lineTwo.userInteractionEnabled = YES;
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 50-1, DeviceWidth, 1)];
    line2.backgroundColor = RGB_COLOR(235,236,237);
    [lineTwo addSubview:line2];
    
    UILabel *l2 = [[UILabel alloc] initWithFrame:ScaleFrame(15, 0, 110, 50)];
    l2.text = @"确认新密码：";
    l2.font = DeviceFont(15);
    l2.textColor = AllTextColorTit;
    [lineTwo addSubview:l2];
    
    userNameTF = [[PowerEnterUITextField alloc]
                  initWithFrame:ScaleFrame(109,0, DeviceWidth-109,50)];
    userNameTF.delegate = self;
    userNameTF.minLength = 6;                    //设置输入最小长度为2
    userNameTF.maxLength =6;                    //设置输入最大长度为20
    userNameTF.backgroundColor = [UIColor clearColor];
    userNameTF.borderStyle = UITextBorderStyleNone;
    userNameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入交易密码" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    userNameTF.isSound = NO;
    userNameTF.passwordKeyboardType = Number;
    userNameTF.isHighlightKeybutton = YES;
    [lineTwo addSubview:userNameTF];
    [self.view addSubview:lineTwo];
    userNameTF.timestamp = @"1234567890";
    
    
    UILabel *tips = [[UILabel alloc] initWithFrame:ScaleFrame(15, heightCount+10+50*2+kTipMarginTop, DeviceWidth-20, 20)];
    tips.text = kTipTransPWD;
    tips.font = [UIFont systemFontOfSize:13];
    tips.textColor = AllTextColorTit;
    [self.view addSubview:tips];
    
    

    UIButton *nextButton = [[UIButton alloc]initWithFrame:ScaleFrame(15, 241, DeviceWidth-30, 43)];
    if (IPHONEX) {
        nextButton.frame = ScaleFrame(15, 241, DeviceWidth-30, 43);
    }
    nextButton.backgroundColor =  RGB_COLOR(38,150,196);
    nextButton.layer.cornerRadius = 5;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:18];
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
    NSString *digest2 = [phoneTF getPasswordDigest];
    if([digest1 compare:digest2] != NSOrderedSame){
        alertView(@"两次密码输入不一致");
    }

    new_transaction_caller
    caller.transactionId = @"Timestamp.do"; //交易名
    caller.responsType = ResponsTypeOfString; //返回数据处理
    caller.transactionArgument = nil;   //上传参数
    execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
        if (TransactionIsSuccess) {
            phoneTF.timestamp = returnCaller.webData;
            userNameTF.timestamp = returnCaller.webData;
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
            [params setObject:self.name forKey:@"UserName"];
            [params setObject:self.idcard forKey:@"IdNo"];
            [params setObject:self.card forKey:@"AccountNo"];
            [params setObject:phoneTF.value forKey:@"NewPassWord"];
            [params setObject:userNameTF.value forKey:@"ConfirmPassword"];
            new_transaction_caller
            caller.transactionId = @"PTransPwdReset.do"; //交易名
            caller.webMethod = POST;                                   // POST  GET
            caller.responsType = ResponsTypeOfJson; //返回数据处理
            caller.transactionArgument = params;   //上传参数
            caller.isShowActivityIndicator = YES;
            execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
                if (TransactionIsSuccess) {
                    JRSuccessViewController *r = [[JRSuccessViewController alloc]init];
                    r.bigTipsName = @"交易密码重置成功";
                    r.titleName = @"交易密码重置";
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
