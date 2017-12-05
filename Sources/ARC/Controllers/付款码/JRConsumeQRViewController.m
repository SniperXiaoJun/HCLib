//
//  JRConsumeQRViewController.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/3/28.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRConsumeQRViewController.h"
#import "JRConsumeResultViewController.h"
#import "UIImage+JRSY.h"
#import "JRAlertPassWord.h"
#import "CPNotifyClient.h"
#import "UIImage+JRQRCode.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#define IMAGE(Str) [UIImage imageNamed:Str]


/**    真正开发时重写，为演示方便，目前代码为简写  */
@interface JRConsumeQRViewController ()  <UITextFieldDelegate>{

    UIView  *topView;   // 顶部 包含logo
    UIView  *midView;   // 中部 账号 密码
    UIView  *bottomView;// 底部 按钮

    UIImageView *mainBgView;

    NSString *pwd;
    NSString *TokenID;
    UIImageView *qrImg;
    UIImageView *barImg;

    UILabel     *tokenLabel;
    UIView      *bg_view;


    UIImageView *qrCodeImg;//二维码
    UIImageView *barCodeImg;//条形码
    UILabel *barCodeNumber;//条形码数字

}
@end

@implementation JRConsumeQRViewController

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DebugLog(@"login----viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    DebugLog(@"login ----- viewDidAppear");

}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    DebugLog(@"login----viewWillDisappear");
    [NickMBProgressHUD hideHUD];
}

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
- (CGFloat)getHeightWithText:(NSString *)str
{
    UIFont *font = [UIFont systemFontOfSize:13.0f];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(ScreenWidth-40 * 2 - 70, 999)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:font}
                                    context:nil];
    return rect.size.height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"向商家付款";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPushNotification:) name:kGetPushNotification object:nil];

    mainBgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    mainBgView.image = JRBundeImage(@"consume_bg_big");
    mainBgView.backgroundColor = [UIColor whiteColor];
    mainBgView.userInteractionEnabled = YES;
    [self.view addSubview:mainBgView];

    CGFloat h1 = [self getHeightWithText:@"温馨提示："];
    UILabel *l_left = [[UILabel alloc] initWithFrame:CGRectMake(40, ScreenHeight - 135, 70, h1)];
    l_left.text = @"温馨提示：";
    l_left.textAlignment = NSTextAlignmentRight;
    l_left.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:l_left];

    CGFloat h = [self getHeightWithText:@"请向店员展示二维码，消费贷款金额以柜面输入为准；首笔消费日为所有消费贷款的每月固定还款日。"];
    UILabel *l_right = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(l_left.frame), ScreenHeight - 135, ScreenWidth - 80 - 70, h)];
    l_right.text = @"请向店员展示二维码，消费贷款金额以柜面输入为准；首笔消费日为所有消费贷款的每月固定还款日。";
    l_right.numberOfLines = 0;
    l_right.textAlignment = NSTextAlignmentLeft;
    l_right.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:l_right];

    [self addTopView];
    [self addMidView];
    [self  showAlertPW];
}
#pragma mark - 接到推送消息
- (void)getPushNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification object];
    DebugLog(@"收到推送通知:\n%@",userInfo);
    NSDictionary *extras = userInfo;
    JRConsumeResultViewController *vc = [[JRConsumeResultViewController alloc] init];
    vc.NotiDic = userInfo;

    if (extras[@"TransDate"]) {
        vc.time = extras[@"TransDate"];
    }

    if (extras[@"Amount"]) {
        vc.amount = extras[@"Amount"];
    }

    if (extras[@"JumpWay"]) {
        vc.JumpWay = extras[@"JumpWay"];
    }

    vc.tokenID = extras[@"TokenId"];
    vc.orderId = extras[@"OrderId"];

    CPNotifyClient *notify = [[CPNotifyClient alloc] init];
    [notify notifyClientRefresh];

    [self.navigationController pushViewController:vc animated:YES];


}
- (void)showAlertPW{
    JRAlertPassWord *pwdView = [[JRAlertPassWord alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    DebugLog(@"windows: %@",[[UIApplication sharedApplication] windows]);
    [self.view addSubview:pwdView];

    [pwdView show:^{
        NSLog(@"context.pass %@",Context.sendStringData);
        pwd = Context.sendStringData;

        [self getToken];
    } withCancelBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];

}
- (void)addTopView{


    UIImageView *cancelView = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCALE, 25*SCALE,35,35)];
    cancelView.image = JRBundeImage(@"back_54_54");
    cancelView.userInteractionEnabled = YES;
    UITapGestureRecognizer *cancelLoginTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelLoginTaped)];
    [cancelView addGestureRecognizer:cancelLoginTap];
    [mainBgView addSubview:cancelView];


    UILabel *titleMsg = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*SCALE,ScreenWidth, 30*SCALE)];
    titleMsg.textAlignment = NSTextAlignmentCenter;
    titleMsg.text = @"消费贷款";
    titleMsg.textColor = [UIColor whiteColor];
    [mainBgView addSubview:titleMsg];
}
- (void)addMidView{



    CGFloat topQRWH = 420 * scaleW;
    CGFloat a = ScreenWidth == 320 ? 220 : 290;

    qrImg = [[UIImageView alloc] initWithFrame:CGRectMake( (ScreenWidth - topQRWH)/2, a * scaleH, topQRWH, topQRWH)];
    qrImg.image = JRBundeImage(@"consume_qr_default_nor_2");
    [mainBgView addSubview:qrImg];

    if (ScreenWidth > 320) {
        tokenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(qrImg.frame) + 90 * scaleH, ScreenWidth, 20)];
    }else{
        tokenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(qrImg.frame) + 50 * scaleH, ScreenWidth, 40)];

    }

    tokenLabel.text = @"点击可查看付款码数字";
    if (TokenID.length != 0) {
        tokenLabel.text = [self normalStrWithStr:TokenID];
    }
    tokenLabel.textAlignment = NSTextAlignmentCenter;
    tokenLabel.numberOfLines = 0;
    tokenLabel.font = [UIFont systemFontOfSize:13];
    tokenLabel.hidden = YES;
    [mainBgView addSubview:tokenLabel];

    tokenLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAni)];
    [tokenLabel addGestureRecognizer:tap1];



    CGFloat barW = 600 * scaleW;
    CGFloat barH = 180 * scaleH;
    barImg  = [[UIImageView alloc] initWithFrame:CGRectMake( (ScreenWidth - barW)/2,CGRectGetMaxY(tokenLabel.frame) + 20 * scaleH, barW, barH)];
    barImg.hidden = YES;

    //阴影
    barImg.layer.shadowOffset = CGSizeMake(-0.5, 0.5);
    barImg.layer.shadowRadius = 0.5;
    barImg.layer.shadowColor = [UIColor blackColor].CGColor;
    barImg.layer.shadowOpacity = 0.2;
    barImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAni)];
    [barImg addGestureRecognizer:tap2];

    [mainBgView addSubview:barImg];

    if (TokenID.length == 0) {
        qrImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlertPW)];
        [qrImg addGestureRecognizer:tap];

    }

}

- (void)showJRCodeView{
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    backView.backgroundColor = RGB_COLOR(55,57,78);
    [self.view addSubview:backView];


    UIView *whiteView = [[UIView alloc] initWithFrame:ScaleFrame(20, 36, 335, 381)];

    if (IPHONEX) {
        whiteView.frame = ScaleFrame(20, 36+20, 335, 381);
    }

    whiteView.layer.cornerRadius = 5;
    whiteView.layer.masksToBounds = YES;
    whiteView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:whiteView];

    barCodeImg = [[UIImageView alloc] initWithFrame:ScaleFrame(29, 20, 278, 66)];
    [whiteView addSubview:barCodeImg];

    barCodeNumber = [[UILabel alloc] initWithFrame:ScaleFrame(0, 100, 335, 12)];
    barCodeNumber.text = @"点击可查看付款码数字";
    if (TokenID.length != 0) {
        barCodeNumber.text = [self normalStrWithStr:TokenID];
    }

    barCodeNumber.textAlignment = NSTextAlignmentCenter;
    barCodeNumber.numberOfLines = 0;
    barCodeNumber.font = DeviceFont(15);
    barCodeNumber.textColor = RGB_COLOR(34,34,34);
    [whiteView addSubview:barCodeNumber];

    qrCodeImg = [[UIImageView alloc] initWithFrame:ScaleFrame(67, 124, 203, 203)];
    [whiteView addSubview:qrCodeImg];

    UIImageView *codeLogoImg = [[UIImageView alloc] initWithFrame:ScaleFrame(87, 87, 30, 30)];
    codeLogoImg.image = JRBundeImage(@"二维码logo");
    [qrCodeImg addSubview:codeLogoImg];


    UIImageView * lineImg = [[UIImageView alloc] initWithFrame:ScaleFrame(0, 338, 335, 1)];
    lineImg.image = JRBundeImage(@"付款码分割线虚线");
    [whiteView addSubview:lineImg];


    UILabel *infoLabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 353, 335, 13)];
    infoLabel.textColor = RGB_COLOR(34,34,34);
    infoLabel.text = @"使用居然分期付";
    infoLabel.font =DeviceFont(13);
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:infoLabel];


    UILabel *infoTips = [[UILabel alloc] initWithFrame:ScaleFrame(0, 437, DeviceWidth, 13)];
    if (IPHONEX) {
        infoTips.frame = ScaleFrame(0, 437+20, DeviceWidth, 13);
    }
    infoTips.textColor = RGB_COLOR(157,158,174);
    infoTips.text = @"提示：请向店员展示二维码，消费贷款金额以柜面输入为准。";
    infoTips.font =DeviceFont(12);
    infoTips.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:infoTips];


    UIImageView * footLogoImg = [[UIImageView alloc] initWithFrame:ScaleFrame(155, 560, 66, 19)];
    footLogoImg.image = JRBundeImage(@"jrlogo");
    if (IPHONEX) {
        footLogoImg.frame = ScaleFrame(155, 560+40, 66, 19);
    }
    [backView addSubview:footLogoImg];

}




- (void)getToken{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];

    [params setObject:Context.sendStringData forKey:@"TrsPassword"];

    new_transaction_caller
    caller.transactionId = @"GetTokenForConsumeLoan.do"; //交易名
    caller.webMethod = POST;                                   // POST  GET
    caller.responsType = ResponsTypeOfJson; //返回数据处理
    caller.transactionArgument = params;   //上传参数
    caller.isShowActivityIndicator = YES;
    execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
        if (TransactionIsSuccess) {

            DebugLog(@"returnCaller.transactionResult--%@",returnCaller.transactionResult);
            TokenID = returnCaller.transactionResult[@"TokenId"];
            qrImg.userInteractionEnabled = NO;
            tokenLabel.text = [self normalStrWithStr:TokenID];

            dispatch_async(dispatch_get_main_queue(), ^{

//                qrImg.image = [UIImage imageWithQrStr:TokenID];
//                barImg.image = [UIImage barcodeImageWithContent:TokenID
//                                                  codeImageSize:CGSizeMake(300, 90)
//                                                            red:0
//                                                          green:0
//                                                           blue:0];
//                barImg.hidden = NO;
//                tokenLabel.hidden = NO;


                /********************/
                [self showJRCodeView];

                barCodeNumber.text = [self normalStrWithStr:TokenID];
                qrCodeImg.image = [UIImage imageWithQrStr:TokenID];
                barCodeImg.image = [UIImage barcodeImageWithContent:TokenID
                                                  codeImageSize:CGSizeMake(300, 90)
                                                            red:0
                                                          green:0
                                                           blue:0];

            });

        }else{
            alerErr
        }
    }));
}


/*
 *  取消视图 “x号”
 */
- (void)cancelLoginTaped{
    [self.navigationController popViewControllerAnimated:YES];
}

// 正常号转银行卡号 － 增加4位间的空格
-(NSString *)normalStrWithStr:(NSString *)str
{
    int size = (int)(str.length / 4);

    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0;n < size; n++)
    {
        [tmpStrArr addObject:[str substringWithRange:NSMakeRange(n*4, 4)]];
    }

    [tmpStrArr addObject:[str substringWithRange:NSMakeRange(size*4, (str.length % 4))]];

    return  [tmpStrArr componentsJoinedByString:@"   "];
}

- (void)tapBgDispear{
    if (bg_view) {
        [bg_view removeFromSuperview];
    }
}

- (void)rotationAni{
    DebugLog(@"动画旋转");

    bg_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    bg_view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bg_view];

    UITapGestureRecognizer *tap_bg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgDispear)];
    [bg_view addGestureRecognizer:tap_bg];


    CGFloat tipW = 450;
    CGFloat tipX = 50;
    CGFloat tipY = 320;
    if (ScreenWidth == 375) {
        tipX = 50;
        tipY = 320;
    }else if(ScreenWidth == 414){
        tipX = 80;
        tipY = 350;
    }else{
        tipX = 30;
        tipY = 273;
    }
    UILabel *tipL = [[UILabel alloc] initWithFrame:CGRectMake(tipX,tipY, tipW, 20)];
    //    UILabel *tipL = [[UILabel alloc] initWithFrame:CGRectMake(tipW/2-10,50-tipW/2, tipW, 20)];
    tipL.text = [self normalStrWithStr:TokenID];
    tipL.transform=CGAffineTransformMakeRotation(M_PI/2);

    tipL.textAlignment = NSTextAlignmentCenter;
    tipL.numberOfLines = 0;
    tipL.font = [UIFont systemFontOfSize:15];
    [bg_view addSubview:tipL];


    //条形码
    CGFloat w = 400;
    CGFloat h = 120;
    UIImage *barImage = [UIImage barcodeImageWithContent:TokenID
                                           codeImageSize:CGSizeMake(w, h)
                                                     red:0
                                                   green:0
                                                    blue:0];
    CGRect barImageView_Frame = CGRectMake((ScreenWidth - h)/2-140,(ScreenHeight - w)/2 +140, w,h);
    DebugLog(@"kkk:%@",NSStringFromCGRect(barImageView_Frame));
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:barImageView_Frame];
    barImageView.transform=CGAffineTransformMakeRotation(M_PI/2);
    barImageView.image = barImage;
    barImageView.backgroundColor = [UIColor clearColor];
    //阴影
    barImageView.layer.shadowOffset = CGSizeMake(-0.5, 0.5);
    barImageView.layer.shadowRadius = 0.5;
    barImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    barImageView.layer.shadowOpacity = 0.2;

    [bg_view addSubview:barImageView];

}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGetPushNotification object:nil];
}

@end

