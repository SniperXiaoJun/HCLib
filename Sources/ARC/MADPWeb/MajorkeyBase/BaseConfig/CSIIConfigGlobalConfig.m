//
//  CSIIConfigGlobalConfig.m
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 11-7-26.
//  Copyright (c) 2011年 北京科蓝软件系统股份有限公司. All rights reserved.
//
#import "CSIIConfigGlobalConfig.h"
@implementation CSIIConfigGlobalConfig
+(void)initDictConfig;
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *FundUsage = [[NSMutableArray alloc]init];
    [FundUsage addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"直销银行转账"]];
    [dictionary setObject:FundUsage forKey:@"FundUsage"];
        
    NSMutableArray *JobStation = [[NSMutableArray alloc]init];
    
    [JobStation addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"请选择"]];
    [JobStation addObject:[NSDictionary dictionaryWithObject:@"7" forKey:@"县级以上(含)中小学"]];
    [JobStation addObject:[NSDictionary dictionaryWithObject:@"8" forKey:@"县级以上(含)医院"]];
    [JobStation addObject:[NSDictionary dictionaryWithObject:@"5" forKey:@"中小型民营企业"]];
    [JobStation addObject:[NSDictionary dictionaryWithObject:@"3" forKey:@"大中型国有企业"]];
    [JobStation addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"行政事业单位"]];
    [JobStation addObject:[NSDictionary dictionaryWithObject:@"10" forKey:@"自由职业者"]];
    [JobStation addObject:[NSDictionary dictionaryWithObject:@"9" forKey:@"个体工商户"]];
    [JobStation addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"政府机关"]];
    [JobStation addObject:[NSDictionary dictionaryWithObject:@"6" forKey:@"高等院校"]];
    [JobStation addObject:[NSDictionary dictionaryWithObject:@"4" forKey:@"大型民营企业"]];
    [JobStation addObject:[NSDictionary dictionaryWithObject:@"11" forKey:@"其他"]];
    [dictionary setObject:JobStation forKey:@"JobStation"];
    
    NSMutableArray *TradeStation = [[NSMutableArray alloc]init];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"请选择"]];

    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"政府机构"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"建筑业"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"3" forKey:@"水利、电力"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"4" forKey:@"批发、零售"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"5" forKey:@"交通运输"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"6" forKey:@"新闻传媒"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"7" forKey:@"咨询业"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"8" forKey:@"能源"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"9" forKey:@"餐饮娱乐业"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"10" forKey:@"IT通讯"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"11" forKey:@"金融业"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"12" forKey:@"房地产业"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"13" forKey:@"文化教育"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"14" forKey:@"医疗卫生"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"15" forKey:@"旅游业"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"16" forKey:@"公共管理"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"17" forKey:@"农林牧渔"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"18" forKey:@"服务业"]];
    [TradeStation addObject:[NSDictionary dictionaryWithObject:@"19" forKey:@"其他"]];
    [dictionary setObject:TradeStation forKey:@"TradeStation"];
    
    NSMutableArray* PorcessState = [[NSMutableArray alloc]init];
    [PorcessState addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"未处理"]];
    [PorcessState addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"成功受理"]];
    [PorcessState addObject:[NSDictionary dictionaryWithObject:@"3" forKey:@"拒绝受理"]];
    [PorcessState addObject:[NSDictionary dictionaryWithObject:@"4" forKey:@"已处理"]];
    [PorcessState addObject:[NSDictionary dictionaryWithObject:@"5" forKey:@"已取消"]];
    [dictionary setObject:PorcessState forKey:@"PorcessState"];



    NSMutableArray *Asset = [[NSMutableArray alloc]init];
    [Asset addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"请选择"]];
    [Asset addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"住房"]];
    [Asset addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"商用房"]];
    [Asset addObject:[NSDictionary dictionaryWithObject:@"3" forKey:@"住房+商用房"]];
    [dictionary setObject:Asset forKey:@"Asset"];
    
    
    NSMutableArray *AcctStatus = [[NSMutableArray alloc]init];
    [AcctStatus addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"正常"]];

    [AcctStatus addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"提前支取注销"]];
    [AcctStatus addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"到期"]];
    [AcctStatus addObject:[NSDictionary dictionaryWithObject:@"" forKey:@"全部"]];

    [dictionary setObject:AcctStatus forKey:@"AcctStatus"];
    
    NSMutableArray *DyApplyAmt = [[NSMutableArray alloc]init];
    [DyApplyAmt addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"请选择"]];
    [DyApplyAmt addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"20-50万元（含）"]];
    [DyApplyAmt addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"50-100万元（含）"]];
    [DyApplyAmt addObject:[NSDictionary dictionaryWithObject:@"3" forKey:@"100-200万元（含）"]];
    [DyApplyAmt addObject:[NSDictionary dictionaryWithObject:@"4" forKey:@"200-300万元（含）"]];
    [dictionary setObject:DyApplyAmt forKey:@"DyApplyAmt"];
    
    NSMutableArray *XyApplyAmt = [[NSMutableArray alloc]init];
    [XyApplyAmt addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"请选择"]];

    [XyApplyAmt addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"5-10万元（含）"]];
    [XyApplyAmt addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"10-30万元（含）"]];
    [XyApplyAmt addObject:[NSDictionary dictionaryWithObject:@"3" forKey:@"30-50万元（含）"]];
    [XyApplyAmt addObject:[NSDictionary dictionaryWithObject:@"4" forKey:@"50-80万元（含）"]];
    [XyApplyAmt addObject:[NSDictionary dictionaryWithObject:@"5" forKey:@"80-100万元（含）"]];
    [dictionary setObject:XyApplyAmt forKey:@"XyApplyAmt"];
    
    NSMutableArray *FrApplyAmt = [[NSMutableArray alloc]init];
    [FrApplyAmt addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"请选择"]];
    [FrApplyAmt addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"5-10万元（含）"]];
    [FrApplyAmt addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"10-30万元（含）"]];
    [FrApplyAmt addObject:[NSDictionary dictionaryWithObject:@"3" forKey:@"30-50万元（含）"]];
    [FrApplyAmt addObject:[NSDictionary dictionaryWithObject:@"4" forKey:@"50-100万元（含）"]];
    [dictionary setObject:FrApplyAmt forKey:@"FrApplyAmt"];
    
    NSMutableArray *LoanUseType = [[NSMutableArray alloc]init];
    [LoanUseType addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"请选择"]];
    [LoanUseType addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"一次性使用"]];
    [LoanUseType addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"循环使用"]];
    [dictionary setObject:LoanUseType forKey:@"LoanUseType"];
    
    
    NSMutableArray *DayType = [[NSMutableArray alloc]init];
    [DayType addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"只查当日"]];
    [DayType addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"最近7天"]];
    [DayType addObject:[NSDictionary dictionaryWithObject:@"3" forKey:@"最近30天"]];
    [DayType addObject:[NSDictionary dictionaryWithObject:@"4" forKey:@"区间查询"]];
    [dictionary setObject:DayType forKey:@"DayType"];
    
    NSMutableArray *Yhhd = [[NSMutableArray alloc]init];
    [Yhhd addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"请选择"]];
    [Yhhd addObject:[NSDictionary dictionaryWithObject:@"0.6" forKey:@"上线推广期，年利率立减0.6%"]];
    [dictionary setObject:Yhhd forKey:@"Yhhd"];
    
    NSMutableArray *VipYh = [[NSMutableArray alloc]init];
    [VipYh addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"请选择"]];
    [VipYh addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"无"]];
    [VipYh addObject:[NSDictionary dictionaryWithObject:@"0.4" forKey:@"钻石级达标客户年利率立减0.4%"]];
    [VipYh addObject:[NSDictionary dictionaryWithObject:@"0.3" forKey:@"白金级达标客户年利率立减0.3%"]];
    [VipYh addObject:[NSDictionary dictionaryWithObject:@"0.1" forKey:@"黄金级达标客户年利率立减0.1%"]];
    [dictionary setObject:VipYh forKey:@"VipYh"];
    
    NSMutableArray *BorTime = [[NSMutableArray alloc]init];
    [BorTime addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"1年"]];
    [dictionary setObject:BorTime forKey:@"BorTime"];
    
    NSMutableArray *RePayType = [[NSMutableArray alloc]init];
    
    [RePayType addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"请选择"]];
    [RePayType addObject:[NSDictionary dictionaryWithObject:@"4" forKey:@"等额本息"]];

    [RePayType addObject:[NSDictionary dictionaryWithObject:@"3" forKey:@"等额本金"]];
    [RePayType addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"按月结息，到期还本"]];
    [RePayType addObject:[NSDictionary dictionaryWithObject:@"5" forKey:@"按季结息，到期还本"]];
    [RePayType addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"利随本清"]];

    [dictionary setObject:RePayType forKey:@"RePayType"];
    
    NSMutableArray *LoanType = [[NSMutableArray alloc]init];
    [LoanType addObject:[NSDictionary dictionaryWithObject:@"DY" forKey:@"抵押贷款"]];
    [LoanType addObject:[NSDictionary dictionaryWithObject:@"XY" forKey:@"信用贷款"]];
    [LoanType addObject:[NSDictionary dictionaryWithObject:@"QT" forKey:@"信用贷款"]];
    [dictionary setObject:LoanType forKey:@"LoanType"];
    
    NSMutableArray *FrRePayType = [[NSMutableArray alloc]init];
    [FrRePayType addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"请选择"]];
    [FrRePayType addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"分期还款"]];
    [FrRePayType addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"一次性还款"]];
    
    [dictionary setObject:FrRePayType forKey:@"FrRePayType"];
    
    
    NSMutableArray *LoanPurpose = [[NSMutableArray alloc]init];
    
    [LoanPurpose addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"请选择"]];
    [LoanPurpose addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"购车"]];
    [LoanPurpose addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"休闲旅游"]];
    [LoanPurpose addObject:[NSDictionary dictionaryWithObject:@"3" forKey:@"健康医疗"]];
    [LoanPurpose addObject:[NSDictionary dictionaryWithObject:@"4" forKey:@"教育培训"]];
    [LoanPurpose addObject:[NSDictionary dictionaryWithObject:@"5" forKey:@"家庭装修"]];
    [LoanPurpose addObject:[NSDictionary dictionaryWithObject:@"6" forKey:@"购置大额耐用消费品"]];
    [LoanPurpose addObject:[NSDictionary dictionaryWithObject:@"7" forKey:@"其他个人消费"]];
    [dictionary setObject:LoanPurpose forKey:@"LoanPurpose"];

    
    NSMutableArray *FrLoanPurpose = [[NSMutableArray alloc]init];
    [FrLoanPurpose addObject:[NSDictionary dictionaryWithObject:@"0" forKey:@"请选择"]];
    [FrLoanPurpose addObject:[NSDictionary dictionaryWithObject:@"1" forKey:@"个人消费"]];
    [FrLoanPurpose addObject:[NSDictionary dictionaryWithObject:@"2" forKey:@"个人生产经营"]];
    [dictionary setObject:FrLoanPurpose forKey:@"FrLoanPurpose"];
    
    
    if ([NSJSONSerialization isValidJSONObject:dictionary])
    {
//        [[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil] writeToFile:DOCUMENT_FOLDER(DICTFILENAME) atomically:YES];
    }
}

+(void)initAnimationConfig;
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:@"kAnimationTypeFlip" forKey:@"LoginTypeViewController"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"CSIIUIBottomTabViewController"];
    [dictionary setObject:@"kAnimationTypeFlip" forKey:@"CSIIUIMainTabViewController"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"AccountListDetailViewController"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"AccountListViewController"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"RabotActAddViewController"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"AccountListOtherDepositType"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"AccountInquiryViewController"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"AccountManageViewController"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"AccountManageAlterAccName"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"AccountManageReportAccLost"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"DisburseQueryDIYViewController"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"DisburseQueryPeriodViewController"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"NewAddRepaymentEnter"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"HistoryRepaymentEnter"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"HistoryRepaymentDetail"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"CSIISubmitViewController"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"CSIIResultViewController"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"SelfRegistrationConfirmViewController"];
    [dictionary setObject:@"kAnimationTypeDefault" forKey:@"SelfRegistrationInputViewController"];
    if ([NSJSONSerialization isValidJSONObject:dictionary])
    {
//        [[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil] writeToFile:DOCUMENT_FOLDER(ANIMATIONFILENAME) atomically:YES];
    }
}
/*
+(void)initAnimationConfigHD;
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    [[dictionary JSONData]writeToFile:DOCUMENT_FOLDER(ANIMATIONFILENAMEHD) atomically:YES];
}
+(void)initPageNetworkPowerConfig;
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];

    [[dictionary JSONData]writeToFile:DOCUMENT_FOLDER(PAGENETWORKPOWER) atomically:YES];
}
*/
+(void)initMenuConfig;
{
    /* 我的账户 */
    NSArray *myAccount = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"账户总览",@"kNodeName",
                           @"accoutSearchDI.png", @"kImage",
                           @"accoutSearchSeletedDI.png", @"kImageSeleted",
                           [NSNumber numberWithInt:1], @"kSortNum",
                           @"0",@"kNodeIndex",
                           @"kViewcontroller", @"kNodeType",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>0|MyAccountsViewController>0",@"kNavigationObject",
                           nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"交易明细查询",@"kNodeName",
                           @"accountListDI.png", @"kImage",
                           @"accountListSelectedDI.png", @"kImageSeleted",
                           [NSNumber numberWithInt:0], @"kSortNum",
                           @"1",@"kNodeIndex",
                           @"kViewcontroller", @"kNodeType",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>0|MyAccountsViewController>1",@"kNavigationObject",
                           nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"账户管理",@"kNodeName",
                           @"accountManageDI.png", @"kImage",
                           @"accountManageDISelected.png", @"kImageSeleted",
                           [NSNumber numberWithInt:0], @"kSortNum",
                           @"2",@"kNodeIndex",
                           @"kViewcontroller", @"kNodeType",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>0|MyAccountsViewController>2",@"kNavigationObject",
                           nil],
                          nil];
    /* 转账汇款 */
    NSArray * transfer = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"行内转账",@"kNodeName",
                           @"innerTransferDI.png", @"kImage",
                           @"innerTransferSelectedDI.png", @"kImageSeleted",
                           @"innerTransferDI.png",@"kMenuListImage",
                           [NSNumber numberWithInt:0], @"kSortNum",
                           @"3",@"kNodeIndex",
                           @"kViewcontroller", @"kNodeType",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>1|TransferViewController>0",@"kNavigationObject",
                           nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"实时到账汇款(免费)",@"kNodeName",
                           @"ex_crossTransferDI.png", @"kImage",
                           @"ex_crossTransferSelectedDI.png", @"kImageSeleted",
                           @"ex_crossTransferDI.png",@"kMenuListImage",
                           [NSNumber numberWithInt:2], @"kSortNum",
                           @"4",@"kNodeIndex",
                           @"kViewcontroller", @"kNodeType",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>1|TransferViewController>1",@"kNavigationObject",
                           nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"跨行转账",@"kNodeName",
                           @"crossTransferDI.png", @"kImage",
                           @"crossTransferSeletedDI.png", @"kImageSeleted",
                           @"crossTransferDI.png",@"kMenuListImage",
                           [NSNumber numberWithInt:0], @"kSortNum",
                           @"5",@"kNodeIndex",
                           @"kViewcontroller", @"kNodeType",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>1|TransferViewController>2",@"kNavigationObject",
                           nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"手机号汇款",@"kNodeName",
                           @"mobileTransferDI.png", @"kImage",
                           @"mobileTransferSeletedDI.png", @"kImageSeleted",
                           @"mobileTransferDI.png",@"kMenuListImage",
                           [NSNumber numberWithInt:0], @"kSortNum",
                           @"6",@"kNodeIndex",
                           @"kViewcontroller", @"kNodeType",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>1|TransferViewController>3",@"kNavigationObject",
                           nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"信用卡还款",@"kNodeName",
                           @"creditCardDI.png", @"kImage",
                           @"creditCardSelectedDI.png", @"kImageSeleted",
                           @"creditCardDI.png",@"kMenuListImage",
                           [NSNumber numberWithInt:0], @"kSortNum",
                           @"7",@"kNodeIndex",
                           @"kViewcontroller", @"kNodeType",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>1|TransferViewController>4",@"kNavigationObject",
                           nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"收款人管理",@"kNodeName",
                           @"payeeAccountDI.png", @"kImage",
                           @"payeeAccountSelectedDI.png", @"kImageSeleted",
                           @"payeeAccountDI.png",@"kMenuListImage",
                           @"kViewcontroller", @"kNodeType",
                           [NSNumber numberWithInt:0], @"kSortNum",
                           @"8",@"kNodeIndex",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>1|TransferViewController>5",@"kNavigationObject",
                           nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"转账明细查询",@"kNodeName",
                           @"transferDetQryDI.png", @"kImage",
                           @"transferDetQrySelectedDI.png", @"kImageSeleted",
                           @"transferDetQryDI.png",@"kMenuListImage",
                           @"kViewcontroller", @"kNodeType",
                           [NSNumber numberWithInt:0], @"kSortNum",
                           @"9",@"kNodeIndex",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>1|TransferViewController>6",@"kNavigationObject",
                           nil],
                          nil];
    
    /* 缴费充值 */
    NSArray * disburse = [NSArray arrayWithObjects:
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"缴费充值",@"kNodeName",
                           @"1jfzf.png", @"kImage",
                           @"1jfzfo.png", @"kImageSeleted",
                           @"1jfzf.png",@"kMenuListImage",
                           [NSNumber numberWithInt:5], @"kSortNum",
                           @"13",@"kNodeIndex",
                           @"kViewcontroller", @"kNodeType",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>2|DisburseViewController>0",@"kNavigationObject",
                           nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"缴费记录查询",@"kNodeName",
                           @"disburseQryDI.png", @"kImage",
                           @"disburseQrySeletedDI.png", @"kImageSeleted",
                           @"disburseQryDI.png",@"kMenuListImage",
                           [NSNumber numberWithInt:0], @"kSortNum",
                           @"15",@"kNodeIndex",
                           @"kViewcontroller", @"kNodeType",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>2|DisburseViewController>1",@"kNavigationObject",
                           nil],
                          
                          //TODO:支付宝
                          /*
                           [NSDictionary dictionaryWithObjectsAndKeys:
                           @"缴费充值(全国)",@"kNodeName",
                           @"recharge.png", @"kImage",
                           @"recharge_o.png", @"kImageSeleted",
                           @"recharge.png",@"kMenuListImage",
                           [NSNumber numberWithInt:6], @"kSortNum",
                           @"14",@"kNodeIndex",
                           @"kViewcontroller", @"kNodeType",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:YES],kIsDispl2ay,
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>2|DisburseViewController>2",@"kNavigationObject",
                           nil],
                           */
                          nil];
    
    /* 投资理财 */
    NSArray * investment = [NSArray arrayWithObjects:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"产品购买/预约购买",@"kNodeName",
                             @"invProQryDI.png", @"kImage",
                             @"invProQrySelectedDI.png", @"kImageSeleted",
                             @"invProQryDI.png",@"kMenuListImage",
                             [NSNumber numberWithInt:0], @"kSortNum",
                             @"20",@"kNodeIndex",
                             @"kViewcontroller", @"kNodeType",
                             [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                             [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                             [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                             @"CSIIUIMainTabViewController>1|MobileBankViewController>3|InvestmentViewController>0",@"kNavigationObject",
                             nil],
                            
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"我的理财产品",@"kNodeName",
                             @"myInvProDI.png", @"kImage",
                             @"myInvProSelectedDI.png", @"kImageSeleted",
                             @"myInvProDI.png", @"kMenuListImage",
                             [NSNumber numberWithInt:0], @"kSortNum",
                             @"21",@"kNodeIndex",
                             @"kViewcontroller", @"kNodeType",
                             [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                             [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                             [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                             @"CSIIUIMainTabViewController>1|MobileBankViewController>3|InvestmentViewController>1",@"kNavigationObject",
                             nil],
                            nil];
    
    /* 无卡取现 */
    NSArray * cardless = [NSArray arrayWithObjects:
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"无卡取现申请",@"kNodeName",
                           @"wkqxsq.png", @"kImage",
                           @"wkqx_o.png", @"kImageSeleted",
                           @"wkqxsq.png",@"kMenuListImage",
                           [NSNumber numberWithInt:3], @"kSortNum",
                           @"10",@"kNodeIndex",
                           @"kViewcontroller", @"kNodeType",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>4|CardlessViewController>0",@"kNavigationObject",
                           nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"我的预约申请",@"kNodeName",
                           @"wdyysq.png", @"kImage",
                           @"wdyysq_o.png", @"kImageSeleted",
                           @"wdyysq.png",@"kMenuListImage",
                           [NSNumber numberWithInt:0], @"kSortNum",
                           @"11",@"kNodeIndex",
                           @"kViewcontroller", @"kNodeType",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>4|CardlessViewController>1",@"kNavigationObject",
                           nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"无卡取现查询",@"kNodeName",
                           @"wkqxQry.png", @"kImage",
                           @"wkqxQry_o.png", @"kImageSeleted",
                           @"wkqxQry.png",@"kMenuListImage",
                           [NSNumber numberWithInt:0], @"kSortNum",
                           @"12",@"kNodeIndex",
                           @"kViewcontroller", @"kNodeType",
                           [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>1|MobileBankViewController>4|CardlessViewController>2",@"kNavigationObject",
                           nil],
                          nil];
    
    /* 储蓄存款 */
    NSArray * deposit = [NSArray arrayWithObjects:
                         
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"活期转定期",@"kNodeName",
                          @"currToSchDI.png", @"kImage",
                          @"currToSchSelectedDI.png", @"kImageSeleted",
                          @"currToSchDI.png",@"kMenuListImage",
                          [NSNumber numberWithInt:0], @"kSortNum",
                          @"16",@"kNodeIndex",
                          @"kViewcontroller", @"kNodeType",
                          [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                          [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                          [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                          @"CSIIUIMainTabViewController>1|MobileBankViewController>5|DepositViewController>0",@"kNavigationObject",
                          nil],
                         
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"定期存款支取",@"kNodeName",
                          @"SchToCurrDI.png", @"kImage",
                          @"SchToCurrSelectedDI.png", @"kImageSeleted",
                          @"SchToCurrDI.png",@"kMenuListImage",
                          [NSNumber numberWithInt:0], @"kSortNum",
                          @"17",@"kNodeIndex",
                          @"kViewcontroller", @"kNodeType",
                          [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                          [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                          [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                          @"CSIIUIMainTabViewController>1|MobileBankViewController>5|DepositViewController>1",@"kNavigationObject",
                          nil],
                         
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"活期转通知存款",@"kNodeName",
                          @"currToNotDI.png", @"kImage",
                          @"currToNotSelectedDI.png", @"kImageSeleted",
                          @"currToNotDI.png",@"kMenuListImage",
                          [NSNumber numberWithInt:0], @"kSortNum",
                          @"18",@"kNodeIndex",
                          @"kViewcontroller", @"kNodeType",
                          [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                          [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                          [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                          @"CSIIUIMainTabViewController>1|MobileBankViewController>5|DepositViewController>2",@"kNavigationObject",
                          nil],
                         
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"通知存款支取",@"kNodeName",
                          @"notToCurrDI.png", @"kImage",
                          @"notToCurrSelectedDI.png", @"kImageSeleted",
                          @"notToCurrDI.png",@"kMenuListImage",
                          [NSNumber numberWithInt:0], @"kSortNum",
                          @"19",@"kNodeIndex",
                          @"kViewcontroller", @"kNodeType",
                          [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                          [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                          [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                          @"CSIIUIMainTabViewController>1|MobileBankViewController>5|DepositViewController>3",@"kNavigationObject",
                          nil],
                         nil];
    
    /* 我的设置 */
    NSArray * mySetting = [NSArray arrayWithObjects:
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"默认账户设置",@"kNodeName",
                            @"1wdszo_zksz.png", @"kImage",
                            @"1wdszo_zkszo.png", @"kImageSeleted",
                            @"1wdszo_zksz.png", @"kMenuListImage",
                            @"kViewcontroller", @"kNodeType",
                            [NSNumber numberWithInt:0], @"kSortNum",
                            @"22",@"kNodeIndex",
                            [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                            [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                            [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                            @"CSIIUIMainTabViewController>1|MobileBankViewController>7|MySettingsViewController>0",@"kNavigationObject",
                            nil],
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"登录密码修改",@"kNodeName",
                            @"1wdszo_drmmxg.png", @"kImage",
                            @"1wdszo_drmmxgo.png", @"kImageSeleted",
                            @"1wdszo_drmmxg.png", @"kMenuListImage",
                            [NSNumber numberWithInt:0], @"kSortNum",
                            @"23",@"kNodeIndex",
                            @"kViewcontroller", @"kNodeType",
                            [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                            [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                            [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                            @"CSIIUIMainTabViewController>1|MobileBankViewController>7|MySettingsViewController>1",@"kNavigationObject",
                            nil],
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"添加账户",@"kNodeName",
                            @"1wdszo_tjzh.png", @"kImage",
                            @"1wdszo_tjzho.png", @"kImageSeleted",
                            @"1wdszo_tjzh.png", @"kMenuListImage",
                            [NSNumber numberWithInt:0], @"kSortNum",
                            @"24",@"kNodeIndex",
                            @"kViewcontroller", @"kNodeType",
                            [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                            [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                            [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                            @"CSIIUIMainTabViewController>1|MobileBankViewController>7|MySettingsViewController>2",@"kNavigationObject",
                            nil],
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"删除账户",@"kNodeName",
                            @"1wdszo_sczh.png", @"kImage",
                            @"1wdszo_sczho.png", @"kImageSeleted",
                            @"1wdszo_sczh.png", @"kMenuListImage",
                            @"kViewcontroller", @"kNodeType",
                            [NSNumber numberWithInt:0], @"kSortNum",
                            @"25",@"kNodeIndex",
                            [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                            [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                            [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                            @"CSIIUIMainTabViewController>1|MobileBankViewController>7|MySettingsViewController>3",@"kNavigationObject",
                            nil],
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"转账限额设置",@"kNodeName",
                            @"1wdszo_zzxesz.png", @"kImage",
                            @"1wdszo_zzxeszo.png", @"kImageSeleted",
                            @"1wdszo_zzxesz.png", @"kMenuListImage",
                            [NSNumber numberWithInt:0], @"kSortNum",
                            @"26",@"kNodeIndex",
                            @"kViewcontroller", @"kNodeType",
                            [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                            [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                            [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                            @"CSIIUIMainTabViewController>1|MobileBankViewController>7|MySettingsViewController>4",@"kNavigationObject",
                            nil],
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"预留信息设置",@"kNodeName",
                            @"1wdszo_ylxxxg.png", @"kImage",
                            @"1wdszo_ylxxxgo.png", @"kImageSeleted",
                            @"1wdszo_ylxxxg.png", @"kMenuListImage",
                            [NSNumber numberWithInt:0], @"kSortNum",
                            @"27",@"kNodeIndex",
                            @"kViewcontroller", @"kNodeType",
                            [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                            [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                            [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                            @"CSIIUIMainTabViewController>1|MobileBankViewController>7|MySettingsViewController>5",@"kNavigationObject",
                            nil],
                           nil];
    
    /* 网点地图 */
    NSArray * mapRefer = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"附近网点",@"kNodeName",
                           @"2wdcxo_fjwd.png", @"kImage",
                           @"2wdcxo_fjwdo.png", @"kImageSeleted",
                           @"kViewcontroller", @"kNodeType",
                           [NSNumber numberWithInt:8], @"kSortNum",
                           @"28",@"kNodeIndex",
                           [[NSNumber alloc]initWithBool:NO],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>2|FinanceAssistantViewController>2|CSIIUIMapTabViewController>1",@"kNavigationObject",
                           nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"网点查询",@"kNodeName",
                           @"2wdcxo_wdcx.png", @"kImage",
                           @"2wdcxo_wdcxo.png", @"kImageSeleted",
                           @"kViewcontroller", @"kNodeType",
                           [NSNumber numberWithInt:0], @"kSortNum",
                           @"29",@"kNodeIndex",
                           [[NSNumber alloc]initWithBool:NO],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>2|FinanceAssistantViewController>2|CSIIUIMapTabViewController>2",@"kNavigationObject",
                           nil],
                          nil];
    
    /* 理财计算器 */
    NSArray * financeCalculator = [NSArray arrayWithObjects:
                                   [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"存款计算器",@"kNodeName",
                                    @"2lcjsqo_ckjs.png", @"kImage",
                                    @"2lcjsqo_ckjso.png", @"kImageSeleted",
                                    @"kViewcontroller", @"kNodeType",
                                    [NSNumber numberWithInt:0], @"kSortNum",
                                    @"30",@"kNodeIndex",
                                    [[NSNumber alloc]initWithBool:NO],@"kNeedLogin",
                                    [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                                    [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                                    @"CSIIUIMainTabViewController>2|FinanceAssistantViewController>4|CSIIUICalculatorTabViewController>1",@"kNavigationObject",
                                    nil],
                                   
                                   [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"贷款计算器",@"kNodeName",
                                    @"2lcjsqo_dkjs.png", @"kImage",
                                    @"2lcjsqo_dkjso.png", @"kImageSeleted",
                                    @"kViewcontroller", @"kNodeType",
                                    [NSNumber numberWithInt:0], @"kSortNum",
                                    @"31",@"kNodeIndex",
                                    [[NSNumber alloc]initWithBool:NO],@"kNeedLogin",
                                    [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                                    [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                                    @"CSIIUIMainTabViewController>2|FinanceAssistantViewController>4|CSIIUICalculatorTabViewController>2",@"kNavigationObject",
                                    nil],
                                   nil];
    /* 优惠快讯 */
    NSArray * saleInfo = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"营销快讯",@"kNodeName",
                           @"2yhzxo1_yxkx.png", @"kImage",
                           @"2yhzxo1_yxkxo.png", @"kImageSeleted",
                           @"kViewcontroller", @"kNodeType",
                           [NSNumber numberWithInt:0], @"kSortNum",
                           @"32",@"kNodeIndex",
                           [[NSNumber alloc]initWithBool:NO],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>2|FinanceAssistantViewController>5|CSIIUISaleInfoTabViewController>1",@"kNavigationObject",
                           nil],
                          
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"本行公告",@"kNodeName",
                           @"2yhzxo1_bhgg.png", @"kImage",
                           @"2yhzxo1_bhggo.png", @"kImageSeleted",
                           @"kViewcontroller", @"kNodeType",
                           [NSNumber numberWithInt:0], @"kSortNum",
                           @"33",@"kNodeIndex",
                           [[NSNumber alloc]initWithBool:NO],@"kNeedLogin",
                           [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                           [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                           @"CSIIUIMainTabViewController>2|FinanceAssistantViewController>5|CSIIUISaleInfoTabViewController>2",@"kNavigationObject",
                           nil],
                          nil];
    
    /** 功能模块  手机银行 **/
    NSArray *mobileBank = [NSArray arrayWithObjects:
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"我的账户",@"kNodeName",
                            @"myAccountDI.png", @"kImage",
                            @"myAccountSelectedDI.png",@"kImageSeleted",
                            kMenuList, @"kNodeType",
                            myAccount, @"kItems",
                            nil],
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"转账汇款",@"kNodeName",
                            @"transferDI.png", @"kImage",
                            @"transferSelectedDI.png", @"kImageSeleted",
                            kMenuList, @"kNodeType",
                            transfer, @"kItems",
                            nil],
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"生活缴费",@"kNodeName",
                            @"2jfcz.png", @"kImage",
                            @"2jfczo.png", @"kImageSeleted",
                            kMenuList, @"kNodeType",
                            disburse, @"kItems",
                            nil],
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"投资理财",@"kNodeName",
                            @"1tzlc.png", @"kImage",
                            @"1tzlco.png", @"kImageSeleted",
                            kMenuList, @"kNodeType",
                            investment, @"kItems",
                            nil],
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"无卡取现",@"kNodeName",
                            @"wkqx.png", @"kImage",
                            @"wkqx_o.png", @"kImageSeleted",
                            kMenuList, @"kNodeType",
                            cardless, @"kItems",
                            nil],
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"储蓄存款",@"kNodeName",
                            @"1cxck.png", @"kImage",
                            @"1cxcko.png", @"kImageSeleted",
                            kMenuList, @"kNodeType",
                            deposit, @"kItems",
                            nil],
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"无卡支付管理",@"kNodeName",
                            @"noCarPay.png", @"kImage",
                            @"noCarPay_o.png", @"kImageSeleted",
                            @"kViewcontroller", @"kNodeType",
                            [NSNumber numberWithInt:0], @"kSortNum",
                            @"33",@"kNodeIndex",
                            [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                            [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                            [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                            @"CSIIUIMainTabViewController>1|MobileBankViewController>6",
                            @"kNavigationObject",
                            nil],
                           
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"我的设置",@"kNodeName",
                            @"1wdszo_zksz.png", @"kImage",
                            @"1wdszo_zkszo.png", @"kImageSeleted",
                            kMenuList, @"kNodeType",
                            mySetting, @"kItems",
                            nil],
                           nil];
    
    /** 功能模块  掌上生活 **/
    NSArray *financialService = [NSArray arrayWithObjects:
                                 [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"营银商圈",@"kNodeName",
                                  @"yysq.png", @"kImage",
                                  @"yysq_o.png", @"kImageSeleted",
                                  [NSNumber numberWithInt:3], @"kSortNum",
                                  @"35",@"kNodeIndex",
                                  @"kViewcontroller", @"kNodeType",
                                  [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                                  [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                                  [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                                  @"CSIIUIMainTabViewController>2|FinanceAssistantViewController>0",@"kNavigationObject",
                                  nil],
                                 
                                 [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"特约商户",@"kNodeName",
                                  @"tysh.png", @"kImage",
                                  @"tysh_o.png", @"kImageSeleted",
                                  [NSNumber numberWithInt:4], @"kSortNum",
                                  @"36",@"kNodeIndex",
                                  @"kViewcontroller", @"kNodeType",
                                  [[NSNumber alloc]initWithBool:NO],@"kNeedLogin",
                                  [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                                  [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                                  @"CSIIUIMainTabViewController>2|FinanceAssistantViewController>1",@"kNavigationObject",
                                  nil],
                                 
                                 [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"网点查询",@"kNodeName",
                                  @"2wdcx.png", @"kImage",
                                  @"2wdcxo.png", @"kImageSeleted",
                                  kMenuList, @"kNodeType",
                                  mapRefer, @"kItems",
                                  nil],
                                 
                                 [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"银行卡展示",@"kNodeName",
                                  @"kzs.png", @"kImage",
                                  @"kzso.png", @"kImageSeleted",
                                  [NSNumber numberWithInt:0], @"kSortNum",
                                  @"34",@"kNodeIndex",
                                  @"kViewcontroller", @"kNodeType",
                                  [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                                  [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                                  [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                                  @"CSIIUIMainTabViewController>2|FinanceAssistantViewController>3",@"kNavigationObject",
                                  nil],
                                 
                                 [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"理财计算器",@"kNodeName",
                                  @"2lcjsq.png", @"kImage",
                                  @"2lcjsqo.png", @"kImageSeleted",
                                  kMenuList, @"kNodeType",
                                  financeCalculator, @"kItems",
                                  nil],
                                 
                                 [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"营行快讯",@"kNodeName",
                                  @"2yhzx.png", @"kImage",
                                  @"2yhzxo.png", @"kImageSeleted",
                                  kMenuList, @"kNodeType",
                                  saleInfo, @"kItems",
                                  nil],
                                 
                                 [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"理财产品查询",@"kNodeName",
                                  @"2lccpcx.png", @"kImage",
                                  @"2lccpcxo.png", @"kImageSeleted",
                                  @"kViewcontroller", @"kNodeType",
                                  [NSNumber numberWithInt:0], @"kSortNum",
                                  @"37",@"kNodeIndex",
                                  [[NSNumber alloc]initWithBool:NO],@"kNeedLogin",
                                  [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                                  [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                                  @"CSIIUIMainTabViewController>2|FinanceAssistantViewController>6",@"kNavigationObject",
                                  nil],
                                 
                                 [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"客户服务",@"kNodeName",
                                  @"2khfw.png", @"kImage",
                                  @"2khfwo.png", @"kImageSeleted",
                                  @"kViewcontroller", @"kNodeType",
                                  [NSNumber numberWithInt:6], @"kSortNum",
                                  @"38",@"kNodeIndex",
                                  [[NSNumber alloc]initWithBool:NO],@"kNeedLogin",
                                  [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                                  [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                                  @"CSIIUIMainTabViewController>2|FinanceAssistantViewController>7",@"kNavigationObject",
                                  nil],
                                 
                                 [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"资费标准",@"kNodeName",
                                  @"3zfbz.png", @"kImage",
                                  @"3zfbzo.png", @"kImageSeleted",
                                  @"3zfbz.png",@"kMenuListImage",
                                  @"kViewcontroller", @"kNodeType",
                                  [NSNumber numberWithInt:0], @"kSortNum",
                                  @"39",@"kNodeIndex",
                                  [[NSNumber alloc]initWithBool:NO],@"kNeedLogin",
                                  [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                                  [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                                  @"CSIIUIMainTabViewController>2|FinanceAssistantViewController>8",@"kNavigationObject",
                                  nil],
                                 [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"利率查询",@"kNodeName",
                                  @"2ll.png", @"kImage",
                                  @"2llo.png", @"kImageSeleted",
                                  [NSNumber numberWithInt:0], @"kSortNum",
                                  @"40",@"kNodeIndex",
                                  @"kViewcontroller", @"kNodeType",
                                  [[NSNumber alloc]initWithBool:YES],@"kNeedLogin",
                                  [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                                  [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                                  @"CSIIUIMainTabViewController>2|FinanceAssistantViewController>9",@"kNavigationObject",
                                  nil],
                                 nil];
    
    /** 功能模块  系统设置 **/
    NSArray *systemSetting = [NSArray arrayWithObjects:
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"帮助信息",@"kNodeName",
                               @"3bzxx.png", @"kImage",
                               @"3bzxxo.png", @"kImageSeleted",
                               @"3bzxx.png",@"kMenuListImage",
                               @"kViewcontroller", @"kNodeType",
                               [NSNumber numberWithInt:0], @"kSortNum",
                               @"41",@"kNodeIndex",
                               [[NSNumber alloc]initWithBool:NO],@"kNeedLogin",
                               [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                               [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                               @"CSIIUIMainTabViewController>3|SystemSettingsViewController>0",@"kNavigationObject",
                               nil],
                              
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"功能演示",@"kNodeName",
                               @"3ysgn.png", @"kImage",
                               @"3ysgno.png", @"kImageSeleted",
                               @"3ysgn.png",@"kMenuListImage",
                               @"kViewcontroller", @"kNodeType",
                               [NSNumber numberWithInt:0], @"kSortNum",
                               @"42",@"kNodeIndex",
                               [[NSNumber alloc]initWithBool:NO],@"kNeedLogin",
                               [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                               [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                               @"CSIIUIMainTabViewController>WelComePage",@"kNavigationObject",
                               nil],
                              
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"软件更新",@"kNodeName",
                               @"3jcgx.png", @"kImage",
                               @"3jcgxo.png", @"kImageSeleted",
                               @"3jcgx.png",@"kMenuListImage",
                               @"kViewcontroller", @"kNodeType",
                               [NSNumber numberWithInt:0], @"kSortNum",
                               @"43",@"kNodeIndex",
                               [[NSNumber alloc]initWithBool:NO],@"kNeedLogin",
                               [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                               [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                               @"CSIIUIMainTabViewController>UpDate",@"kNavigationObject",
                               nil],
                              
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"主题设置",@"kNodeName",
                               @"1wdszo_hf.png", @"kImage",
                               @"1wdszo_hfo.png", @"kImageSeleted",
                               @"1wdszo_hf.png",@"kMenuListImage",
                               @"kViewcontroller", @"kNodeType",
                               [NSNumber numberWithInt:0], @"kSortNum",
                               @"46",@"kNodeIndex",
                               [[NSNumber alloc]initWithBool:NO],@"kNeedLogin",
                               [[NSNumber alloc]initWithBool:NO],@"kIsDisplay",
                               [[NSNumber alloc]initWithBool:NO],@"kIsReadOnly",
                               @"CSIIUIMainTabViewController>3|SystemSettingsViewController>3",@"kNavigationObject",
                               nil],
                              
                              nil];
    
    
    NSArray *items = [NSArray arrayWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"手机银行",@"kNodeName",
                       @"sjyh.png", @"kImage",
                       @"sjyho.png", @"kImageSeleted",
                       @"kMenuIcons", @"kNodeType",
                       mobileBank, @"kItems",
                       nil],
                      
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"掌上生活",@"kNodeName",
                       @"jrzs.png", @"kImage",
                       @"jrzso.png", @"kImageSeleted",
                       @"kMenuIcons", @"kNodeType",
                       financialService, @"kItems",
                       nil],
                      
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"系统设置",@"kNodeName",
                       @"1wdsz.png", @"kImage",
                       @"1wdszo.png", @"kImageSeleted",
                       kMenuList, @"kNodeType",
                       systemSetting, @"kItems",
                       nil],
                      nil];
    
    NSMutableDictionary *root = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                          @"定制菜单",@"kNodeName",
                          @"", @"kImage",
                          kMenuList, @"kNodeType",
                          [NSString string], @"kTarget",
                          items, @"kItems",
                          [[NSNumber alloc]initWithInt:40], @"sortMaxNum",
                          nil];
    
    if ([NSJSONSerialization isValidJSONObject:root])
    {
//        [[NSJSONSerialization dataWithJSONObject:root options:NSJSONWritingPrettyPrinted error:nil] writeToFile:DOCUMENT_FOLDER(kMenuField) atomically:YES];
    }
}


@end
