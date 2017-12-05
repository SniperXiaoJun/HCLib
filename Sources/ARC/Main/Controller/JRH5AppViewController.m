//
//  JRH5AppViewController.m
//  ProductInfoFlow
//
//  Created by Shen Yu on 16/4/14.
//  Copyright © 2016年 Shen Yu. All rights reserved.
//

#import "JRH5AppViewController.h"

@interface JRH5AppViewController ()

@end

@implementation JRH5AppViewController
- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.title = @"h5app";
//        DebugLog(@"userId---%@",self.userId);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.title = @"百度";
    DebugLog(@"___%@",Singleton.rootViewController.viewControllers);
    
    DebugLog(@"ppppppppppp-\n%@-%p",self.navigationController,self.navigationController);
    
    
//    self.url = [NSURL URLWithString:@"https://www.baidu.com"];
//    DebugLog(@"%@",self.url);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
