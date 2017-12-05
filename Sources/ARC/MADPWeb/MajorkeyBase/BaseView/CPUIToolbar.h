//
//  CSIIUIToolbar.h
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-5-8.
//  Copyright (c) 2013年 科蓝公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifdef __IPHONE_7_0
@protocol CPUIToolbarDelegate <UIToolbarDelegate>
#else
@protocol CPUIToolbarDelegate <NSObject>
#endif
@required
-(void)backToToday;
-(void)hiddenKeyboard;
-(void)frontNextAction:(int)index;
@end
@interface CPUIToolbar : UIToolbar
{
@private
    UISegmentedControl *backToTodaySegmented;
#if __has_feature(objc_arc_weak)
    __weak id <CPUIToolbarDelegate>delegate;
#else
	__unsafe_unretained id <CPUIToolbarDelegate>delegate;
#endif
}
#if __has_feature(objc_arc_weak)
@property (nonatomic, weak) id <CPUIToolbarDelegate>delegate;
#else
@property (nonatomic, unsafe_unretained) id <CPUIToolbarDelegate>delegate;
#endif
@property (nonatomic, strong) UISegmentedControl *backToTodaySegmented;
@end
