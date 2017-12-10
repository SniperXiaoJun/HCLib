//
//  JRMyWalletStagePayView.m
//  Double
//
//  Created by 何崇 on 2017/11/17.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "JRMyWalletStagePayView.h"
#import "JRStagePayAuthorizeController.h"
#import "JRStagePayAdsController.h"
#import "JRStagePayMenuController.h"

#import "CSIIFormatUitli.h"

#define DefaultFrame ScaleFrame(0, 0, DeviceWidth, 140)
#define SectionThreeLogoFrame ScaleFrame(15, 15, 16, 16)
#define SectionThreeTitleFrame ScaleFrame(37, 16, 259, 15)

//未开通
#define SectionThreeRightTitleFrame ScaleFrame(280, 16, 73, 16)
#define SectionThreeRightLogoFrame ScaleFrame(350, 19, 10, 10)
#define SectionThreeDownlimitMoneyFrame ScaleFrame(38, 63, 72, 16)
#define SectionThreeDownlimitMoneyTipFrame ScaleFrame(37, 92, 75, 12)
#define SectionThreeDownDescriptionFrame ScaleFrame(136, 64, 215, 15)
#define SectionThreeDownOpenUseFrame ScaleFrame(136, 89, 54, 18)
#define SectionThreeDownFlexibleEasyFrame ScaleFrame(198, 92, 54, 12)

@interface JRMyWalletStagePayView(){
    NSString *occurType;    //发生类型
    NSString *consumeState; //新发生状态
    NSString *raiseState;   //提额状态
    NSString *creditState;  //预授信状态

}

@end


@implementation JRMyWalletStagePayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }

    //新发生状态
    consumeState = Singleton.consumeInfoDict[@"applyInfo"][@"applyStatus"];

    //默认为新发生的类型
    occurType = Singleton.consumeInfoDict[@"applyInfo"][@"applyOccurType"];

    //判断是否是预授信客户

    //creditlimitnew  预授信额度
    //creditStatus    预授信状态：    YSJHZT_00";//预授信待激活状态    "YSJHZT_01";//预授信激活状态    "YSJHZT_02";//预授信拒绝

    //预授信状态
    creditState = Singleton.consumeInfoDict[@"creditStatus"];


    //如果新发生已经激活判断是否是提额状态 如果是提额状态则发生类型为提额
    if ([consumeState isEqualToString:@"SQZT_JH"] || [creditState isEqualToString:@"YSJHZT_01"]) {
        //提额状态
        raiseState = Singleton.consumeInfoDict[@"raiseInfo"][@"raiseStatus"];
        if ([raiseState isEqualToString:@"SQZT_SPZ"] ||
            [raiseState isEqualToString:@"SQZT_TG"] ) {
            occurType = Singleton.consumeInfoDict[@"raiseInfo"][@"raiseOccurType"];
        }else{
            occurType = Singleton.consumeInfoDict[@"applyInfo"][@"applyOccurType"];
        }
    }


    if ([occurType isEqualToString:@"FSLX_00"] &&([consumeState isEqualToString:@""] ||
        [consumeState isEqualToString:@"SQZT_NULL"] ||
        [consumeState isEqualToString:@"SQZT_YGD"] ||
        consumeState == nil) ) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 140*DeviceScaleX);
    }
    //待审核
    else if ([occurType isEqualToString:@"FSLX_00"] && [consumeState isEqualToString:@"SQZT_SQ"] ) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 140*DeviceScaleX);
    }

    //审批中
    else if ([occurType isEqualToString:@"FSLX_00"] && [consumeState isEqualToString:@"SQZT_SPZ"] ) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 154*DeviceScaleX);
    }

    //新发生的审批通过 或者 预授信待激活
    else if (([occurType isEqualToString:@"FSLX_00"] && [consumeState isEqualToString:@"SQZT_TG"])||
             [creditState isEqualToString:@"YSJHZT_00"]) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 154*DeviceScaleX);
    }

    else if ([occurType isEqualToString:@"FSLX_01"] || [consumeState isEqualToString:@"SQZT_JH"] ||
              [creditState isEqualToString:@"YSJHZT_00"]) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 230*DeviceScaleX);
    }
    else if ([consumeState isEqualToString:@"SQZT_JJ"] ||
             [consumeState isEqualToString:@"SQZT_XTJJ"] ||
             [consumeState isEqualToString:@"SQZT_TH"] ) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 154*DeviceScaleX);
    }

    if ([creditState isEqualToString:@"FSLX_01"]) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 230*DeviceScaleX);
    }

    [self stagePayWithState:consumeState occurType:occurType];

    return self;
    
}

- (void)setConsumeState:(NSString *)consumeState{
    self.consumeState = consumeState;

    
}

- (void)refreshView {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.backgroundColor = [UIColor whiteColor];

    //新发生状态
    consumeState = Singleton.consumeInfoDict[@"applyInfo"][@"applyStatus"];

    //默认为新发生的类型
    occurType = Singleton.consumeInfoDict[@"applyInfo"][@"applyOccurType"];

    //creditlimitnew  预授信额度
    //creditStatus    预授信状态：    YSJHZT_00";//预授信待激活状态    "YSJHZT_01";//预授信激活状态    "YSJHZT_02";//预授信拒绝

    creditState = Singleton.consumeInfoDict[@"creditStatus"];


    //如果新发生已经激活判断是否是提额状态 如果是提额状态则发生类型为提额
    if ([consumeState isEqualToString:@"SQZT_JH"] || [creditState isEqualToString:@"YSJHZT_01"]) {
        //提额状态
        raiseState = Singleton.consumeInfoDict[@"raiseInfo"][@"raiseStatus"];
        if ([raiseState isEqualToString:@"SQZT_SPZ"] ||
            [raiseState isEqualToString:@"SQZT_TG"] ) {
            occurType = Singleton.consumeInfoDict[@"raiseInfo"][@"raiseOccurType"];
        }else{
            occurType = Singleton.consumeInfoDict[@"applyInfo"][@"applyOccurType"];
        }
    }

    if ([occurType isEqualToString:@"FSLX_00"] && ([consumeState isEqualToString:@""] ||
        [consumeState isEqualToString:@"SQZT_NULL"] ||
        [consumeState isEqualToString:@"SQZT_YGD"] ||
        consumeState == nil)) {
        self.frame = CGRectMake(DefaultFrame.origin.x, DefaultFrame.origin.y, DefaultFrame.size.width, 140*DeviceScaleX);
    }

    //待审核
    else if ([occurType isEqualToString:@"FSLX_00"] && [consumeState isEqualToString:@"SQZT_SQ"] ) {
        self.frame = CGRectMake(DefaultFrame.origin.x, DefaultFrame.origin.y, DefaultFrame.size.width, 140*DeviceScaleX);
    }

    //审批中
    else if ([occurType isEqualToString:@"FSLX_00"] && [consumeState isEqualToString:@"SQZT_SPZ"] ) {
        self.frame = CGRectMake(DefaultFrame.origin.x, DefaultFrame.origin.y, DefaultFrame.size.width, 154*DeviceScaleX);
    }

    //新发生的审批通过 或者 预授信客户显示去激活
    else if (([occurType isEqualToString:@"FSLX_00"] && [consumeState isEqualToString:@"SQZT_TG"])||
             [creditState isEqualToString:@"YSJHZT_00"]) {
        self.frame = CGRectMake(DefaultFrame.origin.x, DefaultFrame.origin.y, DefaultFrame.size.width, 154*DeviceScaleX);
    }

    else if ([occurType isEqualToString:@"FSLX_01"] || [consumeState isEqualToString:@"SQZT_JH"]  ||
              [creditState isEqualToString:@"YSJHZT_00"]) {
        self.frame = CGRectMake(DefaultFrame.origin.x, DefaultFrame.origin.y, DefaultFrame.size.width, 230*DeviceScaleX);
    }
    else if ([consumeState isEqualToString:@"SQZT_JJ"] ||
             [consumeState isEqualToString:@"SQZT_XTJJ"] ||
             [consumeState isEqualToString:@"SQZT_TH"] ) {
        self.frame = CGRectMake(DefaultFrame.origin.x, DefaultFrame.origin.y, DefaultFrame.size.width, 154*DeviceScaleX);
    }

    if ([creditState isEqualToString:@"YSJHZT_01"]) {
        self.frame = CGRectMake(DefaultFrame.origin.x, DefaultFrame.origin.y, DefaultFrame.size.width, 230*DeviceScaleX);
    }


    [self stagePayWithState:consumeState occurType:occurType];
}


- (UIView *)stagePayWithState:(NSString *)state occurType:(NSString *)occurType{
    //底图

    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    cellView.userInteractionEnabled = YES;
    [self addSubview:cellView];

    CSIILabelButton * accountLogo = [[CSIILabelButton alloc] init];
    [accountLogo  setImage:JRBundeImage(@"分期icon") frame:SectionThreeLogoFrame forState:UIControlStateNormal];
    [accountLogo setLabel:@"居然分期付" frame:SectionThreeTitleFrame];
    accountLogo.label.font = DeviceFont(14);
    [cellView addSubview:accountLogo];

    //如果是预授信待激活
    if ([creditState isEqualToString:@"YSJHZT_00"]) {
        cellView.frame = ScaleFrame(0, 0, DeviceWidth, 154);
        CSIILabelButton * activeBtn = [[CSIILabelButton alloc] init];
        [activeBtn  setImage:JRBundeImage(@"箭头icon") frame:ScaleFrame(353, 17, 6, 11) forState:UIControlStateNormal];
        [activeBtn setLabel:@"激活" frame:ScaleFrame(325, 16, 35, 13)];
        activeBtn.label.font = DeviceFont(13);
        activeBtn.label.textColor = RGB_COLOR(153,153,153);
        [activeBtn addTarget:self action:@selector(activeClick) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:activeBtn];

        UILabel *limitlabel = [[UILabel alloc] initWithFrame:ScaleFrame(154, 50, 95, 12)];
        limitlabel.text = @"已审批额度(元)";
        limitlabel.textColor = RGB_COLOR(34,34,34);
        limitlabel.font = DeviceFont(12);
        [cellView addSubview:limitlabel];


        //预授信额度
        NSString *vchqutStr = Singleton.consumeInfoDict[@"creditlimitnew"];
        if (vchqutStr.length==0) {
            vchqutStr = @"0.00";
        }

        vchqutStr = [CSIIFormatUitli splitByRmb:vchqutStr];
        UILabel *limitMoneylabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 71, DeviceWidth, 19)];
        limitMoneylabel.text = vchqutStr;
        limitMoneylabel.textColor = RGB_COLOR(223,64,49);
        limitMoneylabel.font = DeviceFont(20);
        limitMoneylabel.textAlignment = NSTextAlignmentCenter;
        [cellView addSubview:limitMoneylabel];

        UILabel *lineLabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 112, DeviceWidth, DeviceLineWidth)];
        lineLabel.backgroundColor = RGB_COLOR(236,236,236);
        lineLabel.alpha = 0.6;
        [cellView addSubview:lineLabel];

        CSIILabelButton * activatFile = [[CSIILabelButton alloc] init];
        [activatFile  setImage:JRBundeImage(@"开通箭头icon") frame:ScaleFrame(216, 128, 10, 10) forState:UIControlStateNormal];
        [activatFile setLabel:@"马上激活" frame:ScaleFrame(154, 125, 65, 14)];
        activatFile.label.font = DeviceFont(15);
        activatFile.label.textColor = RGB_COLOR(38,150,196);
        [cellView addSubview:activatFile];


        UIImageView *stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-47*DeviceScaleX, 65, 51*DeviceScaleX, 47*DeviceScaleX)];
        stateImageView.image = JRBundeImage(@"待激活印章icon");
        [cellView addSubview:stateImageView];


        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activeClick)];
        [cellView addGestureRecognizer:tap];

        return cellView;
    }
    //预授信已激活
    else if ([creditState isEqualToString:@"YSJHZT_01"]) {
        cellView.frame = ScaleFrame(0, 0, DeviceWidth, 230);

        UIView *headView = [[UIView alloc] initWithFrame:ScaleFrame(0, 0, DeviceWidth, 135)];
        [cellView addSubview:headView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailClick)];
        [headView addGestureRecognizer:tap];

        CSIILabelButton * openStagePay = [[CSIILabelButton alloc] init];
        [openStagePay setLabel:[NSString stringWithFormat:@"有效期至：%@",Singleton.consumeInfoDict[@"endDate"]] frame:ScaleFrame(DeviceWidth-171, 17, 160, 11)];
        openStagePay.label.font = DeviceFont(11);
        openStagePay.label.textColor = RGB_COLOR(153,153,153);
        openStagePay.label.textAlignment = NSTextAlignmentRight;
        [openStagePay addTarget:self action:@selector(openStagePay) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:openStagePay];

        UILabel *limitlabel = [[UILabel alloc] initWithFrame:ScaleFrame(154, 50, 95, 12)];
        limitlabel.text = @"可用额度(元)";
        limitlabel.textColor = RGB_COLOR(34,34,34);
        limitlabel.font = DeviceFont(12);
        [headView addSubview:limitlabel];

        //可用额度
        NSString *valdqtStr = Singleton.consumeInfoDict[@"validAmt"];
        if (valdqtStr.length==0) {
            valdqtStr = @"0.00";
        }

        valdqtStr = [CSIIFormatUitli splitByRmb:valdqtStr];

        //总额度 18201144749
        NSString *vchqutStr = Singleton.consumeInfoDict[@"limitAmt"];
        if (vchqutStr.length==0) {
            vchqutStr = @"0.00";
        }
        vchqutStr = [CSIIFormatUitli splitByRmb:vchqutStr];


        UILabel *limitMoneylabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 71, DeviceWidth, 19)];
        limitMoneylabel.text = valdqtStr;
        limitMoneylabel.textColor = RGB_COLOR(223,64,49);
        limitMoneylabel.textAlignment = NSTextAlignmentCenter;
        limitMoneylabel.font = DeviceFont(20);
        [headView addSubview:limitMoneylabel];

        UILabel *canUseMoneylabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 99, DeviceWidth, 12)];
        canUseMoneylabel.text = [NSString stringWithFormat:@"总额度：%@",vchqutStr];
        canUseMoneylabel.textColor = RGB_COLOR(153,153,153);
        canUseMoneylabel.textAlignment = NSTextAlignmentCenter;
        canUseMoneylabel.font = DeviceFont(12);
        [headView addSubview:canUseMoneylabel];

        UILabel *lineLabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 134, DeviceWidth, DeviceLineWidth)];
        lineLabel.backgroundColor = RGB_COLOR(236,236,236);
        lineLabel.alpha = 0.6;
        [headView addSubview:lineLabel];


        //如果是预授信调额待激活
        if ([Singleton.consumeInfoDict[@"activeInfo"][@"activeStatus"] isEqualToString:@"SQZT_TG"]) {
            //还款区
            NSString *payMoneyCount = Singleton.consumeInfoDict[@"payAmount"];
            if (payMoneyCount.length==0) {
                payMoneyCount = @"0.00";
            }

            payMoneyCount = [CSIIFormatUitli splitByRmb:payMoneyCount];


            UIView *payMoney = [[UIView alloc] initWithFrame:CGRectMake(0, 135*DeviceScaleX, ScreenWidth/2, 95*DeviceScaleX)];
            payMoney.userInteractionEnabled = YES;
            [cellView addSubview:payMoney];

            CSIILabelButton * payMoneyTitle = [[CSIILabelButton alloc] init];
            if ([payMoneyCount floatValue]>0.00) {
                [payMoneyTitle  setImage:JRBundeImage(@"需还款角标icon") frame:ScaleFrame(115, 145-136, 30, 10) forState:UIControlStateNormal];
            }

            [payMoneyTitle setLabel:@"还款" frame:ScaleFrame(79, 149-136, 35, 14)];
            payMoneyTitle.label.font = DeviceFont(15);
            payMoneyTitle.label.textColor = RGB_COLOR(34,34,34);
            [payMoney addSubview:payMoneyTitle];


            //本月待还
            UILabel *monthPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (172-136)*DeviceScaleX, ScreenWidth/2, 12*DeviceScaleX)];
            monthPayLabel.text = [NSString stringWithFormat:@"当期应还%@",payMoneyCount];

            monthPayLabel.textColor = RGB_COLOR(153,153,153);
            monthPayLabel.textAlignment = NSTextAlignmentCenter;
            monthPayLabel.numberOfLines = 0;
            monthPayLabel.font = DeviceFont(12);
            [payMoney addSubview:monthPayLabel];

            UIButton *payNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [payNowBtn setFrame:ScaleFrame(56, 193-136, 76, 26)];
            payNowBtn.layer.borderWidth = 1;
            payNowBtn.layer.cornerRadius = 3;
            payNowBtn.layer.masksToBounds = YES;
            payNowBtn.layer.borderColor = RGB_COLOR(38,150,196).CGColor;
            payNowBtn.titleLabel.font = DeviceFont(13);
            [payNowBtn setTitle:@"立即还款" forState:UIControlStateNormal];
            [payNowBtn setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
            [payNowBtn addTarget:self action:@selector(JRPayNowAction) forControlEvents:UIControlEventTouchUpInside];
            [payMoney addSubview:payNowBtn];




            UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:ScaleFrame(ScreenWidth/3-1, 112, DeviceLineWidth, 95*DeviceScaleX)];
            lineLabel1.backgroundColor = RGB_COLOR(236,236,236);
            lineLabel1.alpha = 0.6;
            [payMoney addSubview:lineLabel1];
/*

            //提额区
            UIView *raiseMoney = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/3, 135*DeviceScaleX, ScreenWidth/3, 95*DeviceScaleX)];
            [cellView addSubview:raiseMoney];
            CSIILabelButton * raiseMoneyTitle = [[CSIILabelButton alloc] init];

            NSString *raiseCornerLogoName=@"可提额角标icon";
            NSString *raiseLimitLabelText = @"最高可提额至50万";
            NSString *raiseApplyBtnText = @"申请提额";

            //提额申请进度
            NSString *raiseLimitStates = raiseState;
            //提额申请金额
            NSString *raiseLimitBusiAmt = Singleton.consumeInfoDict[@"raiseInfo"][@"raiseBusiAmt"];

            if ([raiseLimitStates isEqualToString:@""] ||
                raiseLimitStates == nil ||
                [raiseLimitStates isEqualToString:@"SQZT_NULL"]||
                [raiseLimitStates isEqualToString:@"SQZT_YGD"]){
                raiseCornerLogoName=@"可提额角标icon";
                raiseLimitLabelText = @"最高可提额至50万";
                raiseApplyBtnText = @"申请提额";
            }else if ([raiseLimitStates isEqualToString:@"SQZT_SPZ"]){
                raiseCornerLogoName=@"审批中角标icon";
                raiseLimitLabelText = @"最高可提额至50万";
                raiseApplyBtnText = @"补充资料";
            }else if ([raiseLimitStates isEqualToString:@"SQZT_TG"]){
                raiseCornerLogoName=@"待激活角标icon";

                raiseLimitLabelText = [NSString stringWithFormat:@"已审批提额%@",[CSIIFormatUitli splitByRmb:raiseLimitBusiAmt]];
                raiseApplyBtnText = @"激活提额";
            }else if ([raiseLimitStates isEqualToString:@"SQZT_JH"]){
                raiseCornerLogoName=@"可提额角标icon";
                raiseLimitLabelText = @"最高可提额至50万";
                raiseApplyBtnText = @"申请提额";
            }else if([raiseLimitStates isEqualToString:@"SQZT_JJ"] || [raiseLimitStates isEqualToString:@"SQZT_XTJJ"] || [raiseLimitStates isEqualToString:@"SQZT_TH"]){
                raiseCornerLogoName=@"失败角标icon";
                raiseLimitLabelText = @"提额申请失败";
                raiseApplyBtnText = @"重新申请";
            }

            [raiseMoneyTitle  setImage:JRBundeImage(raiseCornerLogoName) frame:ScaleFrame((ScreenWidth/3-35)/2+35, 145-136, 30, 10) forState:UIControlStateNormal];
            [raiseMoneyTitle setLabel:@"提额" frame:ScaleFrame((ScreenWidth/3-35)/2, 149-136, 35, 14)];
            raiseMoneyTitle.label.font = DeviceFont(15);
            raiseMoneyTitle.label.textColor = RGB_COLOR(34,34,34);
            [raiseMoney addSubview:raiseMoneyTitle];


            UILabel *raiseLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (172-136)*DeviceScaleX, ScreenWidth/3, 12*DeviceScaleX)];
            raiseLimitLabel.text = raiseLimitLabelText;
            raiseLimitLabel.textColor = RGB_COLOR(153,153,153);
            raiseLimitLabel.textAlignment = NSTextAlignmentCenter;
            raiseLimitLabel.numberOfLines = 0;
            raiseLimitLabel.font = DeviceFont(12);
            [raiseMoney addSubview:raiseLimitLabel];

            UIButton *raiseApplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [raiseApplyBtn setFrame:ScaleFrame((ScreenWidth/3-76)/2, 193-136, 76, 26)];
            raiseApplyBtn.layer.borderWidth = 1;
            raiseApplyBtn.layer.cornerRadius = 3;
            raiseApplyBtn.layer.masksToBounds = YES;
            raiseApplyBtn.layer.borderColor = RGB_COLOR(38,150,196).CGColor;
            raiseApplyBtn.titleLabel.font = DeviceFont(13);
            [raiseApplyBtn setTitle:raiseApplyBtnText forState:UIControlStateNormal];
            [raiseApplyBtn setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
            [raiseApplyBtn addTarget:self action:@selector(JRApplyRaiseAction:) forControlEvents:UIControlEventTouchUpInside];
            [raiseMoney addSubview:raiseApplyBtn];

            UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:ScaleFrame(ScreenWidth/3-1, 112, DeviceLineWidth, 95*DeviceScaleX)];
            lineLabel2.backgroundColor = RGB_COLOR(236,236,236);
            lineLabel2.alpha = 0.6;
            [raiseMoney addSubview:lineLabel2];
            */
            //调额区
            UIView *activeMoney = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 135*DeviceScaleX, ScreenWidth/2, 95*DeviceScaleX)];
            [cellView addSubview:activeMoney];
            CSIILabelButton * activeMoneyTitle = [[CSIILabelButton alloc] init];


            NSString *activeCornerLogoName=@"待激活角标icon";
            NSString *activeLimitLabelText = @"";
            NSString *activeApplyBtnText = @"激活调额";
            NSString *activeLimitBusiAmt = Singleton.consumeInfoDict[@"activeInfo"][@"activeLimit"];

            activeLimitLabelText = [NSString stringWithFormat:@"已审批调额%@",[CSIIFormatUitli splitByRmb:activeLimitBusiAmt]];

            [activeMoneyTitle  setImage:JRBundeImage(activeCornerLogoName) frame:ScaleFrame(115, 145-136, 30, 10) forState:UIControlStateNormal];
            [activeMoneyTitle setLabel:@"调额" frame:ScaleFrame(79, 149-136, 35, 14)];
            activeMoneyTitle.label.font = DeviceFont(15);
            activeMoneyTitle.label.textColor = RGB_COLOR(34,34,34);
            [activeMoney addSubview:activeMoneyTitle];


            UILabel *activeLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (172-136)*DeviceScaleX, ScreenWidth/2, 12*DeviceScaleX)];
            activeLimitLabel.text = activeLimitLabelText;
            activeLimitLabel.textColor = RGB_COLOR(153,153,153);
            activeLimitLabel.textAlignment = NSTextAlignmentCenter;
            activeLimitLabel.numberOfLines = 0;
            activeLimitLabel.font = DeviceFont(12);
            [activeMoney addSubview:activeLimitLabel];

            UIButton *activeApplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [activeApplyBtn setFrame:ScaleFrame(56, 193-136, 76, 26)];
            activeApplyBtn.layer.borderWidth = 1;
            activeApplyBtn.layer.cornerRadius = 3;
            activeApplyBtn.layer.masksToBounds = YES;
            activeApplyBtn.layer.borderColor = RGB_COLOR(38,150,196).CGColor;
            activeApplyBtn.titleLabel.font = DeviceFont(13);
            [activeApplyBtn setTitle:activeApplyBtnText forState:UIControlStateNormal];
            [activeApplyBtn setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
            [activeApplyBtn addTarget:self action:@selector(activeApplyBtn) forControlEvents:UIControlEventTouchUpInside];
            [activeMoney addSubview:activeApplyBtn];

        }
        else{
            //还款区
            NSString *payMoneyCount = Singleton.consumeInfoDict[@"payAmount"];
            if (payMoneyCount.length==0) {
                payMoneyCount = @"0.00";
            }

            payMoneyCount = [CSIIFormatUitli splitByRmb:payMoneyCount];


            UIView *payMoney = [[UIView alloc] initWithFrame:CGRectMake(0, 135*DeviceScaleX, ScreenWidth/2, 95*DeviceScaleX)];
            payMoney.userInteractionEnabled = YES;
            [cellView addSubview:payMoney];

            CSIILabelButton * payMoneyTitle = [[CSIILabelButton alloc] init];
            if ([payMoneyCount floatValue]>0.00) {
                [payMoneyTitle  setImage:JRBundeImage(@"需还款角标icon") frame:ScaleFrame(115, 145-136, 30, 10) forState:UIControlStateNormal];
            }

            [payMoneyTitle setLabel:@"还款" frame:ScaleFrame(79, 149-136, 35, 14)];
            payMoneyTitle.label.font = DeviceFont(15);
            payMoneyTitle.label.textColor = RGB_COLOR(34,34,34);
            [payMoney addSubview:payMoneyTitle];


            //本月待还
            UILabel *monthPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (172-136)*DeviceScaleX, ScreenWidth/2, 12*DeviceScaleX)];
            monthPayLabel.text = [NSString stringWithFormat:@"当期应还%@",payMoneyCount];

            monthPayLabel.textColor = RGB_COLOR(153,153,153);
            monthPayLabel.textAlignment = NSTextAlignmentCenter;
            monthPayLabel.numberOfLines = 0;
            monthPayLabel.font = DeviceFont(12);
            [payMoney addSubview:monthPayLabel];

            UIButton *payNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [payNowBtn setFrame:ScaleFrame(56, 193-136, 76, 26)];
            payNowBtn.layer.borderWidth = 1;
            payNowBtn.layer.cornerRadius = 3;
            payNowBtn.layer.masksToBounds = YES;
            payNowBtn.layer.borderColor = RGB_COLOR(38,150,196).CGColor;
            payNowBtn.titleLabel.font = DeviceFont(13);
            [payNowBtn setTitle:@"立即还款" forState:UIControlStateNormal];
            [payNowBtn setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
            [payNowBtn addTarget:self action:@selector(JRPayNowAction) forControlEvents:UIControlEventTouchUpInside];
            [payMoney addSubview:payNowBtn];




            UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:ScaleFrame(ScreenWidth/3-1, 112, DeviceLineWidth, 95*DeviceScaleX)];
            lineLabel1.backgroundColor = RGB_COLOR(236,236,236);
            lineLabel1.alpha = 0.6;
            [payMoney addSubview:lineLabel1];

            //提额区
            UIView *raiseMoney = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 135*DeviceScaleX, ScreenWidth/2, 95*DeviceScaleX)];

            [cellView addSubview:raiseMoney];
            CSIILabelButton * raiseMoneyTitle = [[CSIILabelButton alloc] init];

            NSString *raiseCornerLogoName=@"可提额角标icon";
            NSString *raiseLimitLabelText = @"最高可提额至50万";
            NSString *raiseApplyBtnText = @"申请提额";

            //提额申请进度
            NSString *raiseLimitStates = raiseState;
            //提额申请金额
            NSString *raiseLimitBusiAmt = Singleton.consumeInfoDict[@"raiseInfo"][@"raiseBusiAmt"];

            if ([raiseLimitStates isEqualToString:@""] ||
                raiseLimitStates == nil ||
                [raiseLimitStates isEqualToString:@"SQZT_NULL"]||
                [raiseLimitStates isEqualToString:@"SQZT_YGD"]){
                raiseCornerLogoName=@"可提额角标icon";
                raiseLimitLabelText = @"最高可提额至50万";
                raiseApplyBtnText = @"申请提额";
            }else if ([raiseLimitStates isEqualToString:@"SQZT_SPZ"]){
                raiseCornerLogoName=@"审批中角标icon";
                raiseLimitLabelText = @"最高可提额至50万";
                raiseApplyBtnText = @"补充资料";
            }else if ([raiseLimitStates isEqualToString:@"SQZT_TG"]){
                raiseCornerLogoName=@"待激活角标icon";

                raiseLimitLabelText = [NSString stringWithFormat:@"已审批提额%@",[CSIIFormatUitli splitByRmb:raiseLimitBusiAmt]];
                raiseApplyBtnText = @"激活提额";
            }else if ([raiseLimitStates isEqualToString:@"SQZT_JH"]){
                raiseCornerLogoName=@"可提额角标icon";
                raiseLimitLabelText = @"最高可提额至50万";
                raiseApplyBtnText = @"申请提额";
            }else if([raiseLimitStates isEqualToString:@"SQZT_JJ"] || [raiseLimitStates isEqualToString:@"SQZT_XTJJ"] || [raiseLimitStates isEqualToString:@"SQZT_TH"]){
                raiseCornerLogoName=@"失败角标icon";
                raiseLimitLabelText = @"提额申请失败";
                raiseApplyBtnText = @"重新申请";
            }

            [raiseMoneyTitle  setImage:JRBundeImage(raiseCornerLogoName) frame:ScaleFrame(115, 145-136, 30, 10) forState:UIControlStateNormal];
            [raiseMoneyTitle setLabel:@"提额" frame:ScaleFrame(79, 149-136, 35, 14)];
            raiseMoneyTitle.label.font = DeviceFont(15);
            raiseMoneyTitle.label.textColor = RGB_COLOR(34,34,34);
            [raiseMoney addSubview:raiseMoneyTitle];


            UILabel *raiseLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (172-136)*DeviceScaleX, ScreenWidth/2, 12*DeviceScaleX)];
            raiseLimitLabel.text = raiseLimitLabelText;
            raiseLimitLabel.textColor = RGB_COLOR(153,153,153);
            raiseLimitLabel.textAlignment = NSTextAlignmentCenter;
            raiseLimitLabel.numberOfLines = 0;
            raiseLimitLabel.font = DeviceFont(12);
            [raiseMoney addSubview:raiseLimitLabel];

            UIButton *raiseApplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [raiseApplyBtn setFrame:ScaleFrame(56, 193-136, 76, 26)];
            raiseApplyBtn.layer.borderWidth = 1;
            raiseApplyBtn.layer.cornerRadius = 3;
            raiseApplyBtn.layer.masksToBounds = YES;
            raiseApplyBtn.layer.borderColor = RGB_COLOR(38,150,196).CGColor;
            raiseApplyBtn.titleLabel.font = DeviceFont(13);
            [raiseApplyBtn setTitle:raiseApplyBtnText forState:UIControlStateNormal];
            [raiseApplyBtn setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
            [raiseApplyBtn addTarget:self action:@selector(JRApplyRaiseAction:) forControlEvents:UIControlEventTouchUpInside];
            [raiseMoney addSubview:raiseApplyBtn];

        }

        return cellView;
    }

    //未申请
    if (([state isEqualToString:@""] || [state isEqualToString:@"SQZT_NULL"] || consumeState == nil)
        || [state isEqualToString:@"SQZT_SQ"]  || [state isEqualToString:@"SQZT_YGD"]) {
        CSIILabelButton * openStagePay = [[CSIILabelButton alloc] init];
        [openStagePay  setImage:JRBundeImage(@"开通箭头icon") frame:SectionThreeRightLogoFrame forState:UIControlStateNormal];
        [openStagePay setLabel:@"我要开通" frame:SectionThreeRightTitleFrame];
        openStagePay.label.font = DeviceFont(16);
        openStagePay.label.textColor = RGB_COLOR(38,150,196);
        [cellView addSubview:openStagePay];


        UILabel *moneylabel = [[UILabel alloc] initWithFrame:SectionThreeDownlimitMoneyFrame];
        moneylabel.text = @"50万";
        moneylabel.textColor = RGB_COLOR(223,64,49);
        moneylabel.font = DeviceFont(20);
                NSMutableAttributedString *footerTextAttributedStr = [self formatSomeCharacter:moneylabel.text];
                moneylabel.attributedText = footerTextAttributedStr;
        [cellView addSubview:moneylabel];


        UILabel *lineLabel = [[UILabel alloc] initWithFrame:ScaleFrame(117, 60, DeviceLineWidth, 50)];
        lineLabel.backgroundColor = RGB_COLOR(236,236,236);
        lineLabel.alpha = 0.6;
        [cellView addSubview:lineLabel];


        UILabel *bigLimitlabel = [[UILabel alloc] initWithFrame:SectionThreeDownlimitMoneyTipFrame];
        bigLimitlabel.text = @"最高额度";
        bigLimitlabel.textColor = RGB_COLOR(153,153,153);
        bigLimitlabel.font = DeviceFont(12);
        [cellView addSubview:bigLimitlabel];


        UILabel *descriptionlabel = [[UILabel alloc] initWithFrame:SectionThreeDownDescriptionFrame];
        descriptionlabel.text = @"装房子、买家具、用居然分期付";
        descriptionlabel.textColor = RGB_COLOR(51,51,51);
        descriptionlabel.font = DeviceFont(14);
        [cellView addSubview:descriptionlabel];


        UIButton *openUseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [openUseBtn setFrame:SectionThreeDownOpenUseFrame];
        [openUseBtn setBackgroundColor:[UIColor whiteColor]];
        openUseBtn.layer.borderColor = RGB_COLOR(38,150,196).CGColor;
        openUseBtn.layer.borderWidth = 1;
        openUseBtn.layer.cornerRadius = 3;
        openUseBtn.layer.masksToBounds = YES;
        openUseBtn.titleLabel.font = DeviceFont(12);
        [openUseBtn setTitle:@"开通即用" forState:UIControlStateNormal];
        [openUseBtn setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
        [openUseBtn addTarget:self action:@selector(openStagePay) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:openUseBtn];



        UIButton *flexibleEasyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [flexibleEasyBtn setFrame:SectionThreeDownFlexibleEasyFrame];
        [flexibleEasyBtn setBackgroundColor:[UIColor whiteColor]];
        flexibleEasyBtn.layer.masksToBounds = YES;
        flexibleEasyBtn.titleLabel.font = DeviceFont(12);
        [flexibleEasyBtn setTitle:@"灵活方便" forState:UIControlStateNormal];
        [flexibleEasyBtn setTitleColor:RGB_COLOR(102,102,102) forState:UIControlStateNormal];
        [flexibleEasyBtn addTarget:self action:@selector(openStagePay) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:flexibleEasyBtn];


        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openStagePay)];
        [cellView addGestureRecognizer:tap];
    }
    //审批中
    else if ([occurType isEqualToString:@"FSLX_00"] && [state isEqualToString:@"SQZT_SPZ"] ) {
        cellView.frame = ScaleFrame(0, 0, DeviceWidth, 154);
        CSIILabelButton * rightUploadTip = [[CSIILabelButton alloc] init];
        [rightUploadTip  setImage:JRBundeImage(@"箭头icon") frame:ScaleFrame(353, 17, 6, 11) forState:UIControlStateNormal];
        [rightUploadTip setLabel:@"补资料" frame:ScaleFrame(310, 16, 45, 13)];
        rightUploadTip.label.font = DeviceFont(13);
        rightUploadTip.label.textColor = RGB_COLOR(153,153,153);
        [rightUploadTip addTarget:self action:@selector(openStagePay) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:rightUploadTip];

        UILabel *limitlabel = [[UILabel alloc] initWithFrame:ScaleFrame(154, 50, 95, 12)];
        limitlabel.text = @"申请额度(元)";
        limitlabel.textColor = RGB_COLOR(34,34,34);
        limitlabel.font = DeviceFont(12);
        [cellView addSubview:limitlabel];

        //总额度
        NSString *vchqutStr = Singleton.consumeInfoDict[@"applyInfo"][@"applyLimit"];
        if (vchqutStr.length==0) {
            vchqutStr = @"0.00";
        }
        vchqutStr = [CSIIFormatUitli splitByRmb:vchqutStr];

        UILabel *limitMoneylabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 71, DeviceWidth, 19)];
        limitMoneylabel.text = vchqutStr;
        limitMoneylabel.textColor = RGB_COLOR(34,34,34);
        limitMoneylabel.font = DeviceFont(20);
        limitMoneylabel.textAlignment = NSTextAlignmentCenter;
        [cellView addSubview:limitMoneylabel];

        UILabel *lineLabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 112, DeviceWidth, DeviceLineWidth)];
        lineLabel.backgroundColor = RGB_COLOR(236,236,236);
        lineLabel.alpha = 0.6;
        [cellView addSubview:lineLabel];

        CSIILabelButton * uploadFile = [[CSIILabelButton alloc] init];
        [uploadFile  setImage:JRBundeImage(@"开通箭头icon") frame:ScaleFrame(216, 128, 10, 10) forState:UIControlStateNormal];
        [uploadFile setLabel:@"补充资料" frame:ScaleFrame(154, 125, 65, 14)];
        uploadFile.label.font = DeviceFont(15);
        uploadFile.label.textColor = RGB_COLOR(38,150,196);
        [cellView addSubview:uploadFile];


        UIImageView *stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-47*DeviceScaleX, 65, 51*DeviceScaleX, 47*DeviceScaleX)];
        stateImageView.image = JRBundeImage(@"审批中印章icon");
        [cellView addSubview:stateImageView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadFile)];
        [cellView addGestureRecognizer:tap];
    }
    //审核通过
    else if ([occurType isEqualToString:@"FSLX_00"] && [state isEqualToString:@"SQZT_TG"] ) {
        cellView.frame = ScaleFrame(0, 0, DeviceWidth, 154);
        CSIILabelButton * activeBtn = [[CSIILabelButton alloc] init];
        [activeBtn  setImage:JRBundeImage(@"箭头icon") frame:ScaleFrame(353, 17, 6, 11) forState:UIControlStateNormal];
        [activeBtn setLabel:@"激活" frame:ScaleFrame(325, 16, 35, 13)];
        activeBtn.label.font = DeviceFont(13);
        activeBtn.label.textColor = RGB_COLOR(153,153,153);
        [activeBtn addTarget:self action:@selector(activeClick) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:activeBtn];

        UILabel *limitlabel = [[UILabel alloc] initWithFrame:ScaleFrame(154, 50, 95, 12)];
        limitlabel.text = @"已审批额度(元)";
        limitlabel.textColor = RGB_COLOR(34,34,34);
        limitlabel.font = DeviceFont(12);
        [cellView addSubview:limitlabel];


        //总额度
        NSString *vchqutStr = Singleton.consumeInfoDict[@"applyInfo"][@"applyLimit"];
        if (vchqutStr.length==0) {
            vchqutStr = @"0.00";
        }
        vchqutStr = [CSIIFormatUitli splitByRmb:vchqutStr];


        UILabel *limitMoneylabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 71, DeviceWidth, 19)];
        limitMoneylabel.text = vchqutStr;
        limitMoneylabel.textColor = RGB_COLOR(223,64,49);
        limitMoneylabel.font = DeviceFont(20);
        limitMoneylabel.textAlignment = NSTextAlignmentCenter;
        [cellView addSubview:limitMoneylabel];

        UILabel *lineLabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 112, DeviceWidth, DeviceLineWidth)];
        lineLabel.backgroundColor = RGB_COLOR(236,236,236);
        lineLabel.alpha = 0.6;
        [cellView addSubview:lineLabel];

        CSIILabelButton * activatFile = [[CSIILabelButton alloc] init];
        [activatFile  setImage:JRBundeImage(@"开通箭头icon") frame:ScaleFrame(216, 128, 10, 10) forState:UIControlStateNormal];
        [activatFile setLabel:@"马上激活" frame:ScaleFrame(154, 125, 65, 14)];
        activatFile.label.font = DeviceFont(15);
        activatFile.label.textColor = RGB_COLOR(38,150,196);
        [cellView addSubview:activatFile];


        UIImageView *stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-47*DeviceScaleX, 65, 51*DeviceScaleX, 47*DeviceScaleX)];
        stateImageView.image = JRBundeImage(@"待激活印章icon");
        [cellView addSubview:stateImageView];


        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activeClick)];
        [cellView addGestureRecognizer:tap];

    }
    //审核拒绝
    else if ([occurType isEqualToString:@"FSLX_00"] && ([state isEqualToString:@"SQZT_JJ"] || [state isEqualToString:@"SQZT_XTJJ"] || [state isEqualToString:@"SQZT_TH"]) ) {

        cellView.frame = ScaleFrame(0, 0, DeviceWidth, 154);

        CSIILabelButton * activeBtn = [[CSIILabelButton alloc] init];
        [activeBtn  setImage:JRBundeImage(@"箭头icon") frame:ScaleFrame(353, 17, 6, 11) forState:UIControlStateNormal];
        [activeBtn setLabel:@"重新申请" frame:ScaleFrame(297, 16, 55, 13)];
        activeBtn.label.font = DeviceFont(13);
        activeBtn.label.textColor = RGB_COLOR(153,153,153);
        [activeBtn addTarget:self action:@selector(activeClick) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:activeBtn];

        UILabel *limitlabel = [[UILabel alloc] initWithFrame:ScaleFrame(154, 51, 95, 12)];
        limitlabel.text = @"申请失败!";
        limitlabel.textColor = RGB_COLOR(223,64,49);
        limitlabel.font = DeviceFont(14);
        [cellView addSubview:limitlabel];


        UILabel *limitMoneylabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 75, DeviceWidth, 19)];
        limitMoneylabel.text = @"您填写的信息不属实，请重新填写";
        limitMoneylabel.textColor = RGB_COLOR(122,123,135);
        limitMoneylabel.font = DeviceFont(12);
        limitMoneylabel.textAlignment = NSTextAlignmentCenter;
        [cellView addSubview:limitMoneylabel];

        UILabel *lineLabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 112, DeviceWidth, DeviceLineWidth)];
        lineLabel.backgroundColor = RGB_COLOR(236,236,236);
        lineLabel.alpha = 0.6;
        [cellView addSubview:lineLabel];

        CSIILabelButton * activatFile = [[CSIILabelButton alloc] init];
        [activatFile  setImage:JRBundeImage(@"开通箭头icon") frame:ScaleFrame(216, 128, 10, 10) forState:UIControlStateNormal];
        [activatFile setLabel:@"重新申请" frame:ScaleFrame(154, 125, 65, 14)];
        activatFile.label.font = DeviceFont(15);
        activatFile.label.textColor = RGB_COLOR(38,150,196);
        [cellView addSubview:activatFile];


        UIImageView *stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-47*DeviceScaleX, 65, 51*DeviceScaleX, 47*DeviceScaleX)];
        stateImageView.image = JRBundeImage(@"审批失败-印章icon");
        [cellView addSubview:stateImageView];


        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openStagePay)];
        [cellView addGestureRecognizer:tap];
    }
    //新发生已激活 或者提额
    else if ([state isEqualToString:@"SQZT_JH"] ||
             [occurType isEqualToString:@"FSLX_01"]) {
        cellView.frame = ScaleFrame(0, 0, DeviceWidth, 230);

        UIView *headView = [[UIView alloc] initWithFrame:ScaleFrame(0, 0, DeviceWidth, 135)];
        [cellView addSubview:headView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailClick)];
        [headView addGestureRecognizer:tap];

        CSIILabelButton * openStagePay = [[CSIILabelButton alloc] init];
        [openStagePay setLabel:[NSString stringWithFormat:@"有效期至：%@",Singleton.consumeInfoDict[@"endDate"]] frame:ScaleFrame(DeviceWidth-171, 17, 160, 11)];
        openStagePay.label.font = DeviceFont(11);
        openStagePay.label.textColor = RGB_COLOR(153,153,153);
        openStagePay.label.textAlignment = NSTextAlignmentRight;
        [openStagePay addTarget:self action:@selector(openStagePay) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:openStagePay];

        UILabel *limitlabel = [[UILabel alloc] initWithFrame:ScaleFrame(154, 50, 95, 12)];
        limitlabel.text = @"可用额度(元)";
        limitlabel.textColor = RGB_COLOR(34,34,34);
        limitlabel.font = DeviceFont(12);
        [headView addSubview:limitlabel];

        //可用额度
        NSString *valdqtStr = Singleton.consumeInfoDict[@"validAmt"];
        if (valdqtStr.length==0) {
            valdqtStr = @"0.00";
        }

        valdqtStr = [CSIIFormatUitli splitByRmb:valdqtStr];

        //总额度 18201144749
        NSString *vchqutStr = Singleton.consumeInfoDict[@"limitAmt"];
        if (vchqutStr.length==0) {
            vchqutStr = @"0.00";
        }
        vchqutStr = [CSIIFormatUitli splitByRmb:vchqutStr];


        UILabel *limitMoneylabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 71, DeviceWidth, 19)];
        limitMoneylabel.text = valdqtStr;
        limitMoneylabel.textColor = RGB_COLOR(223,64,49);
        limitMoneylabel.textAlignment = NSTextAlignmentCenter;
        limitMoneylabel.font = DeviceFont(20);
        [headView addSubview:limitMoneylabel];

        UILabel *canUseMoneylabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 99, DeviceWidth, 12)];
        canUseMoneylabel.text = [NSString stringWithFormat:@"总额度：%@",vchqutStr];
        canUseMoneylabel.textColor = RGB_COLOR(153,153,153);
        canUseMoneylabel.textAlignment = NSTextAlignmentCenter;
        canUseMoneylabel.font = DeviceFont(12);
        [headView addSubview:canUseMoneylabel];

        UILabel *lineLabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 134, DeviceWidth, DeviceLineWidth)];
        lineLabel.backgroundColor = RGB_COLOR(236,236,236);
        lineLabel.alpha = 0.6;
        [headView addSubview:lineLabel];
        
//        UITapGestureRecognizer *tapHeadView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(JRPayNowAction)];
//        [headView addGestureRecognizer:tapHeadView];

        //如果是预授信调额待激活
        if ([Singleton.consumeInfoDict[@"activeInfo"][@"activeStatus"] isEqualToString:@"SQZT_TG"]) {
            //还款区
            NSString *payMoneyCount = Singleton.consumeInfoDict[@"payAmount"];
            if (payMoneyCount.length==0) {
                payMoneyCount = @"0.00";
            }

            payMoneyCount = [CSIIFormatUitli splitByRmb:payMoneyCount];


            UIView *payMoney = [[UIView alloc] initWithFrame:CGRectMake(0, 135*DeviceScaleX, ScreenWidth/2, 95*DeviceScaleX)];
            payMoney.userInteractionEnabled = YES;
            [cellView addSubview:payMoney];

            CSIILabelButton * payMoneyTitle = [[CSIILabelButton alloc] init];
            if ([payMoneyCount floatValue]>0.00) {
                [payMoneyTitle  setImage:JRBundeImage(@"需还款角标icon") frame:ScaleFrame(115, 145-136, 30, 10) forState:UIControlStateNormal];
            }

            [payMoneyTitle setLabel:@"还款" frame:ScaleFrame(79, 149-136, 35, 14)];
            payMoneyTitle.label.font = DeviceFont(15);
            payMoneyTitle.label.textColor = RGB_COLOR(34,34,34);
            [payMoney addSubview:payMoneyTitle];


            //本月待还
            UILabel *monthPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (172-136)*DeviceScaleX, ScreenWidth/2, 12*DeviceScaleX)];
            monthPayLabel.text = [NSString stringWithFormat:@"当期应还%@",payMoneyCount];

            monthPayLabel.textColor = RGB_COLOR(153,153,153);
            monthPayLabel.textAlignment = NSTextAlignmentCenter;
            monthPayLabel.numberOfLines = 0;
            monthPayLabel.font = DeviceFont(12);
            [payMoney addSubview:monthPayLabel];

            UIButton *payNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [payNowBtn setFrame:ScaleFrame(56, 193-136, 76, 26)];
            payNowBtn.layer.borderWidth = 1;
            payNowBtn.layer.cornerRadius = 3;
            payNowBtn.layer.masksToBounds = YES;
            payNowBtn.layer.borderColor = RGB_COLOR(38,150,196).CGColor;
            payNowBtn.titleLabel.font = DeviceFont(13);
            [payNowBtn setTitle:@"立即还款" forState:UIControlStateNormal];
            [payNowBtn setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
            [payNowBtn addTarget:self action:@selector(JRPayNowAction) forControlEvents:UIControlEventTouchUpInside];
            [payMoney addSubview:payNowBtn];




            UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:ScaleFrame(ScreenWidth/3-1, 112, DeviceLineWidth, 95*DeviceScaleX)];
            lineLabel1.backgroundColor = RGB_COLOR(236,236,236);
            lineLabel1.alpha = 0.6;
            [payMoney addSubview:lineLabel1];
/*
            //提额区
            UIView *raiseMoney = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/3, 135*DeviceScaleX, ScreenWidth/3, 95*DeviceScaleX)];
            [cellView addSubview:raiseMoney];
            CSIILabelButton * raiseMoneyTitle = [[CSIILabelButton alloc] init];

            NSString *raiseCornerLogoName=@"可提额角标icon";
            NSString *raiseLimitLabelText = @"最高可提额至50万";
            NSString *raiseApplyBtnText = @"申请提额";

            //提额申请进度
            NSString *raiseLimitStates = raiseState;
            //提额申请金额
            NSString *raiseLimitBusiAmt = Singleton.consumeInfoDict[@"raiseInfo"][@"raiseBusiAmt"];

            if ([raiseLimitStates isEqualToString:@""] ||
                raiseLimitStates == nil ||
                [raiseLimitStates isEqualToString:@"SQZT_NULL"]||
                [raiseLimitStates isEqualToString:@"SQZT_YGD"]){
                raiseCornerLogoName=@"可提额角标icon";
                raiseLimitLabelText = @"最高可提额至50万";
                raiseApplyBtnText = @"申请提额";
            }else if ([raiseLimitStates isEqualToString:@"SQZT_SPZ"]){
                raiseCornerLogoName=@"审批中角标icon";
                raiseLimitLabelText = @"最高可提额至50万";
                raiseApplyBtnText = @"补充资料";
            }else if ([raiseLimitStates isEqualToString:@"SQZT_TG"]){
                raiseCornerLogoName=@"待激活角标icon";
                raiseLimitLabelText = [NSString stringWithFormat:@"已审批提额%@",[CSIIFormatUitli splitByRmb:raiseLimitBusiAmt]];
                raiseApplyBtnText = @"激活提额";
            }else if ([raiseLimitStates isEqualToString:@"SQZT_JH"]){
                raiseCornerLogoName=@"可提额角标icon";
                raiseLimitLabelText = @"最高可提额至50万";
                raiseApplyBtnText = @"申请提额";
            }else if([raiseLimitStates isEqualToString:@"SQZT_JJ"] || [raiseLimitStates isEqualToString:@"SQZT_XTJJ"] || [raiseLimitStates isEqualToString:@"SQZT_TH"]){
                raiseCornerLogoName=@"失败角标icon";
                raiseLimitLabelText = @"提额申请失败";
                raiseApplyBtnText = @"重新申请";
            }

            [raiseMoneyTitle  setImage:JRBundeImage(raiseCornerLogoName) frame:ScaleFrame((ScreenWidth/3-35)/2+35, 145-136, 30, 10) forState:UIControlStateNormal];
            [raiseMoneyTitle setLabel:@"提额" frame:ScaleFrame((ScreenWidth/3-35)/2, 149-136, 35, 14)];
            raiseMoneyTitle.label.font = DeviceFont(15);
            raiseMoneyTitle.label.textColor = RGB_COLOR(34,34,34);
            [raiseMoney addSubview:raiseMoneyTitle];


            UILabel *raiseLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (172-136)*DeviceScaleX, ScreenWidth/3, 12*DeviceScaleX)];
            raiseLimitLabel.text = raiseLimitLabelText;
            raiseLimitLabel.textColor = RGB_COLOR(153,153,153);
            raiseLimitLabel.textAlignment = NSTextAlignmentCenter;
            raiseLimitLabel.numberOfLines = 0;
            raiseLimitLabel.font = DeviceFont(12);
            [raiseMoney addSubview:raiseLimitLabel];

            UIButton *raiseApplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [raiseApplyBtn setFrame:ScaleFrame((ScreenWidth/3-76)/2, 193-136, 76, 26)];
            raiseApplyBtn.layer.borderWidth = 1;
            raiseApplyBtn.layer.cornerRadius = 3;
            raiseApplyBtn.layer.masksToBounds = YES;
            raiseApplyBtn.layer.borderColor = RGB_COLOR(38,150,196).CGColor;
            raiseApplyBtn.titleLabel.font = DeviceFont(13);
            [raiseApplyBtn setTitle:raiseApplyBtnText forState:UIControlStateNormal];
            [raiseApplyBtn setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
            [raiseApplyBtn addTarget:self action:@selector(JRApplyRaiseAction:) forControlEvents:UIControlEventTouchUpInside];
            [raiseMoney addSubview:raiseApplyBtn];


            UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:ScaleFrame(ScreenWidth/3-1, 112, DeviceLineWidth, 95*DeviceScaleX)];
            lineLabel2.backgroundColor = RGB_COLOR(236,236,236);
            lineLabel2.alpha = 0.6;
            [raiseMoney addSubview:lineLabel2];
*/
            //调额区
            UIView *activeMoney = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 135*DeviceScaleX, ScreenWidth/2, 95*DeviceScaleX)];
            [cellView addSubview:activeMoney];
            CSIILabelButton * activeMoneyTitle = [[CSIILabelButton alloc] init];


            NSString *activeCornerLogoName=@"待激活角标icon";
            NSString *activeLimitLabelText = @"";
            NSString *activeApplyBtnText = @"激活调额";
            NSString *activeLimitBusiAmt = Singleton.consumeInfoDict[@"activeInfo"][@"activeLimit"];

            activeLimitLabelText = [NSString stringWithFormat:@"已审批调额%@",[CSIIFormatUitli splitByRmb:activeLimitBusiAmt]];

            [activeMoneyTitle  setImage:JRBundeImage(activeCornerLogoName) frame:ScaleFrame(115, 145-136, 30, 10) forState:UIControlStateNormal];
            [activeMoneyTitle setLabel:@"调额" frame:ScaleFrame(79, 149-136, 35, 14)];
            activeMoneyTitle.label.font = DeviceFont(15);
            activeMoneyTitle.label.textColor = RGB_COLOR(34,34,34);
            [activeMoney addSubview:activeMoneyTitle];


            UILabel *activeLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (172-136)*DeviceScaleX, ScreenWidth/2, 12*DeviceScaleX)];
            activeLimitLabel.text = activeLimitLabelText;
            activeLimitLabel.textColor = RGB_COLOR(153,153,153);
            activeLimitLabel.textAlignment = NSTextAlignmentCenter;
            activeLimitLabel.numberOfLines = 0;
            activeLimitLabel.font = DeviceFont(12);
            [activeMoney addSubview:activeLimitLabel];

            UIButton *activeApplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [activeApplyBtn setFrame:ScaleFrame(56, 193-136, 76, 26)];
            activeApplyBtn.layer.borderWidth = 1;
            activeApplyBtn.layer.cornerRadius = 3;
            activeApplyBtn.layer.masksToBounds = YES;
            activeApplyBtn.layer.borderColor = RGB_COLOR(38,150,196).CGColor;
            activeApplyBtn.titleLabel.font = DeviceFont(13);
            [activeApplyBtn setTitle:activeApplyBtnText forState:UIControlStateNormal];
            [activeApplyBtn setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
            [activeApplyBtn addTarget:self action:@selector(activeApplyBtn) forControlEvents:UIControlEventTouchUpInside];
            [activeMoney addSubview:activeApplyBtn];
        }else{
            //还款区
            NSString *payMoneyCount = Singleton.consumeInfoDict[@"payAmount"];
            if (payMoneyCount.length==0) {
                payMoneyCount = @"0.00";
            }
            payMoneyCount = [CSIIFormatUitli splitByRmb:payMoneyCount];


            UIView *payMoney = [[UIView alloc] initWithFrame:CGRectMake(0, 135*DeviceScaleX, ScreenWidth/2, 95*DeviceScaleX)];
            [cellView addSubview:payMoney];

            CSIILabelButton * payMoneyTitle = [[CSIILabelButton alloc] init];
            if ([payMoneyCount floatValue]>0.00) {
                [payMoneyTitle  setImage:JRBundeImage(@"需还款角标icon") frame:ScaleFrame(115, 145-136, 30, 10) forState:UIControlStateNormal];
            }

            [payMoneyTitle setLabel:@"还款" frame:ScaleFrame(79, 149-136, 35, 14)];
            payMoneyTitle.label.font = DeviceFont(15);
            payMoneyTitle.label.textColor = RGB_COLOR(34,34,34);
            [payMoney addSubview:payMoneyTitle];


            //本月待还
            UILabel *monthPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (172-136)*DeviceScaleX, ScreenWidth/2, 12*DeviceScaleX)];
            monthPayLabel.text = [NSString stringWithFormat:@"当期应还%@",payMoneyCount];

            monthPayLabel.textColor = RGB_COLOR(153,153,153);
            monthPayLabel.textAlignment = NSTextAlignmentCenter;
            monthPayLabel.numberOfLines = 0;
            monthPayLabel.font = DeviceFont(12);
            [payMoney addSubview:monthPayLabel];

            UIButton *payNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [payNowBtn setFrame:ScaleFrame(56, 193-136, 76, 26)];
            payNowBtn.layer.borderWidth = 1;
            payNowBtn.layer.cornerRadius = 3;
            payNowBtn.layer.masksToBounds = YES;
            payNowBtn.layer.borderColor = RGB_COLOR(38,150,196).CGColor;
            payNowBtn.titleLabel.font = DeviceFont(13);
            [payNowBtn setTitle:@"立即还款" forState:UIControlStateNormal];
            [payNowBtn setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
            [payNowBtn addTarget:self action:@selector(JRPayNowAction) forControlEvents:UIControlEventTouchUpInside];
            [payMoney addSubview:payNowBtn];



            UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:ScaleFrame(ScreenWidth/3-1, 112, DeviceLineWidth, 95*DeviceScaleX)];
            lineLabel1.backgroundColor = RGB_COLOR(236,236,236);
            lineLabel1.alpha = 0.6;
            [payMoney addSubview:lineLabel1];

            //提额区
            UIView *raiseMoney = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 135*DeviceScaleX, ScreenWidth/2, 95*DeviceScaleX)];
            [cellView addSubview:raiseMoney];
            CSIILabelButton * raiseMoneyTitle = [[CSIILabelButton alloc] init];

            NSString *raiseCornerLogoName=@"可提额角标icon";
            NSString *raiseLimitLabelText = @"最高可提额至50万";
            NSString *raiseApplyBtnText = @"申请提额";

            //提额申请进度
            NSString *raiseLimitStates = raiseState;
            //提额申请金额
            NSString *raiseLimitBusiAmt = Singleton.consumeInfoDict[@"raiseInfo"][@"raiseBusiAmt"];

            if ([raiseLimitStates isEqualToString:@""] ||
                raiseLimitStates == nil ||
                [raiseLimitStates isEqualToString:@"SQZT_NULL"]||
                [raiseLimitStates isEqualToString:@"SQZT_YGD"]){
                raiseCornerLogoName=@"可提额角标icon";
                raiseLimitLabelText = @"最高可提额至50万";
                raiseApplyBtnText = @"申请提额";
            }else if ([raiseLimitStates isEqualToString:@"SQZT_SPZ"]){
                raiseCornerLogoName=@"审批中角标icon";
                raiseLimitLabelText = @"最高可提额至50万";
                raiseApplyBtnText = @"补充资料";
            }else if ([raiseLimitStates isEqualToString:@"SQZT_TG"]){
                raiseCornerLogoName=@"待激活角标icon";
                NSString *raisedMoneyText = [CSIIFormatUitli splitByRmb:raiseLimitBusiAmt];
                raiseLimitLabelText = [NSString stringWithFormat:@"已审批提额%@",raisedMoneyText];

                raiseApplyBtnText = @"激活提额";
            }else if ([raiseLimitStates isEqualToString:@"SQZT_JH"]){
                raiseCornerLogoName=@"可提额角标icon";
                raiseLimitLabelText = @"最高可提额至50万";
                raiseApplyBtnText = @"申请提额";
            }else if([raiseLimitStates isEqualToString:@"SQZT_JJ"] || [raiseLimitStates isEqualToString:@"SQZT_XTJJ"] || [raiseLimitStates isEqualToString:@"SQZT_TH"]){
                raiseCornerLogoName=@"失败角标icon";
                raiseLimitLabelText = @"提额申请失败";
                raiseApplyBtnText = @"重新申请";
            }

            [raiseMoneyTitle  setImage:JRBundeImage(raiseCornerLogoName) frame:ScaleFrame(115, 145-136, 30, 10) forState:UIControlStateNormal];
            [raiseMoneyTitle setLabel:@"提额" frame:ScaleFrame(79, 149-136, 35, 14)];
            raiseMoneyTitle.label.font = DeviceFont(15);
            raiseMoneyTitle.label.textColor = RGB_COLOR(34,34,34);
            [raiseMoney addSubview:raiseMoneyTitle];


            UILabel *raiseLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (172-136)*DeviceScaleX, ScreenWidth/2, 12*DeviceScaleX)];
            raiseLimitLabel.text = raiseLimitLabelText;
            raiseLimitLabel.textColor = RGB_COLOR(153,153,153);
            raiseLimitLabel.textAlignment = NSTextAlignmentCenter;
            raiseLimitLabel.numberOfLines = 0;
            raiseLimitLabel.font = DeviceFont(12);
            [raiseMoney addSubview:raiseLimitLabel];

            UIButton *raiseApplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [raiseApplyBtn setFrame:ScaleFrame(56, 193-136, 76, 26)];
            raiseApplyBtn.layer.borderWidth = 1;
            raiseApplyBtn.layer.cornerRadius = 3;
            raiseApplyBtn.layer.masksToBounds = YES;
            raiseApplyBtn.layer.borderColor = RGB_COLOR(38,150,196).CGColor;
            raiseApplyBtn.titleLabel.font = DeviceFont(13);
            [raiseApplyBtn setTitle:raiseApplyBtnText forState:UIControlStateNormal];
            [raiseApplyBtn setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
            [raiseApplyBtn addTarget:self action:@selector(JRApplyRaiseAction:) forControlEvents:UIControlEventTouchUpInside];
            [raiseMoney addSubview:raiseApplyBtn];
        }
    }

    return cellView;
}

//补充资料
- (void)uploadFile{
    DebugLog(@"补充资料");
    NSMutableDictionary *dict =  [NSMutableDictionary dictionary];

    if (Singleton.consumeInfoDict[@"applyInfo"]>0) {
        [dict setObject:Singleton.consumeInfoDict[@"applyNo"] forKey:@"applyNo"];
    }

    [JRJumpClientToVx jumpWithZipID:Consume_upload controller:Singleton.rootViewController params:dict];
}

//去激活
- (void)activeClick{
    DebugLog(@"去激活");
    [JRJumpClientToVx jumpWithZipID:Consume_active controller:Singleton.rootViewController];
}

- (void)activeApplyBtn{
    DebugLog(@"调额去激活");
    [JRJumpClientToVx jumpWithZipID:Consume_active controller:Singleton.rootViewController];
}

//立即还款
- (void)JRPayNowAction{

    if([Singleton.consumeInfoDict[@"isConsume"] isEqualToString:@"N"]){
        alertView(@"您还没有使用过消费贷!");
        return;
    }

    DebugLog(@"立即还款");
    [JRJumpClientToVx jumpWithZipID:Consume_repay controller:Singleton.rootViewController];

}

//申请提额
- (void)JRApplyRaiseAction:(UIButton *)sender{
    DebugLog(@"申请提额");

    if ([sender.titleLabel.text isEqualToString:@"申请提额"] ||
        [sender.titleLabel.text isEqualToString:@"重新申请"]) {
        [self checkRaiseType];

    }else if ([sender.titleLabel.text isEqualToString:@"补充资料"]) {

        NSMutableDictionary *dict =  [NSMutableDictionary dictionary];

        if ([Singleton.consumeInfoDict[@"raiseInfo"][@"raiseApplyNo"] length]>0) {
            [dict setObject:Singleton.consumeInfoDict[@"raiseInfo"][@"raiseApplyNo"] forKey:@"applyNo"];
        }


        [JRJumpClientToVx jumpWithZipID:Consume_upload controller:Singleton.rootViewController params:dict];


    }else if ([sender.titleLabel.text isEqualToString:@"激活提额"]) {
        [JRJumpClientToVx jumpWithZipID:Consume_active controller:Singleton.rootViewController];
    }

}

//检查是预授信客户还是非预授信
- (void)checkRaiseType{

    if ([Singleton.consumeInfoDict[@"creditStatus"] isEqualToString:@"YSJHZT_01"]) {
        DebugLog(@"消费贷提额_预授信");
        //消费贷提额_预授信
        [JRJumpClientToVx jumpWithZipID:Consume_limitupY controller:Singleton.rootViewController];

    }else{
        DebugLog(@"消费贷提额_主动申请");

        //消费贷提额_主动申请
        [JRJumpClientToVx jumpWithZipID:Consume_limitupF controller:Singleton.rootViewController];
    }

    return;
    /*

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
    [params setObject:@"3000" forKey:@"prodId"];
    [params setObject:@"P" forKey:@"PWDType"];

    new_transaction_caller
    caller.transactionId = @"LN1102Qry.do"; //交易名
    caller.webMethod = POST;                //
    caller.responsType = ResponsTypeOfJson; //返回数据处理
    caller.transactionArgument = params;   //上传参数
    caller.isShowActivityIndicator = YES;
    execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {

        if (TransactionIsSuccess)
        {
            if ([TransReturnInfo[@"creditLimit"] floatValue]>0) {

                DebugLog(@"消费贷提额_预授信");
                //消费贷提额_预授信
                [JRJumpClientToVx jumpWithZipID:Consume_limitupY controller:Singleton.rootViewController];

            }else{
                DebugLog(@"消费贷提额_主动申请");

                //消费贷提额_主动申请
                [JRJumpClientToVx jumpWithZipID:Consume_limitupF controller:Singleton.rootViewController];

            }

        }else{
            alerErr
        }
    }));
     */
}

//居然分期详情
- (void)detailClick{
    DebugLog(@"居然分期详情");
}


//开通分起付
- (void)openStagePay{

    if (![JRPluginUtil isCheckOk]) {
        return;
    }
    
    //判断是否已经同意过该协议 如果之前同意过则进入申请页面

    NSString *haveReadAuthorize = [[NSUserDefaults standardUserDefaults] objectForKey:@"HaveReadAuthorize"];

    //是否阅读过协议
    if ([haveReadAuthorize isEqualToString:@"Y"]) {
        //是否阅读过消费贷产品介绍
        JRStagePayAdsController *stagePayAds = [[JRStagePayAdsController alloc] init];
        [Singleton.rootViewController pushViewController:stagePayAds animated:YES];

    }else{
        JRStagePayAuthorizeController *stagePay = [[JRStagePayAuthorizeController alloc] init];

        [Singleton.rootViewController pushViewController:stagePay animated:YES];
    }

    return;
}


-(NSMutableAttributedString *)formatSomeCharacter:(NSString *)str{
    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc]initWithString:str];
    [tempStr addAttribute:NSBaselineOffsetAttributeName
                    value:@(1.5)   // 正值上偏 负值下偏
                    range:NSMakeRange(str.length-1, 1)];

    [tempStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:14]
                    range:NSMakeRange(str.length-1, 1)];

    [tempStr addAttribute:NSKernAttributeName
                    value:@2                    // NSNumber
                    range:NSMakeRange(str.length-2, 1)];
    return tempStr;
}


@end
