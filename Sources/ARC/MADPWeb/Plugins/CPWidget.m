//
//  CPWidget.m
//  CPPlugins
//
//  Created by 任兴 on 15/7/16.
//  Copyright (c) 2015年 刘任朋. All rights reserved.
//

#import "CPWidget.h"
#import "CPCustomUIToolbar.h"
@implementation CPWidget

- (void)DatePicker {
  isDatePicker = YES;
  isTimePicker = NO;
  [self addPickView];
}
- (void)TimePicker {
  isDatePicker = NO;
  isTimePicker = YES;
  [self addPickView];
}
- (void)ListPicker {

  arrList = [[NSArray alloc]
      initWithArray:(NSArray *)self.curData[@"data"][@"Params"]];

  UIPickerView *pickerView = [[UIPickerView alloc]
      initWithFrame:CGRectMake(0.0, view.frame.size.height - 216.0, 0.0, 0.0)];
  pickerView.delegate = self;
  pickerView.dataSource = self;

  crossTypeField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  CPCustomUIToolbar *textFieldToolbar = [[CPCustomUIToolbar alloc] init];
  textFieldToolbar.delegate = self;
  crossTypeField.inputAccessoryView = textFieldToolbar;
  crossTypeField.borderStyle = UITextBorderStyleNone;
  crossTypeField.inputView = pickerView;
  crossTypeField.hidden = YES;
  [crossTypeField becomeFirstResponder];
  [self.curViewController.view addSubview:crossTypeField];
}

- (void)addPickView {

  UIDatePicker *inputDatePickerView = [[UIDatePicker alloc]
      initWithFrame:CGRectMake(0.0, view.frame.size.height - 216.0, 0.0, 0.0)];
  if (isTimePicker) {
    [inputDatePickerView setDatePickerMode:UIDatePickerModeTime];

  } else {
    [inputDatePickerView setDatePickerMode:UIDatePickerModeDate];
  }
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];

  inputDatePickerView.date =
      [dateFormatter dateFromString:self.curData[@"data"][@"Params"]];
  //    PickerViewDate = self.curData[@"data"][@"Params"];
  //    self.pluginResponseCallback(PickerViewDate);

  [inputDatePickerView addTarget:self
                          action:@selector(setDateInfo:)
                forControlEvents:UIControlEventValueChanged];

  crossTypeField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  CPUIToolbar *textFieldToolbar = [[CPUIToolbar alloc] init];
  textFieldToolbar.delegate = self;

  crossTypeField.inputAccessoryView = textFieldToolbar;
  crossTypeField.borderStyle = UITextBorderStyleNone;
  crossTypeField.inputView = inputDatePickerView;
  crossTypeField.hidden = YES;
  [crossTypeField becomeFirstResponder];

  [self.curViewController.view addSubview:crossTypeField];
}
- (void)backToToday {
}
- (void)frontNextAction:(int)index {
}
- (void)hiddenKeyboard;
{
  [crossTypeField resignFirstResponder];

  if ([PickerViewDate isEqualToString:@""] || PickerViewDate == nil) {
    PickerViewDate = self.curData[@"data"][@"Params"];
  }
  self.pluginResponseCallback(PickerViewDate);
    PickerViewDate=nil;
}
- (void)setDateInfo:(UIDatePicker *)sender;
{
  UIDatePicker *datePicker = (UIDatePicker *)sender;
  NSDate *date = datePicker.date;
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd"];

  if (isTimePicker) {

    [formatter setDateFormat:@"HH:mm:ss"];
  }
  PickerViewDate = [formatter stringFromDate:date];
}
- (void)cancelButtonClick:(UIButton *)sender {
  self.pluginResponseCallback(PickerViewDate);
    PickerViewDate=nil;

}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{ return 1; }
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component;
{ return [arrList count]; }
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  return arrList[row];
}
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {

  PickerViewDate = [arrList objectAtIndex:row];
}

@end
