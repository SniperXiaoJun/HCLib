//
//  CPNotifyClient.m
//  CsiiMobileFinance
//
//  Created by  高鹏飞 on 2017/3/31.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "CPNotifyClient.h"

@implementation CPNotifyClient

- (void)notifyClientRefresh{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Client object:nil];
}
- (void)companyRefresh{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Client_Company object:nil];

}


@end
