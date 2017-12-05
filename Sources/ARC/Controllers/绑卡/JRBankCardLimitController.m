//
//  JRBankCardLimitController.m
//  Double
//
//  Created by 何崇 on 2017/11/22.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "JRBankCardLimitController.h"

@interface JRBankCardLimitController (){

    NSArray * bankArray;
}

@end

@implementation JRBankCardLimitController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"银行限额规定";

    self.view.backgroundColor = RGB_COLOR(249,249,249);
    self.tableView = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];

    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];

    NSString *file = [[NSBundle mainBundle] pathForResource:@"limitList.json" ofType:@""];
    NSData *data = [NSData dataWithContentsOfFile:file];
    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
    bankArray = [NSArray arrayWithArray:d[@"limitList"]];

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
    return bankArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0*DeviceScaleX;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0*DeviceScaleX;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
     return 60*DeviceScaleX*2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:ScaleFrame(0, 0, DeviceWidth, 44)];
    headerView.backgroundColor = [UIColor whiteColor];

    NSArray *titleArr = @[@"支持银行",@"单笔限额",@"单日限额"];
    for (int i=0; i<3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:ScaleFrame(DeviceWidth/3*i, 0, DeviceWidth/3, 44)];
        label.text = titleArr[i];
        label.font = DeviceFont(14);
        label.textColor = RGB_COLOR(122,123,135);
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
    }

    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *headerView = [[UIView alloc] initWithFrame:ScaleFrame(0, 0, DeviceWidth, 60*2)];

    UILabel *topLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 20, DeviceWidth-15, 12)];
    topLabel.text = @"以上内容会有变动，若有变动，请以相应银行最新发布为准";
    topLabel.font = DeviceFont(12);
    topLabel.textColor = RGB_COLOR(122,123,135);
    [headerView addSubview:topLabel];

    UILabel *downLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 45, DeviceWidth-15, 12)];
    downLabel.text = @"更新时间 2017年11月28";
    downLabel.font = DeviceFont(12);
    downLabel.textColor = RGB_COLOR(122,123,135);
    [headerView addSubview:downLabel];

    return headerView;

    // 512  448 44

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIde = [NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIde];

        NSDictionary *currentDict = bankArray[indexPath.row];
        NSString *bankName = currentDict[@"bank"];
        NSString *aLimitStr = [currentDict[@"dealLimit"] objectForKey:@"aLimit"];
        NSString *dayLimitStr = [currentDict[@"dealLimit"] objectForKey:@"dayLimit"];

        NSArray *currentArr = @[bankName,aLimitStr,dayLimitStr];
        for (int i=0; i<3; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:ScaleFrame(DeviceWidth/3*i, 0, DeviceWidth/3, 44)];
            label.text = currentArr[i];
            label.font = DeviceFont(14);
            label.textColor = RGB_COLOR(122,123,135);
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
        }

    }
    

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
