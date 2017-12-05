//
//  CustomAlertView.h
//  IOS7CustomAlertView
//
//  Created by hanruimin on 13-10-11.
//  Copyright (c) 2013年 hanruimin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
  CustomAlertViewType_Msg_TwoBtn = 1, //含有title，提示内容以及两个button.
  CustomAlertViewType_Msg_OneBtn, //含有title，提示内容以及一个button.
  CustomAlertViewType_ActivityIndiAndMsg_OneBtn, //含有title，UIActivityIndicatorView控件,提示内容以及一个button.
  CustomAlertViewType_View_OneBtn, //含有title，一个UIView控件以及一个button.
  CustomAlertViewType_Msg_CustomTextField_TwoBtn, //含有title，定制的textfield，提示内容以及两个button.
  CustomAlertViewType_Msg_TextField_TwoBtn, //含有title，textfield，提示内容以及两个button.
  CustomAlertViewType_JalBreakBuy_Login, //含title,两个button，密码输入textfield，用户名等提示信息
  CustomAlertViewType_RemindTime,

} CustomAlertViewType;

@protocol CustomAlertViewDelegate;

@interface CSIICustomAlertView : UIView <UITextFieldDelegate> {
  CustomAlertViewType _alertViewType;
  id<CustomAlertViewDelegate> _customDelegate;

  UILabel *titleLabel;
  UILabel *contentLabel;

  UIButton *leftBtn;
  UIButton *rightBtn;
  UIButton *centerBtn;

  UIActivityIndicatorView *indicatorView;

  UITextField *textField;

  UIView *_alertView;
  UIView *_bgView;
}

@property(nonatomic, retain) id<CustomAlertViewDelegate> customDelegate;
@property(nonatomic, retain) UILabel *contentLabel;
@property(nonatomic, retain) UITextField *textField;

//含有title，提示内容以及两个button.
- (id)initWithTitle:(NSString *)title
                msg:(NSString *)msg
      rightBtnTitle:(NSString *)rightTitle
       leftBtnTitle:(NSString *)leftTitle
           delegate:(id<CustomAlertViewDelegate>)_delegate;

- (id)initWithTitle:(NSString *)title
                msg:(NSString *)msg
      rightBtnTitle:(NSString *)rightTitle
       leftBtnTitle:(NSString *)leftTitle
           delegate:(id<CustomAlertViewDelegate>)_delegate
        msgFontSize:(CGFloat)fontSize;
//含有title，提示内容以及一个button.
- (id)initWithTitle:(NSString *)title
                msg:(NSString *)msg
     centerBtnTitle:(NSString *)centerTitle;

//含有title，UIActivityIndicatorView控件,提示内容以及一个button.
- (id)initProgressAlertViewWithTitle:(NSString *)title
                                 msg:(NSString *)msg
                      centerBtnTitle:(NSString *)centerTitle
                            delegate:(id<CustomAlertViewDelegate>)_delegate;

//含有title，一个定制的UIView控件以及一个button.
- (id)initWithCustomView:(UIView *)customView
                   title:(NSString *)title
          centerBtnTitle:(NSString *)centerTitle
                delegate:(id<CustomAlertViewDelegate>)_delegate;

//含有title，定制的textfield，提示内容以及两个button.
- (id)initWithCustomTextField:(UITextField *)customTextField
                        title:(NSString *)title
                          msg:(NSString *)msg
                rightBtnTitle:(NSString *)rightTitle
                 leftBtnTitle:(NSString *)leftTitle
                     delegate:(id<CustomAlertViewDelegate>)_delegate;

//含有title，textfield，提示内容以及两个button.
- (id)initTextFieldWithTitle:(NSString *)title
                         msg:(NSString *)msg
               rightBtnTitle:(NSString *)rightTitle
                leftBtnTitle:(NSString *)leftTitle
                    delegate:(id<CustomAlertViewDelegate>)_delegate;

//含title,两个button，密码输入textfield，用户名等提示信息
- (id)initLoginWithDelegate:(id<CustomAlertViewDelegate>)delegate
                     userId:(NSString *)userid
                      title:(NSString *)strTitle
              rightBtnTitle:(NSString *)strRbt;

//只显示一条信息
- (id)initWithFrame:(CGRect)frame WithMsg:(NSString *)msg;

- (id)initRemindAlert;

- (void)showAfterDelay:(NSTimeInterval)delay;
- (void)show;

- (void)hideAlertView;

- (void)setTitle:(NSString *)title;
@end

@protocol CustomAlertViewDelegate <NSObject>

@optional

- (void)leftBtnPressedWithinalertView:(CSIICustomAlertView *)alert;
- (void)rightBtnPressedWithinalertView:(CSIICustomAlertView *)alert;
- (void)centerBtnPressedWithinalertView:(CSIICustomAlertView *)alert;

@end
