//
//  JRMyWalletAccountView.m
//  Double
//
//  Created by 何崇 on 2017/11/17.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "JRMyWalletAccountView.h"
#import "CSIIFormatUitli.h"
#import "JRJumpClientToVx.h"
#import "JRPluginUtil.h"

#define SectionTwoHeaderFrame ScaleFrame(0, 0, DeviceWidth, 95)
#define SectionTwoLogoFrame ScaleFrame(15, 16, 18, 18)
#define SectionTwoTitleFrame ScaleFrame(37, 18, 79, 15)
#define SectionMoneyFrame ScaleFrame(37, 56, 240, 30)
#define SectionPayFrame ScaleFrame(208, 50, 71, 30)
#define SectionGetFrame ScaleFrame(289, 50, 71, 30)
#define SectionDownFrame ScaleFrame(0, 95,DeviceWidth, 45)
#define SectionDownTitleFrame ScaleFrame(37, 111, 85, 13)
#define SectionDownRightArrowFrame ScaleFrame(353, 111, 6, 11)
#define SectionDownLineFrame ScaleFrame(37, 95, 323, DeviceLineWidth)

@interface JRMyWalletAccountView(){


}


@end

@interface JRMyWalletAccountView()

@property(nonatomic,strong) UILabel *moneylabel;

@end


@implementation JRMyWalletAccountView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self accountView];
    }
    return self;

}

- (UIView *)accountView{
    //底图
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:cellView];

    UIView *headView = [[UIView alloc] initWithFrame:SectionTwoHeaderFrame];
    [cellView addSubview:headView];
    CSIILabelButton * accountLogo = [[CSIILabelButton alloc] init];
    [accountLogo  setImage:JRBundeImage(@"账户余额icon") frame:SectionTwoLogoFrame forState:UIControlStateNormal];
    [accountLogo setLabel:@"账户余额" frame:SectionTwoTitleFrame];
    accountLogo.label.font = DeviceFont(14);
    [headView addSubview:accountLogo];


    _moneylabel = [[UILabel alloc] initWithFrame:SectionMoneyFrame];
    _moneylabel.text = @"0.00元";
    if (Singleton.consumeInfoDict[@"Amount"]) {

        NSString * moneylabelStr =[Singleton.consumeInfoDict[@"Amount"] stringByAppendingString:@"元"];
        _moneylabel.text =[CSIIFormatUitli splitByRmb:moneylabelStr];
    }
    _moneylabel.textColor = RGB_COLOR(223,64,49);
    _moneylabel.font = DeviceFont(20);
    NSMutableAttributedString *moneyTextAttributedStr = [self formatSomeCharacter:_moneylabel.text];
    _moneylabel.attributedText = moneyTextAttributedStr;
    [headView addSubview:_moneylabel];


    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn setFrame:SectionPayFrame];
    [payBtn setBackgroundColor:RGB_COLOR(38,150,196)];
    payBtn.layer.cornerRadius = 3;
    payBtn.layer.masksToBounds = YES;
    payBtn.titleLabel.font = DeviceFont(15);
    [payBtn setTitle:@"充值" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(JRPayAction) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:payBtn];


    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getBtn setFrame:SectionGetFrame];
    [getBtn setBackgroundColor:[UIColor whiteColor]];
    getBtn.layer.borderColor = RGB_COLOR(38,150,196).CGColor;
    getBtn.layer.borderWidth = 1;
    getBtn.layer.cornerRadius = 3;
    getBtn.layer.masksToBounds = YES;
    getBtn.titleLabel.font = DeviceFont(15);
    [getBtn setTitle:@"提现" forState:UIControlStateNormal];
    [getBtn setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
    [getBtn addTarget:self action:@selector(JRGetAction) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:getBtn];

    UILabel *lineLabel = [[UILabel alloc] initWithFrame:SectionDownLineFrame];
    lineLabel.backgroundColor = RGB_COLOR(236,236,236);
    lineLabel.alpha = 0.6;
    [cellView addSubview:lineLabel];



    UIView *downView = [[UIView alloc] initWithFrame:SectionDownFrame];
    [cellView addSubview:downView];

    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transDetail:)];
    [downView addGestureRecognizer:tapGes];

    UILabel *transDetailLabel = [[UILabel alloc] initWithFrame:SectionDownTitleFrame];
    transDetailLabel.textColor = RGB_COLOR(34, 34, 34);
    transDetailLabel.text = @"交易明细";
    transDetailLabel.font = DeviceFont(14);
    [cellView addSubview:transDetailLabel];

    CSIILabelButton * rightArrow = [[CSIILabelButton alloc] init];
    [rightArrow  setImage:JRBundeImage(@"箭头icon") frame:SectionDownRightArrowFrame forState:UIControlStateNormal];
    [cellView addSubview:rightArrow];

    return cellView;
}

- (void)refreshView{

    if ([Singleton.consumeInfoDict[@"Amount"] length]>0) {
        _moneylabel.text =[Singleton.consumeInfoDict[@"Amount"] stringByAppendingString:@"元"];
        NSMutableAttributedString *moneyTextAttributedStr = [self formatSomeCharacter:_moneylabel.text];
        _moneylabel.attributedText = moneyTextAttributedStr;
    }

}

//充值
- (void)JRPayAction{
    DebugLog(@"充值");

    if (![JRPluginUtil isCheckOk]) {
        return;
    }

    [JRJumpClientToVx jumpWithZipID:JRRecharge controller:Singleton.rootViewController];
}

//提现
- (void)JRGetAction{
    DebugLog(@"提现");

    if (![JRPluginUtil isCheckOk]) {
        return;
    }

    [JRJumpClientToVx jumpWithZipID:JRWithdrawals controller:Singleton.rootViewController];
}

//交易明细
- (void)transDetail:(UITapGestureRecognizer *)tap{
    DebugLog(@"交易明细");

    if (![JRPluginUtil isCheckOk]) {
        return;
    }
    
    [JRJumpClientToVx jumpWithZipID:JRTrsDetail controller:Singleton.rootViewController];
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
