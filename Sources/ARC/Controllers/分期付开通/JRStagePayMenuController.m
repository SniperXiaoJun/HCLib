//
//  JRStagePayMenuController.m
//  Double
//
//  Created by 何崇 on 2017/11/15.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "JRStagePayMenuController.h"
#import "JRUploadIdCardViewController.h"
#import "JRBindCardViewController.h"
#import "JRPluginUtil.h"

@interface JRStagePayMenuController ()

@property(nonatomic,assign) BOOL isCredit;//是否预授信 yes:预授信  no:非预授信

@end

@implementation JRStagePayMenuController


/*
 业务逻辑说明：
 1.进入该页面之前首先初始化插件时已经进行客户X-Token验证
 2.如果验证通过会返回客户信息，根据Singleton.userInfo判断客户是否已经实名及其绑卡
 3.如果已经实名判断是非是预授信客户
 4.预授信客户“开通居然分期付” 右侧按钮为“去激活”，非预授信客户为“未开通”
 5.点击“去激活”或者“未开通” 记录该状态，下次客户不会进入本页面，而是直接进入激活或开通页面。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开通居然分期付";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGB_COLOR(249,249,249);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //判断客户是否实名认证
    if ([Singleton.userInfo[@"CifName"] length] > 0) {
        [self initRequest];
    }
}


- (void)initRequest{
    //
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
            DebugLog(@"LN1102Qry.do  预授信 YES:%@",TransReturnInfo);

            if ([TransReturnInfo[@"creditLimit"] floatValue]>0) {
                //预授信 YES
                _isCredit = YES;
            }


            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];

        }else{
            alerErr
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f*DeviceScaleY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 9.0f*DeviceScaleY;
    }else if (section == 0) {
        return 26.0f*DeviceScaleY;
    }
    return 0.01f*DeviceScaleY;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self headView].frame.size.height;
    }else if (indexPath.section == 1){
        return [self menuView].frame.size.height;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        UIView *backView = [[UIView alloc] initWithFrame:ScaleFrame(0, 0, DeviceWidth, 66*3)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 14, 220, 12)];
        titleLabel.textColor = RGB_COLOR(122,123,135);
        titleLabel.text = @"居然金融为您的账户安全保驾护航！";
        titleLabel.font = DeviceFont(12);
        [backView addSubview:titleLabel];
        return backView;
    }

    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    cell.contentView.backgroundColor = RGB_COLOR(249,249,249);

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

        if (indexPath.section == 0) {
            [cell.contentView addSubview:[self headView]];
        }else if (indexPath.section == 1){
            [cell.contentView addSubview:[self menuView]];
        }

    }else{
        if (indexPath.section == 1){
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }

            [cell.contentView addSubview:[self menuView]];
        }

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)headView{
    UIView *cellView = [[UIView alloc] initWithFrame:ScaleFrame(0, 0, DeviceWidth, 130)];

    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:ScaleFrame(136, 17, 104, 71)];
    logoImage.image = JRBundeImage(@"银行卡icon");
    [cellView addSubview:logoImage];

    NSString *cifName = Singleton.userInfo[@"CifName"];
    NSString *bindCard = Singleton.userInfo[@"Entitycard"];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:ScaleFrame(117, 105, 155, 13)];
    titleLabel.textColor = RGB_COLOR(122,123,135);


    if (cifName.length>0 && bindCard.length>0) {
        titleLabel.text = @"已完成实名认证及绑卡";
    }else{
        titleLabel.text = @"请先完成实名认证及绑卡";
    }

    titleLabel.font = DeviceFont(13);
    [cellView addSubview:titleLabel];

    return cellView;
}


- (UIView *)menuView{
    UIView *cellView = [[UIView alloc] initWithFrame:ScaleFrame(0, 0, DeviceWidth, 66*3)];
    NSArray *logoArr = @[@"step1-icon",@"step2-icon",@"step3-icon"];
    NSArray *titleName = @[@"实名认证",@"银行卡绑定",@"开通居然分期付"];

    NSMutableArray *rightBtnName = [NSMutableArray array];
    NSMutableArray *rightBtnState = [NSMutableArray array];

    if (!Singleton.userInfo[@"CifName"] ||[Singleton.userInfo[@"CifName"] length] == 0) {
        [rightBtnName addObject:@"未实名"];
        [rightBtnState addObject:@"N"];
    }else{
        [rightBtnName addObject:@"已实名"];
        [rightBtnState addObject:@"Y"];
    }

    if (!Singleton.userInfo[@"Entitycard"] ||[Singleton.userInfo[@"Entitycard"] length] == 0) {
        [rightBtnName addObject:@"未绑卡"];
        [rightBtnState addObject:@"N"];
    }else{
        [rightBtnName addObject:@"已绑卡"];
        [rightBtnState addObject:@"Y"];
    }


    if (_isCredit) {
        [rightBtnName addObject:@"去激活"];
        [rightBtnState addObject:@"N"];
    }else{
        if (![JRPluginUtil checkApplyConsumeNoAlert]) {
            [rightBtnName addObject:@"未开通"];
            [rightBtnState addObject:@"N"];
        }else{
            [rightBtnName addObject:@"已开通"];
            [rightBtnState addObject:@"Y"];
        }
    }




    for (int i=0; i<3; i++) {

        UIView *backView = [[UIView alloc] initWithFrame:ScaleFrame(0, 66*i, DeviceWidth, 66)];
        backView.tag = 100+i;
        [cellView addSubview:backView];

        CSIILabelButton * realNameBtn = [[CSIILabelButton alloc] init];
        [realNameBtn  setImage:JRBundeImage(logoArr[i]) frame:ScaleFrame(15, (65-33)/2, 33, 33) forState:UIControlStateNormal];
        [realNameBtn setLabel:titleName[i] frame:ScaleFrame(56, (65-14)/2, 130, 14)];
        realNameBtn.label.textColor = RGB_COLOR(34,34,34);
        realNameBtn.label.font = DeviceFont(15);
        [backView addSubview:realNameBtn];

        if (i<2) {
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 65, 344, DeviceLineWidth)];
            lineLabel.backgroundColor = RGB_COLOR(235,236,237);
            lineLabel.alpha = 0.6;
            [backView addSubview:lineLabel];
        }

        UIButton *menuBtn = [[UIButton alloc] initWithFrame:ScaleFrame(290, (65-20)/2, 57, 20)];
        [menuBtn setTitle:rightBtnName[i] forState:UIControlStateNormal];
        menuBtn.layer.cornerRadius = 10;
        menuBtn.layer.masksToBounds = YES;
        menuBtn.titleLabel.font = DeviceFont(13);

        if ([rightBtnState[i] isEqualToString:@"Y"]) {
            menuBtn.backgroundColor = RGB_COLOR(204,204,204);
            //已完成不可点击
            backView.userInteractionEnabled = NO;
        }else{
            menuBtn.backgroundColor = RGB_COLOR(255,255,255);
            menuBtn.layer.borderWidth = 1;
            menuBtn.layer.borderColor = RGB_COLOR(38,150,196).CGColor;
            [menuBtn setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
            backView.userInteractionEnabled = YES;

        }
        [backView addSubview:menuBtn];

        CSIILabelButton * rightArrow = [[CSIILabelButton alloc] init];
        [rightArrow  setImage:JRBundeImage(@"箭头icon") frame:ScaleFrame(DeviceWidth-15, (65-11)/2, 6, 11) forState:UIControlStateNormal];
        [backView addSubview:rightArrow];


        UITapGestureRecognizer *tapVackView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView:)];
        [backView addGestureRecognizer:tapVackView];
    }

    return cellView;
}


- (void)tapBackView:(UIGestureRecognizer *)tap{
    NSLog(@"tap.view.tag:%d",tap.view.tag);

    if (tap.view.tag == 100) {      //点击实名认证
        JRUploadIdCardViewController *upload = [[JRUploadIdCardViewController alloc] init];
        [Singleton.rootViewController pushViewController:upload animated:YES];
    }else if (tap.view.tag == 101) {//点击
        JRBindCardViewController *bindCard = [[JRBindCardViewController alloc] init];
        [Singleton.rootViewController pushViewController:bindCard animated:YES];
    }else if (tap.view.tag == 102) {

        if (![JRPluginUtil isCheckOk]) {
            return;
        }

        if (_isCredit) {
            DebugLog(@"去激活");
            [JRJumpClientToVx jumpWithZipID:Consume_active controller:Singleton.rootViewController];
        }else{
            DebugLog(@"去开通");
            [JRJumpClientToVx jumpWithZipID:Consume_apply controller:Singleton.rootViewController];
        }

    }

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
