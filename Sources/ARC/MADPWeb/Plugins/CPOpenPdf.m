//
//  CPOpenPdf.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/5/8.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "CPOpenPdf.h"
//#import "JRH5AppViewController.h"
#import "PDFViewController.h"
#import "SYAFURLConnectionOperation.h"
#import "JRSYPDFViewController.h"
@implementation CPOpenPdf
- (void)openPdf{
    DebugLog(@"查看 pdf 文件: %@",self.curData[@"data"][@"Params"]);
    NSDictionary *info = self.curData[@"data"][@"Params"];
    
    if (!info[@"url"] || [info[@"url"] length] == 0 ) {
        alertView(@"合同地址为空");
    }

    NSInteger issign = [info[@"isSign"] integerValue];
    [self downLoadPdfFile:info[@"url"] isSign:issign];
    
    
    
//    DebugLog(@"imgUpload-------%@",self.curData[@"data"][@"Params"]);
//    NSDictionary *info = self.curData[@"data"][@"Params"];
//
//    PDFViewController  *VC = [[PDFViewController  alloc] init];
//    if (info[@"title"]) {
//        VC.title = info[@"title"];
//    }
//    if (info[@"url"]) {
//        VC.Url = info[@"url"];
//    }
//    [Singleton.rootViewController pushViewController:VC animated:YES];
//    return;
}
#pragma mark -下载PDF文件到本地
- (void)downLoadPdfFile:(NSString *)urlStr isSign:(NSInteger)issign
{
    [NickMBProgressHUD showMessage:@"请稍后"];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/contract.pdf"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    
    //创建 Request
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    //下载进行中的事件
    SYAFURLConnectionOperation *operation = [[SYAFURLConnectionOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
    
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float progress =  (float)totalBytesRead / totalBytesExpectedToRead;
        //下载完成
        //该方法会在下载完成后立即执行
        if (progress == 1.0) {
            NSLog(@"下载成功");
            
            [NickMBProgressHUD hideHUD];
            
            NSDictionary *info = self.curData[@"data"][@"Params"];
            
            if (!info[@"url"] || [info[@"url"] length] == 0 ) {
                alertView(@"合同地址为空");
            }
            
            JRSYPDFViewController *vc = [[JRSYPDFViewController alloc] initWithFilePath:filePath fileName:@"" pdfBlock:^(NSString *isBack) {
                if (![isBack isEqualToString:@""])
                {
                    self.pluginResponseCallback(@"");
                }
            } isSign:issign];
            vc.pdfUrlStr = info[@"url"];
            [Singleton.rootViewController pushViewController:vc animated:YES];
        }
    }];
    
    //下载完成的事件
//    [operation setCompletionBlock:^{
//        NSLog(@"PDF成功了");
//        [NickMBProgressHUD hideHUD];
//        
//        JRSYPDFViewController *vc = [[JRSYPDFViewController alloc] initWithFilePath:filePath fileName:@"" pdfBlock:^(NSString *isBack) {
//            if (![isBack isEqualToString:@""])
//            {
//                self.pluginResponseCallback(@"");
//            }
//        } isSign:issign];
//        [Singleton.rootViewController pushViewController:vc animated:YES];
//    }];
    
    [operation start];
}
@end
