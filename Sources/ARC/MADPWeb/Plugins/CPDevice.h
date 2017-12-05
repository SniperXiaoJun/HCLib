//
//  CPDevice.h
//  CSIIPlatformLib
//
//  Created by 任兴 on 15/6/18.
//  Copyright (c) 2015年 刘任朋. All rights reserved.
//

#import "CPPlugin.h"
/*!
 * @class
 * @abstract CPDevice设备信息插件，提供js获取设备信息功能。
 */
@interface CPDevice : CPPlugin
/*!
 * @method
 * @abstract 获取设备信息
 * @discussion：信息包含：
 * @discussion：VersionName：应用版本名
 * @discussion：Platform：设备平台（Android/Ios/Windows Phone）
 * @discussion：Uuid：设备唯一标示
 * @discussion：Model：设备型号
 * @discussion：OSVersion：设备系统版本
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(void)DeviceInfo;
/*!
 * @method
 * @abstract 应用程序版本名
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (NSString*)VersionName;
/*!
 * @method
 * @abstract 设备平台
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (NSString*)Platform;
/*!
 * @method
 * @abstract 设备唯一标识符(UUID)
 * @result 返回值通过pluginResponseCallback  类型 string
 */

- (NSString*)Uuid;
/*!
 * @method
 * @abstract 设备型号
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (NSString*)Model;
/*!
 * @method
 * @abstract 设备系统版本
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (NSString *)OSVersion;
/*!
 * @method
 * @abstract 获取网络连接信息(2g/3g/4g/wifi/none)
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(NSString *)NetworkMsg;
/*!
 * @method
 * @abstract 获取网络连接状态(true/false)
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(NSString *)NetworkStatus;
@end
