//
//  JRCSIIAddAccountView.h
//  CsiiMobileFinance
//
//  Created by  高鹏飞 on 2017/3/6.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JRCSIIAddAccountViewBlock)();

@interface JRCSIIAddAccountView : UIView

@property (nonatomic,copy)JRCSIIAddAccountViewBlock JRCSIIAddAccountViewBlock;

+(JRCSIIAddAccountView *)shareInstance;

-(void)show:(JRCSIIAddAccountViewBlock)JRCSIIAddAccountViewBlock;


@property (nonatomic,strong)NSDictionary *dataDict;

@property (nonatomic,copy)NSString *TrsPassword;

@property (nonatomic,copy)NSDictionary *formDic;

@end
