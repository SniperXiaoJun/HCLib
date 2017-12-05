//
//  SMSCodeButton.h
//  MobileClient
//
//  Created by 杨楠 on 14/8/21.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSIISMSCodeButton : UIButton

@property (nonatomic, getter = isRunning)BOOL running;
@property (nonatomic, copy)NSString* phoneNumber;
@property (nonatomic, copy)NSString* actionName;

- (void)stopClock;

@end
