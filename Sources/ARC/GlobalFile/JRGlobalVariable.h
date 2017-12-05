//
//  JRGlobalVariable.h
//  ProductInfoFlow
//
//  Created by Shen Yu on 16/3/29.
//  Copyright © 2016年 Shen Yu. All rights reserved.
//

#ifndef JRGlobalVariable_h
#define JRGlobalVariable_h



#define RSAKEY @"932E1FCD7272FEF137C006DA347D92C3FAB9DBE3D21B2CEA840744477D29E43DA74D63E409EAF77E79F98029D5C1369673AB83D1CD9D98B80E70CCF509EC987B7834335F1A1347FC88F5CB7BB1C591D48BF65BF2F6E68024C4C298253F62C042E04DF811804FFAD1E260CD22EE9D15012E94CCA00C9332BF9FC403DE007DDF73"

#define XCodeBoundleVersion  1.0.0   // xcode的提交版本，在联系我们  展示
#define LeftViewH 90            // 文章高度
#define NewsViewH 40            // 公告高度
#define ChartViewH  597*scaleH    // 折线图高度
#define MenuIconViewH 80        // 每个菜单的高度
#define MenuIconPageControlH 10 // PageControl占位高度

#define authStr @"#allauth"    // 判断是否需要登录的标志位
/** 通知 */
#define Login_Notification @"login_now"                     // 登录通知名
#define Login_Out_Notification @"login_out"                 // 退出登录通知名
#define Notify_Client @"notify_client"                      // 刷新富文本楼层
#define Notify_Client_Company @"notify_client_company"      // 刷新企业专区

#define Notify_RadarView_Animation @"radarView_animation"   // 雷达特效
#define Notify_Sidai_Animation @"sidai_animation"           // 丝带特效


#define kMachineBindingQryMessage @"kMachineBindingQryMessage"//设备绑定信息

/*第一次启动标志*/
#define kIsNoFirstRun @"kIsNoFirstRunVersion2.7"

#define kIsBindPhone @"kIsBindPhone"

#define Login_do  @"login_CC.do"

#define kMemoryCache_AcList @"kMemoryCache_AcList"
#define kMemoryCache_UserName @"kMemoryCache_UserName"
#define kMemoryCache_UserId @"kMemoryCache_UserId"
#define kMemoryCache_UserInfo @"kMemoryCache_UserInfo"
#define kCifNo @"kCifNo"




#define kTipTransPWD @"温馨提示：请输入6位数字交易密码"
#define kTipLoginPWD @"温馨提示：密码为长度6-16位的大小写字母和数字组合，且不能连续重复三位。"
#define kTipLabelH   40
#define kTipMarginTop 16
#define kTipMarginMid 30




#define kisHaveSetGesture @"kisHaveSetGesture"

#define kisHaveSetFinger @"kisHaveSetFinger"   // 是否开启指纹
#define kUserId @"kUserId"                    //也是Userid 手机号


#define kGetPushNotification @"getPushNotification"  // 极光推送通知
#define kGetPushMesage @"getPushMesage"              // 极光推送消息


// zip包 标识符
#define kZipQRCode                  @"QRCode"              // 扫码支付zip包
#define kRecharge                   @"Recharge"            // 充值
#define kWithdrawals                @"Withdrawals"         // 提现
#define kApplyLoan                  @"ApplyLoan"           // 贷款
#define kStateJudge                 @"StateJudge"          // 非激活状态都走这里
#define kTrsDetail                  @"TrsDetail"           // 零钱
#define kStaffLoan                  @"StaffLoan"           //  员工贷
#define kConsumerLoanDetail         @"ConsumerLoanDetail"  //  贷款详情
#define kEmployeeLoanDetail         @"EmployeeLoanDetail"  //  员工款详情


/* 设计家插件应用标识 */
#define Consume_apply               @"consume_apply"        //消费贷申请
#define Consume_active              @"consume_active"       //消费贷激活
#define Consume_drawmoney           @"consume_drawmoney"    //消费贷提款
#define Consume_repay               @"consume_repay"        //消费贷还款
#define Consume_trsrecord           @"consume_trsrecord"    //消费贷交易记录

#define Consume_limitupF            @"sjj_consume_raiseLimitF"     //消费贷提额_主动申请
#define Consume_limitupY            @"sjj_consume_raiseLimitY"     //消费贷提额_预授信
#define Consume_upload              @"consume_upload"       //消费贷资料补录

#define JRFirmBankaccount           @"FirmBankaccount"      //个人银行账户应用标识：sjj_BankCardMgmt  zip包名 ：sjj_BankCardMgmt
#define JRRecharge                  @"sjj_Recharge"         //个人充值应用标识：sjj_Recharge zip包名：sjj_Recharge
#define JRWithdrawals               @"sjj_Withdrawals"      //个人提现应用标识：sjj_Withdrawals zip包名：sjj_Withdrawals
#define JRTrsDetail                 @"sjj_TrsDetail"        //个人零钱明细标识：sjj_TrsDetail zip包名：sjj_TrsDetail

/* 设计家插件应用标识 */


#define kCommonQa                   @"CommonQa"             //  常见问题


// 消费贷
#define kLoanDetail                 @"LoanDetail"          //  消费贷借款明细
#define kRepayment                  @"Repayment"           //  消费贷还款
#define kDrawMoney                  @"DrawMoney"           //  消费贷提额

// 流转贷
#define kRLTMainPage                @"RLTMainPage"           //  流转贷主页
#define kRLTTrsDetail               @"RLTTrsDetail"           // 流转贷明细




// 企业zip包
#define kRunningLoanApply           @"RunningLoanApply"    //  流水贷申请
#define kRunningLoanActive          @"RunningLoanActive"   //  流水贷激活
#define kRunningLoanActiveCridit    @"RunningLoanActiveCridit" // 预授信激活
#define kRLMainPage                 @"RLMainPage"          //  流水贷其他情况
#define kRLAddPerson                @"RLAddPerson"         //  流水贷新增担保人
#define kETrsDetail                 @"ETrsDetail"          //  交易明细 ？
#define kECash                      @"ECash"               //  提现
#define kEBankaccount               @"EBankaccount"        //  银行账户
#define kInteresTrial               @"InteresTrial"        //  提款
#define kCalculator                 @"Calculator"          //  计算器





// 路由 拦截 功能 
#define jAppLoan            @"AppLoan"          // 首页---我要贷款--跳VX
#define jHomePersonalLoan   @"HomePersonalLoan" // 首页---个人贷款--跳原生
#define jConsumeQr          @"consumeQr"        // 首页---扫码支付--跳原生
#define jHelpCenter         @"helpCenter"       // 我的---帮助中心--跳原生
#define jSetting            @"setting"          // 我的---设置-----跳原生
#define Invoice            @"invoice"          // 我的---电子发票-----跳原生
#define jCompany            @"company"          // 我的---企业专区--跳原生
#define YuanGong            @"employee"          // 首页---员工专区--跳原生




// 一天
#define oneDay (24*60*60)
// 删除周期：天
#define deletePeriod 30

// 富文本每个条目之间的间距
#define richTextCellMargin 10

#define NoWordsMenuMargin  15
#define NoWordsMid  15
// 底部tabBar 显示隐藏


//#define hideTabBar 3;
//#define showTabbar 4;

// 在富文本楼层传给vx数据的key
#define PartCellInfo @"partCellInfo"

//#define DebugLog( s, ... ) printf( "<%s:(%d)> %s %s\n\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] cStringUsingEncoding:NSUTF8StringEncoding], __LINE__,__func__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] cStringUsingEncoding:NSUTF8StringEncoding])


// 对于 13年刘旺写的框架做容错处理，Modify By ShenYu
#define  alerErr if ([returnCaller.transactionResult[@"jsonError"]  isKindOfClass:[NSString class]]) {\
    UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:returnCaller.transactionResult[@"jsonError"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];\
    [alt show];\
}


#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define SCALE   (ScreenWidth/320)


#define scaleW  (ScreenWidth/750)
#define scaleH  (ScreenHeight/1334)

#define scalePW (ScreenWidth/1242)
#define scalePH (ScreenHeight/2208)



// RGB颜色
#define SYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 随机色
#define SYRandomColor SYColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define AllTextFont ScreenWidth==320? 14 : 16
#define AllTextColorTit SYColor(34, 34, 34)
#define AllTextColorDetail SYColor(199,209,214)
#define AllLineColor SYColor(235,236,237)


#define DeviceFrame [UIScreen mainScreen].bounds;



// 背景颜色
#define BIGBGColor [UIColor colorWithRed:(240)/255.0 green:(240)/255.0 blue:(240)/255.0 alpha:1]

// 可点击的蓝色
#define clickColor SYColor(0, 81, 211)

#define DisableBg [UIColor lightGrayColor]
#define EnableBg  [UIColor colorWithRed:20/255.0 green:124/255.0 blue:209/255.0 alpha:1]


#define TitleColor @"#333333"



// 弹框
#define alertMsg(Msg)   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:Msg preferredStyle:UIAlertControllerStyleAlert];\
UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];\
[alertController addAction:okAction];\
[self presentViewController:alertController animated:YES completion:nil];\
return;



// 弹框
#define alertNoReturn(Msg)   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:Msg preferredStyle:UIAlertControllerStyleAlert];\
UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];\
[alertController addAction:okAction];\
[self presentViewController:alertController animated:YES completion:nil];


// 弹框，alertView
#define alertView(Msg)  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:Msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alert show];\
return;

#define removeSubViewsInCell for (UIView *subView in self.contentView.subviews) { \
    [subView removeFromSuperview];\
}


// 检查手机号码
#define  checkPhoneNum(Number)    if (![JRPattern checkTelNumber:Number]) return;



// 单例实例
#define Singleton [JRSYSingleClass shareInstance]
// 当前tab的baseUrl
#define nowTabBaseUrl _dataDict[@"baseUrl"]


#define MaskShow   [[CPUIActivityIndicator sharedInstance] show];
#define MaskHide   [[CPUIActivityIndicator sharedInstance] hidden];


// 正则  登录密码 8-12 大小写
#define kPatterLoginPwd @"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,16}$"
#define kLoginPwdMin    6
#define kLoginPwdMax    16


#define kMaxLengthName          20   // 姓名
#define kMaxLengthBankCard      19   // 银行卡号
#define kMaxLengthBankName      20   // 银行名字
#define kMaxLengthPhoneNum      11   // 手机号
#define kMaxLengthIdCard        18   // 身份证号
#define kMaxLengthVerifyNum     6    // 手机验证码



/************以下为自定义楼层的 ID *********/
#define Floor_Home_Bottom @"index_loan_ad"      // 首页底部 与 贷款页面底部一致
#define Floor_Home_Bottom_One  ( 272 * scaleH )   // 员工贷或流转贷高度
#define Floor_Home_Bottom_Two  ( 549 * scaleH )   // 员工贷和流转贷一起高度


#define Floor_Loan @"floor_loan"        // 贷款顶部
#define Floor_Loan_H  ( 520 * scaleH )  // 贷款顶部高度


#define Floor_Loan_Detail @"floor_loan_detail_1"          //我的-贷款
#define Floor_Loan_Detail_ALL  ( 454 * scaleH )           //三个都有
#define Floor_Loan_Detail_Two  ( 302 * scaleH )           // 有2个
#define Floor_Loan_Detail_One  ( 150 * scaleH )           // 有1个

#define LiuShuiHeight  ( 371 * scaleH )
#define KaiDianHeight  ( 371 * scaleH )
#define GuoQiaoHeight  ( 399 * scaleH )


#define User_Info @"floor_user_info"    // 个人信息
#define User_Info_H  ( 440 * scaleH )   // 个人信息高度


#define Floor_Yuangongdai @"yuangongdai"          // 员工贷和流转贷
#define Floor_Yuangongdai_One  ( 222 * scaleH )   // 员工贷或流转贷高度
#define Floor_Yuangongdai_Two  ( 454 * scaleH )   // 员工贷和流转贷一起高度


//#define Floor_Liuzhuandai @"liuzhuandai"        // 流转贷
//#define Floor_Liuzhuandai_H  (245 * scaleH )    // 流转贷高度

#define LimitTableViewCellH  64
#define Floor_Loan_Up_Limit     @"loan_up_limit"                // 提额还款
#define Floor_Loan_Up_Limit_H  ( LimitTableViewCellH * 2 )      // 提额还款高度

#endif
