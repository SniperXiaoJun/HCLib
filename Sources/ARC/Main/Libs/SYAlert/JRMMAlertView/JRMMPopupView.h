//
//  JRMMPopupView.h
//  JRMMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRMMPopupItem.h"
#import "JRMMPopupWindow.h"
#import "JRMMPopupCategory.h"
#import "JRMMPopupDefine.h"

typedef NS_ENUM(NSUInteger, JRMMPopupType) {
    JRMMPopupTypeAlert,
    JRMMPopupTypeSheet,
    JRMMPopupTypeCustom,
};

@class JRMMPopupView;

typedef void(^JRMMPopupBlock)(JRMMPopupView *);
typedef void(^JRMMPopupCompletionBlock)(JRMMPopupView *, BOOL);

@interface JRMMPopupView : UIView

@property (nonatomic, assign, readonly) BOOL           visible;             // default is NO.

@property (nonatomic, strong          ) UIView         *attachedView;       // default is JRMMPopupWindow. You can attach JRMMPopupView to any UIView.

@property (nonatomic, assign          ) JRMMPopupType    type;                // default is MMPopupTypeAlert.
@property (nonatomic, assign          ) NSTimeInterval animationDuration;   // default is 0.3 sec.
@property (nonatomic, assign          ) BOOL           withKeyboard;        // default is NO. When YES, alert view with be shown with a center offset (only effect with MMPopupTypeAlert).

@property (nonatomic, copy            ) JRMMPopupCompletionBlock   showCompletionBlock; // show completion block.
@property (nonatomic, copy            ) JRMMPopupCompletionBlock   hideCompletionBlock; // hide completion block

@property (nonatomic, copy            ) JRMMPopupBlock   showAnimation;       // custom show animation block.
@property (nonatomic, copy            ) JRMMPopupBlock   hideAnimation;       // custom hide animation block.

/**
 *  override this method to show the keyboard if with a keyboard
 */
- (void) showKeyboard;

/**
 *  override this method to hide the keyboard if with a keyboard
 */
- (void) hideKeyboard;


/**
 *  show the popup view
 */
- (void) show;

/**
 *  show the popup view with completiom block
 *
 *  @param block show completion block
 */
- (void) showWithBlock:(JRMMPopupCompletionBlock)block;

/**
 *  hide the popup view
 */
- (void) hide;

/**
 *  hide the popup view with completiom block
 *
 *  @param block hide completion block
 */
- (void) hideWithBlock:(JRMMPopupCompletionBlock)block;

/**
 *  hide all popupview with current class, eg. [JRMMAlertView hideAll];
 */
+ (void) hideAll;

@end
