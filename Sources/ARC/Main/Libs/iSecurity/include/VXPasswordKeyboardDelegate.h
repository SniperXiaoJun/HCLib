//
//  VXPasswordKeyboardDelegate.h
//  SA iSecurity Safety Input System for iOS
//
//  This file was created by Wang Xuesong on 12-11-9
//
//  Copyright 2012年 北京科蓝软件系统有限公司. All rights reserved.
//

#import "PasswordKeyboardDelegate.h"
#import "iSecurityTypes.h"

@protocol VXDelegate
@optional
- (void)textLength:(NSInteger)length withKeyboardDelegate:(id<KeyboardDelegate>)delegate;
- (void)enterKeyPressedWithKeyboardDelegate:(id<KeyboardDelegate>)delegate;
- (void)invalidCharacter:(unichar)ch withKeyboardDelegate:(id<KeyboardDelegate>)delegate;
- (void)maxTextLength:(NSInteger)length withKeyboardDelegate:(id<KeyboardDelegate>)delegate;
@end

@interface VXPasswordKeyboardDelegate : PasswordKeyboardDelegate {
@protected
    id<VXDelegate> vxDelegate;
}
@property (nonatomic, assign) id<VXDelegate> vxDelegate;

@end
