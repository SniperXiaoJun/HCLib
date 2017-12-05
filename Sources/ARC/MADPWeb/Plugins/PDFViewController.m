//
//  PDFViewController.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/5/8.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "PDFViewController.h"

@interface PDFViewController (){

    UIWebView *mWebView;
}

@end

@implementation PDFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    mWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    mWebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mWebView];
    
//    NSURL *url = [NSURL URLWithString:@"http://10.99.5.11:9999/clients/useruploads/iap/VPkkk.pdf"];
    NSURL *url = [NSURL URLWithString:self.Url];
    [mWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
//    [mWebView setScalesPageToFit:YES];

}




@end
