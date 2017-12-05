//
//  CSIIUITableViewController.h
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-24.
//  Copyright (c) 2013年 科蓝公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
typedef void (^MajorBaseTableBlock)(id responseData);
@interface MajorBaseTableViewController : UITableViewController <UITextFieldDelegate> {
@private
    NSMutableArray* inputControls;
    NSMutableDictionary* rowHeightDictionary;
#if __has_feature(objc_arc_weak)
    __weak id delegate;
#else
    __unsafe_unretained id delegate;
#endif

    BOOL isShowKeyBoard;

    UISwipeGestureRecognizer* upSwipe;
}
@property (strong, nonatomic) UIButton* leftButton;
@property (strong, nonatomic) UIButton* rightButton;

#if __has_feature(objc_arc_weak)
@property (nonatomic, weak) id delegate;
;
#else
@property (nonatomic, unsafe_unretained) id delegate;
#endif
@property (nonatomic, strong) UISwipeGestureRecognizer* upSwipe;
@property (nonatomic, strong) NSMutableArray* inputControls;
@property (nonatomic, strong) NSMutableDictionary* rowHeightDictionary;
@property (nonatomic, retain) UIView* warmTipsView;
@property (strong, nonatomic) MajorBaseTableBlock majorBaseTableViewControllerBlock;

/*!
 @method
 @abstract 返回事件
 */

- (void)backAction;
/*!
 @method
 @abstract 隐藏导航栏logo
 */

-(void)hiddenNavigationBarLogo;
#pragma mark - 处理数据
- (void)reciveWithData:(NSDictionary*)aDictionary withComplete:(void (^)(id responseData))completeBlock;

@end
