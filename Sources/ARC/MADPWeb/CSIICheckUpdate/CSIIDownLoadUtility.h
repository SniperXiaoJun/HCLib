//
//  CSIIDownLoadUtility.h
//  CSIIPlatformLib
//
//  Created by liurenpeng on 8/19/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^CSIIDownLoadUtilityCallback)(id responsdata, BOOL success);
@interface CSIIDownLoadUtility : UIView <UIAlertViewDelegate>

/*!
 * @property
 * @abstract 下载回调
 * @result 返回结果
 */
@property(nonatomic, copy) CSIIDownLoadUtilityCallback downLoadFinishBlock;

/*!
 *  下载zip包
 *
 *  @param zipList             下载的列表
 *  @param downLoadResultBlock 返回下载结果
 */
- (void)downLoadWithList:(NSArray *)zipList
          downLoadFinish:(CSIIDownLoadUtilityCallback)downLoadResultBlock;
- (void)downLoadWithUrl:(NSString *)zipUrl downLoadFinish:(CSIIDownLoadUtilityCallback)downLoadResultBlock;

- (void)cancelDownload;
@end
