//
//  JRStagePayController.m
//  Double
//
//  Created by 何崇 on 2017/11/13.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "JRStagePayAdsController.h"
#import "CSIILabelButton.h"
#import "JRStagePayMenuController.h"
@interface JRStagePayAdsController (){
    UIWindow *mWindow;

}

@end

@implementation JRStagePayAdsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开通居然分期付";
    self.tableView.backgroundColor = RGB_COLOR(249,249,249);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    for (UIView *view in mWindow.subviews) {
        [view removeFromSuperview];
    }

    mWindow.frame = CGRectMake(0, 0, 0, 0);
    [mWindow resignKeyWindow];
    mWindow = nil;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setFootView:CGRectMake(0, ScreenHeight-43*DeviceScaleX, ScreenWidth, 43*DeviceScaleX)];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f*DeviceScaleY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 120.0f*DeviceScaleY;
    }
    return 9.0f*DeviceScaleY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self headView].frame.size.height;
    }else if (indexPath.section==1){
        return [self applyView].frame.size.height;
    }else if (indexPath.section==2){
        return [self warrantAndRepay].frame.size.height;
    }else if (indexPath.section==3){
        return [self needFile].frame.size.height;
    }

    return 180.0f*DeviceScaleY;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

        if (indexPath.section == 0) {
            [cell.contentView addSubview:[self headView]];
        }else if (indexPath.section ==1){
            [cell.contentView addSubview:[self applyView]];
        }else if (indexPath.section ==2){
            [cell.contentView addSubview:[self warrantAndRepay]];
        }else if (indexPath.section ==3){
            [cell.contentView addSubview:[self needFile]];
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark- CellView  cell视图
- (UIView *)headView{
    UIView *cellView = [[UIView alloc] initWithFrame:ScaleFrame(0, 0, DeviceWidth, 214)];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:ScaleFrame(16, 20, 100, 13)];
    titleLabel.text = @"最高申请额度";
    titleLabel.font = DeviceFont(14);
    titleLabel.textColor = RGB_COLOR(34,34,34);
    [cellView addSubview:titleLabel];


    UILabel *moneylabel = [[UILabel alloc] initWithFrame:ScaleFrame(17, 46, 60, 23)];
    moneylabel.text = @"50万";
    moneylabel.textColor = RGB_COLOR(223,64,49);
    moneylabel.font = DeviceFont(35);
    NSMutableAttributedString *footerTextAttributedStr = [self formatSomeCharacter:moneylabel.text];
    moneylabel.attributedText = footerTextAttributedStr;
    [cellView addSubview:moneylabel];

    UILabel *lineLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 88, 345, DeviceLineWidth)];
    lineLabel.backgroundColor = RGB_COLOR(235,236,237);
    lineLabel.alpha = 0.6;
    [cellView addSubview:lineLabel];


    UILabel *dateLimit = [[UILabel alloc] initWithFrame:ScaleFrame(15, 102, 75, 13)];
    dateLimit.text = @"期限范围：";
    dateLimit.font = DeviceFont(14);
    dateLimit.textColor = RGB_COLOR(122,123,135);
    [cellView addSubview:dateLimit];

    UILabel *dateLimitInfo = [[UILabel alloc] initWithFrame:ScaleFrame(87, 102, 110, 15)];
    dateLimitInfo.text = @"最长可至36期";
    dateLimitInfo.font = DeviceFont(15);
    dateLimitInfo.textColor = RGB_COLOR(0,127,179);
    [cellView addSubview:dateLimitInfo];

    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:ScaleFrame(15, 129, 345, DeviceLineWidth)];
    lineLabel1.backgroundColor = RGB_COLOR(235,236,237);
    lineLabel1.alpha = 0.6;

    [cellView addSubview:lineLabel1];


    UILabel *stagePayRate = [[UILabel alloc] initWithFrame:ScaleFrame(15, 143, 75, 14)];
    stagePayRate.text = @"分期费率：";
    stagePayRate.font = DeviceFont(14);
    stagePayRate.textColor = RGB_COLOR(122,123,135);
    [cellView addSubview:stagePayRate];

    UILabel *stagePayRateInfo = [[UILabel alloc] initWithFrame:ScaleFrame(87, 143, 220, 15)];
    stagePayRateInfo.text = @"0.3%-0.5%，更有免息分期优惠";
    stagePayRateInfo.font = DeviceFont(15);
    stagePayRateInfo.textColor = RGB_COLOR(0,127,179);
    [cellView addSubview:stagePayRateInfo];

    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:ScaleFrame(15, 171, 345, DeviceLineWidth)];
    lineLabel2.backgroundColor = RGB_COLOR(235,236,237);
    lineLabel2.alpha = 0.6;

    [cellView addSubview:lineLabel2];

    UILabel *useLimit = [[UILabel alloc] initWithFrame:ScaleFrame(15, 186, 75, 13)];
    useLimit.text = @"限制用途：";
    useLimit.font = DeviceFont(14);
    useLimit.textColor = RGB_COLOR(122,123,135);
    [cellView addSubview:useLimit];

    UILabel *useLimitInfo = [[UILabel alloc] initWithFrame:ScaleFrame(87, 185, 260, 15)];
    useLimitInfo.text = @"装修房屋，购买家具、电器、建材等";
    useLimitInfo.font = DeviceFont(15);
    useLimitInfo.textColor = RGB_COLOR(34,34,34);
    [cellView addSubview:useLimitInfo];

    return cellView;
}


- (UIView *)applyView{
    UIView *cellView = [[UIView alloc] initWithFrame:ScaleFrame(0, 0, DeviceWidth, 130)];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 11, 68, 14)];
    titleLabel.text = @"申请流程";
    titleLabel.font = DeviceFont(15);
    titleLabel.textColor = RGB_COLOR(34,34,34);
    [cellView addSubview:titleLabel];

    UILabel *lineLabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 37, DeviceWidth, DeviceLineWidth)];
    lineLabel.backgroundColor = RGB_COLOR(235,236,237);
    lineLabel.alpha = 0.6;

    [cellView addSubview:lineLabel];

    NSArray *titleName = @[@"申请开通",@"系统审批",@"签约激活",@"分期消费"];
    NSArray *titleImgName = @[@"申请开通icon",@"审批icon",@"签约激活icon",@"分期消费icon"];

    for (int i=0; i<titleName.count; i++) {
        UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:ScaleFrame(31+98*i, 61, 23, 24)];
        logoImgView.image = JRBundeImage(titleImgName[i]);
        [cellView addSubview:logoImgView];

        if (i<titleName.count-1) {
            UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:ScaleFrame(77+98*i, 69, 30, 6)];
            arrowImgView.image = JRBundeImage(@"流程箭头icon");
            [cellView addSubview:arrowImgView];
        }


        UILabel *titleLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15+98*i, 94, 65, 12)];
        titleLabel.text = titleName[i];
        titleLabel.font = DeviceFont(14);
        titleLabel.textColor = RGB_COLOR(51,51,51);
        [cellView addSubview:titleLabel];

    }



    return cellView;
}


- (UIView *)warrantAndRepay{
    UIView *cellView = [[UIView alloc] initWithFrame:ScaleFrame(0, 0, DeviceWidth, 85)];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 12, 120, 15)];
    titleLabel.text = @"担保及偿还方式";
    titleLabel.font = DeviceFont(15);
    titleLabel.textColor = RGB_COLOR(34,34,34);
    [cellView addSubview:titleLabel];

    UILabel *lineLabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 38, DeviceWidth, DeviceLineWidth)];
    lineLabel.backgroundColor = RGB_COLOR(235,236,237);
    lineLabel.alpha = 0.6;
    [cellView addSubview:lineLabel];

    UILabel *infoLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 54, 170, 13)];
    infoLabel.text = @"1.信用担保； 2.分期偿还";
    infoLabel.font = DeviceFont(14);
    infoLabel.textColor = RGB_COLOR(122,123,135);
    [cellView addSubview:infoLabel];

    return cellView;
}

- (UIView *)needFile{
    UIView *cellView = [[UIView alloc] initWithFrame:ScaleFrame(0, 0, DeviceWidth, 310)];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 12, 120, 15)];
    titleLabel.text = @"所需材料";
    titleLabel.font = DeviceFont(15);
    titleLabel.textColor = RGB_COLOR(34,34,34);
    [cellView addSubview:titleLabel];

    UILabel *lineLabel = [[UILabel alloc] initWithFrame:ScaleFrame(0, 38, DeviceWidth, DeviceLineWidth)];
    lineLabel.backgroundColor = RGB_COLOR(235,236,237);
    lineLabel.alpha = 0.6;
    [cellView addSubview:lineLabel];

    UILabel *infoLabel = [[UILabel alloc] initWithFrame:ScaleFrame(17, 57-10, 341, 240)];
    infoLabel.font = DeviceFont(14);
    infoLabel.numberOfLines = 0;
    infoLabel.textColor = RGB_COLOR(122,123,135);
    [cellView addSubview:infoLabel];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10.f*DeviceScaleX;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    // 其他属性请自行查阅NSMutableParagraphStyle头文件

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"1.借款人基本信息录入；\n2.装修房屋的房产证明材料（房产证、购房合同+发票、银行按揭贷款合同）。装修房屋需借款人本人（含共同持有）或直系亲属持有；\n3.装修房屋由直系亲属持有的，需提供户口簿、结婚证等证明材料；\n4.若能提供公积金缴费记录或社保缴费记录等工作证明材料、以及其他财力证明，将有助于贷款快速获批或获得较高贷款额度。"];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                    value:paragraphStyle
                    range:NSMakeRange(0, attributedString.length)];
    infoLabel.attributedText = attributedString;
    return cellView;
    
}


- (void)setFootView:(CGRect)frame{

    UIButton *nextButton = [[UIButton alloc]initWithFrame:ScaleFrame(0, 0, DeviceWidth, 43)];
    nextButton.backgroundColor = RGB_COLOR(38,150,196);
    nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:(16)*(DeviceScaleX != 1?DeviceScaleX*0.94:DeviceScaleX)];
    [nextButton setTitle:@"马上开通" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];

    mWindow = [[UIWindow alloc]initWithFrame:frame];
    mWindow.windowLevel = UIWindowLevelAlert + 1;
    mWindow.backgroundColor = [UIColor whiteColor];
    [mWindow addSubview:nextButton];
    [mWindow makeKeyAndVisible];//关键语句,显示window

}
- (void)nextButtonAction{
    JRStagePayMenuController *stagePay = [[JRStagePayMenuController alloc] init];
    [self.navigationController pushViewController:stagePay animated:YES];

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
