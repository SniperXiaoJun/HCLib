//
//  JRStagePayAuthorizeController.m
//  Double
//
//  Created by 何崇 on 2017/11/15.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "JRStagePayAuthorizeController.h"
#import "JRStagePayAdsController.h"
#import "JRMyWalletViewController.h"

@interface JRStagePayAuthorizeController (){
    UIWindow *mWindow;
//    UIWebView *webView;
    NSArray *headerTitleArr;
    NSArray *htmlFileArr;
    NSMutableArray *frameArr;
    CGRect webViewFrame;
    NSInteger currentShowSectionId;

}
@property(nonatomic,strong) UIButton *checkBtn;

@end

@implementation JRStagePayAuthorizeController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开通居然金融";

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGB_COLOR(249,249,249);

    headerTitleArr = @[@"居然金融用户注册协议",@"安心签平台服务协议",@"隐私政策"];
    htmlFileArr = @[@"zhuce",@"anxinqian",@"yinsi"];
    frameArr = [NSMutableArray array];
    webViewFrame = CGRectMake(0, 0, ScreenWidth, 345*DeviceScaleY);
    currentShowSectionId = 0;


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
    
    [self setFootView:CGRectMake(0, ScreenHeight-115*DeviceScaleX, ScreenWidth, 115*DeviceScaleX)];
}



- (void)setFootView:(CGRect)frame{

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 115*DeviceScaleX)];
    footView.backgroundColor = RGB_COLOR(249,249,249);
    _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkBtn.frame =ScaleFrame(16, 21, 20, 20);
    [_checkBtn setImage:JRBundeImage(@"radioUnselect") forState:UIControlStateNormal];
    [_checkBtn setImage:JRBundeImage(@"radioSelect") forState:UIControlStateSelected];
    [_checkBtn setSelected:YES];
    [_checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_checkBtn];

    UILabel * protocolLabel = [[UILabel alloc] initWithFrame:ScaleFrame(45, 23, 260, 38)];
    protocolLabel.font = DeviceFont(13);
    protocolLabel.text = @"阅读并同意以上协议，\n授权居然金融平台查询您的个人征信记录";
    protocolLabel.userInteractionEnabled = YES;
    protocolLabel.numberOfLines = 0;
    protocolLabel.textColor = RGB_COLOR(34, 34, 34);
    NSMutableAttributedString *protocolAttributedStr = [self formatSomeCharacter:protocolLabel.text];
    protocolLabel.attributedText = protocolAttributedStr;
    [footView addSubview:protocolLabel];



    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(0, (115-43)*DeviceScaleX, ScreenWidth, 43*DeviceScaleX)];
    nextButton.backgroundColor = RGB_COLOR(38,150,196);
    nextButton.titleLabel.font = DeviceBoldFont(18);
    [nextButton setTitle:@"授权并通过" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:nextButton];

    mWindow = [[UIWindow alloc]initWithFrame:frame];
    mWindow.windowLevel = UIWindowLevelAlert + 1;
    mWindow.backgroundColor = [UIColor whiteColor];
    [mWindow addSubview:footView];
    [mWindow makeKeyAndVisible];//关键语句,显示window
}

- (void)checkBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;

}


-(NSMutableAttributedString *)formatSomeCharacter:(NSString *)str{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.f;
//    paragraphStyle.alignment = NSTextAlignmentLeft;

    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc]initWithString:str];
    [tempStr addAttribute:NSForegroundColorAttributeName
                    value:RGB_COLOR(122,123,135)
                    range:NSMakeRange(10, str.length-10)];
    [tempStr addAttribute:NSFontAttributeName
                    value:DeviceFont(12)
                    range:NSMakeRange(10, str.length-10)];
    
    [tempStr addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, tempStr.length)];
    return tempStr;
}


- (void)nextButtonAction{

    if (!_checkBtn.selected) {
        alertMsg(@"请先阅读并同意以上协议");
        return;
    }

    [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:@"HaveReadAuthorize"];

    if ([_nextpageVCName isEqualToString:@"JRMyWalletViewController"]) {
//        UIViewController *vc = (UIViewController *)NSClassFromString(_nextpageVCName);
        JRMyWalletViewController *vc = [[JRMyWalletViewController  alloc] init];

        [self.navigationController pushViewController:vc animated:YES];
    }else{
        JRStagePayAdsController *vc = [[JRStagePayAdsController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == currentShowSectionId) {
        return 345*DeviceScaleX;
    }else{
        return 0.01f;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45*DeviceScaleY;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == headerTitleArr.count-1) {
        return 125*DeviceScaleX;
    }
    return 5*DeviceScaleX;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] init];
    return footView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45*DeviceScaleY)];
    headView.tag = 100+section;
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:ScaleFrame(15, 15, 140, 13)];
    titleLabel.font = DeviceFont(13);
    titleLabel.textColor = RGB_COLOR(38,150,196);
    titleLabel.text = headerTitleArr[section];
    [headView addSubview:titleLabel];

    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45*DeviceScaleY-1, ScreenWidth, DeviceLineWidth)];
    lineLabel.backgroundColor = RGB_COLOR(235,236,237);
    lineLabel.alpha = 0.6;
    [headView addSubview:lineLabel];

    CSIILabelButton * rightArrow = [[CSIILabelButton alloc] init];
    rightArrow.tag = 1000+section;
    [headView addSubview:rightArrow];

    if (section != currentShowSectionId) {
        [rightArrow  setImage:JRBundeImage(@"箭头icon") frame:ScaleFrame(DeviceWidth-22, (45*DeviceScaleY-11)/2, 6, 11) forState:UIControlStateNormal];
    }else{
        [rightArrow  setImage:JRBundeImage(@"箭头朝下") frame:ScaleFrame(DeviceWidth-24, (45*DeviceScaleY-6)/2, 11, 6) forState:UIControlStateNormal];
    }

    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [headView addGestureRecognizer:tapGes];

    return headView;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }



    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"JRBundle.bundle"];
//    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];

    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.html",bundlePath,htmlFileArr[indexPath.section]]];



//    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:htmlFileArr[indexPath.section] ofType:@"html"]];


    if (indexPath.section == currentShowSectionId) {
        UIWebView *webView = [[UIWebView alloc] init];
        webView.frame = CGRectMake(0, 0, ScreenWidth, 345*DeviceScaleY);
        webView.backgroundColor = [UIColor whiteColor];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        webView.frame = CGRectMake(0, 0, ScreenWidth, 345*DeviceScaleY);

        [cell.contentView addSubview:webView];
    }else{
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-  (void)tapClick:(UIGestureRecognizer *)tap{
    if (currentShowSectionId != tap.view.tag-100) {
        currentShowSectionId = tap.view.tag-100;

        [self.tableView reloadData];
    }


}


@end
