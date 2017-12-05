//
//  JRPayTableViewController.m
//  Double
//
//  Created by 何崇 on 2017/11/24.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "JRPayTableViewController.h"
#import "CSIICustomTextField.h"
#import "PowerEnterUITextField.h"

@interface JRPayTableViewController ()<UITextFieldDelegate>{
//    UIWindow *mWindow;
    CSIICustomTextField *msgCode;
    UIButton *getGSMButton;
    PowerEnterUITextField *transPwd;

}

@end

@implementation JRPayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单支付";
    self.tableView.backgroundColor = RGB_COLOR(249,249,249);

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

//    for (UIView *view in mWindow.subviews) {
//        [view removeFromSuperview];
//    }
//
//    mWindow.frame = CGRectMake(0, 0, 0, 0);
//    [mWindow resignKeyWindow];
//    mWindow = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    [self setFootView:CGRectMake(0, ScreenHeight-43*DeviceScaleX, ScreenWidth, 43*DeviceScaleX)];
}



- (void)setFootView:(CGRect)frame{

//    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 43*DeviceScaleX)];
//    nextButton.backgroundColor = RGB_COLOR(38,150,196);
//    nextButton.titleLabel.font = DeviceBoldFont(18);
//    [nextButton setTitle:@"确认支付" forState:UIControlStateNormal];
//    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
//
//    mWindow = [[UIWindow alloc]initWithFrame:frame];
//    mWindow.windowLevel = UIWindowLevelAlert + 1;
//    mWindow.backgroundColor = [UIColor whiteColor];
//    [mWindow addSubview:nextButton];
//    [mWindow makeKeyAndVisible];//关键语句,显示window

}

- (void)nextButtonAction{


}


- (UIView *)orderView{
    UIView *view = [[UIView alloc] initWithFrame:ScaleFrame(0, 0, DeviceWidth, 266)];
    view.backgroundColor = [UIColor whiteColor];

    UILabel *orderMoneyTitle = [[UILabel alloc] initWithFrame:ScaleFrame(15, 23, 100, 15)];
    orderMoneyTitle.text = @"订单金额(元)";
    orderMoneyTitle.textColor = RGB_COLOR(34,34,34);
    orderMoneyTitle.font = DeviceFont(15);
    [view addSubview:orderMoneyTitle];

    UILabel *orderMoney = [[UILabel alloc] initWithFrame:ScaleFrame(16, 50, 100, 20)];
    orderMoney.text = @"3,680.00";
    orderMoney.textColor = RGB_COLOR(223,64,49);
    orderMoney.font = DeviceFont(22);
    [view addSubview:orderMoney];

    UILabel *lineLabel0 = [[UILabel alloc] initWithFrame:ScaleFrame(15, 93, 360, DeviceLineWidth)];
    lineLabel0.backgroundColor = RGB_COLOR(235,236,237);
    lineLabel0.alpha = 0.6;
    [view addSubview:lineLabel0];


    UILabel *orderNumberLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 111, 90, 15)];
    orderNumberLabel.text = @"订单编号";
    orderNumberLabel.textColor = RGB_COLOR(34,34,34);
    orderNumberLabel.font = DeviceFont(15);
    [view addSubview:orderNumberLabel];

    UILabel *orderNumber = [[UILabel alloc] initWithFrame:ScaleFrame(DeviceWidth-285, 111, 270, 15)];
    orderNumber.text = @"1000487838899876";
    orderNumber.textAlignment = NSTextAlignmentRight;
    orderNumber.textColor = RGB_COLOR(122,123,135);
    orderNumber.font = DeviceFont(15);
    [view addSubview:orderNumber];

    UILabel *lineLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 143, 360, DeviceLineWidth)];
    lineLabel.backgroundColor = RGB_COLOR(235,236,237);
    lineLabel.alpha = 0.6;
    [view addSubview:lineLabel];

    UILabel *payTypeLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 160, 90, 15)];
    payTypeLabel.text = @"支付方式";
    payTypeLabel.textColor = RGB_COLOR(34,34,34);
    payTypeLabel.font = DeviceFont(15);
    [view addSubview:payTypeLabel];

    UILabel *payType = [[UILabel alloc] initWithFrame:ScaleFrame(DeviceWidth-285, 160, 270, 15)];
    payType.text = @"居然分期付";
    payType.textAlignment = NSTextAlignmentRight;
    payType.textColor = RGB_COLOR(122,123,135);
    payType.font = DeviceFont(15);
    [view addSubview:payType];
    
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:ScaleFrame(15, 192, 360, DeviceLineWidth)];
    lineLabel1.backgroundColor = RGB_COLOR(235,236,237);
    lineLabel1.alpha = 0.6;

    [view addSubview:lineLabel1];


    UILabel *termTypeLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 209, 90, 15)];
    termTypeLabel.text = @"分期方式";
    termTypeLabel.textColor = RGB_COLOR(34,34,34);
    termTypeLabel.font = DeviceFont(15);
    [view addSubview:termTypeLabel];

    UILabel *termType = [[UILabel alloc] initWithFrame:ScaleFrame(DeviceWidth-285, 210, 270, 15)];
    termType.text = @"1366.66元x3期";
    termType.textAlignment = NSTextAlignmentRight;
    termType.textColor = RGB_COLOR(122,123,135);
    termType.font = DeviceFont(15);
    [view addSubview:termType];

    UILabel *servicCharge = [[UILabel alloc] initWithFrame:ScaleFrame(DeviceWidth-285, 234, 270, 15)];
    servicCharge.text = @"(手续费268.00元，费率0.7%／期)";
    servicCharge.textAlignment = NSTextAlignmentRight;
    servicCharge.textColor = RGB_COLOR(122,123,135);
    servicCharge.font = DeviceFont(13);
    [view addSubview:servicCharge];


    return view;
}


- (UIView *)inputInfoView{
    UIView *view = [[UIView alloc] initWithFrame:ScaleFrame(0, 0, DeviceWidth, 101)];
    view.backgroundColor = [UIColor whiteColor];

    UILabel *payTypeLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 18, 110, 15)];
    payTypeLabel.text = @"手机验证码：";
    payTypeLabel.textColor = RGB_COLOR(34,34,34);
    payTypeLabel.font = DeviceFont(15);
    [view addSubview:payTypeLabel];

    msgCode = [[CSIICustomTextField alloc]
                  initWithFrame:ScaleFrame(107,0, DeviceWidth-CGRectGetWidth(payTypeLabel.frame),50)];
    msgCode.delegate = self;
    msgCode.font = [UIFont systemFontOfSize:AllTextFont];
    msgCode.backgroundColor = [UIColor clearColor];
    msgCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入短信验证码" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    msgCode.tag = 4;
    msgCode.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:msgCode];

    getGSMButton = [[UIButton alloc]initWithFrame:ScaleFrame(291, (50-13)/2, 74, 13) ];
    getGSMButton.layer.cornerRadius = 3;
    getGSMButton.titleLabel.font=DeviceFont(14);
    [getGSMButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getGSMButton setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
    [getGSMButton addTarget:self action:@selector(sendSmsRequest) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:getGSMButton];

    UILabel *lineLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 51, 360, DeviceLineWidth)];
    lineLabel.backgroundColor = RGB_COLOR(235,236,237);
    lineLabel.alpha = 0.6;
    [view addSubview:lineLabel];

    UILabel *transPwdLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 68, 90, 15)];
    transPwdLabel.text = @"交易密码：";
    transPwdLabel.textColor = RGB_COLOR(34,34,34);
    transPwdLabel.font = DeviceFont(15);
    [view addSubview:transPwdLabel];

    transPwd = [[PowerEnterUITextField alloc]
                  initWithFrame:ScaleFrame(112,51, DeviceWidth-CGRectGetWidth(payTypeLabel.frame),50)];
    transPwd.delegate = self;
    transPwd.backgroundColor = [UIColor clearColor];
    transPwd.borderStyle = UITextBorderStyleNone;
    transPwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
    transPwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入交易密码" attributes:@{NSForegroundColorAttributeName:AllTextColorDetail,NSFontAttributeName:DeviceFont(15)}];
    transPwd.minLength = 6;                    //设置输入最小长度为2
    transPwd.maxLength =6;                    //设置输入最大长度为20
    transPwd.timestamp = @"1234567890";
    transPwd.isSound = NO;
    transPwd.passwordKeyboardType = Number;
    transPwd.isHighlightKeybutton = YES;
    [view addSubview:transPwd];




    return view;
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

    checkPhoneNum(@"phoneTF.text");//手机号

    [getGSMButton setTitle:@"发送中" forState:UIControlStateNormal];
    getGSMButton.userInteractionEnabled = NO;


    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
    [params setObject:@"phoneTF.text" forKey:@"PhoneNo"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 80.0f*DeviceScaleX;
    }
    return 10.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self orderView].frame.size.height;
    }else if (indexPath.section == 1){
        return [self inputInfoView].frame.size.height;

    }

    return 180.0f*DeviceScaleY;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];

    if (section == 1) {
        view.frame = CGRectMake(0, 0, ScreenWidth,  80.0f*DeviceScaleX);
        UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(15*DeviceScaleX, 18*DeviceScaleX, ScreenWidth-30*DeviceScaleX, 43*DeviceScaleX)];
        nextButton.backgroundColor = RGB_COLOR(38,150,196);
        nextButton.titleLabel.font = DeviceBoldFont(16);
        nextButton.layer.cornerRadius = 5;
        nextButton.layer.masksToBounds = YES;
        [nextButton setTitle:@"确定支付" forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];

        [view addSubview:nextButton];
    }

    return view;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

        if (indexPath.section == 0) {
            [cell.contentView addSubview:[self orderView]];
        }else if (indexPath.section == 1){
            [cell.contentView addSubview:[self inputInfoView]];
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
