//
//  JRConsumeResultViewController.h
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/3/28.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRConsumeResultViewController : JRRootViewController
@property (nonatomic,copy)   NSString     *time;
@property (nonatomic,copy)   NSString     *amount;
@property (nonatomic,copy)   NSString     *JumpWay;
@property (nonatomic,copy)   NSString     *orderId;
@property (nonatomic,copy)   NSString     *tokenID;
//@property (nonatomic,copy)   NSString     *loanDate;
@property (nonatomic,strong) NSDictionary *NotiDic;
@end
