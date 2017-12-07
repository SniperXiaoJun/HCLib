//
//  JRMyFinancialAccountView.m
//  Double
//
//  Created by 何崇 on 2017/11/17.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "JRMyWalletFinancialAccountView.h"
#import "JRPersonalMessagesViewController.h"
#import "JRUploadIdCardViewController.h"
#import "JRSuccessViewController.h"
#import "JRBindCardViewController.h"
#import "JRScanViewController.h"
#import "JRPluginUtil.h"
#import "JRJumpClientToVx.h"
#import "JRConsumeQRViewController.h"

//第一个section
#define SectionOneFrame ScaleFrame(0, 0, DeviceWidth, 185 )
#define SectionOneHeaderFrame ScaleFrame(0, 0, DeviceWidth, 105)
#define SectionOneMenuFrame ScaleFrame(0, 105, DeviceWidth, 80)
#define SectionOneHeadLogoFrame  ScaleFrame(16, 22, 60, 60) //logo的frame
#define SectionOneUpTitleFrame ScaleFrame(88, 34, 116, 16) //bigTitle的frame
#define SectionOneDownTitleFrame ScaleFrame(88, 57, 208, 11) //smallTitle的frame
#define SectionOneRealNameLogoFrame ScaleFrame(190, 33, 51, 18) //实名认证的frame
#define SectionOneRightArrowFrame ScaleFrame(DeviceWidth-22, 46, 6, 11) //右侧箭头frame

#define SectionTwoFrame ScaleFrame(0, 0, DeviceWidth, 140)
#define SectionTwoHeaderFrame ScaleFrame(0, 0, DeviceWidth, 95)
#define SectionTwoLogoFrame ScaleFrame(15, 16, 18, 18)
#define SectionTwoTitleFrame ScaleFrame(37, 18, 59, 15)
#define SectionMoneyFrame ScaleFrame(37, 56, 240, 30)
#define SectionPayFrame ScaleFrame(208, 50, 71, 30)
#define SectionGetFrame ScaleFrame(289, 50, 71, 30)
#define SectionDownFrame ScaleFrame(0, 95,DeviceWidth, 45)
#define SectionDownTitleFrame ScaleFrame(37, 111, 65, 13)
#define SectionDownRightArrowFrame ScaleFrame(353, 111, 6, 11)
#define SectionDownLineFrame ScaleFrame(37, 95, 323, DeviceLineWidth)

@interface JRMyWalletFinancialAccountView(){
    UILabel *accountPhone;
    UIButton *gotoRealName;
}

@end

@implementation JRMyWalletFinancialAccountView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self financialAccountView];
    }
    return self;

}

- (UIView *)financialAccountView{

    //底图
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:cellView];

    UIView *headView = [[UIView alloc] initWithFrame:SectionOneHeaderFrame];
    headView.userInteractionEnabled = YES;
    [cellView addSubview:headView];
    //头像
    UIImageView * headImgView = [[UIImageView alloc] initWithFrame:SectionOneHeadLogoFrame];
    headImgView.image = JRBundeImage(@"缺省头像icon");
    [headView addSubview:headImgView];

    UILabel *accountTip = [[UILabel alloc] initWithFrame:SectionOneUpTitleFrame];
    accountTip.text = @"我的金融账户";
    accountTip.textColor = RGB_COLOR(34, 34, 34);
    accountTip.font = DeviceFont(16);
    [headView addSubview:accountTip];


    NSString *mobileStr = [Singleton.userInfo objectForKey:@"Mobile"];

    if (mobileStr.length>0) {
        mobileStr = [mobileStr remixPhoneNum];
    }

    accountPhone = [[UILabel alloc] initWithFrame:SectionOneDownTitleFrame];
    accountPhone.text = mobileStr.length>0?mobileStr:@"暂无";
    accountPhone.textColor = RGB_COLOR(136, 136, 136);
    accountPhone.font = DeviceFont(14);
    [headView addSubview:accountPhone];


    NSString *realNameLogoName = @"未实名icon";
    if ([Singleton.userInfo[@"CifName"] length]>0) {
        realNameLogoName = @"已实名icon";
    }

    gotoRealName = [[UIButton alloc] initWithFrame:SectionOneRealNameLogoFrame];
    [gotoRealName  setImage:JRBundeImage(realNameLogoName)  forState:UIControlStateNormal];
    gotoRealName.titleLabel.font = [UIFont systemFontOfSize:13];
    [gotoRealName addTarget:self action:@selector(personInfo) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:gotoRealName];


    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personInfo)];
    [headView addGestureRecognizer:headTap];


    CSIILabelButton * rightArrow = [[CSIILabelButton alloc] init];
    [rightArrow  setImage:JRBundeImage(@"箭头icon") frame:SectionOneRightArrowFrame forState:UIControlStateNormal];
    [rightArrow addTarget:self action:@selector(personInfo) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:rightArrow];



    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(headView.frame), ScreenWidth, DeviceLineWidth)];
    lineLabel.backgroundColor = RGB_COLOR(236, 236, 236);
    lineLabel.alpha = 0.6;
    [cellView addSubview:lineLabel];

    
    UIView *menuView = [[UIView alloc] initWithFrame:SectionOneMenuFrame];
    [cellView addSubview:menuView];

    NSArray *menuImgArr = @[@"扫一扫icon",@"付款码icon",@"钱包-银行卡icon"];
    NSArray *menuTitleArr = @[@"扫一扫",@"付款码",@"银行卡"];
    for (int i=0; i<3; i++) {

        UIButton *menuBtn =  [UIButton buttonWithTitle:menuTitleArr[i] titleFont:DeviceFont(14) image:JRBundeImage(menuImgArr[i]) selectedImage:JRBundeImage(menuImgArr[i] ) frame:CGRectMake(i*ScreenWidth/3, 0, ScreenWidth/3, CGRectGetHeight(menuView.frame))];
        [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        menuBtn.tag = 10+i;
        [menuView addSubview:menuBtn];
    }

    return cellView;
}

- (void)refreshView {

    NSString *mobileStr = [Singleton.userInfo objectForKey:@"Mobile"];

    if (mobileStr.length>0) {
        mobileStr = [mobileStr remixPhoneNum];
    }
    accountPhone.text = mobileStr.length>0?mobileStr:@"暂无";


    NSString *realNameLogoName = @"未实名icon";
    if ([Singleton.userInfo[@"CifName"] length]>0) {
        realNameLogoName = @"已实名icon";
    }

    [gotoRealName  setImage:JRBundeImage(realNameLogoName)  forState:UIControlStateNormal];
}

//实名认证
- (void)personInfo{

    if ([Singleton.userInfo[@"CifName"] length]>0) {
        // 已实名认证
        JRPersonalMessagesViewController *p = [[JRPersonalMessagesViewController alloc] init];
        [Singleton.rootViewController pushViewController:p animated:YES];
    }else{
        //未实名认证
        JRUploadIdCardViewController *p = [[JRUploadIdCardViewController alloc] init];
        [Singleton.rootViewController pushViewController:p animated:YES];
    }
}


//扫一扫  付款码  银行卡
- (void)menuBtnClick:(UIButton *)sender{

    if (sender.tag == 10) {
        //校验是否实名及其绑卡
        if (![JRPluginUtil isCheckOk]) {
            return;
        }

        //查看消费贷是否有额度
        if (![JRPluginUtil getConsumeValidLimit]) {
            return;
        }

        //扫一扫
        //[self consumeQrClick];
        JRScanViewController *scanVC = [[JRScanViewController alloc] init];
        [Singleton.rootViewController pushViewController:scanVC animated:NO];
        return;
    }else if (sender.tag == 11){
        //校验是否实名及其绑卡
        if (![JRPluginUtil isCheckOk]) {
            return;
        }

        //查看消费贷是否有额度
        if (![JRPluginUtil getConsumeValidLimit]) {
            return;
        }

        //付款码
        JRConsumeQRViewController *qrView = [[JRConsumeQRViewController alloc] init];
        [Singleton.rootViewController pushViewController:qrView animated:YES];
        return;

    }else if (sender.tag == 12){
        //校验是否实名认证 然后才绑卡

        if (![JRPluginUtil isCustmerOk]) {
            return;
        }

        if ([Singleton.userInfo[@"Entitycard"] length]>0) {
            //已绑定银行卡
            [JRJumpClientToVx jumpWithZipID:@"sjj_BankCardMgmt" controller:Singleton.rootViewController];
        }else{
            //未绑定银行卡
            JRBindCardViewController *bindCard = [[JRBindCardViewController alloc] init];
            [Singleton.rootViewController pushViewController:bindCard animated:YES];
        }
        return;
    }

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
