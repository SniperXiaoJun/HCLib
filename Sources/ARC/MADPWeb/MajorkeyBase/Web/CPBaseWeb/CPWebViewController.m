//
//  CPWebViewController.m
//  CPPlugins
//
//  Created by liurenpeng on 7/27/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CPWebViewController.h"
#import "CPWebView.h"
#import "CPContext.h"
#import "CPPluginsUtility.h"
#import "CPUIVXWebCachingURLProtocol.h"
@interface CPWebViewController ()
{
    BOOL isEuccess;
}
@end
@implementation CPWebViewController
@synthesize webUrl; //@dynamic webUrl;
@synthesize webActionId;
@synthesize webViewControllerBlock;
@synthesize webParams;

#pragma mark - Life cycle
- (id)init
{
    self = [super init];
    if (self) {
        webUrl = nil;
    }
    return self;
}
- (id)initWithActionId:(NSString*)actionId;
{
    self = [self init];
    if (self) {
        self.webActionId = actionId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addWebView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.backButton = [[CPUIBackButton alloc] init];
    [self.backButton addTarget:self
                        action:@selector(backAction)
              forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backItem =
        [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = backItem;



    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightButton.frame = CGRectMake(ScreenWidth - 50, (44-15)/2, 80, 15);
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.rightButton addTarget:self
                        action:@selector(rightButtonAction)
              forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem* rightItem =
    [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self.rightButton setHidden:YES];
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
}

- (void)didReceiveMemoryWarning
{

    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{

    self.webView.delegate = nil;
    [self.webView removeFromSuperview];
    self.webView = nil;
}

#pragma mark - Action

- (void)rightButtonAction{
    if (isEuccess) {
        [self.webView callHandler:@"VXMoreTitle"
                             data:nil
                 responseCallback:^(id backResponseData) {

                 }];
    }
}

- (void)backAction
{
    __weak typeof(self) weakSelf = self;

    if (isEuccess) {
        [self.webView callHandler:@"VXBack"
                             data:nil
                 responseCallback:^(id backResponseData) {
                     if ([backResponseData isEqualToString:@"false"]) {
                     }
                     else {
                         
                         [weakSelf.navigationController popViewControllerAnimated:YES];
                         [weakSelf.webView clearWebCache];
                         [[NSURLCache sharedURLCache] removeAllCachedResponses];

                     }
                 }];
        
        
    }else{
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [weakSelf.webView clearWebCache];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}

- (void)HideBackButton
{
    [self.backButton setHidden:YES];
}

- (void)ShowBackButton
{

    [self.backButton setHidden:NO];
}

- (void)HideRightButton
{
    [self.rightButton setHidden:YES];
}
- (void)ShowRightButton:(id)dict
{

    NSString *title = dict[@"data"][@"Params"];
    CGSize labelsize = [title sizeWithFont:[UIFont systemFontOfSize:15]];
    labelsize.width = [title length]*17;

    [self.rightButton setFrame:CGRectMake(ScreenWidth - labelsize.width, (44-15)/2, labelsize.width, 15)];
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    [self.rightButton setHidden:NO];
}


#pragma mark - setting WebView
- (void)addWebView
{
    if (self.webView) {
        [self __loadView];
        return;
    }
    CGRect webFrame;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    webFrame = CGRectMake(0, 0, self.view.bounds.size.width,
        ScreenHeight);
   
    self.webView = [[CPWebView alloc] initWithFrame:webFrame delegate:self];
    self.webView.userInteractionEnabled = YES;
    self.webView.actionId = self.webActionId;
    self.webView.params = self.webParams;

    [self.webView registerPlugins];
    self.webView.frame = webFrame;
    self.webView.scrollView.scrollEnabled = NO;

    [self.view addSubview:self.webView];
    if (webUrl) {
        [self __loadView];
    }
}

- (void)setWebUrl:(NSString*)url;
{
    if (webUrl != url) {
        webUrl = url;
        if (self.webView) {
            [self __loadView];
        }
    }
}
- (NSString*)getWebUrl
{
    return webUrl;
}

- (void)__loadView
{
     __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
         __strong typeof(self) strongSelf = weakSelf;
        if (webUrl != nil || webUrl != NULL) {

            NSURLRequest* request = [CPPluginsUtility managerUrlPath:webUrl];
            [strongSelf.webView loadRequest:request];
        }
        dispatch_async(dispatch_get_main_queue(), ^{

                       });
    });
}

- (void)reloadWebView   
{
     __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (webUrl != nil || webUrl != NULL) {

            [strongSelf.webView reloadWebView];
        }
        dispatch_async(dispatch_get_main_queue(), ^{

                       });
    });
}
- (BOOL)reloadSeletcIndexView:(NSInteger)index;
{
    [self.webView callHandler:@"TabMain"
                         data:[NSString stringWithFormat:@"%ld", (long)index]];
    return YES;
}
#pragma mark - 处理数据
- (void)reciveWithData:(NSDictionary*)aDictionary withComplete:(void (^)(id responseData))completeBlock;
{
    self.webActionId = aDictionary[@"ActionId"];
    webViewControllerBlock = completeBlock;
    if (aDictionary[@"params"]) {
        self.webParams = aDictionary[@"params"];
    }
}
#pragma mark - webViewDelegate
- (BOOL)webView:(UIWebView*)webView
    shouldStartLoadWithRequest:(NSURLRequest*)request
                navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    isEuccess=YES;
    
    [[NSUserDefaults standardUserDefaults]
        setInteger:0
            forKey:@"WebKitCacheModelPreferenceKey"];
}
- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
    isEuccess=NO;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
