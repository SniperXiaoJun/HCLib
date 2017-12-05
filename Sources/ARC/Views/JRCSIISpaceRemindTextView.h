//
//  JRCSIISpaceRemindTextView.h
//  CsiiMobileFinance
//
//  Created by  高鹏飞 on 2017/3/6.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JRCSIISpaceRemindTextViewBlock)();

@interface JRCSIISpaceRemindTextView : UIView

@property (nonatomic,copy)JRCSIISpaceRemindTextViewBlock JRCSIISpaceRemindTextViewBlock;

+(JRCSIISpaceRemindTextView *)shareInstance;

-(void)show:(JRCSIISpaceRemindTextViewBlock)JRCSIISpaceRemindTextViewBlock;

@property (nonatomic,strong) NSDictionary  *dataDict;

@property (nonatomic,copy) NSString * TrsPassword;

@property (nonatomic,copy) NSDictionary *formDic;


@end
