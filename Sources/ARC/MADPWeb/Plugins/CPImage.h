//
//  CPCamera.h
//  CPPlugins
//
//  Created by 任兴 on 15/7/20.
//  Copyright (c) 2015年 刘任朋. All rights reserved.
//

#import "CPPlugin.h"

@interface CPImage : CPPlugin {

  UIPageControl *pageControl;
}

/*!
 * @method
 * @abstract  拍照或相册选取带剪辑
 * @result 返回值通过pluginResponseCallback  类型 base64string
 */

- (void)CaptureImage;
/*!
 * @method
 * @abstract  拍照或相册选取不带剪辑
 * @result 返回值通过pluginResponseCallback  类型 文件路径
 */
- (void)CapturePhoto;

/*!
 * @method
 * @abstract  拍照或相册选取带剪辑
 * @result 返回值通过pluginResponseCallback  类型 文件路径
 */

- (void)CapturePhotoCrop;

@end
