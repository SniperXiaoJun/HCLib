//
//  JRForgetTransactionPasswordViewController.m
//  CsiiMobileFinance
//
//  Created by Summer on 2017/4/5.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRForgetTransactionPasswordViewController.h"
#import "CSIICustomTextField.h"
#import "JRForgetTransactionPassword2ViewController.h"
@interface JRForgetTransactionPasswordViewController ()<UITextFieldDelegate>
{
    UITextField *phoneTF;
    UITextField *nameTF;
    UITextField *cardTF;

}
@end

@implementation JRForgetTransactionPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title  = @"重置交易密码";
    self.view.backgroundColor = BIGBGColor;

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
    l.text = @"姓名：";
    l.font = DeviceFont(15);
    l.textColor = AllTextColorTit;
    [lineOne addSubview:l];
    
    nameTF = [[UITextField alloc]
               initWithFrame:ScaleFrame(109,0, DeviceWidth-109,50)];
//    nameTF.delegate = self;
    nameTF.font = DeviceFont(15);
    nameTF.backgroundColor = [UIColor clearColor];
    
    nameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入姓名" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    [lineOne addSubview:nameTF];
    [self.view addSubview:lineOne];
    
    
    UIImageView *lineTwo = [[UIImageView alloc] initWithFrame:ScaleFrame(0, heightCount+10+50, DeviceWidth, 50)];
    [self.view addSubview:lineOne];
    lineTwo.backgroundColor = [UIColor whiteColor];
    lineTwo.userInteractionEnabled = YES;
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 50-1, DeviceWidth, 1)];
    line2.backgroundColor = RGB_COLOR(235,236,237);
    [lineTwo addSubview:line2];
    
    UILabel *l2 = [[UILabel alloc] initWithFrame:ScaleFrame(15, 0, 110, 50)];
    l2.text = @"身份证：";
    l2.font = DeviceFont(15);
    l2.textColor = AllTextColorTit;
    [lineTwo addSubview:l2];
    
    phoneTF = [[UITextField alloc]
              initWithFrame:ScaleFrame(109,0, DeviceWidth-109,50)];
    phoneTF.font = DeviceFont(15);
    phoneTF.backgroundColor = [UIColor clearColor];
    phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入身份证号码" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    [lineTwo addSubview:phoneTF];
    [self.view addSubview:lineTwo];
    
    UIImageView *lineThree = [[UIImageView alloc] initWithFrame:ScaleFrame(0, heightCount+10+50*2, DeviceWidth, 50)];
    lineThree.backgroundColor = [UIColor whiteColor];
    lineThree.userInteractionEnabled = YES;
    
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 50-1, DeviceWidth, 1)];
    line3.backgroundColor = RGB_COLOR(235,236,237);
    [lineThree addSubview:line3];
    
    UILabel *l3 = [[UILabel alloc] initWithFrame:ScaleFrame(15, 0, 110, 50)];
    l3.text = @"银行卡号：";
    l3.font = DeviceFont(15);
    l3.textColor = AllTextColorTit;
    [lineThree addSubview:l3];
    
    cardTF = [[UITextField alloc]
               initWithFrame:ScaleFrame(109,0, DeviceWidth-109,50)];
    cardTF.font = DeviceFont(15);
    cardTF.backgroundColor = [UIColor clearColor];
    cardTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入银行卡号" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    [lineThree addSubview:cardTF];
    [self.view addSubview:lineThree];
    

    UIButton *nextButton = [[UIButton alloc]initWithFrame:ScaleFrame(15, 241, DeviceWidth-30, 43)];
    if (IPHONEX) {
        nextButton.frame = ScaleFrame(15, 241+20, DeviceWidth-30, 43);
    }
    nextButton.backgroundColor = RGB_COLOR(38,150,196);
    nextButton.layer.cornerRadius = 5;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];


}
-(void)nextButtonAction{

    if (nameTF.text.length == 0) {
        alertView(@"姓名不能为空");
    }
    if (phoneTF.text.length == 0) {
        alertView(@"身份证不能为空");
    }
    if (cardTF.text.length == 0) {
        alertView(@"银行卡号不能为空");
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
    [params setObject:nameTF.text forKey:@"UserName"];
    [params setObject:phoneTF.text forKey:@"IdNo"];
    [params setObject:cardTF.text forKey:@"AccountNo"];
    new_transaction_caller
    caller.transactionId = @"PTransPwdResetConfirm.do"; //交易名
    caller.webMethod = POST;                                   // POST  GET
    caller.responsType = ResponsTypeOfJson; //返回数据处理
    caller.transactionArgument = params;   //上传参数
    caller.isShowActivityIndicator = YES;
    execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
        if (TransactionIsSuccess) {
            JRForgetTransactionPassword2ViewController *r = [[JRForgetTransactionPassword2ViewController alloc]init];
            r.name = nameTF.text;
            r.card = cardTF.text;
            r.idcard = phoneTF.text;
            [self.navigationController pushViewController:r animated:YES];
        }else{
            alerErr
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
