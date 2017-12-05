//
//  JRScanViewController.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/3/9.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CPQRViewController.h"
@interface JRScanViewController ()

@end

@implementation JRScanViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (Singleton.isDismissFormQr) {
        [self.navigationController popViewControllerAnimated:YES];
    }


}

//- view
- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super initWithNibName:nil bundle:nil])) {
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    AVCaptureDevice* inputDevice =
    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput* captureInput =
    [AVCaptureDeviceInput deviceInputWithDevice:inputDevice
                                          error:nil];
    if (!captureInput) {
        alertView(@"此应用程序没有权限来访问您的相机您可以在“隐私->相机”中启用访问")
    }
    else {
        
        DebugLog(@"------%@",Singleton.rootViewController);
        DebugLog(@"------%@",self.navigationController.viewControllers);
        CPQRViewController *qr = [[CPQRViewController alloc] initWithResult:^(NSString *result, BOOL isSucceed) {
            if (isSucceed) {
                DebugLog(@"扫一扫成功%@",result);
                //                Singleton.navUrl = result;
                if (IOS8_OR_LATER) {
                    if (![result containsString:@"#csiiiap#"]) {
                        NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", result]];
                        [[UIApplication sharedApplication] openURL:cleanURL];
                        return ;
                    }
                }else{
                    if ([result rangeOfString:@"#csiiiap#"].length == 0) {
                        return;
                    }
                }
                NSRange csiiiapRange = [result rangeOfString:@"#csiiiap#"];
                DebugLog(@"range====%@",NSStringFromRange(csiiiapRange));
                
                NSString *subStr = [result substringFromIndex:(csiiiapRange.location+csiiiapRange.length)];
                DebugLog(@"subnStr====%@",subStr);
                
                // 判断扫过来的二维码是否和当前一致
                NSArray *commondArr = [subStr componentsSeparatedByString:@"/"];
                if ([commondArr[0] isEqualToString:@"switchseverurl"]) {
                    
                    NSString *urlstr = [commondArr[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    DebugLog(@"urlstr==%@",urlstr);
                    NSString *nowUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"navUrl"];
                    
                    if ([urlstr isEqualToString:nowUrl]) { // 不一致
                        alertView(@"扫描的二维码地址和当前的服务器地址一致，无需切换");
                    }else{
                        [[Routable sharedRouter] open:subStr];
                    }
                }
            }
        }];
        [self presentViewController:qr animated:NO completion:nil];
    }
}
@end
