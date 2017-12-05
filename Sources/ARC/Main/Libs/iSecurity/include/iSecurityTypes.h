//
//  iSecurityTypes.m
//  SA iSecurity Safety Input System for iOS
//
//  This file was created by Wang Xuesong on 12-3-9
//
//  Copyright 2012年 北京科蓝软件系统有限公司. All rights reserved.
//

#ifndef iSecurity_iSecurityTypes_h
#define iSecurity_iSecurityTypes_h

#define LANDSCAPE_FRAME_HD  (CGRectMake(0, 44, 1024, 351))
#define PORTRAIT_FRAME_HD   (CGRectMake(0, 44, 768, 263))

#define PORTRAIT_FRAME      (CGRectMake(0, 44, 320, 216))
#define LANDSCAPE_FRAME     (CGRectMake(0, 44, 480, 161))

#define V_OK                                0
#define V_ERROR_EMPTY                       -1
#define V_ERROR_TOO_SHORT                   -2
#define V_ERROR_NOT_ACCEPT                  -3
#define V_ERROR_SIMPLE_PASSWORD             -4
#define V_ERROR_DICTIONARY_PASSWORD         -5
#define V_ERROR_TYPE_NO_MATCH               -6
#define V_ERROR_UNKNOWN                     -10

#define V_DICTIONARY_SEPARATOR              ','

#define V_CONTENTTYPE_ANY                   0x00000000
#define V_CONTENTTYPE_NUM                   0x00000001
#define V_CONTENTTYPE_LETTER                0x00000002
#define V_CONTENTTYPE_PUNCT                 0x00000004

/**********************************************************
 *
 * KeyboardTypeLowerCaseLetter     //小写字母键盘
 * KeyboardTypeCapitalLetter       //大写字母键盘
 * KeyboardTypeNumber              //数字键盘
 * KeyboardTypeSymbol              //符号键盘
 * KeyboardTypePinNumber           //用来输入纯数字的iPhone键盘
 *
 *********************************************************/
typedef enum {
    KeyboardTypeLowerCaseLetter,
    KeyboardTypeCapitalLetter,
    KeyboardTypeNumber,
    KeyboardTypeSymbol,
    KeyboardTypePinNumber
} KeyboardType;

@protocol KeyboardDelegate <NSObject>
@required
- (void)appendCharacter:(unichar)aChar;
- (void)backspace;
- (void)enter;
- (NSUInteger)textLength;
- (void)clear;
- (void)reloadKeyboard;
@end

#endif
