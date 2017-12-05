//
//  JRPersonalMessagesViewController.m
//  CsiiMobileFinance
//
//  Created by Summer on 2017/3/21.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRPersonalMessagesViewController.h"

@interface JRPersonalMessagesViewController ()
{
    NSArray *titleArray;
    NSArray *textArray;
}
@end

@implementation JRPersonalMessagesViewController

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"账户信息";
    
    DebugLog(@"个人信息字典 == %@", Singleton.userInfo);
    NSString *accountStr = [Singleton.userInfo[@"AccountNo"] length]>0?Singleton.userInfo[@"AccountNo"]:@"未绑卡";

    titleArray = @[@"姓名",@"身份证号",@"绑定手机",@"电子账号"];
    textArray = @[Singleton.userInfo[@"CifName"], Singleton.userInfo[@"IdNo"], Singleton.userInfo[@"UserId"], accountStr];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

        UILabel *lae= [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-220*SCALE, 7*SCALE, 200*SCALE, 30*SCALE)];
        lae.textAlignment = 2;
        lae.font = DeviceFont(15);
        lae.textColor =  RGB_COLOR(122,123,135);
        lae.text = textArray[indexPath.row];

        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(20, 44*SCALE - 0.5, ScreenWidth - 20, 0.5)];
        img.backgroundColor = AllLineColor;
        [cell.contentView addSubview:img];

        
        if (indexPath.row == 1)
        {
            lae.text = [textArray[indexPath.row] remixIdCard];
        }
        if (indexPath.row == 2)
        {
            lae.text = [textArray[indexPath.row] remixPhoneNum];
            img.frame = CGRectMake(0, 44*SCALE - 0.5, ScreenWidth, 0.5);
        }
        [cell.contentView addSubview:lae];
        cell.textLabel.text = titleArray[indexPath.row];
        cell.textLabel.font = DeviceFont(15);
        cell.textLabel.textColor = AllTextColorTit;
    }

    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80*SCALE)];
        UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(20*SCALE, 40*SCALE, ScreenWidth-40*SCALE, 40*SCALE)];
        nextButton.backgroundColor = [UIColor colorWithRed:20/255.0 green:124/255.0 blue:209/255.0 alpha:1];
        nextButton.layer.cornerRadius = 5;
        nextButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [nextButton setTitle:@"保存" forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:nextButton];
        return view;
    }
    return nil;
}

-(void)nextButtonAction{
    
}

#pragma mark - UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*SCALE;
}

@end
