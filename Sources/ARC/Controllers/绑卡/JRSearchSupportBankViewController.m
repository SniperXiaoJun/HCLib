//
//  JRSearchSupportBankViewController.m
//  CsiiMobileFinance
//
//  Created by 张平辉 on 2017/7/25.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRSearchSupportBankViewController.h"

@interface JRSearchSupportBankViewController ()
{
    UITableView *myTableView;
    NSMutableArray *bankArray;
}
@end

@implementation JRSearchSupportBankViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    self.title = @"选择银行";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"limitList.json" ofType:@""];
    NSData *data = [NSData dataWithContentsOfFile:file];
    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
    bankArray = d[@"limitList"];
    
    [JRSYHttpTool post:@"BankMsgListQry.do" parameters:params success:^(id json) {
        
        if ([json[@"_RejCode"] isEqualToString:@"000000"])
        {
            self.dataArray = [NSMutableArray arrayWithArray:json[@"List"]];
            [self creatUI];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)creatUI
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierStr];
    }
    else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.textLabel.text = dict[@"BankName"];
    cell.textLabel.font = [UIFont systemFontOfSize:AllTextFont];
    cell.textLabel.textColor = AllTextColorTit;
    
    NSString *ci;
    NSString *ri;
    for (NSDictionary *d in bankArray)
    {
        
        if ([d[@"bankId"] isEqualToString:dict[@"BankId"]])
        {
            ci = [self handDataWithString:d[@"dealLimit"][@"aLimit"]];
            ri = [self handDataWithString:d[@"dealLimit"][@"dayLimit"]];
//            ci = d[@"dealLimit"][@"aLimit"];
//            ri = d[@"dealLimit"][@"dayLimit"];
        }
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(单笔限额:%@，日累积限额:%@)",ci, ri];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:ScreenWidth==320? 10 : 12];
    cell.detailTextLabel.textColor = AllTextColorDetail;
    
    return cell;
}
/*
 "limitList": [
 {
 "bank": "工商银行",
 "sex": "借记卡",
 "dealLimit": {
 "aLimit": "50000",
 "dayLimit": "50000"
 }
 },
 
 10
 100
 1000
 10000
 100000
 */

- (NSString *)handDataWithString:(NSString *)str
{
    NSString *moneyString = [NSString string];
    
    NSInteger length = str.length;
    
    if (length <= 3)
    {
        moneyString = [str stringByAppendingString:@"元"];
    }
    if (length == 4)
    {
        moneyString = [[str substringToIndex:1] stringByAppendingString:@"千元"];
    }
    if (length >= 5)
    {
        moneyString = [[str substringToIndex:length-4] stringByAppendingString:@"万元"];
    }
    return moneyString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArray[indexPath.row];
    [self.delegate chooseBank:dict[@"BankName"]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
