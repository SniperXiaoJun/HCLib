//
//  JRVXWebViewController.m
//  ProductInfoFlow
//
//  Created by 刘任朋 on 16/4/25.
//  Copyright © 2016年 Shen Yu. All rights reserved.
//

#import "JRVXWebViewController.h"
#import "CSIIConfigGlobalImport.h"
#import "UIBarButtonItem+JRExtension.h"


@interface JRVXWebViewController (){

    UIImageView       *backImg;
}
@property (nonatomic, strong)NSDictionary *actionParams;
@end

@implementation JRVXWebViewController
- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
        _actionParams = params;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    NSLog(@"vx-viewWillAppear-nav%@",self.navigationController);
    NSLog(@"vx-viewWillAppear-root%@",Singleton.rootViewController);
    [Singleton.rootViewController setNavigationBarHidden:NO];
    
    UIImage *image_url = JRBundeImage( @"back_60_60");


    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemTarget:self action:@selector(backBtnDidClick) image:image_url highlightedImage:image_url];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [backImg removeFromSuperview];

}


- (void)backBtnDidClick{
    [self backAction];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [CSIIBusinessContext sharedInstance].serverUrl =
//    @"http://124.207.86.58:9074/pmobile/";
//    [CSIIBusinessContext sharedInstance].serverPath =
//    @"Product_pweb";
    
    self.webUrl = [self.routaDict objectForKey:@"Url"];
    self.webView.scrollView.scrollEnabled=YES;
    
//    NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"www.baidu.com", @"ActionUrl", @"T", @"LoginType", nil];
    self.webView.params =[self.routaDict objectForKey:PartCellInfo];
    
    // git日志  0504 企业密码
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:1.0 alpha:1.0];
//    
//    //    默认带有一定透明效果，可以使用以下方法去除系统效果
//    [self.navigationController.navigationBar setTranslucent:NO];
    
    
    
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [CPUtility registerHandler:@"Web_Web"
    //                    withObject:Context.rootNavViewController
    //                      withData:dic];
    //    webViewControllerBlock = completeBlock;
    
//    webParams
//  
//    self.webActionId = aDictionary[@"ActionId"];
//    webViewControllerBlock = completeBlock;
//    if (aDictionary[@"params"]) {
//        self.webParams = aDictionary[@"params"];
//    }
}

@end
