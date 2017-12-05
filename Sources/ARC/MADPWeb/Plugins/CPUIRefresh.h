//
//  CPUIRefresh.h
//  CSIIPlatformLib
//
//  Created by 任兴 on 15/6/30.
//  Copyright (c) 2015年 刘任朋. All rights reserved.
//

#import "CPPlugin.h"

/*!
 * @class
 * @abstract CPUIRefresh UI刷新插件
 */
@interface CPUIRefresh : CPPlugin

/*!
 * @method
 * @abstract 隐藏标题栏返回键按钮
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(void)HideBackButton;

/*!
 * @method
 * @abstract 显示标题栏返回键按钮
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(void)ShowBackButton;

/*!
 * @method
 * @abstract 设置标题栏title
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(void)SetTitle;

/*!
 * @method
 * @abstract 设置标题栏title
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (void)showRightText;

/*!
 * @method
 * @abstract 设置标题栏title
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (void)hideRightText;

@end
