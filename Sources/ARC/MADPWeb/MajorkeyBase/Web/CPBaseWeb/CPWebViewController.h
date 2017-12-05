//
//  CPWebViewController.h
//  CPPlugins
//
//  Created by liurenpeng on 7/27/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPWebView.h"
#import "CPUIBackButton.h"
/*!
 * @class
 * @abstract WebViewController基类
 */

typedef void (^CPWebBlock)(id responseData);
@interface CPWebViewController : UIViewController <UIWebViewDelegate> {
    //NSString* webUrl;
}

/*!
 * @property
 * @abstract id
 */
@property (nonatomic, copy) NSString* webActionId;
/*!
 * @property
 * @abstract 参数
 */

@property (nonatomic, copy) NSDictionary * webParams;
/*!
 * @property
 * @abstract 访问url
 */

@property (nonatomic, strong, setter=setWebUrl:,getter=getWebUrl) NSString* webUrl;
/*!
 * @property
 * @abstract 当前的webview
 */

@property (nonatomic, strong) CPWebView* webView;
/*!
 * @property
 * @abstract 返回按钮
 */
@property (nonatomic, strong) CPUIBackButton* backButton;

/*!
 * @property
 * @abstract 右侧导航按钮
 */
@property (nonatomic, strong) UIButton* rightButton;

/*!
 * @property
 * @abstract 回调
 */
@property (nonatomic, strong) CPWebBlock webViewControllerBlock;

/*!
 * @method
 *
 * @abstract 增加webView
 *
 */
- (id)initWithActionId:(NSString*)actionId;
/*!
 * @method
 *
 * @abstract 加载webview
 *
 */

- (void)__loadView;
/*!
 * @method
 *
 * @abstract web页选项卡进行切换
 *
 */

- (BOOL)reloadSeletcIndexView:(NSInteger)index;
/*!
 * @method
 * @
 重新加载webview
 *
 */
- (void)reloadWebView;
/*!
 * @method
 *
 * @abstract 返回按钮事件
 *
 */
- (void)backAction;

/*!
 * @method
 * @abstract 返回数据
 *
 */
- (void)reciveWithData:(NSDictionary*)aDictionary withComplete:(void (^)(id responseData))completeBlock;

@end
