//
//  CPZhima.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/5/12.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "CPZhima.h"
#import "JRH5AppViewController.h"

@implementation CPZhima
- (void)openWebView{
    NSLog(@"imgUpload-------%@",self.curData[@"data"][@"Params"]);

    JRH5AppViewController *vc = [[JRH5AppViewController alloc] init];
    vc.url = [NSURL URLWithString:self.curData[@"data"][@"Params"]];
    [Singleton.rootViewController pushViewController:vc animated:YES];
    

}
@end
