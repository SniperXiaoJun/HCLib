//
//  JRBLMCameraViewController.m
//  CustomCamera
//
//  Created by michael on 14-2-7.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "JRBLMCameraViewController.h"
#import <ImageIO/ImageIO.h>
#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] intValue] >= 7)

@interface JRBLMCameraViewController ()
{
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_captureInput;
    AVCaptureStillImageOutput *_captureOutput;
    AVCaptureVideoPreviewLayer *_preview;
    AVCaptureDevice *_device;
    
    UIImage *_finishImage;
    
    UIView * cameraView;
    
    UIView * editView;
    
    UIScrollView * editScrollView;
    UIImageView * editImageView;
    
    //扫描框
    UIImageView * _identifyCard;
}

@end

@implementation JRBLMCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.allowedEdit = YES;//默认为NO
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCameraUI];
    [self initialize];
    
    _preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    _preview.frame = CGRectMake(0, 0, self.photoView.frame.size.width, self.photoView.frame.size.height);
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    _identifyCard = [[UIImageView alloc]initWithFrame:_preview.frame];
    
    [_preview addSublayer:_identifyCard.layer];
    [self.photoView.layer addSublayer:_preview];

    [_session startRunning];
    
    switch (_cameraType) {
        case CameraUseFront:
        {
            if (IPHONE5) {
                _identifyCard.image = [UIImage imageNamed:@"zm_01sm"];
            }
            else{
                _identifyCard.image = [UIImage imageNamed:@"zm_02sm"];
            }
        }
            break;
        case CameraUseBack:
        {
            if (IPHONE5) {
                _identifyCard.image = [UIImage imageNamed:@"bm_01sm"];
            }
            else{
                _identifyCard.image = [UIImage imageNamed:@"bm_02sm"];
            }
        }
            break;
        case CameraUseAll:
        {
            if (IPHONE5) {
                _identifyCard.image = [UIImage imageNamed:@"sc_01sm"];
            }
            else{
                _identifyCard.image = [UIImage imageNamed:@"sc_02sm"];
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)setCameraType:(CameraUseType)cameraType{
    _cameraType = cameraType;
}
- (BOOL)prefersStatusBarHidden:(BOOL)hidden
{
    return hidden;//隐藏为YES，显示为NO
}

-(void)initCameraUI
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden:YES];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    cameraView = [[UIView alloc] initWithFrame:self.view.bounds];
    cameraView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:cameraView];
    //闪光灯，切换前后摄像头
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,cameraView.frame.size.width, 50.0f)];
    topView.backgroundColor = [UIColor blackColor];
    [cameraView addSubview:topView];
    
    _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _flashButton.frame = CGRectMake(20, 3, 44, 44);
    _flashButton.backgroundColor = [UIColor clearColor];
    [_flashButton addTarget:self action:@selector(changeFlash:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_flashButton];
    
    _positionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _positionButton.frame = CGRectMake(240, 3, 44, 44);
    _positionButton.backgroundColor = [UIColor clearColor];
    [_positionButton setImage:[UIImage imageNamed:@"front-camera"] forState:UIControlStateNormal];
    [_positionButton addTarget:self action:@selector(positionCnange:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_positionButton];
    
    //取消，拍照
    UIView * bottomView = [[UIView alloc] init];
    if (IOS7_OR_LATER) {
        bottomView.frame = CGRectMake(0, cameraView.frame.size.height-64, cameraView.frame.size.width, 64);
    }
    else{
        bottomView.frame = CGRectMake(0, cameraView.frame.size.height-44, cameraView.frame.size.width, 64);
    }
    bottomView.backgroundColor = [UIColor blackColor];
    [cameraView addSubview:bottomView];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(20, 10, 44, 44);
    _cancelButton.backgroundColor = [UIColor clearColor];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_cancelButton];
    
    _takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _takePhotoButton.frame = CGRectMake(bottomView.frame.size.width/2.0-25, 7, 50, 50);
    _takePhotoButton.backgroundColor = [UIColor clearColor];
    [_takePhotoButton setTitle:@"拍照" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_takePhotoButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_takePhotoButton setImage:[UIImage imageNamed:@"take"] forState:UIControlStateNormal];
    [bottomView addSubview:_takePhotoButton];
    //相机背景图
    _photoView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height, cameraView.frame.size.width, cameraView.frame.size.height - topView.frame.size.height - bottomView.frame.size.height)];
    _photoView.backgroundColor = [UIColor blackColor];
    [cameraView addSubview:_photoView];
}

-(void)initEditViewWithImage:(UIImage *)image
{
    editView = [[UIView alloc] initWithFrame:self.view.bounds];
    editView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:editView];
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,editView.frame.size.width, 50.0f)];
    topView.backgroundColor = [UIColor blackColor];
    [editView addSubview:topView];
    
    if (self.allowedEdit) {
        UILabel * titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(topView.frame.size.width/2.0f-75.0f, 0, 150, 50)];
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.text = @"缩放和移动";
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.textColor = [UIColor whiteColor];
        [topView addSubview:titleLbl];
    }
    
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, editView.frame.size.height-64, editView.frame.size.width, 64)];
    bottomView.backgroundColor = [UIColor blackColor];
    [editView addSubview:bottomView];
    
    editScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height, editView.frame.size.width, editView.frame.size.height - topView.frame.size.height - bottomView.frame.size.height)];
    [editScrollView setBackgroundColor:[UIColor blackColor]];
    [editScrollView setDelegate:self];
    [editScrollView setShowsHorizontalScrollIndicator:NO];
    [editScrollView setShowsVerticalScrollIndicator:NO];
    
    if (self.allowedEdit) {
        [editScrollView setMaximumZoomScale:2.0];
    }else
        [editScrollView setMaximumZoomScale:1.0];
    
    
    editImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, editScrollView.frame.size.width, editScrollView.frame.size.height)];
    editImageView.image = image;
    [editImageView setContentMode:UIViewContentModeScaleAspectFit];

    [editScrollView setContentSize:[editImageView frame].size];
    [editScrollView setMinimumZoomScale:[editScrollView frame].size.width / [editImageView frame].size.width];
    [editScrollView setZoomScale:[editScrollView minimumZoomScale]];
    [editScrollView addSubview:editImageView];
    
    [editView addSubview:editScrollView];
    
    UIButton * editCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editCancelButton.frame = CGRectMake(20, 10, 44, 44);
    editCancelButton.backgroundColor = [UIColor clearColor];
    [editCancelButton setTitle:@"重拍" forState:UIControlStateNormal];
    [editCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editCancelButton addTarget:self action:@selector(editCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:editCancelButton];
    
    UIButton * editSaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editSaveButton.frame = CGRectMake(bottomView.frame.size.width - 104, 10, 84, 44);
    editSaveButton.backgroundColor = [UIColor clearColor];
    [editSaveButton setTitle:@"使用照片" forState:UIControlStateNormal];
    [editSaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editSaveButton addTarget:self action:@selector(editSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:editSaveButton];
}

-(void)initialize
{
    //1.创建会话层
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPreset640x480];
    
    //2.创建、配置输入设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [_device lockForConfiguration:nil];
    if([_device flashMode] == AVCaptureFlashModeOff){
        [_flashButton setImage:[UIImage imageNamed:@"flash-off"] forState:UIControlStateNormal];
    }
    else if([_device flashMode] == AVCaptureFlashModeAuto){
        [_flashButton setImage:[UIImage imageNamed:@"flash-auto"] forState:UIControlStateNormal];
    }
    else{
        [_flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
    }
    [_device unlockForConfiguration];
    
	NSError *error;
	_captureInput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
	if (!_captureInput)
	{
		NSLog(@"Error: %@", error);
		return;
	}
    [_session addInput:_captureInput];
    
    
    //3.创建、配置输出
    _captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [_captureOutput setOutputSettings:outputSettings];
	[_session addOutput:_captureOutput];
}

- (UIImage *)composeImage:(UIImage *)subImage toImage:(UIImage *)superImage atFrame:(CGRect)frame
{
    CGSize superSize = superImage.size;
    CGFloat widthScale = frame.size.width / self.photoView.frame.size.width;
    CGFloat heightScale = frame.size.height / self.photoView.frame.size.height;
    CGFloat xScale = frame.origin.x / self.photoView.frame.size.width;
    CGFloat yScale = frame.origin.y / self.photoView.frame.size.height;
    CGRect subFrame = CGRectMake(xScale * superSize.width, yScale * superSize.height, widthScale * superSize.width, heightScale * superSize.height);
    
    UIGraphicsBeginImageContext(superSize);
    [superImage drawInRect:CGRectMake(0, 0, superSize.width, superSize.height)];
    [subImage drawInRect:subFrame];
    __autoreleasing UIImage *finish = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finish;
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == position)
        {
            return device;
        }
    }
    return nil;
}

- (void)addHollowOpenToView
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2f;
    animation.delegate = self;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionFade;
    [self.view.layer addAnimation:animation forKey:@"animation"];
    UIView * whiteView = [[UIView alloc] initWithFrame:_photoView.frame];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.alpha = 0.0f;
    [self.view addSubview:whiteView];
    [UIView animateWithDuration:0.1 animations:^{
        whiteView.alpha = 0.5f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            whiteView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [whiteView removeFromSuperview];
            [self.view bringSubviewToFront:editView];
        }];
    }];
}
#pragma mark - IBAction

- (void)takePhoto:(id)sender
{
    //get connection
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    UIDevice *device = [UIDevice currentDevice];
    if (device.orientation == UIDeviceOrientationFaceUp || device.orientation == UIDeviceOrientationPortrait) {
        //平躺向上，直立
        [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    else if (device.orientation == UIDeviceOrientationFaceDown || device.orientation == UIDeviceOrientationPortraitUpsideDown) {
        //平躺向下，颠倒
        [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
    }
    else if (device.orientation == UIDeviceOrientationLandscapeLeft) {
        //左
        [videoConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
    else if (device.orientation == UIDeviceOrientationLandscapeRight) {
        //右
        [videoConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
    }
    else{
        [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    //get UIImage
    [_captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         
         CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             // Do something with the attachments.
         }
         // Continue as appropriate.
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         _finishImage = [[UIImage alloc] initWithData:imageData];
         _finishImage = [_finishImage fixOrientation];
         
         [self initEditViewWithImage:_finishImage];
         [self addHollowOpenToView];
     }];
}

- (void)changeFlash:(id)sender
{
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] && [_device hasFlash])
    {
        [_flashButton setEnabled:NO];
        [_device lockForConfiguration:nil];
        if([_device flashMode] == AVCaptureFlashModeOff)
        {
            [_device setFlashMode:AVCaptureFlashModeAuto];
            [_flashButton setImage:[UIImage imageNamed:@"flash-auto"] forState:UIControlStateNormal];
        }
        else if([_device flashMode] == AVCaptureFlashModeAuto)
        {
            [_device setFlashMode:AVCaptureFlashModeOn];
            [_flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
        }
        else{
            [_device setFlashMode:AVCaptureFlashModeOff];
            [_flashButton setImage:[UIImage imageNamed:@"flash-off"] forState:UIControlStateNormal];
        }
        [_device unlockForConfiguration];
        [_flashButton setEnabled:YES];
    }
}

- (void)positionCnange:(id)sender
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = .8f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"fade";
    if (_device.position == AVCaptureDevicePositionFront) {
        animation.subtype = kCATransitionFromRight;
    }
    else if(_device.position == AVCaptureDevicePositionBack){
        animation.subtype = kCATransitionFromLeft;
    }
    [_preview addAnimation:animation forKey:@"animation"];
    
    NSArray *inputs = _session.inputs;
    for ( AVCaptureDeviceInput *input in inputs )
    {
        AVCaptureDevice *device = input.device;
        if ([device hasMediaType:AVMediaTypeVideo])
        {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
            {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            }
            else
            {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            }
            _device = newCamera;
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [_session beginConfiguration];
            
            [_session removeInput:input];
            [_session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [_session commitConfiguration];
            break;
        }
    }
}

- (void)cancelAction:(id)sender
{
    [self hiddenStatusBar];
}

#pragma mark - editAction
-(void)editCancelAction:(id)sender
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2f;
    animation.delegate = self;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionFade;
    [self.view bringSubviewToFront:cameraView];
    [self.view.layer addAnimation:animation forKey:@"animation"];
}

-(void)editSaveButton:(id)sender
{
    if (self.allowedEdit) {
        UIImage * coppImage;
        
        if (editScrollView.zoomScale==1.0f) {
            coppImage = _finishImage;
        }else
            coppImage= [self finishCropping];

        if ([self.delegate respondsToSelector:@selector(cameraFinish:)]) {
            [self.delegate cameraFinish:coppImage];
        }
    }else
    {

        if ([self.delegate respondsToSelector:@selector(cameraFinish:)]) {
            [self.delegate cameraFinish:_finishImage];
        }
    }
    [self hiddenStatusBar];
}

- (UIImage *)finishCropping {

    //截屏
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(cropped, nil, nil, nil);
    UIImage * outImage = [screenImage getSubImage:editScrollView.frame];
    return outImage;
}

#pragma mark - scrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return editImageView;
}

- (void)hiddenStatusBar
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden:NO];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - 设置支持的方向
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
