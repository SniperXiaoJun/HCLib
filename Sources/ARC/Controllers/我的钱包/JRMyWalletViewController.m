//
//  JRMyWalletViewController.m
//  JuRanPlugin
//
//  Created by 何崇 on 2017/10/30.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "JRMyWalletViewController.h"
#import "JRMyWalletFinancialAccountView.h"
#import "JRMyWalletAccountView.h"
#import "JRMyWalletStagePayView.h"
#import "NickMJRefresh.h"
#import "JRSettingController.h"
#import "JRPluginUtil.h"

//第一个section
#define SectionOneFrame ScaleFrame(0, 0, DeviceWidth, 185 )
//第二个section
#define SectionTwoFrame ScaleFrame(0, 0, DeviceWidth, 140)
//第三个section
#define SectionThreeFrame ScaleFrame(0, 0, DeviceWidth, 140)


@interface JRMyWalletViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong) JRMyWalletFinancialAccountView *financialAccountView;
@property(nonatomic,strong) JRMyWalletAccountView *accountView;
@property(nonatomic,strong) JRMyWalletStagePayView *stagePayView;
@property(nonatomic,strong) UILabel *moneylabel;

@end

@implementation JRMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的钱包";

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGB_COLOR(249,249,249);

    _financialAccountView = [[JRMyWalletFinancialAccountView alloc] initWithFrame:SectionOneFrame] ;
    
    _accountView = [[JRMyWalletAccountView alloc] initWithFrame:SectionTwoFrame];

    _stagePayView = [[JRMyWalletStagePayView alloc] initWithFrame:SectionThreeFrame];

    [self addRightNavBarButton];

    [self.tableView addHeaderWithTarget:self action:@selector(requstCustomLoanInfo)];

    DebugLog(@"%f",ScreenWidth/DeviceWidth);


}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[JRPluginUtil shareInstance] setLeftBarButton];
    [self requstCustomLoanInfo];
}


- (void)addRightNavBarButton{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitleColor:[UIColor colorWithRed:20/255.0 green:124/255.0 blue:209/255.0 alpha:1]
                      forState:UIControlStateNormal];
    [rightButton setTitle:@"设置" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton addTarget:self
                    action:@selector(settingClick)
          forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(ScreenWidth - 50, (44-13)/2, 50, 13);
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightButton setTitleColor:RGB_COLOR(34,34,34) forState:UIControlStateNormal];
    UIBarButtonItem* rightItem =
    [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)settingClick{
    

    JRSettingController *setVC = [[JRSettingController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}


-(void)setDownRefresh{
    [self.tableView addHeaderWithTarget:self action:@selector(requstCustomLoanInfo)];
    [self.tableView headerBeginRefreshing];
}


#pragma mark -UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f*DeviceScaleY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 9.0f*DeviceScaleY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return _financialAccountView.frame.size.height;
    }else if (indexPath.section == 1){
        return _accountView.frame.size.height;
    }else if (indexPath.section == 2){
        return _stagePayView.frame.size.height;
    }
    return 180.0f*DeviceScaleY;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        if (indexPath.section == 0) {
            [cell.contentView addSubview:_financialAccountView];
        }else if (indexPath.section == 1){
            [cell.contentView addSubview:_accountView];
        }else if(indexPath.section == 2){
            [cell.contentView addSubview:_stagePayView];
        }
    }else{

        if (indexPath.section == 0) {
            [_financialAccountView refreshView];
        }else if (indexPath.section == 1){
            [_accountView refreshView];
        }else if(indexPath.section == 2){
            [_stagePayView refreshView];
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)backToRoot{
    [Singleton.rootViewController popToRootViewControllerAnimated:YES];
}

#pragma mark -CellView

//查询消费贷新发生状态
- (void)requstCustomLoanInfo
{
    if ([Singleton.userInfo[@"Entitycard"] length]<=0){
        [self.tableView headerEndRefreshing];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
    [params setObject:@"3000" forKey:@"prodId"];
    
    new_transaction_caller
    caller.transactionId = @"UserHomePageInfoQry.do"; //交易名
    caller.webMethod = POST;                                   // POST  GET
    caller.responsType = ResponsTypeOfJson; //返回数据处理
    caller.transactionArgument = params;   //上传参数
    caller.isShowActivityIndicator = YES;
    execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {

        if (TransactionIsSuccess)
        {
            DebugLog(@"UserHomePageInfoQry.do:%@",TransReturnInfo);
            Singleton.consumeInfoDict = [NSDictionary dictionaryWithDictionary:TransReturnInfo];

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


@end
