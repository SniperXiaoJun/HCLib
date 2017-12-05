//
//  CPAlert.h
//  CSIIPlatformLib
//
//  Created by 任兴 on 15/6/18.
//  Copyright (c) 2015年 刘任朋. All rights reserved.
//

#import "CPPlugin.h"
#import "CSIICustomAlertView.h"

/*!
 * @class
 * @abstract CPAlert插件，处理js的提示请求。
 */

@interface CPAlert : CPPlugin<UIAlertViewDelegate,CustomAlertViewDelegate>

/*!
 * @method
 * @abstract 默认一个按钮的alert
 * @discussion：弹出框样式为系统默认，切包含按键回调，弹出框按钮为确定按钮和取消按钮。
 * @param js端传过来的data
 * @result 返回值通过pluginResponseCallback  类型 string
 */

-(void)ShowHintMsgDefaultAlert;
/*!
 * @method
 * @abstract 默认两个按钮的alert
 * @discussion：弹出框样式为系统默认，切包含按键回调，弹出框按钮为确定按钮和取消按钮。
 * @param js端传过来的data
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(void)ShowHintMsgDefaultConfirm;
/*!
 * @method
 * @abstract 自定义一个按钮的alert
 * @discussion：弹出框样式为系统默认，切包含按键回调，弹出框按钮为确定按钮和取消按钮。
 * @param js端传过来的data
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(void)ShowHintMsgCustomAlert;
/*!
 * @method
 * @abstract 自定义两个按钮的alert
 * @discussion：弹出框样式为系统默认，切包含按键回调，弹出框按钮为确定按钮和取消按钮。
 * @param js端传过来的data
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(void)ShowHintMsgCustomConfirm;
/*!
 * @method
 * @abstract 自定义一个按钮的alert
 * @discussion：弹出框样式为系统默认，切包含按键回调，弹出框按钮为确定按钮和取消按钮。
 * @param js端传过来的data
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (void)ShowHintMsgToast;


/*!
 * @method
 * @abstract 签约确认弹框（营口）
 * @discussion：弹出框样式为系统默认，切包含按键回调，弹出框按钮为签约按钮和取消按钮。
 * @param js端传过来的data
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(void)ShowSignConfirm;

@end
