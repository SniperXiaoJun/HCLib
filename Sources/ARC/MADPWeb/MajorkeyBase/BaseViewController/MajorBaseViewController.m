//
//  CSIISuperViewController.m
//  MobileClient
//
//  Created by wangfaguo on 13-7-17.
//  Copyright (c) 2013年 pro. All rights reserved.
//

#import "MajorBaseViewController.h"
#import "CSIICustomTextField.h"
#import "UIImage+CPExtensions.h"
#define ALERT_SAFE 1111

@interface MajorBaseViewController () {
    UIImageView* backGroundImage;
    UITextField* curActiveTextField;
    NSInteger viewYOffset;
    UIImageView* _navilogo;
}
@end

@implementation MajorBaseViewController

@synthesize leftButton;
@synthesize rightButton;
@synthesize inputControls;
//@synthesize relatedPageServerHints;
@synthesize backgroundView = backGroundImage;
@synthesize majorBaseViewControllerBlock;

#pragma mark - lifeCircle
- (id)init
{
    self = [super init];
    if (self) {
        self.changBackGround = NO;
        self.inputControls = [[NSMutableArray alloc] init];
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBackground"
//                                                                          inbundle:@"MADPPluginSDKResource.bundle"
//                                                                          withPath:@"BaseController"]];

    self.view.backgroundColor =
        [UIColor colorWithRed:0.95f
                        green:0.95f
                         blue:0.96f
                        alpha:1.00f];

    backGroundImage =
        [[UIImageView alloc] initWithFrame:self.view.frame]; //添加背景图片
    [self.view addSubview:backGroundImage];

    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton
        setBackgroundImage:[UIImage imageNamed:@"left"
                                      inbundle:@"MADPPluginSDKResource.bundle"
                                      withPath:@"BaseController"]
                  forState:UIControlStateNormal];
    [leftButton
        setBackgroundImage:[UIImage imageNamed:@"left"
                                      inbundle:@"MADPPluginSDKResource.bundle"
                                      withPath:@"BaseController"]
                  forState:UIControlStateHighlighted];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self
                   action:@selector(leftButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(15, 10, 10, 15);
    UIBarButtonItem* leftItem =
        [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    leftButton.hidden = NO;

    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton
        setBackgroundImage:[UIImage imageNamed:@"nav_goheader"
                                      inbundle:@"MADPPluginSDKResource.bundle"
                                      withPath:@"BaseController"]
                  forState:UIControlStateNormal];
    [rightButton
        setBackgroundImage:[UIImage imageNamed:@"nav_goheader"
                                      inbundle:@"MADPPluginSDKResource.bundle"
                                      withPath:@"BaseController"]
                  forState:UIControlStateHighlighted];
    [rightButton setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(rightButtonAction:)
          forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(ScreenWidth - 50, 5, 35, 35);

    UIBarButtonItem* rightItem =
        [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    rightButton.hidden = YES;

    //    _Swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self
    //    action:@selector(leftButtonAction:)];
    //    _Swipe.direction = UISwipeGestureRecognizerDirectionRight;
    //    [self.view addGestureRecognizer:_Swipe];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    _navilogo =
        [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 349 / 2) / 2,
                                               10, 349 / 2, 43 / 2)];
    [_navilogo setImage:[UIImage imageNamed:@"logo"
                                   inbundle:@"MADPPluginSDKResource.bundle"
                                   withPath:@"BaseController"]];
    _navilogo.tag = 5000;
//    [self.navigationController.navigationBar addSubview:_navilogo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_navilogo removeFromSuperview];
}

-(void)hiddenNavigationBarLogo{
    [_navilogo removeFromSuperview];
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
#pragma mark - 导航条按钮事件
- (void)leftButtonAction:(id)sender
{    
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        //present方式
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
    
}
- (void)rightButtonAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 模块跳转接受数据的方法
- (void)reciveWithData:(NSDictionary*)aDictionary withComplete:(void (^)(id responseData))completeBlock;
{
    majorBaseViewControllerBlock = completeBlock;
}

#pragma mark - UITextFieldDelegate

/*限制使用滚轮禁止编辑*/
- (BOOL)textField:(UITextField*)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString*)string
{
    if ([[textField inputView] class] == [UIPickerView class]) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect ;
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        rect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }else {
        rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    }
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
}

/**/
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{

    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}
/**/
- (void)textFieldDidBeginEditing:(UITextField*)textField
{

    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 246.0 - 80); //键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if (offset > 0) {
        CGRect rect = CGRectMake(0.0f, -offset, width, height);
        self.view.frame = rect;
    }
    else {
        CGRect rect;
        NSArray *viewcontrollers=self.navigationController.viewControllers;
        if (viewcontrollers.count>1) {
            rect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
        }else {
            rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

@end
