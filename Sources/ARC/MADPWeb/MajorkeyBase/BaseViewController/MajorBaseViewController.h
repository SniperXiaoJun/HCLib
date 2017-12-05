//
//  MajorBaseViewController.h
//  MobileClient
//
//  Created by wangfaguo on 13-7-17.
//  Copyright (c) 2013年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MajorBaseBlock)(id responseData);
@interface MajorBaseViewController : UIViewController <UITextFieldDelegate> {
    NSMutableArray* inputControls;
}
@property (nonatomic) BOOL changBackGround;
@property (strong, nonatomic) UIButton* leftButton;
@property (strong, nonatomic) UIButton* rightButton;
@property (strong, nonatomic) UISwipeGestureRecognizer* Swipe;
@property (strong, nonatomic) NSMutableArray* inputControls;
@property (strong, nonatomic) UIImageView* backgroundView;
@property (strong, nonatomic) NSDictionary* superDic;
@property (strong, nonatomic) MajorBaseBlock majorBaseViewControllerBlock;

/*!
 @method
 @abstract 左侧按钮点击事件
 */

- (void)leftButtonAction:(id)sender;
/*!
 @method
 @abstract 右侧按钮点击事件
 */

- (void)rightButtonAction:(id)sender;
/*!
 @method
 @abstract 隐藏导航栏的logo
 */


-(void)hiddenNavigationBarLogo;
/*!
 @method
 @abstract 数据接收以及回调
 */
- (void)reciveWithData:(NSDictionary*)aDictionary withComplete:(void (^)(id responseData))completeBlock;

@end
