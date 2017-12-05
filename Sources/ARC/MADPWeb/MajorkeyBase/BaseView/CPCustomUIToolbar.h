//
//  CSIIUIToolBar.h
//  iPhoneTZBankClient
//
//  Created by 刘旺 on 11-8-7.
//  Copyright (c) 2011年 科蓝公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MajorBaseViewController.h" //属性被存放在基类中，取得对象的时候将基类加入避免编译提示错误
#import "CSIIUIToolbarDelegate.h"

@protocol CSIIUIToolbarDoneDelegate <NSObject>

- (void)csiiUItoolBarDoneAction;

@end

@interface CPCustomUIToolbar : UIToolbar <CSIIUIToolbarDelegate> {
@private
    id<CSIIUIToolbarDoneDelegate> DoneDelegate;
    id<CSIIUIToolbarDelegate> delegate;
    UISegmentedControl* segmentedControl1s;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) id DoneDelegate;
@property (nonatomic, retain) UISegmentedControl* segmentedControl1s;

- (void)hiddenKeyboardAction:(id)sender;
@end
