//
//  CSIIUITableViewController.m
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-24.
//  Copyright (c) 2013年 科蓝公司. All rights reserved.
//

#import "MajorBaseTableViewController.h"
#import "UIImage+CPExtensions.h"
#import "CSIIConfigGlobalImport.h"
//#import "CSIIUIBackButton.h"
//#import "ThemeManager.h"
@interface MajorBaseTableViewController () {

    UIImageView* backGroundImage;
    UITextField* curActiveTextField;
    NSInteger viewYOffset;
    UIImageView* _navilogo;
}

@end

@implementation MajorBaseTableViewController
@synthesize inputControls, delegate, rowHeightDictionary, upSwipe;
@synthesize leftButton;
@synthesize rightButton;
@synthesize majorBaseTableViewControllerBlock;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        if (!self.inputControls) {
            //            self.tableView.separatorColor = [UIColor colorWithRed:(12*16+6)/255.0 green:(11*16+1)/255.0 blue:(7*16+15)/255.0 alpha:1.0];
        }
        self.inputControls = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)init
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        if (!self.rowHeightDictionary) {
            self.rowHeightDictionary = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    _navilogo = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 349 / 2) / 2, 10, 349 / 2, 43 / 2)];
    [_navilogo setImage:[UIImage imageNamed:@"logo"
                                   inbundle:@"MADPPluginSDKResource.bundle"
                                   withPath:@"BaseController"]];
    _navilogo.tag = 5000;
    [self.navigationController.navigationBar addSubview:_navilogo];

    upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
    [upSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [upSwipe setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:upSwipe];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowNotification:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    //keyboard iPad键盘浮动解决方案
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeFrameNotification:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)hiddenNavigationBarLogo{
    [_navilogo removeFromSuperview];
}

- (void)keyboardDidShowNotification:(NSNotification*)sender
{
    DebugLog(@"");
}
- (void)keyboardWillShowNotification:(NSNotification*)sender
{
    DebugLog(@"");
}
- (void)keyboardDidChangeFrameNotification:(NSNotification*)sender
{
    DebugLog(@"");
}
- (void)keyboardWillChangeFrameNotification:(NSNotification*)sender
{
    DebugLog(@"");
}
- (void)keyboardWillHideNotification:(NSNotification*)sender
{
    DebugLog(@"");
}

/**/
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    DebugLog(@"");

    //
    //    CGRect parentRect = [textField.superview convertRect:textField.superview.bounds toView:textField.superview];
    //
    //    DebugLog(@"%@",NSStringFromCGRect(textField.superview.superview.superview.frame));
    [textField resignFirstResponder];

    return YES;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{

    return 1;
}

/**/
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    DebugLog(@"");

    //    DebugLog(@"%@",NSStringFromCGRect(textField.superview.superview.superview.frame));
    //    CGRect frame = textField.frame;
    //    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0 - 80);//键盘高度216
    //    NSTimeInterval animationDuration = 0.30f;
    //    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    //    [UIView setAnimationDuration:animationDuration];
    //    float width = self.view.frame.size.width;
    //    float height = self.view.frame.size.height;
    //    if(offset > 0)
    //    {
    //        CGRect rect = CGRectMake(0.0f, -offset,width,height);
    //        self.view.frame = rect;
    //    }
    //    else{
    //        CGRect rect = CGRectMake(0.0f, self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, self.view.frame.size.height);
    //        self.view.frame = rect;
    //    }
    //    [UIView commitAnimations];
}

- (void)transactionCallback:(CSIIBusinessCaller*)returnCaller;
{
}
- (void)pickerCallback:(CSIIBusinessCaller*)returnCaller;
{
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
}

- (void)dealloc
{
    [[CSIIBusinessLogic sharedInstance] cancelWithPage:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    [[CSIIBusinessLogic sharedInstance] cancelWithPage:NSStringFromClass([self class])];
    [_navilogo removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated;
{
    [super viewDidDisappear:animated];
    [self.warmTipsView removeFromSuperview];
    [[CSIIBusinessLogic sharedInstance] cancelWithPage:NSStringFromClass([self class])];
}

- (void)loadView
{
    [super loadView];
    if (!self.rowHeightDictionary) {
        self.rowHeightDictionary = [[NSMutableDictionary alloc] init];
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;

    }
    
    [self.view addSubview:backGroundImage];
    
    self.tableView.backgroundColor =
    [UIColor colorWithRed:0.95f
                    green:0.95f
                     blue:0.96f
                    alpha:1.00f];


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
    leftButton.frame = CGRectMake(0, 5, 35, 35);
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
    rightButton.hidden = NO;

    //    //摇一摇
    //    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    //    [self becomeFirstResponder];
}
- (void)leftButtonAction:(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];
    return;
}
- (void)rightButtonAction:(id)sender
{

    [self.navigationController popToRootViewControllerAnimated:YES];
    return;
}

- (void)backAction
{
    [[CSIIBusinessLogic sharedInstance] cancelWithPage:NSStringFromClass([self class])];
    if ([self.navigationController.viewControllers count] > 1) {

        if ([self.navigationController.viewControllers[self.navigationController.viewControllers.count - 1] isKindOfClass:NSClassFromString(@"ResultViewController")]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

/*限制使用滚轮禁止编辑*/
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{

    if ([[textField inputView] class] == [UIPickerView class]) {
        return NO;
    }

    return YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{

    if (self.warmTipsView) {
        [self.warmTipsView setHidden:NO];
        [[UIApplication sharedApplication].keyWindow addSubview:self.warmTipsView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    if (self.warmTipsView) {
        [self.warmTipsView setHidden:YES];
    }
}
#pragma mark - 处理数据
- (void)reciveWithData:(NSDictionary*)aDictionary withComplete:(void (^)(id responseData))completeBlock;
{
    majorBaseTableViewControllerBlock = completeBlock;
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    CGRect rect = CGRectMake(0.0f, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
//    self.view.frame = rect;
//    [UIView commitAnimations];
//    [textField resignFirstResponder];
//    return YES;
//}
//
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    CGRect frame = textField.frame;
//    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0 - 80);//键盘高度216
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    float width = self.view.frame.size.width;
//    float height = self.view.frame.size.height;
//    if(offset > 0)
//    {
//        CGRect rect = CGRectMake(0.0f, -offset,width,height);
//        self.view.frame = rect;
//    }
////    }else{
////        CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
////        self.view.frame = rect;
////    }
//    [UIView commitAnimations];
//}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath;
{
    if ([self.rowHeightDictionary objectForKey:[NSString stringWithFormat:@"%ld:%ld", (long)indexPath.section, (long)indexPath.row]]) {
        return [[self.rowHeightDictionary objectForKey:[NSString stringWithFormat:@"%ld:%ld", (long)indexPath.section, (long)indexPath.row]] intValue];
    }
    else {
        return 40;
    }
}

@end
