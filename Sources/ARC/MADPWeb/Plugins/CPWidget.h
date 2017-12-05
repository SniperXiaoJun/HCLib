//
//  CPWidget.h
//  CPPlugins
//
//  Created by 任兴 on 15/7/16.
//  Copyright (c) 2015年 刘任朋. All rights reserved.
//
#import "CPPlugin.h"
#import "CPUIToolbar.h"
@interface CPWidget : CPPlugin <UIPickerViewDataSource, UIPickerViewDelegate, CPUIToolbarDelegate> {

    UIView* view;
    NSString* PickerViewDate;
    BOOL isDatePicker;
    BOOL isTimePicker;
    UITextField* crossTypeField;
    NSArray* arrList;
}
- (void)DatePicker;
- (void)TimePicker;
- (void)ListPicker;
@end
