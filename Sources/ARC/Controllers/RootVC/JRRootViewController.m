//
//  JRRootViewController.m
//  Double
//
//  Created by 何崇 on 2017/11/16.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "JRRootViewController.h"

@interface JRRootViewController ()

@end

@implementation JRRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    //左边的barButtonItem
    UIImage *image_url = JRBundeImage( @"back_60_60");

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemTarget:self action:@selector(back) image:image_url highlightedImage:image_url];
}

-(void)back{
    //这里要用self，不是self.navigationController
    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
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
