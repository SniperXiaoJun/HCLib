//
//  ViewController.m
//  TrustSignPDFTest
//
//  Created by WangLi on 2016/9/28.
//  Copyright © 2016年 CFCA. All rights reserved.
//
#import "JRSYPDFViewController.h"

#import "TrustSignPDFDS.h"


#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>

#import "NickMBProgressHUD+MJ.h"

@interface JRSYPDFViewController ()<TrustSignPDFDSDelegate>

@property (nonatomic, strong)UISegmentedControl *readStyleSegment;
@property (nonatomic, strong)UIButton *sealButton;
@property (nonatomic, strong)TrustSignPDFDS *bookView;


@end

#define SEAL_BUTTON_HEIGHT 44

@implementation JRSYPDFViewController {
    NSString *_filePath;
    NSInteger sign;
}

- (instancetype)initWithFilePath:(NSString *)filePath
                        fileName:(NSString *)fileName
                        pdfBlock:(PDFCallBack)pdfBlock
                          isSign:(NSInteger)isSign
{
    if (self = [super init]) {
        _filePath = filePath;
//        self.title = [NSString stringWithFormat:@"%@(%@)", fileName, [TrustSignPDFDS getVersion]];
        self.title = @"合同详情";
        self.view.backgroundColor = [UIColor colorWithRed:220.f/255.f green:220.f/255.f blue:220.f/255.f alpha:1.f];
        self.pdfCallBackBlock = pdfBlock;
        sign = isSign;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *image_url = JRBundeImage( @"back_60_60");

    self.backButton = [[CPUIBackButton alloc] init];
    [self.backButton setImage:image_url forState:UIControlStateNormal];
    [self.backButton addTarget:self
                        action:@selector(backButtonAction)
              forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backItem =
    [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    
    self.refreshButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
    self.refreshButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.refreshButton addTarget:self
                           action:@selector(reDownLoadPdfFile)
              forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem =
    [[UIBarButtonItem alloc] initWithCustomView:self.refreshButton];
    self.navigationItem.rightBarButtonItem = rightItem;

}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initToolView];
//    [self readStyleChange];
}



- (void)reDownLoadPdfFile
{
    if ([NickMBProgressHUD respondsToSelector:@selector(showMessage:)]) {
        [NickMBProgressHUD showMessage:@"请稍后"];
    }else{
        DebugLog(@"未找到方法：[NickMBProgressHUD showMessage]");
    }
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/contract.pdf"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    
    //创建 Request
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.pdfUrlStr]];
    
    //下载进行中的事件
    SYAFURLConnectionOperation *operation = [[SYAFURLConnectionOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
    
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float progress =  (float)totalBytesRead / totalBytesExpectedToRead;
        //下载完成
        //该方法会在下载完成后立即执行
        if (progress == 1.0) {
            NSLog(@"下载成功");
            
            
            if ([NickMBProgressHUD respondsToSelector:@selector(hideHUD)]) {
                [NickMBProgressHUD hideHUD];
            }else{
                DebugLog(@"未找到方法：[NickMBProgressHUD hideHUD]");
            }
            [self initBookViewWithFilePath:_filePath];

        }else if (progress<0){
            if ([NickMBProgressHUD respondsToSelector:@selector(hideHUD)]) {
                [NickMBProgressHUD hideHUD];
            }else{
                DebugLog(@"未找到方法：[NickMBProgressHUD hideHUD]");
            }
        }
    }];
    
    //下载完成的事件
    //    [operation setCompletionBlock:^{
    //        NSLog(@"PDF成功了");
    //        [NickMBProgressHUD hideHUD];
    //
    //        [self initBookViewWithFilePath:_filePath];
    //        [Singleton.rootViewController pushViewController:vc animated:YES];
    //    }];
    
    [operation start];
}




- (void)backButtonAction
{
    if (sign == 0)
    {
        self.pdfCallBackBlock(@"a");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        self.pdfCallBackBlock(@"a");
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DaiKuanRefresh" object:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initBookViewWithFilePath:_filePath];
}
- (void)initBookViewWithFilePath:(NSString *)filePath
{
    NSUInteger pageNo = 0;
    CGFloat    pageOffset = 0.f;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefault objectForKey:@"kPdfCurrentPageInfo"];
    if (dict) {
//        pageNo = [[dict objectForKey:@"pageNo"] unsignedIntegerValue];
        pageNo = 0;
        pageOffset = 0;
    }
    
    NSInteger errorCode = 0;
    if (self.bookView) {
        [self.bookView removeFromSuperview];
    }

    CGRect bookViewFrame = CGRectMake(0, 64, ScreenWidth,ScreenHeight);
    self.bookView = [[TrustSignPDFDS alloc] initWithPDFPath:filePath frame:bookViewFrame pageNo:pageNo offset:pageOffset readStyle:(self.readStyleSegment.selectedSegmentIndex == 0)?TrustSignPDFDSReadStyleSequential:TrustSignPDFDSReadStyleSingle delegate:self errorCode:&errorCode];
    self.bookView.backgroundColor = [UIColor colorWithRed:239.0f/255 green:239.0f/255 blue:239.0f/255 alpha:1.0f];
    if (self.bookView) {
            [self.view addSubview:self.bookView];
    } else {
        NSString *errorMessage = [NSString stringWithFormat:@"打开文档失败，请检查文档路径。错误码：%08x", (int)errorCode];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - TrustSignPDFDS delegate
- (void)didPageScrolled:(NSUInteger)firstPageNo offset:(CGFloat)offset positionOffsetProportion:(CGFloat)proportion isDocumentEnd:(BOOL)isDocumentEnd
{
    
}

-(void)didPDFBookViewTapped:(PDFTapAreaInfo*)tapAreaInfo
{
    
}

@end
