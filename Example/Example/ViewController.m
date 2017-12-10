//
//  ViewController.m
//  Example
//
//  Created by 何崇 on 2017/12/5.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "ViewController.h"
//#import "JRPLugin.h"

//#import <HCLib/JRPLugin.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.view.backgroundColor = [UIColor whiteColor];

//     JRPLugin *plugin = [JRPLugin shareInstance];
//    [JRPLugin ToJRPluginWithEntranceInfo:[NSDictionary dictionary] loginBlock:^(NSDictionary *dict) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"X-Token回调函数" message:@"这里是设计家回调函数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//    }];


    /*
     [UIImage imageNamed:imgName inbundle:@"JRBundle.bundle" withPath:@""]

     NSString *const NickMJRefreshBundleName = @"NickMJRefresh.bundle";

     #define NickMJRefreshSrcName(file) [NickMJRefreshBundleName stringByAppendingPathComponent:file]


     NickMJRefreshSrcName(@"arrow.png")
     */

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
