//
//  CPExitToSJJ.m
//  Double
//
//  Created by 何崇 on 2017/11/28.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "CPExitToSJJ.h"

@implementation CPExitToSJJ

-(void)ExitToSJJ {
    if ([Singleton.SJJInfo[@"entrance"] isEqualToString:@"SJJPAY"]  ||
        [Singleton.SJJInfo[@"entrance"] isEqualToString:@"EDTZ"])
    {
        [Singleton.rootViewController popToViewController:Singleton.SJJOPenVC animated:YES];
    }
    //
}

@end
