//
//  JRCSIIGeneralConfirmView.h
//  CsiiMobileFinance
//
//  Created by  高鹏飞 on 2017/3/6.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JRCSIIGeneralConfirmViewBlock)();


@interface JRCSIIGeneralConfirmView : UIView

@property (nonatomic,copy)JRCSIIGeneralConfirmViewBlock JRCSIIGeneralConfirmViewBlock;

+(JRCSIIGeneralConfirmView *)shareInstance;

-(void)show:(JRCSIIGeneralConfirmViewBlock)JRCSIIGeneralConfirmViewBlock;

@property (nonatomic,strong) NSDictionary  *dataDict;

@property (nonatomic,copy) NSString * TrsPassword;

@property (nonatomic,copy) NSDictionary *formDic;


@end
