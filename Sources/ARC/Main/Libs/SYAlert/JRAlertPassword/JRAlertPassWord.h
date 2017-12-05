//
//  JRAlertPassWord.h
//  ZXBAuthentication
//
//  Created by Summer on 16/1/27.
//  Copyright © 2016年 Shen Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^JRAlertPassWordBlock)();

typedef void(^CancelPassWordBlock)();

@interface JRAlertPassWord : UIView

@property (nonatomic,copy)JRAlertPassWordBlock JRAlertPassWordBlock;

@property (nonatomic,copy)CancelPassWordBlock cancelPassWordBlock;

+(JRAlertPassWord*)shareJRAlertPassWord;

-(void)show:(JRAlertPassWordBlock)JRAlertPassWordBlock;

-(void)show:(JRAlertPassWordBlock)JRAlertPassWordBlock withCancelBlock:(CancelPassWordBlock)cancelBlcok;

@property (nonatomic,copy) NSString *value;
- (void)JRAlertPassWordHide;
@end
