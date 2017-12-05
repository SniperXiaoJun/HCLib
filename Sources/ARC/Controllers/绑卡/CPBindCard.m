//
//  CPBindCard.m
//  CsiiMobileFinance
//
//  Created by Summer on 2017/4/6.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "CPBindCard.h"
#import "JRBindCardViewController.h"
//#import "JRUploadIdCardViewController.h"
@implementation CPBindCard
-(void)bindCard{
    NSLog(@"%@",self.curData);
    if ([self.curData[@"data"][@"Params"][@"IsrealName"] isEqualToString:@"N"]) {
//        JRUploadIdCardViewController *s = [[JRUploadIdCardViewController alloc] init];
//        [self.curViewController.navigationController pushViewController:s animated:YES];
    }else{
    JRBindCardViewController *s = [[JRBindCardViewController alloc] init];
    [self.curViewController.navigationController pushViewController:s animated:YES];
    }
}
@end
