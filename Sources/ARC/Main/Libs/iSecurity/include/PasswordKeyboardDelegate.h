//
//  PasswordKeyboardDelegate.h
//  SA iSecurity Safety Input System for iOS
//
//  This file was created by Wang Xuesong on 12-9-3
//
//  Copyright 2012年 北京科蓝软件系统有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iSecurityTypes.h"

typedef enum {
    Product = 0,
    Test,
    Development
} WorkMode;

@class Keyboard;

@interface PasswordKeyboardDelegate : NSObject <KeyboardDelegate> {
@protected
    BOOL usePasswordKeyboard;
    NSString *accepts;
    NSString *applicationPlatformModulus;
    NSString *encryptionPlatformModulus;
    NSString *timestamp;
    NSString *lastError;
    uint32_t encryptType;
    KeyboardType keyboardType;
    uint32_t minLength;
    uint32_t maxLength;
    NSString *maskChar;
    BOOL randomKeyboard;
    Keyboard *keyboard;
    NSMutableString *password;
    NSData *challengeCode;
    uint32_t contentType;
    BOOL passwordMode;
    NSString *secureKey;
    NSString *seed;
    WorkMode mode;
}

@property (nonatomic, assign) BOOL usePasswordKeyboard;
@property (nonatomic, retain) NSString *accepts;
@property (nonatomic, retain) NSString *applicationPlatformModulus;
@property (nonatomic, retain) NSString *encryptionPlatformModulus;
@property (nonatomic, retain) NSString *timestamp;
@property (nonatomic, retain) NSString *lastError;
@property (nonatomic, assign) uint32_t encryptType;
@property (nonatomic, assign) KeyboardType keyboardType;
@property (nonatomic, assign) uint32_t minLength;
@property (nonatomic, assign) uint32_t maxLength;
@property (nonatomic, retain) NSString *maskChar;
@property (nonatomic, assign) BOOL randomKeyboard;
@property (readonly) Keyboard *keyboard;
@property (nonatomic, retain) NSData *challengeCode;
@property (nonatomic, assign) uint32_t contentType;
@property (nonatomic, assign) BOOL passwordMode;
@property (nonatomic, retain) NSString *secureKey;
@property (nonatomic, retain) NSString *seed;
@property (nonatomic, assign) WorkMode mode;

- (id)initUsingPasswordKeyboard:(BOOL)use;
- (id)init;

- (BOOL)accept:(NSString*)appendString;
- (NSString*)getPassword;
- (NSString*)getPinPassword;
- (NSString*)getPasswordWithPan:(NSString*)pan;
- (NSString*)getPasswordWithUserName:(NSString*)name;
- (int8_t)getComplexDegree;
- (int32_t)verify;
- (NSString*)getEncryptedPinCode;

@end
