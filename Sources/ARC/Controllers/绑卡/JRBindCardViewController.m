//
//  JRBindCardViewController.m
//  CsiiMobileFinance
//
//  Created by Summer on 2017/3/28.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRBindCardViewController.h"
#import "CSIICustomTextField.h"
//#import "CSIIUIGetSMSCodeButton.h"
#import "PowerEnterUITextField.h"
#import "JRBindCardSuccessViewController.h"
#import "JRH5AppViewController.h"
#import "JRSearchSupportBankViewController.h"
#import "JRBankListView.h"
#import "JRBankCardLimitController.h"
#import "JRSYHttpTool.h"

@interface JRBindCardViewController ()<UIAlertViewDelegate,UITextFieldDelegate,ChooseBankViewDelegate>
{
    CSIICustomTextField *cardTF;
    CSIICustomTextField *bankTF;

    CSIICustomTextField *phoneTF;
    CSIICustomTextField *userNameTF;
    UIButton *getGSMButton;
    PowerEnterUITextField *userNameTF1;
    PowerEnterUITextField *userNameTF2;

    JRBankListView *bankListView;
    NSString *BondBankId;

    NSArray *bankArray;
}
@property (nonatomic,strong) UIButton *checkBtn;

@end

@implementation JRBindCardViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;


    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitleColor:[UIColor colorWithRed:20/255.0 green:124/255.0 blue:209/255.0 alpha:1]
                      forState:UIControlStateNormal];
    [rightButton setTitle:@"银行限额" forState:UIControlStateNormal];
    rightButton.titleLabel.font = DeviceFont(14);
    [rightButton addTarget:self
                    action:@selector(rightButtonAction)
          forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(ScreenWidth - 50, (44-13)/2, 70, 13);
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightButton setTitleColor:RGB_COLOR(34,34,34) forState:UIControlStateNormal];
    UIBarButtonItem* rightItem =
    [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightButtonAction{
    JRBankCardLimitController *cardLimit = [[JRBankCardLimitController alloc] init];
    [self.navigationController pushViewController:cardLimit animated:YES];
}

- (void)searchBank
{
    [cardTF resignFirstResponder];
    [phoneTF resignFirstResponder];
    [userNameTF resignFirstResponder];
    [userNameTF1 resignFirstResponder];
    [userNameTF2 resignFirstResponder];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
    
    [JRSYHttpTool post:@"BankMsgListQry.do" parameters:params success:^(id json) {
        
        if ([json[@"_RejCode"] isEqualToString:@"000000"])
        {
            NSArray *arr = json[@"List"];
            if (arr.count != 0)
            {
                if (bankListView == nil)
                {
                    bankListView = [[JRBankListView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 280)];
                    bankListView.delegate = self;
                    bankListView.dataArray = [NSMutableArray arrayWithArray:json[@"List"]];
                    [self.view addSubview:bankListView];
                    [UIView animateWithDuration:0.3 animations:^{
                        bankListView.frame = CGRectMake(0, ScreenHeight - 280, ScreenWidth, 280);
                    }];
                }
                else
                {
                    [UIView animateWithDuration:0.3 animations:^{
                        bankListView.frame = CGRectMake(0, ScreenHeight - 280, ScreenWidth, 280);
                    }];
                }
            }
            else
            {
                alertMsg(@"获取银行列表失败");
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)chooseBank:(NSDictionary *)dict
{
    
    bankTF.text = dict[@"BankName"];
    BondBankId = dict[@"BankId"];
}

- (void)initBankJsonList{

    NSString *file = [[NSBundle mainBundle] pathForResource:@"limitList.json" ofType:@""];
    NSData *data = [NSData dataWithContentsOfFile:file];
    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
    bankArray = [NSArray arrayWithArray:d[@"limitList"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    self.title = @"绑定银行卡";

    [self initBankJsonList];

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    backView.backgroundColor = RGB_COLOR(249,249,249);
    [self.view addSubview:backView];

    //银行卡号
    UIImageView *cardView = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 0, DeviceWidth, 49)];
    [backView addSubview:cardView];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.userInteractionEnabled = YES;

    UIImageView *lin = [[UIImageView alloc] initWithFrame:ScaleFrame(15, 48, DeviceWidth, 1)];
    lin.backgroundColor = RGB_COLOR(235,236,237);
    [cardView addSubview:lin];

    UILabel *l0 = [[UILabel alloc] initWithFrame:ScaleFrame(15, 18, 85, 14)];
    l0.text = @"银行卡号:";
    l0.font = DeviceFont(15);
    l0.textColor = DeviceTextNormalColor;
    [cardView addSubview:l0];

    cardTF = [[CSIICustomTextField alloc]
              initWithFrame:ScaleFrame(107,0, DeviceWidth-CGRectGetWidth(l0.frame),48)];
    cardTF.delegate = self;
    cardTF.font = DeviceFont(15);
    cardTF.backgroundColor = [UIColor clearColor];
    cardTF.tag = 157;
    cardTF.keyboardType = UIKeyboardTypeNumberPad;
    [cardTF addTarget:self action:@selector(bankNumChange:) forControlEvents:UIControlEventEditingChanged];
    cardTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入银行卡号" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    [cardView addSubview:cardTF];
    cardTF.tag = 1;


    //所属银行
    UIImageView *bankView = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 49, DeviceWidth, 49)];
    [backView addSubview:bankView];
    bankView.backgroundColor = [UIColor whiteColor];
    bankView.userInteractionEnabled = YES;

    UIImageView *lin1 = [[UIImageView alloc] initWithFrame:ScaleFrame(15, 48, DeviceWidth, 1)];
    lin1.backgroundColor = RGB_COLOR(235,236,237);
    [bankView addSubview:lin1];

    UILabel *ll = [[UILabel alloc] initWithFrame:ScaleFrame(15, 18, 85, 14)];
    ll.text = @"所属银行:";
    ll.font = DeviceFont(15);
    ll.textColor = DeviceTextNormalColor;
    [bankView addSubview:ll];
    
    bankTF = [[CSIICustomTextField alloc]
              initWithFrame:ScaleFrame(107,0, DeviceWidth-CGRectGetWidth(l0.frame),48)];
    bankTF.delegate = self;
    bankTF.font = DeviceFont(15);
    [bankTF setEnabled:NO];
    bankTF.backgroundColor = [UIColor clearColor];
    bankTF.textColor = AllTextColorDetail;
    [bankView addSubview:bankTF];

    //预留手机号
    UIImageView *phoneView = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 49*2, DeviceWidth, 49)];
    [backView addSubview:phoneView];
    phoneView.backgroundColor = [UIColor whiteColor];
    phoneView.userInteractionEnabled = YES;
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:ScaleFrame(15, 48, DeviceWidth, 1)];
    line.backgroundColor = RGB_COLOR(235,236,237);
    [phoneView addSubview:line];
    
    UILabel *l = [[UILabel alloc] initWithFrame:ScaleFrame(15, 18, 85, 14)];
    l.text = @"预留手机号:";
    l.font = DeviceFont(15);
    l.textColor = DeviceTextNormalColor;
    [phoneView addSubview:l];
    
    phoneTF = [[CSIICustomTextField alloc]
               initWithFrame:ScaleFrame(107,0, DeviceWidth-CGRectGetWidth(l0.frame),48)];
    phoneTF.delegate = self;
    phoneTF.text = [[NSUserDefaults standardUserDefaults] valueForKey:kUserId];
    phoneTF.font = [UIFont systemFontOfSize:AllTextFont];
    phoneTF.backgroundColor = [UIColor clearColor];
    phoneTF.textColor = AllTextColorDetail;
    phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入银行预留手机号" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    phoneTF.tag = 3;
    [phoneTF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [phoneView addSubview:phoneTF];


    //短信验证码
    UIImageView *messageCodeView = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 49*3, DeviceWidth, 49)];
    [backView addSubview:messageCodeView];
    messageCodeView.backgroundColor = [UIColor whiteColor];
    messageCodeView.userInteractionEnabled = YES;
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:ScaleFrame(15, 48, DeviceWidth, 1)];
    line2.backgroundColor = RGB_COLOR(235,236,237);
    [messageCodeView addSubview:line2];
    
    UILabel *l2 = [[UILabel alloc] initWithFrame:ScaleFrame(15, 18, 85, 14)];
    l2.text = @"验证码:";
    l2.font = DeviceFont(15);
    l2.textColor = DeviceTextNormalColor;
    [messageCodeView addSubview:l2];
    
    userNameTF = [[CSIICustomTextField alloc]
                  initWithFrame:ScaleFrame(107,0, DeviceWidth-CGRectGetWidth(l0.frame),48)];
    userNameTF.delegate = self;
    userNameTF.font = [UIFont systemFontOfSize:AllTextFont];
    userNameTF.backgroundColor = [UIColor clearColor];
    userNameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入短信验证码" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    userNameTF.tag = 4;
    userNameTF.keyboardType = UIKeyboardTypeNumberPad;
    [messageCodeView addSubview:userNameTF];
    
    getGSMButton = [[UIButton alloc]initWithFrame:ScaleFrame(291, (48-13)/2, 74, 13) ];
    getGSMButton.layer.cornerRadius = 3;
    getGSMButton.titleLabel.font=DeviceFont(14);
    [getGSMButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getGSMButton setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
    [getGSMButton addTarget:self action:@selector(sendSmsRequest) forControlEvents:UIControlEventTouchUpInside];
    [messageCodeView addSubview:getGSMButton];
    

    //支付密码
    UIImageView *transPwdView = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 49*4, DeviceWidth, 49)];
    transPwdView.backgroundColor = [UIColor whiteColor];
    transPwdView.userInteractionEnabled = YES;
    [backView addSubview:transPwdView];

    UIImageView *line3 = [[UIImageView alloc] initWithFrame:ScaleFrame(15, 48, DeviceWidth, 1)];
    line3.backgroundColor = RGB_COLOR(235,236,237);
    [transPwdView addSubview:line3];

    UILabel *l3 = [[UILabel alloc] initWithFrame:ScaleFrame(15, 18, 85, 14)];
    l3.text = @"支付密码:";
    l3.font = DeviceFont(15);
    l3.textColor = DeviceTextNormalColor;
    [transPwdView addSubview:l3];
    
    userNameTF1 = [[PowerEnterUITextField alloc]
                   initWithFrame:ScaleFrame(112,0, DeviceWidth-CGRectGetWidth(l0.frame),48)];
    userNameTF1.delegate = self;
    userNameTF1.backgroundColor = [UIColor clearColor];
    userNameTF1.borderStyle = UITextBorderStyleNone;
    userNameTF1.font = DeviceFont(15);
    userNameTF1.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameTF1.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请设置6位数字支付密码" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    userNameTF1.passwordKeyboardType = Number;
    userNameTF1.minLength = 6;
    userNameTF1.maxLength = 6;
    userNameTF1.timestamp = @"1234567890";
    userNameTF1.isSound = NO;
    userNameTF1.isHighlightKeybutton = YES;
    [transPwdView addSubview:userNameTF1];

    //确认密码
    UIImageView *lineFour = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 49*5, DeviceWidth, 49)];
    lineFour.backgroundColor = [UIColor whiteColor];
    lineFour.userInteractionEnabled = YES;
    
    UIImageView *line4 = [[UIImageView alloc] initWithFrame:ScaleFrame(15, 48, DeviceWidth, 1)];
    line4.backgroundColor = RGB_COLOR(235,236,237);
//    [lineFour addSubview:line4];

    UILabel *l4 = [[UILabel alloc] initWithFrame:ScaleFrame(15, 18, 85, 14)];
    l4.text = @"确认密码:";
    l4.font = DeviceFont(15);
    l4.textColor = DeviceTextNormalColor;
    [lineFour addSubview:l4];
    
    userNameTF2 = [[PowerEnterUITextField alloc]
                   initWithFrame:ScaleFrame(112,0, DeviceWidth-CGRectGetWidth(l0.frame),48)];
    userNameTF2.delegate = self;
    userNameTF2.minLength = 5;
    userNameTF2.passwordKeyboardType = Number;
    userNameTF2.font = DeviceFont(15);
    userNameTF2.backgroundColor = [UIColor clearColor];
    userNameTF2.borderStyle = UITextBorderStyleNone;
    userNameTF2.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameTF2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"确认支付密码" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    userNameTF2.minLength = 6;
    userNameTF2.maxLength = 6;
    userNameTF2.timestamp = @"1234567890";
    userNameTF2.isSound = NO;
    userNameTF2.isHighlightKeybutton = YES;
    [lineFour addSubview:userNameTF2];
    [backView addSubview:lineFour];


    _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkBtn.frame =ScaleFrame(15, 306, 22, 22);
    [_checkBtn setImage:JRBundeImage(@"radioUnselect") forState:UIControlStateNormal];
    [_checkBtn setImage:JRBundeImage(@"radioSelect") forState:UIControlStateSelected];
    [_checkBtn setSelected:YES];


    [_checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_checkBtn];

    UILabel * protocolLabel = [[UILabel alloc] initWithFrame:ScaleFrame(45, 310, 260, 14)];
    protocolLabel.font = DeviceFont(13);
    protocolLabel.text = @"阅读并同意，居然金融《委托代扣协议》";
    protocolLabel.userInteractionEnabled = YES;
    NSMutableAttributedString *protocolAttributedStr = [self formatSomeCharacter:protocolLabel.text];
    protocolLabel.attributedText = protocolAttributedStr;
    [backView addSubview:protocolLabel];



//    CSIILabelButton *protocolLabel = [[CSIILabelButton alloc] init];
//    [protocolLabel setImage:JRBundeImage(@"radioUnselect") frame:ScaleFrame(15, 306, 22, 22) forState:UIControlStateNormal];
//    [protocolLabel setImage:JRBundeImage(@"radioSelect") frame:ScaleFrame(15, 306, 22, 22) forState:UIControlStateSelected];
//    [protocolLabel setSelected:YES];
//    protocolLabel.label.textColor = RGB_COLOR(122,123,135);
//    [protocolLabel setLabel:@"阅读并同意，居然金融《委托代扣协议》" frame:ScaleFrame(45, 310, 260, 14)];
//    protocolLabel.label.font = DeviceFont(13);
//    NSMutableAttributedString *protocolAttributedStr = [self formatSomeCharacter:protocolLabel.label.text];
//    protocolLabel.label.attributedText = protocolAttributedStr;
//    [backView addSubview:protocolLabel];


    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(regisAgreeMentClick)];
    [protocolLabel addGestureRecognizer:tapGes];
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(backView.frame)-43*DeviceScaleY, ScreenWidth, 43*DeviceScaleY)];
    nextButton.backgroundColor = RGB_COLOR(38,150,196);
    nextButton.titleLabel.font = DeviceFont(18);
    [nextButton setTitle:@"确定" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:nextButton];
     /**/
}


//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
- (CGFloat)getHeightWithText:(NSString *)str andWid:(CGFloat)wid
{
    UIFont *font = [UIFont systemFontOfSize:13.0f];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(wid, 999)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:font}
                                    context:nil];
    return rect.size.height;
}


#pragma mark - 输入框代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
//    银行卡号		1
//    所属银行		2
//    手机号码		3
//    验证码         4
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if (textField.tag == 1) {
        if (textField.text.length >= kMaxLengthBankCard) return NO;
        
    }else if(textField.tag == 2){
        if (textField.text.length >= kMaxLengthBankName) return NO;
        
    }else if(textField.tag == 3){
        if (textField.text.length >= kMaxLengthPhoneNum) return NO;
        
    }else if(textField.tag == 4){
        if (textField.text.length >= kMaxLengthVerifyNum) return NO;
        
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        bankListView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 280);
    }];

    if (textField == cardTF)
    {
        bankTF.text = @"";
        bankTF.textColor = [UIColor blackColor];
        BondBankId = @"";
    }
}

-  (void)textFieldDidEndEditing:(UITextField *)textField
{

    [textField resignFirstResponder];

     if (textField == cardTF)
     {
         NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
         [params setObject:cardTF.text forKey:@"UserAcctNo"];

         new_transaction_caller
         caller.transactionId = @"CardBINQry.do"; //交易名
         caller.webMethod = POST;                                   // POST  GET
         caller.responsType = ResponsTypeOfJson; //返回数据处理
         caller.transactionArgument = params;   //上传参数
         caller.isShowActivityIndicator = NO;
         execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
             if (TransactionIsSuccess) {
                 DebugLog(@"CardBINQry.do-%@",TransReturnInfo);
                 BOOL haveThisBank = NO;

                 DebugLog(@"bankArray ****-%@",bankArray);


                 for (int i=0; i<bankArray.count; i++) {
                     NSDictionary *currentDict = bankArray[i];
                     NSString *bankId = currentDict[@"bankId"];
                     NSString *bank = currentDict[@"bank"];

                     DebugLog(@"bankArray %d****-%@",i,bankId);

                     if ([TransReturnInfo[@"BondBankId"] isEqualToString:bankId]) {

                         DebugLog(@"BondBankId  isEqualToString %d****-%@",i,bankId);
                         DebugLog(@"bank  isEqualToString %@",bank);
                         DebugLog(@"bankId  isEqualToString %@",bankId);

                         haveThisBank = YES;
                         BondBankId = currentDict[@"bankId"];
                         bankTF.text = bank;
                         bankTF.textColor = [UIColor blackColor];

                         break;
                     }
                 }

                 if (haveThisBank == NO) {
                     BondBankId = @"";
                     bankTF.text = @"暂不支持该银行卡";
                     bankTF.textColor = [UIColor redColor];
                 }
             }else{
                 alerErr
             }
         }));

     }

}


-(NSMutableAttributedString *)formatSomeCharacter:(NSString *)str{
    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc]initWithString:str];
    [tempStr addAttribute:NSForegroundColorAttributeName
                    value:RGB_COLOR(38,150,196)
                    range:NSMakeRange(10, str.length-10)];

    return tempStr;
}

- (void)checkBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;

}

- (void)regisAgreeMentClick{
    DebugLog(@"注册协议");
    
    JRH5AppViewController *h5 = [[JRH5AppViewController alloc] init];
    h5.url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"daikou" ofType:@"html"]];
    [self.navigationController pushViewController:h5 animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
//        [cardTF becomeFirstResponder];
    }
}
- (void)nextButtonAction{
   
    [cardTF resignFirstResponder];

    if (cardTF.text.length>0) {
        if (BondBankId == nil ||
            BondBankId == @"") {
            alertView(@"请输入支持的银行卡");
        }
    }



    int errorCode = [userNameTF1 verify];
    if (errorCode==-1) {
        alertView(@"请输入支付密码！");
    }else if(errorCode == -2){
        alertView(@"支付密码长度不够！");
    }else if(errorCode == -3){
        alertView(@"支付密码格式错误！");
    }
    
    int errorCode22 = [userNameTF2 verify];
    if (errorCode22==-1) {
        alertView(@"请输入确认密码！");
    }else if(errorCode22 == -2){
        alertView(@"确认密码长度不够！");
    }else if(errorCode22 == -3){
        alertView(@"确认密码格式错误！");
    }
    
    NSString *digest1 = [userNameTF1 getPasswordDigest];
    NSString *digest2 = [userNameTF2 getPasswordDigest];
    if([digest1 compare:digest2] != NSOrderedSame){
        alertView(@"两次密码输入不一致");
    }
    
    if (cardTF.text.length == 0 || phoneTF.text.length == 0  || userNameTF.text.length == 0 || userNameTF1.value.length ==0 || userNameTF2.value.length ==0 || bankTF.text.length == 0 ) {
        alertView(@"请完善表格信息再提交");
    }
    
    if (!_checkBtn.selected) {
        alertView(@"请先接受代扣协议");
    }
    [JRSYHttpTool post:@"TimestampJson.do" parameters:nil success:^(id json) {
        userNameTF1.timestamp = json[@"Timestamp"];
        userNameTF2.timestamp = json[@"Timestamp"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
        [params setObject:cardTF.text forKey:@"UserAcctNo"];
        [params setObject:BondBankId forKey:@"BondBankId"];
        [params setObject:phoneTF.text forKey:@"PhoneNo"];
        [params setObject:userNameTF.text forKey:@"OTPPassword"];
        [params setObject:userNameTF1.value forKey:@"Tranpw"];
        [params setObject:userNameTF2.value forKey:@"TranpwConfirm"];
        [params setObject:@"P" forKey:@"PWDType"];
        
        [params setObject:@"P" forKey:@"BondType"];
        
        if (bankTF.text.length != 0) {
            [params setObject:bankTF.text forKey:@"BankName"];  // 卡bin
            
        }
       [JRSYHttpTool post:@"BondAccount.do" parameters:params success:^(id json) {
           
           
           Singleton.isLogin = YES;
           Singleton.userInfo = json;
           [[NSUserDefaults standardUserDefaults] setObject:json[@"UserId"] forKey:kUserId];
           [[NSNotificationCenter defaultCenter] postNotificationName:Login_Notification object:nil];
           
           
           
           JRBindCardSuccessViewController *p = [[JRBindCardSuccessViewController alloc]init];
           [self.navigationController pushViewController:p animated:YES];
           
           
       } failure:^(NSError *error) {
           
       }];
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)bankNumChange :(UITextField *)textField
{

}

#pragma mark -- CSIIUIGetSMSCodeButtonDataSource方法
//上传短信验证码所需数据
- (NSMutableDictionary *)getSMSCodeButtonClickGetDic:(NSString *)tokenName
{
    return  [NSMutableDictionary dictionaryWithDictionary:@{@"ExistCheckFlag":@"true",@"MobilePhone":phoneTF.text,@"TokenIndex":@"1",@"TokenMessage":@"sms.RegisterPre.P"}];
}

-(void)countDown
{
    __block int timeout= 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [getGSMButton setTitle:@"重新发送" forState:UIControlStateNormal];
//                getGSMButton.backgroundColor = EnableBg;
                getGSMButton.userInteractionEnabled = YES;
                
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [getGSMButton setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                getGSMButton.userInteractionEnabled = NO;
//                getGSMButton.backgroundColor = DisableBg;

            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

- (void)sendSmsRequest{
    
    
    checkPhoneNum(phoneTF.text);

    [getGSMButton setTitle:@"发送中" forState:UIControlStateNormal];
//    getGSMButton.backgroundColor = DisableBg;
    getGSMButton.userInteractionEnabled = NO;
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
    [params setObject:phoneTF.text forKey:@"PhoneNo"];
//    [params setObject:@"BondAccount" forKey:@"TransId"];
    [params setObject:@"uibs004" forKey:@"Template"];

    new_transaction_caller
    caller.transactionId = @"SendSMS.do"; //交易名
    caller.webMethod = POST;                                   // POST  GET
    caller.responsType = ResponsTypeOfJson; //返回数据处理
    caller.transactionArgument = params;   //上传参数
    caller.isShowActivityIndicator = YES;
    execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
        if (TransactionIsSuccess) {
            [self countDown];
            // TODO:上线注释
//            userNameTF.text = TransReturnInfo[@"OTPPassword"];
        }else{
            alertView(@"获取验证码失败");
        }
    }));
    
}

- (void)textChange
{
    if (phoneTF.text.length > 11)
    {
        NSString *text = phoneTF.text;
        NSString *s = [text substringToIndex:11];
        phoneTF.text = s;
    }
}

@end
