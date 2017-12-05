//
//  PasswordTextField.h
//  SA iSecurity Safety Input System for iOS
//
//  This file was created by Wang Xuesong on 12-3-8
//
//  Copyright 2012年 北京科蓝软件系统有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iSecurityTypes.h"
#import "PasswordKeyboardDelegate.h"

@interface PasswordTextField : UITextField {
@private
    BOOL usePasswordKeyboard;
    PasswordKeyboardDelegate<UITextFieldDelegate> *passwordTextFieldDelegate;
}

@property (nonatomic, readonly) PasswordKeyboardDelegate<UITextFieldDelegate> *passwordTextFieldDelegate;
@property (nonatomic, assign) BOOL usePasswordKeyboard;
@property (nonatomic, retain) NSString *accepts;
@property (nonatomic, retain) NSString *applicationPlatformModulus;
@property (nonatomic, retain) NSString *encryptionPlatformModulus;
@property (nonatomic, assign) uint32_t encryptType;
@property (nonatomic, assign) KeyboardType kbdType;
@property (nonatomic, assign) uint32_t minLength;
@property (nonatomic, assign) uint32_t maxLength;
@property (nonatomic, retain) NSString *maskChar;
@property (nonatomic, assign) BOOL kbdRandom;

- (id)initWithCoder:(NSCoder *)aDecoder usingPasswordKeyboard:(BOOL)use;
- (id)initWithFrame:(CGRect)frame usingPasswordKeyboard:(BOOL)use;

- (void)setValue:(NSString*)value;
- (void)clear;
- (NSString*)getValue:(NSString*)timestamp;
- (NSString*)getValue:(NSString*)timestamp withPan:(NSString*)pan;
- (short)verify;
- (short)getLength;
- (char)getComplexDegree;
- (long)getVertion;
- (NSString*)lastError;

@end
