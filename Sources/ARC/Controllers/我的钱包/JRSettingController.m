//
//  JRSettingController.m
//  Double
//
//  Created by 何崇 on 2017/11/23.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "JRSettingController.h"
#import "JRChangeTransactionPasswordViewController.h"
#import "JRForgetTransactionPasswordViewController.h"
#import "JRPluginUtil.h"

@interface JRSettingController ()

@property(nonatomic,strong) NSArray *titleArr;
@end

@implementation JRSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.tableView = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    _titleArr = @[@"修改交易密码",@"重置交易密码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.01f*DeviceScaleX;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f*DeviceScaleX;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0*DeviceScaleX;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

        cell.textLabel.text = _titleArr[indexPath.row];
        cell.textLabel.font = DeviceFont(16);
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (![JRPluginUtil isCheckOk]) {
        return;
    }

    if (indexPath.row == 0) {
        JRChangeTransactionPasswordViewController *changePwd = [[JRChangeTransactionPasswordViewController alloc] init];
        [self.navigationController pushViewController:changePwd animated:YES];

    }else if (indexPath.row == 1){
        JRForgetTransactionPasswordViewController *forgetPwd = [[JRForgetTransactionPasswordViewController alloc] init];
        [self.navigationController pushViewController:forgetPwd animated:YES];

    }

}



@end
