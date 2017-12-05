//
//  CPJump.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/4/7.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "CPJump.h"
#import "JRJumpClientToVx.h"

@implementation CPJump
- (void)JumpZipToZip{

    [self.curViewController.navigationController popViewControllerAnimated:NO];
    
    NSString *param = self.curData[@"data"][@"Params"];
    
    [JRJumpClientToVx jumpWithZipID:param controller:self.curViewController];
    
}
@end
