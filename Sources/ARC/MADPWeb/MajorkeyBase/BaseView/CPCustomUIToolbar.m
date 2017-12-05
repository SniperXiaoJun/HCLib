//
//  CSIIUIToolBar.m
//  iPhoneTZBankClient
//
//  Created by 刘旺 on 11-8-7.
//  Copyright (c) 2011年 科蓝公司. All rights reserved.
//

#import "CPCustomUIToolbar.h"

@implementation CPCustomUIToolbar
@synthesize delegate, segmentedControl1s;

- (id)init {

  self = [super
      initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,
                               44)];
  if (self != nil) {
    self.barStyle = UIBarStyleDefault;
    self.translucent = YES;
    // self.alpha = 1;

    NSMutableArray *buttons = [[NSMutableArray alloc] init];

    //        NSArray *buttonNames = [NSArray arrayWithObjects:@"前一项",
    //        @"后一项", nil];
    //        UISegmentedControl* segmentedControl = [[UISegmentedControl alloc]
    //        initWithItems:buttonNames];
    //        segmentedControl.momentary = YES;    //设置在点击后是否恢复原样
    //        segmentedControl.multipleTouchEnabled=NO;     //可触摸
    //        segmentedControl.segmentedControlStyle =
    //        UISegmentedControlStyleBar;
    //        [segmentedControl addTarget:self
    //        action:@selector(indexControlAction:)
    //        forControlEvents:UIControlEventValueChanged];
    //
    //        UIBarButtonItem *myButtonss = [[UIBarButtonItem
    //        alloc]initWithCustomView:segmentedControl];

    //        [buttons addObject:myButtonss];

    //        UIBarButtonItem *flexibleSpace1 = [[UIBarButtonItem alloc]
    //        initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
    //        target:nil action:nil];
    //        [buttons addObject:flexibleSpace1];

    NSArray *myButtons = [NSArray arrayWithObjects:@"回到今天", nil];
    self.segmentedControl1s =
        [[UISegmentedControl alloc] initWithItems:myButtons];
    self.segmentedControl1s.momentary = YES; //设置在点击后是否恢复原样
    self.segmentedControl1s.multipleTouchEnabled = NO; //可触摸
    self.segmentedControl1s.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.segmentedControl1s addTarget:self
                                action:@selector(setToday)
                      forControlEvents:UIControlEventValueChanged];

    UIBarButtonItem *myttonsss =
        [[UIBarButtonItem alloc] initWithCustomView:segmentedControl1s];
    [buttons addObject:myttonsss];
    self.segmentedControl1s.hidden = YES;

    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                             target:nil
                             action:nil];
    [buttons addObject:flexibleSpace];

    UIButton *doneButton = [[UIButton alloc]
        initWithFrame:CGRectMake(self.bounds.size.width - 50, 7, 45, 30)];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton
        setTitleColor:
            [UIColor colorWithRed:0.01f green:0.45f blue:0.88f alpha:1.00f]
             forState:UIControlStateNormal];
    doneButton.tag = 99999;

    [doneButton addTarget:self
                   action:@selector(hiddenKeyboardAction:)
         forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *doneBarButton =
      [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    [buttons addObject:doneBarButton];

//    [self addSubview:doneBarButton];

    [self setItems:buttons];
  }
  return self;
}

- (void)setToday;
{ [self.delegate setToday]; }

- (void)hiddenKeyboardAction:(id)sender {

  if ([self.DoneDelegate
          respondsToSelector:@selector(csiiUItoolBarDoneAction)]) {
    [self.DoneDelegate csiiUItoolBarDoneAction];
  }

  NSTimeInterval animationDuration = 0.30f;
  [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
  [UIView setAnimationDuration:animationDuration];


    
//  if ([[self.delegate delegate] isKindOfClass:[UIView class]]) {
//
//  } else if ([[self.delegate delegate]
//                 isKindOfClass:[UIViewController class]]) {
//  }

  [UIView commitAnimations];
  [self.delegate resignFirstResponder];
}

- (void)indexControlAction:(id)sender {
  MajorBaseViewController *vc =
      (MajorBaseViewController *)[self.delegate delegate];

  if ([[vc inputControls] count] == 1) {
    return;
  }
  int preIndex = 0;
  int nexIndex = 0;
  for (int i = 0; i < [[vc inputControls] count]; i++) {
    if ([[vc inputControls] objectAtIndex:i] == self.delegate) {
      if (i == 0) {
        preIndex = (int)[[vc inputControls] count] - 1;
        nexIndex = i + 1;
      } else if (i == [[vc inputControls] count] - 1) {
        preIndex = i - 1;
        nexIndex = 0;
      } else {
        preIndex = i - 1;
        nexIndex = i + 1;
      }
    }
  }
  switch ([sender selectedSegmentIndex]) {
  case 0:
    [self.delegate resignFirstResponder];
    [[[vc inputControls] objectAtIndex:preIndex] becomeFirstResponder];
    break;
  case 1:
    [self.delegate resignFirstResponder];
    [[[vc inputControls] objectAtIndex:nexIndex] becomeFirstResponder];
    break;
  default:
    break;
  }
}
-(void)csiiUItoolBarDoneAction{

}
@end
