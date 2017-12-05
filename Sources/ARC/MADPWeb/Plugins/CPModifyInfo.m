//
//  CPModifyInfo.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/5/5.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "CPModifyInfo.h"

@implementation CPModifyInfo
- (void)modifyInfo{
//    self.cu
    DebugLog(@"modifyInfo-------%@",self.curData[@"data"][@"Params"]);
    
    Singleton.userInfo = self.curData[@"data"][@"Params"];
    
}
@end
