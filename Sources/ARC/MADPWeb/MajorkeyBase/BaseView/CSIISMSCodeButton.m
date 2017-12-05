//
//  SMSCodeButton.m
//  MobileClient
//
//  Created by 杨楠 on 14/8/21.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "CSIISMSCodeButton.h"
#import "CSIIConfigGlobalImport.h"
@interface CSIISMSCodeButton ()
{
    NSTimer* _clock;
    int _time; //秒
}
@end

@implementation CSIISMSCodeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.layer.cornerRadius = 5.0f;
//        self.layer.masksToBounds =  YES;
//        self.layer.borderWidth = 1.0f;
        [self setTitle:@"发送" forState:UIControlStateNormal];
        [self setBackgroundImage:JRBundeImage(@"messBtn_bg") forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addTarget:self action:@selector(getSMSCdodeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)getSMSCdodeAction {
    if ([self.phoneNumber isEqualToString:@""]) {
        ShowAlertView(@"提示", @"手机号不能为空", nil, @"完成", nil);
        return;
    }
    
    NSMutableDictionary*postDic = [[NSMutableDictionary alloc]init];
    [postDic setObject:self.phoneNumber forKey:@"MobileNo"];
    [postDic setObject:self.actionName forKey:@"BusinessName"];

//    [_session postToServer:@"GenTokenNameV1.do" actionParams:postDic method:@"POST"];
    [self startClock];
}

- (void)loopAction {
    if (_time == 0) {
        [self stopClock];
    } else {
        [self setTitle:[NSString stringWithFormat:@"%d", _time] forState:UIControlStateNormal];
        _time --;
        self.running = YES;
    }
}

- (void)startClock {
    self.userInteractionEnabled = NO;
    _time = 60; //1分钟
    _clock = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(loopAction) userInfo:nil repeats:YES];
}

- (void)stopClock {
    [self setTitle:@"重获" forState:UIControlStateNormal];
    [_clock invalidate];
    _time = 60;
    self.running = NO;
    self.userInteractionEnabled = YES;
}

@end
