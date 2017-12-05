//
//  CPQRCoder.m
//  CocoaPodDemo
//
//  Created by liurenpeng on 7/29/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CPQRCoderViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZBarReaderViewController.h"
#import "CPQRFuncitonBundle.h"

#define CPCAPTURE_BOUND ([UIScreen mainScreen].bounds)
#define CPCAPTURE_WIDTH (([UIScreen mainScreen].bounds.size.width) / 1.5f)
#define CPQR_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7
@interface CPQRCoderViewController () <ZBarReaderDelegate> {
    CGRect scropRect;
    BOOL isPhoto;
    BOOL isCapture;
}

@end
@implementation CPQRCoderViewController
@synthesize cornerBoarder;
@synthesize cornerLineWidth;
@synthesize abstractLabel;
@synthesize captureButton;
@synthesize scanResult;
@synthesize captureVideoPreviewLayer;
@synthesize captureSession;
@synthesize isScanning;
@synthesize qrCoderView;
@synthesize scanLineView;
@synthesize scanLineAnimation;
@synthesize lampButton;
@synthesize codeRect;
@synthesize scanView;

- (id)initWithResult:(CPScanResult)result
{
    self = [super init];
    if (self) {

        isCapture = [self judgeAVCaptureDevice];
        isPhoto = NO;
        self.scanResult = result;
        self.cornerLineWidth = 20.f;
        self.cornerBoarder = 2.f;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            self.codeRect = CGRectMake(CPCAPTURE_BOUND.size.width / 2 - CPCAPTURE_WIDTH / 2, CPCAPTURE_BOUND.size.height / 2 - CPCAPTURE_WIDTH / 2,
                CPCAPTURE_WIDTH, CPCAPTURE_WIDTH);
        }
        else {
            self.codeRect = CGRectMake(CPCAPTURE_BOUND.size.width / 2 - CPCAPTURE_WIDTH / 2, CPCAPTURE_BOUND.size.height / 2 - CPCAPTURE_WIDTH / 2 - 64,
                CPCAPTURE_WIDTH, CPCAPTURE_WIDTH);
        }

        BOOL custom = [UIImagePickerController
            isSourceTypeAvailable:
                UIImagePickerControllerSourceTypeCamera]; //判断摄像头是否能用

        if (custom) {
            [self settingSystemCapture];
        }
        [self createView];
        [self setLampButtonAttribute];
        [self setAbstractLabelAttribute];
        [self setCaptureButtonAttribute];
        if (isCapture) {
            [self setScanLineViewAttribute];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"二维码扫描";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self animationStart];
    if (isCapture) {
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(animationStart)
                   name:UIApplicationDidBecomeActiveNotification
                 object:nil];
        //        scropRect = CGRectMake(self.codeRect.origin.y / CPCAPTURE_BOUND.size.height,
        //            self.codeRect.origin.x / CPCAPTURE_BOUND.size.width,
        //            self.codeRect.size.height / CPCAPTURE_BOUND.size.height,
        //            self.codeRect.size.width / CPCAPTURE_BOUND.size.width);
        scropRect = CGRectMake((CPCAPTURE_BOUND.size.height - CPCAPTURE_BOUND.size.width) / 2 / CPCAPTURE_BOUND.size.height,
            0,
            CPCAPTURE_BOUND.size.width / CPCAPTURE_BOUND.size.height,
            1);
        lampButton.selected = NO;
        [self.captureSession startRunning];
    }
}
- (BOOL)judgeAVCaptureDevice
{

    AVCaptureDevice* inputDevice =
        [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    AVCaptureDeviceInput* captureInput =
        [AVCaptureDeviceInput deviceInputWithDevice:inputDevice
                                              error:nil];
    if (!captureInput) {
        UIAlertView* alert = [[UIAlertView alloc]
                initWithTitle:@"提示"
                      message:@"此"
                      @"应用程序没有权限来访问您的相机，"
                      @"您可以在“隐私->相机”中启用访问。"
                     delegate:nil
            cancelButtonTitle:@"确定"
            otherButtonTitles:nil];
        [alert show];
        inputDevice = nil;
        captureInput = nil;
        return NO;
    }
    return YES;
}
- (void)setLampButtonAttribute
{
    AVCaptureDevice* device =
        [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device isTorchModeSupported:device.torchMode]) {
        lampButton = [UIButton buttonWithType:UIButtonTypeCustom];
        lampButton.frame = CGRectMake(CPCAPTURE_BOUND.size.width - 55,
            self.codeRect.origin.y - 45, 35, 35);
        [lampButton setImage:[UIImage imageWithContentsOfFile:
                                          [CPQRFuncitonBundle
                                              getFileWithName:@"light_off.png"]]
                    forState:UIControlStateNormal];
        [lampButton setImage:[UIImage imageWithContentsOfFile:
                                          [CPQRFuncitonBundle
                                              getFileWithName:@"light_on.png"]]
                    forState:UIControlStateSelected];
        [lampButton addTarget:self
                       action:@selector(flashLightClick:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:lampButton];
    }
}
- (void)createView
{

    self.qrCoderView = [[CPQRCoderView alloc] initWithFrame:self.view.bounds];
    qrCoderView.captureHeight = self.codeRect.size.height;
    qrCoderView.captureWidth = self.codeRect.size.width;
    qrCoderView.cornerBoarder = self.cornerBoarder;
    qrCoderView.cornerLineWidth = self.cornerLineWidth;
    qrCoderView.codeViewRect = self.codeRect;
    //    self.scanView = [[UIImageView alloc] initWithFrame:self.codeRect];
    //    self.scanView.backgroundColor = [UIColor clearColor];
    //    [self.view addSubview:self.scanView];

    self.qrCoderView.alpha = 0.6f;
    [self.view addSubview:qrCoderView];
    [self bezierPathWithRect:self.codeRect];
}
- (void)bezierPathWithRect:(CGRect)rect
{
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.qrCoderView.frame];
    [path appendPath:[UIBezierPath bezierPathWithRect:rect]];
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [self.qrCoderView.layer setMask:shapeLayer];
}
- (void)setAbstractLabelAttribute
{
    abstractLabel = [[UILabel alloc] init];
    self.abstractLabel.frame = CGRectMake(0, self.codeRect.origin.y + self.codeRect.size.height,
        CPCAPTURE_BOUND.size.width, 40);
    abstractLabel.textAlignment = NSTextAlignmentCenter;
    abstractLabel.font = [UIFont systemFontOfSize:14];
    abstractLabel.backgroundColor = [UIColor clearColor];
    abstractLabel.textColor = [UIColor whiteColor];
    abstractLabel.text = @"将二维码图片放入框内,将自动扫描";
    [self.view addSubview:self.abstractLabel];
}
- (void)setScanLineViewAttribute
{
    scanLineView = [[UIImageView alloc]
                    initWithImage:[UIImage imageWithContentsOfFile:
                                   [CPQRFuncitonBundle
                                    getFileWithName:@"code_line.png"]]];
    scanLineView.frame = CGRectMake(self.codeRect.origin.x, self.codeRect.origin.y,
        self.codeRect.size.width, 2);
    [self.view addSubview:scanLineView];

    [self animationStart];
}
- (void)animationStart
{
    if (self.scanLineAnimation) {
        [self.scanLineView.layer removeAllAnimations];
    }
    self.scanLineAnimation =
        [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    self.scanLineAnimation.fromValue = [NSNumber numberWithFloat:0];
    self.scanLineAnimation.toValue =
        [NSNumber numberWithFloat:self.codeRect.size.height - 2];
    self.scanLineAnimation.duration = 3;
    self.scanLineAnimation.repeatCount = 1000;
    self.scanLineAnimation.removedOnCompletion = YES;
    self.scanLineAnimation.fillMode = kCAFillModeForwards;
    [self.scanLineView.layer addAnimation:self.scanLineAnimation
                                   forKey:@"transform.translation.y"];
    [self.scanLineView startAnimating];
}
- (void)setCaptureButtonAttribute
{
    captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    captureButton.frame = CGRectMake(
        self.view.center.x - 45,
        self.codeRect.origin.y + self.codeRect.size.height + 60, 90, 35);
    [captureButton
        setImage:[UIImage
                     imageWithContentsOfFile:[CPQRFuncitonBundle
                                                 getFileWithName:@"code_btn.png"]]
        forState:UIControlStateNormal];
    [captureButton addTarget:self
                      action:@selector(phoneImageButton)
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:captureButton];
}

//开启关闭闪光灯
- (void)flashLightClick:(UIButton*)button
{

    AVCaptureDevice* device =
        [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device isTorchModeSupported:device.torchMode]) {
        if (device.torchMode == AVCaptureTorchModeOff && (!button.selected)) {
            //闪光灯开启
            button.selected = !button.selected;
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOn];
        }
        else if (device.torchMode == AVCaptureTorchModeOn && button.selected) {
            //闪光灯关闭
            button.selected = !button.selected;
            [device setTorchMode:AVCaptureTorchModeOff];
        }
    }
}
- (void)phoneImageButton
{
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker
                       animated:YES
                     completion:^{
                         self.isScanning = NO;
                         isPhoto = YES;
                         [self.captureSession stopRunning];
                     }];
}
#pragma mark 开启相机
- (void)settingSystemCapture
{
    self.captureSession = [[AVCaptureSession alloc] init];

    AVCaptureDevice* inputDevice =
        [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    AVCaptureDeviceInput* captureInput =
        [AVCaptureDeviceInput deviceInputWithDevice:inputDevice
                                              error:nil];
    if (!captureInput) {
        UIAlertView* alert = [[UIAlertView alloc]
                initWithTitle:@"提示"
                      message:@"此"
                      @"应用程序没有权限来访问您的相机，"
                      @"您可以在“隐私->相机”中启用访问。"
                     delegate:nil
            cancelButtonTitle:@"确定"
            otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self.captureSession addInput:captureInput];

    if (CPQR_IOS7) {
        AVCaptureMetadataOutput* _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //        [_output
        //            setRectOfInterest:
        //                CGRectMake(self.codeRect.origin.y / CPCAPTURE_BOUND.size.height,
        //                    self.codeRect.origin.x / CPCAPTURE_BOUND.size.width,
        //                    self.codeRect.size.height / CPCAPTURE_BOUND.size.height,
        //                    self.codeRect.size.width / CPCAPTURE_BOUND.size.width)];
        [_output
            setRectOfInterest:
                CGRectMake((CPCAPTURE_BOUND.size.height - CPCAPTURE_BOUND.size.width) / 2 / CPCAPTURE_BOUND.size.height,
                    0,
                    CPCAPTURE_BOUND.size.width / CPCAPTURE_BOUND.size.height,
                    1)];

        self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
        [self.captureSession addOutput:_output];
        _output.metadataObjectTypes = @[ AVMetadataObjectTypeQRCode ];

        if (!self.captureVideoPreviewLayer) {
            self.captureVideoPreviewLayer =
                [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        }
        self.captureVideoPreviewLayer.frame = self.view.bounds;
        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer:self.captureVideoPreviewLayer];

        self.isScanning = YES;
    }
    else {

        AVCaptureVideoDataOutput* captureOutput =
            [[AVCaptureVideoDataOutput alloc] init];

        captureOutput.alwaysDiscardsLateVideoFrames = YES;

        [captureOutput setSampleBufferDelegate:self
                                         queue:dispatch_get_main_queue()];

        NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
        NSNumber* value =
            [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
        NSDictionary* videoSettings =
            [NSDictionary dictionaryWithObject:value
                                        forKey:key];
        [captureOutput setVideoSettings:videoSettings];
        [self.captureSession addOutput:captureOutput];
        NSString* preset = 0;
        if (NSClassFromString(@"NSOrderedSet") && // Proxy for "is this iOS 5" ...
            [UIScreen mainScreen].scale > 1 &&
            [inputDevice supportsAVCaptureSessionPreset:
                             AVCaptureSessionPresetiFrame960x540]) {
            preset = AVCaptureSessionPresetiFrame960x540;
        }
        if (!preset) {
            preset = AVCaptureSessionPresetMedium;
        }
        self.captureSession.sessionPreset = preset;

        if (!self.captureVideoPreviewLayer) {
            self.captureVideoPreviewLayer =
                [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        }
        self.captureVideoPreviewLayer.frame = self.view.bounds;
        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer:self.captureVideoPreviewLayer];
        self.isScanning = YES;
    }
}

#pragma mark 对图像进行解码
- (void)decodeImage:(UIImage*)image
{

    ZBarReaderController* read = [[ZBarReaderController alloc] init];
    if (!isPhoto) {
        read.scanCrop = scropRect;
    }
    CGImageRef cgImageRef = image.CGImage;
    read.showsHelpOnFail = NO;
    ZBarImageScanner* scanner = read.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];

    id<NSFastEnumeration> result = [read scanImage:cgImageRef];
    ZBarSymbol* symbol = nil;
    for (symbol in result) {
        break;
    }

    if (symbol != nil) {
        //解码成功
        [self.captureSession stopRunning];

        self.isScanning = NO;

        for (AVCaptureOutput* output in self.captureSession.outputs) {

            if ([output isMemberOfClass:[AVCaptureVideoDataOutput class]]) {
                [(AVCaptureVideoDataOutput*)output setSampleBufferDelegate:nil
                                                                     queue:NULL];
            }

            [self.captureSession removeOutput:output];
        }

        if ([self.navigationController
                respondsToSelector:@selector(popViewControllerAnimated:)]) {
            isPhoto = NO;
            //            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            isPhoto = NO;
            //            [self dismissViewControllerAnimated:YES completion:nil];
        }
        self.scanResult(symbol.data, YES);

        //        if([self.navigationController
        //        respondsToSelector:@selector(popViewControllerAnimated:)]){
        //            isPhoto = NO;
        //            [self.navigationController popViewControllerAnimated:YES];
        //        }else{
        //            isPhoto = NO;
        //            [self dismissViewControllerAnimated:YES completion:nil];
        //        }
    }
    else {
        //解码失败

        if (isPhoto) {
            self.isScanning = YES;
            [self.captureSession startRunning];
        }
    }
}

#pragma mark - 处理sampleBuffer 并返回 image
- (UIImage*)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);

    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);

    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace) {
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }

    // Get the base address of the pixel buffer
    void* baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);

    // Create a Quartz direct-access data provider that uses data we supply
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    // Create a bitmap image from data supplied by our data provider
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow, colorSpace,
        kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
        provider, NULL, true, kCGRenderingIntentDefault);

    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);

    // Create and return an image object representing the specified Quartz image
    UIImage* image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);

    return image;
}
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput*)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection*)connection
{
    UIImage* image = [self imageFromSampleBuffer:sampleBuffer];

    [self decodeImage:image];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate//IOS7及以上触发
- (void)captureOutput:(AVCaptureOutput*)captureOutput
    didOutputMetadataObjects:(NSArray*)metadataObjects
              fromConnection:(AVCaptureConnection*)connection
{
    NSLog(@"captureOutput:didOutputMetadataObjects:");

    if (metadataObjects.count > 0) {
        //解码成功
        [self.captureSession stopRunning];
        self.isScanning = NO;

        if ([captureOutput isMemberOfClass:[AVCaptureMetadataOutput class]]) {

            [(AVCaptureMetadataOutput*)captureOutput
                setMetadataObjectsDelegate:nil
                                     queue:NULL];
        }
        [self.captureSession removeOutput:captureOutput];

        AVMetadataMachineReadableCodeObject* metadataObject =
            [metadataObjects objectAtIndex:0];

        self.scanResult(metadataObject.stringValue, YES);

        //            if([self.navigationController
        //            respondsToSelector:@selector(popViewControllerAnimated:)]){
        //                [self.navigationController popViewControllerAnimated:YES];
        //            }else{
        //                [self dismissViewControllerAnimated:YES completion:nil];
        //            }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker
didFinishPickingMediaWithInfo:(NSDictionary*)info
{

    UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 isPhoto = YES;
                                 [self decodeImage:image];
                             }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 self.isScanning = YES;
                                 [self.captureSession startRunning];
                             }];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]
        removeObserver:self
                  name:UIApplicationDidBecomeActiveNotification
                object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end

@implementation CPQRCoderView
@synthesize captureWidth;
@synthesize cornerBoarder;
@synthesize cornerLineWidth;
@synthesize codeViewRect;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{

    self.backgroundColor = [UIColor whiteColor];
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor* checkmarkBlue2 =
        [UIColor colorWithRed:0.1f
                        green:0.1f
                         blue:0.1f
                        alpha:0.2f];
    //// Shadow Declarations
    UIColor* shadow2 = [UIColor whiteColor];
    CGSize shadow2Offset = CGSizeMake(-1, 1);
    CGFloat shadow2BlurRadius = 0.06f;

    //// CheckedOval Drawing
    UIBezierPath* checkedOvalPath =
        [UIBezierPath bezierPathWithRect:self.codeViewRect];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius,
        shadow2.CGColor);
    [checkmarkBlue2 setFill];
    [checkedOvalPath fill];
    CGContextRestoreGState(context);

    [[UIColor whiteColor] setStroke];
    checkedOvalPath.lineWidth = 1;
    [checkedOvalPath stroke];

    //绘制小勾
    //设置画笔的颜色（3个1：白色,3个0:黑色）
    CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
    //设置填充颜色
    // CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    //设置线条宽度
    CGContextSetLineWidth(context, 2.f);
    //设置线条起始端样式的方法
    CGContextSetLineCap(context, kCGLineCapRound);
    //设置线条拐角的样式
    CGContextSetLineJoin(context, kCGLineJoinRound);
    //将画笔移动到某一点
    CGContextMoveToPoint(context, self.codeViewRect.origin.x,
        self.codeViewRect.origin.y + self.cornerLineWidth);
    //添加线条
    CGContextAddLineToPoint(context, self.codeViewRect.origin.x,
        self.codeViewRect.origin.y);
    CGContextAddLineToPoint(context,
        self.codeViewRect.origin.x + self.cornerLineWidth,
        self.codeViewRect.origin.y);

    CGContextMoveToPoint(context, self.codeViewRect.origin.x + self.captureWidth - self.cornerLineWidth,
        self.codeViewRect.origin.y);
    //添加线条
    CGContextAddLineToPoint(context,
        self.codeViewRect.origin.x + self.captureWidth,
        self.codeViewRect.origin.y);
    CGContextAddLineToPoint(context,
        self.codeViewRect.origin.x + self.captureWidth,
        self.codeViewRect.origin.y + self.cornerLineWidth);

    CGContextMoveToPoint(context, self.codeViewRect.origin.x + self.captureWidth,
        self.codeViewRect.origin.y + self.captureHeight - self.cornerLineWidth);
    //添加线条
    CGContextAddLineToPoint(context,
        self.codeViewRect.origin.x + self.captureWidth,
        self.codeViewRect.origin.y + self.captureHeight);
    CGContextAddLineToPoint(context, self.codeViewRect.origin.x + self.captureWidth - self.cornerLineWidth,
        self.codeViewRect.origin.y + self.captureHeight);

    CGContextMoveToPoint(context,
        self.codeViewRect.origin.x + self.cornerLineWidth,
        self.codeViewRect.origin.y + self.captureHeight);
    //添加线条
    CGContextAddLineToPoint(context, self.codeViewRect.origin.x,
        self.codeViewRect.origin.y + self.captureHeight);
    CGContextAddLineToPoint(context, self.codeViewRect.origin.x,
        self.codeViewRect.origin.y + self.captureHeight - self.cornerLineWidth);
    //完成绘制
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
