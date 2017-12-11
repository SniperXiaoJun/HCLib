//
//  CPQRViewController.m
//  CPQRFunction
//
//  Created by 刘任朋 on 15/12/23.
//  Copyright © 2015年 刘任朋. All rights reserved.
//

#import "CPQRViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZBarReaderViewController.h"
#import "CPQRFuncitonBundle.h"

#define CPQR_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

#define CPCAPTURE_BOUND ([UIScreen mainScreen].bounds)

#define QRVIEW_WIDTH ([UIScreen mainScreen].bounds.size.width / 1.5)
#define TOOLBAR_WIDTH [UIScreen mainScreen].bounds.size.width

#define TOOLBAR_HEIGHT 60

#define TOOLBARITEM_WIDTH 40
#define TOOLBARITEM_HEIGHT 40
@interface CPQRView : UIView
;
@property (nonatomic, assign) CGFloat captureWidth;
@property (nonatomic, assign) CGFloat captureHeight;
@property (nonatomic, assign) CGFloat cornerLineWidth;
@property (nonatomic, assign) CGFloat cornerBoarder;
@property (nonatomic, assign) CGRect codeViewRect;

@end
@interface CPQRViewController () <ZBarReaderDelegate,UINavigationBarDelegate> {
    UIImageView* _toolBarView;
    UIButton* _backButton; //返回按钮
    UIButton* _lampButton; //闪光灯按钮
    UIButton* _captureButton; //相册按钮
    UILabel* _abstractLabel;
    CPQRView* _qrView; //扫描框
    CGRect _codeRect;
    BOOL _isScanning;
    BOOL _isPhoto;
    CGRect scropRect; //扫描范围
}
@property (nonatomic, strong) CPScanResult scanResult;
@end

@implementation CPQRViewController
@synthesize captureSession;
@synthesize captureVideoPreviewLayer;
@synthesize scanLineAnimation;
@synthesize scanLineView;

#pragma mark - lifeCirCle

- (id)initWithResult:(CPScanResult)result
{
    self = [super init];
    if (self) {
        self.scanResult = result;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _codeRect = CGRectMake(0, 0,
        QRVIEW_WIDTH, QRVIEW_WIDTH);

    //工具条
    _toolBarView = [UIImageView new];
    if (CPQR_IOS7) {
        _codeRect = CGRectMake(([UIScreen mainScreen].bounds.size.width - QRVIEW_WIDTH) / 2, 20 + ([UIScreen mainScreen].bounds.size.height - QRVIEW_WIDTH) / 2, QRVIEW_WIDTH, QRVIEW_WIDTH);
        _toolBarView.frame = CGRectMake(0, 20, TOOLBAR_WIDTH, TOOLBAR_HEIGHT);
    }
    else {
        _codeRect = CGRectMake(([UIScreen mainScreen].bounds.size.width - QRVIEW_WIDTH) / 2, 20 + ([UIScreen mainScreen].bounds.size.height - QRVIEW_WIDTH) / 2, QRVIEW_WIDTH, QRVIEW_WIDTH);
        _toolBarView.frame = CGRectMake(0, 0, TOOLBAR_WIDTH, TOOLBAR_HEIGHT);
    }
    _toolBarView.backgroundColor = [UIColor clearColor];
    _toolBarView.userInteractionEnabled = YES;
    BOOL custom = [UIImagePickerController
        isSourceTypeAvailable:
            UIImagePickerControllerSourceTypeCamera];
    if ([self judgeAVCaptureDevice] && custom) {
        [self settingSystemCapture];
    }
    [self addQRView];
    [self addToolbarItems];
    [self.view addSubview:_toolBarView];
    [self setAbstractLabelAttribute];
    [self setScanLineViewAttribute];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self animationStart];
    if ([self judgeAVCaptureDevice]) {
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(animationStart)
                   name:UIApplicationDidBecomeActiveNotification
                 object:nil];
        //        scropRect = CGRectMake(_codeRect.origin.y / CPCAPTURE_BOUND.size.height,
        //            _codeRect.origin.x / CPCAPTURE_BOUND.size.width,
        //            _codeRect.size.height / CPCAPTURE_BOUND.size.height,
        //            _codeRect.size.width / CPCAPTURE_BOUND.size.width);
        scropRect = CGRectMake((CPCAPTURE_BOUND.size.height - CPCAPTURE_BOUND.size.width) / 2 / CPCAPTURE_BOUND.size.height,
            0,
            CPCAPTURE_BOUND.size.width / CPCAPTURE_BOUND.size.height,
            1);
        _lampButton.selected = NO;
        [self.captureSession startRunning];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![self judgeAVCaptureDevice]) {
        UIAlertView* alert = [[UIAlertView alloc]
                initWithTitle:@"提示"
                      message:@"此"
                      @"应用程序没有权限来访问您的相机，"
                      @"您可以在“隐私->相机”中启用访问。"
                     delegate:nil
            cancelButtonTitle:@"确定"
            otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]
        removeObserver:self
                  name:UIApplicationDidBecomeActiveNotification
                object:nil];
    Singleton.isDismissFormQr = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _backButton = nil;
    _lampButton = nil;
    _captureButton = nil;
}
#pragma mark addQRView
- (void)addQRView
{
    _qrView = [[CPQRView alloc] initWithFrame:self.view.bounds];
    _qrView.captureHeight = _codeRect.size.height;
    _qrView.captureWidth = _codeRect.size.width;
    _qrView.cornerBoarder = 2.f;
    _qrView.cornerLineWidth = 20.f;
    _qrView.codeViewRect = _codeRect;
    _qrView.alpha = 0.3f;
    [self.view addSubview:_qrView];
}
#pragma mark - 设置ToolbarItems
- (void)addToolbarItems
{
    int itemsCount = 3;
    for (int i = 1; i <= itemsCount; i++) {
        CGRect rect = CGRectMake((TOOLBAR_WIDTH * (i * 2 - 1)) / (itemsCount * 2) - TOOLBARITEM_WIDTH / 2, (TOOLBAR_HEIGHT - TOOLBARITEM_HEIGHT) / 2, TOOLBARITEM_WIDTH, TOOLBARITEM_HEIGHT);
        switch (i) {
        case 1: {
            _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_backButton setFrame:rect];
            _backButton.tag = i;
            [_backButton setImage:[UIImage imageWithContentsOfFile:
                                               [CPQRFuncitonBundle
                                                   getFileWithName:@"back_infojr.png"]]
                         forState:UIControlStateNormal];
            [_backButton addTarget:self action:@selector(toolbarItemsAction:) forControlEvents:UIControlEventTouchUpInside];

            [_toolBarView addSubview:_backButton];

        } break;
        case 2: {
            _captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_captureButton setFrame:rect];
            _captureButton.tag = i;
            [_captureButton addTarget:self action:@selector(toolbarItemsAction:) forControlEvents:UIControlEventTouchUpInside];
            [_captureButton setImage:[UIImage imageWithContentsOfFile:
                                                  [CPQRFuncitonBundle
                                                      getFileWithName:@"picture_btnjr.png"]]
                            forState:UIControlStateNormal];
            [_toolBarView addSubview:_captureButton];

        } break;
        case 3: {
            _lampButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_lampButton setFrame:rect];
            _lampButton.tag = i;
            [_lampButton setImage:[UIImage imageWithContentsOfFile:
                                               [CPQRFuncitonBundle
                                                   getFileWithName:@"light_offjr.png"]]
                         forState:UIControlStateNormal];
            [_lampButton setImage:[UIImage imageWithContentsOfFile:
                                               [CPQRFuncitonBundle
                                                   getFileWithName:@"light_onjr.png"]]
                         forState:UIControlStateSelected];
            [_lampButton addTarget:self action:@selector(toolbarItemsAction:) forControlEvents:UIControlEventTouchUpInside];
            [_toolBarView addSubview:_lampButton];

        } break;

        default:
            break;
        }
    }
}
- (void)setAbstractLabelAttribute
{
    _abstractLabel = [[UILabel alloc] init];
    _abstractLabel.frame = CGRectMake(0, _codeRect.origin.y + _codeRect.size.height,
        CPCAPTURE_BOUND.size.width, 40);
    _abstractLabel.textAlignment = NSTextAlignmentCenter;
    _abstractLabel.font = [UIFont systemFontOfSize:14];
    _abstractLabel.backgroundColor = [UIColor clearColor];
    _abstractLabel.textColor = [UIColor whiteColor];
    _abstractLabel.text = @"将二维码图片放入框内,将自动扫描";
    [self.view addSubview:_abstractLabel];
}
- (void)setScanLineViewAttribute
{
    self.scanLineView = [[UIImageView alloc]
        initWithImage:[UIImage imageWithContentsOfFile:
                                   [CPQRFuncitonBundle
                                       getFileWithName:@"code_linejr.png"]]];
    self.scanLineView.frame = CGRectMake(_codeRect.origin.x, _codeRect.origin.y,
        _codeRect.size.width, 2);
    [self.view addSubview:self.scanLineView];
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
        [NSNumber numberWithFloat:_codeRect.size.height - 2];
    self.scanLineAnimation.duration = 3;
    self.scanLineAnimation.repeatCount = 1000;
    self.scanLineAnimation.removedOnCompletion = YES;
    self.scanLineAnimation.fillMode = kCAFillModeForwards;
    [self.scanLineView.layer addAnimation:self.scanLineAnimation
                                   forKey:@"transform.translation.y"];
    [self.scanLineView startAnimating];
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
        //                CGRectMake(_codeRect.origin.y / CPCAPTURE_BOUND.size.height,
        //                    _codeRect.origin.x / CPCAPTURE_BOUND.size.width,
        //                    _codeRect.size.height / CPCAPTURE_BOUND.size.height,
        //                    _codeRect.size.width / CPCAPTURE_BOUND.size.width)];
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

        _isScanning = YES;
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
        _isScanning = YES;
    }
}
#pragma mark -judgeAVCaptureDevice
- (BOOL)judgeAVCaptureDevice
{

    AVCaptureDevice* inputDevice =
        [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    AVCaptureDeviceInput* captureInput =
        [AVCaptureDeviceInput deviceInputWithDevice:inputDevice
                                              error:nil];
    if (!captureInput) {
        inputDevice = nil;
        captureInput = nil;
        return NO;
    }
    return YES;
}
#pragma mark - toolbarItemsAction
- (void)toolbarItemsAction:(UIButton*)button
{
    switch (button.tag) {
    case 1: {
        if ([self.navigationController
                respondsToSelector:@selector(popViewControllerAnimated:)]) {
            [self.navigationController popViewControllerAnimated:NO];
        }
        else {
            [self dismissViewControllerAnimated:NO completion:NULL];
        }

    } break;
    case 2: {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker
                           animated:YES
                         completion:^{
                             _isScanning = NO;
                             _isPhoto = YES;
                             [self.captureSession stopRunning];
                         }];

    } break;
    case 3: {
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

    } break;

    default:
        break;
    }
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
//     viewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}

#pragma mark 对图像进行解码
- (void)decodeImage:(UIImage*)image
{

    ZBarReaderController* read = [[ZBarReaderController alloc] init];
    if (!_isPhoto) {
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

        _isScanning = NO;

        for (AVCaptureOutput* output in self.captureSession.outputs) {

            if ([output isMemberOfClass:[AVCaptureVideoDataOutput class]]) {
                [(AVCaptureVideoDataOutput*)output setSampleBufferDelegate:nil
                                                                     queue:NULL];
            }

            [self.captureSession removeOutput:output];
        }

        if ([self.navigationController
                respondsToSelector:@selector(popViewControllerAnimated:)]) {
            _isPhoto = NO;
            [self.navigationController popViewControllerAnimated:NO];
        }
        else {
            _isPhoto = NO;
            [self dismissViewControllerAnimated:NO completion:nil];
        }
        self.scanResult(symbol.data, YES);
    }
    else {
        //解码失败
        if (_isPhoto) {
            _isScanning = YES;
            
            self.scanResult(@"未发现二维码", NO);

//            [self.captureSession startRunning];
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

    if (metadataObjects.count > 0) {
        //解码成功
        [self.captureSession stopRunning];
        _isScanning = NO;

        if ([captureOutput isMemberOfClass:[AVCaptureMetadataOutput class]]) {

            [(AVCaptureMetadataOutput*)captureOutput
                setMetadataObjectsDelegate:nil
                                     queue:NULL];
        }
        [self.captureSession removeOutput:captureOutput];

        AVMetadataMachineReadableCodeObject* metadataObject =
            [metadataObjects objectAtIndex:0];
        if ([self.navigationController
                respondsToSelector:@selector(popViewControllerAnimated:)]) {
            _isPhoto = NO;
            [self.navigationController popViewControllerAnimated:NO];
        }
        else {
            _isPhoto = NO;
            [self dismissViewControllerAnimated:NO completion:nil];
        }
        self.scanResult(metadataObject.stringValue, YES);
    }else{
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"未发现二维码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker
didFinishPickingMediaWithInfo:(NSDictionary*)info
{

    UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 _isPhoto = YES;
                                 [self decodeImage:image];
                             }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 _isScanning = YES;
                                 [self.captureSession startRunning];
                             }];
}

@end

@implementation CPQRView
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
    CGFloat shadow2BlurRadius = 0.1f;

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
