//
//  CPApp.h
//  CSIIPlatformLib
//
//  Created by liurenpeng on 6/30/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//
#import "CPPlugin.h"
/*!
 * @class
 * @abstract CPApp插件，处理Activity级事件。
 */
@interface CPApp : CPPlugin

/*!
 * @method
 * @abstract webView加载新的Url。
 * @result 返回值通过pluginResponseCallback  类型 string
 */

//干掉
- (void)LoadUrl;
/*!
 * @method
 * @abstract webview回退，回退结果以字符串形式返回“true”或“false”。
 * @result 返回值通过pluginResponseCallback  类型 string
 */

//干掉
- (void)GoBack;
/*!
 * @method
 * @abstract 退出当前activity。
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (void)Exit;
/*!
 * @method
 * @abstract webview清理历史记录，执行完成以空字符串形式返回
 * @result 返回值通过pluginResponseCallback  类型 string
 */
//干掉

- (void)ClearHistory;
/*!
 * @method
 * @abstract webview清理缓存，执行完成以空字符串形式返回
 * @result 返回值通过pluginResponseCallback  类型 string
 */
//干掉

- (void)ClearCache;
@end
