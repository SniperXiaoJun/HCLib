//
//  CSIIUIToolbar.m
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-5-8.
//  Copyright (c) 2013年 科蓝公司. All rights reserved.
//

#import "CPUIToolbar.h"

@implementation CPUIToolbar
@synthesize delegate;
@synthesize backToTodaySegmented;
- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (self) {
        self.barStyle = UIBarStyleBlack;
        self.alpha = 1;
        NSMutableArray* toolbarButtonArray = [[NSMutableArray alloc] init];
        NSArray* frontNextButtonArray = [NSArray arrayWithObjects:@"前一项", @"后一项", nil];
        UISegmentedControl* frontNextSegmented = [[UISegmentedControl alloc] initWithItems:frontNextButtonArray];
        frontNextSegmented.momentary = YES; //设置在点击后是否恢复原样
        frontNextSegmented.multipleTouchEnabled = NO; //可触摸
        frontNextSegmented.segmentedControlStyle = UISegmentedControlStyleBar;
        [frontNextSegmented addTarget:self action:@selector(frontNextAction:) forControlEvents:UIControlEventValueChanged];
        UIBarButtonItem* frontNextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:frontNextSegmented];
        [toolbarButtonArray addObject:frontNextButtonItem];
        UIBarButtonItem* leftItemFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolbarButtonArray addObject:leftItemFlexibleSpace];
        NSArray* backToTodayButtonArray = [NSArray arrayWithObjects:@"回到今天", nil];
        backToTodaySegmented = [[UISegmentedControl alloc] initWithItems:backToTodayButtonArray];
        backToTodaySegmented.momentary = YES; //设置在点击后是否恢复原样
        backToTodaySegmented.multipleTouchEnabled = NO; //可触摸
        backToTodaySegmented.segmentedControlStyle = UISegmentedControlStyleBar;
        [backToTodaySegmented addTarget:self action:@selector(backToToday) forControlEvents:UIControlEventValueChanged];
        UIBarButtonItem* backToTodayButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backToTodaySegmented];
        [toolbarButtonArray addObject:backToTodayButtonItem];
        backToTodaySegmented.hidden = YES;
        UIBarButtonItem* rightItemFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        for (int i = 0; i < 7; i++) {
            [toolbarButtonArray addObject:rightItemFlexibleSpace];
            rightItemFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        }

        [toolbarButtonArray addObject:rightItemFlexibleSpace];
        //        [self setItems:toolbarButtonArray];
        UIButton* doneButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 60, 3, 74, 38)];

        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        //        [doneButton setImage:[UIImage imageWithContentsOfFile:[CSIILibBundle getFileWithName:@"done.png"]] forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(hiddenKeyboardAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneButton];
    }
    return self;
}
- (void)backToToday;
{
    [self.delegate backToToday];
}
- (void)hiddenKeyboardAction:(id)sender
{
    [self.delegate hiddenKeyboard];
}
- (void)frontNextAction:(UISegmentedControl*)sender
{
    [self.delegate frontNextAction:(int)sender.selectedSegmentIndex];
}
@end
