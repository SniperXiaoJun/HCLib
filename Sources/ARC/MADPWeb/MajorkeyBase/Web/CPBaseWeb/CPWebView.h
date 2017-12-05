//
//  CSIIUIVXWebView.h
//  CSIIPlatformLib
//
//  Created by liurenpeng on 6/24/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
typedef void (^BackCallback)(id backResponseData);
/*!
 * @class
 * @abstract 自定义webview。
 */

@interface CPWebView : UIWebView {
    UIViewController* viewController;
    NSDictionary* pluginsDic;
    NSString* urlPath;
    NSString* actionId;
}
/*!
 * @property
 * @abstract 片段id
 */
@property (nonatomic, copy) NSString* actionId;
/*!
 * @property
 * @abstract 当前viewController
 */
@property (nonatomic, strong) UIViewController* viewController;
//@property (nonatomic, strong) NSDictionary* pluginsDic;

/*!
 * @property
 * @abstract 访问的url
 */

@property (nonatomic, strong) NSString* urlPath;
/*!
 * @property
 * @abstract 回调
 */
@property (nonatomic, strong) BackCallback BackCallback;
/*!
 * @property
 * @abstract 参数
 */
@property (nonatomic, strong) NSDictionary* params;

/*!
 * @method
 * @abstract 初始化UIWebView
 */
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;

/*!
 * @method
 * @abstract 注册插件
 */
- (void)registerPlugins;

/*!
 * @method
 * @abstract 原生调用js插件
 */
- (void)callHandler:(NSString*)handlerName data:(id)data;

/*!
 * @method
 * @abstract 原生调用js插件 带返回
 */
- (void)callHandler:(NSString*)handlerName
               data:(id)data
   responseCallback:(BackCallback)backResponseData;

/*!
 * @method
 * @abstract 重新加载
 */
- (void)loadUrl:(NSString*)_urlPath;

/*!
 *  @method
 *  @abstract 清除web cache
 */
- (void)clearWebCache;

/*!
 * @method
 * @abstract 重新加载当前WebView
 */
- (void)reloadWebView;
@end
