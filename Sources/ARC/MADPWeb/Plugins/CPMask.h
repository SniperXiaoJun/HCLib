//
//  CPMask.h
//  CSIIPlatformLib
//
//  Created by 任兴 on 15/6/30.
//  Copyright (c) 2015年 刘任朋. All rights reserved.
//

#import "CPPlugin.h"
/*!
 * @class
 * @abstract CPMask插件，用于js执行耗时操作时，屏蔽UI操作。
 */
@interface CPMask : CPPlugin

/*!
 * @method
 * @abstract 显示遮罩层
 */
- (void)ShowMask;

/*!
 * @method
 * @abstract 隐藏遮罩层
 */
- (void)HideMask;

///*!
// * @method
// * @abstract 单利方法
// */
//+ (CPMask *)sharedInstance;
//
///*!
// * @method
// * @abstract 添加遮罩层
// */
//-(void)addWindowMask;

@end
