//
//  CPQRViewController.h
//  CPQRFunction
//
//  Created by 刘任朋 on 15/12/23.
//  Copyright © 2015年 刘任朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef void (^CPScanResult)(NSString* result, BOOL isSucceed);
@interface CPQRViewController : JRRootViewController <AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* captureVideoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession* captureSession;
@property (nonatomic, strong) CABasicAnimation* scanLineAnimation;
@property (nonatomic, strong) UIImageView* scanLineView;

/*!
 * @method
 * @abstract 初始化方法
 * @param 返回二维码信息
 * @discussion NULL
 * @result NULL
 */
- (id)initWithResult:(CPScanResult)result;
@end
