//
//  JRPublisherH5Vc.m
//  ProductInfoFlow
//
//  Created by Shen Yu on 16/5/26.
//  Copyright © 2016年 Shen Yu. All rights reserved.
//

#import "JRPublisherH5Vc.h"

@implementation JRPublisherH5Vc
- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super initWithNibName:nil bundle:nil])) {
        DebugLog(@"userId---%@",self.userId);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DebugLog(@"___%@",Singleton.rootViewController.viewControllers);
    
    DebugLog(@"ppppppppppp-\n%@-%p",self.navigationController,self.navigationController);
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
