//
//  JRCSIITextandTextView.h
//  CsiiMobileFinance
//
//  Created by  高鹏飞 on 2017/3/6.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JRCSIITextandTextViewBlock)();

@interface JRCSIITextandTextView : UIView

@property (nonatomic,copy)JRCSIITextandTextViewBlock JRCSIITextandTextViewBlock;

+(JRCSIITextandTextView *)shareInstance;

-(void)show:(JRCSIITextandTextViewBlock)JRCSIITextandTextViewBlock;

@property (nonatomic,strong) NSDictionary  *dataDict;

@property (nonatomic,copy) NSString * TrsPassword;

@property (nonatomic,copy) NSDictionary *formDic;

@end
