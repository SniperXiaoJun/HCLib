//
//  JRBLMCameraViewController.h
//  CustomCamera
//
//  Created by michael on 14-2-7.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+JRCutImage.h"

typedef NS_ENUM(NSInteger, CameraUseType) {
    CameraUseFront,
    CameraUseBack,
    CameraUseAll
};

@protocol JRBLMCameraViewControllerDelegate <NSObject>

-(void)cameraFinish:(UIImage *)image;

@end

@interface JRBLMCameraViewController : UIPageViewController<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *photoView;
@property (nonatomic, strong) UIButton *takePhotoButton;
@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *positionButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, assign) CameraUseType cameraType;

@property (nonatomic, assign) BOOL  allowedEdit;

@property (nonatomic, assign) id<JRBLMCameraViewControllerDelegate> delegate;

@end
