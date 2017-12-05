//
//  CPPushView.h
//  CSIIPlatformLib
//
//  Created by liurenpeng on 6/23/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CPPlugin.h"

/*!
 * @class
 * @abstract CPAction插件，用于处理js活动请求。
 */

@interface CPAction : CPPlugin
/*!
 * @method
 * @abstract 打开原生页面窗口
 * @discussion：参数格式：JSON
 * @param js端传过来的参数
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (void)StartNativeAction;
/*!
 * @method
 * @abstract 调用系统浏览器显示url
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (void)StartSystemBrowserAction;

@end
