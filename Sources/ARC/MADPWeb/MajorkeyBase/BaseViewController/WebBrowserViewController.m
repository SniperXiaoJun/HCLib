//
//  CPBrowserViewController.m
//  CPBrowserDemo
//
//  Created by YuXiang on 15/11/4.
//  Copyright © 2015年 CSII. All rights reserved.
//

#import "WebBrowserViewController.h"
#import <QuartzCore/QuartzCore.h>


/* Detect if we're running iOS 7.0 or higher */
#ifndef NSFoundationVersionNumber_iOS_6_1
#define NSFoundationVersionNumber_iOS_6_1  993.00
#endif
#define  MINIMAL_UI (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)

/* Default iOS 6 Theming Properties */
#define DEFAULT_IPHONE_BUTTON_TINT [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]
#define DEFAULT_IPAD_BUTTON_TINT   [UIColor colorWithRed:0.35f green:0.35f blue:0.35f alpha:1.0f]

#define DEFAULT_IPHONE_BEVEL_OPACITY    0.5f
#define DEFAULT_IPAD_BEVEL_OPACITY      0.9f


/* The default blue tint color of iOS 7.0 */
#define DEFAULT_BAR_TINT_COLOR [UIColor colorWithRed:0.0f green:110.0f/255.0f blue:1.0f alpha:1.0f]

/* Detect which user idiom we're running on */
#define IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/* Blank UIBarButtonItem creation */
#define BLANK_BARBUTTONITEM [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]

/* View Controller Theming Properties */
#define BACKGROUND_COLOR_MINIMAL    [UIColor colorWithRed:0.741f green:0.741 blue:0.76f alpha:1.0f]
#define BACKGROUND_COLOR_CLASSIC    [UIColor scrollViewTexturedBackgroundColor]
#define BACKGROUND_COLOR            ((MINIMAL_UI) ? BACKGROUND_COLOR_MINIMAL : BACKGROUND_COLOR_CLASSIC)

/* Navigation Bar Properties */
#define NAVIGATION_BUTTON_WIDTH             31
#define NAVIGATION_BUTTON_SIZE              CGSizeMake(31,31)
#define NAVIGATION_BUTTON_SPACING           40
#define NAVIGATION_BUTTON_SPACING_IPAD      20
#define NAVIGATION_BAR_HEIGHT               (MINIMAL_UI ? 64.0f : 44.0f)
#define NAVIGATION_TOGGLE_ANIM_TIME         0.3

/* Toolbar Properties */
#define TOOLBAR_HEIGHT      44.0f

/* Hieght of the loading progress bar view */
#define LOADING_BAR_HEIGHT          2

/* Unique URL triggered when JavaScript reports page load is complete */
NSString *kCompleteRPCURL = @"webviewprogress:///complete";

/* Default load values to defer to during the load process */
static const float kInitialProgressValue                = 0.1f;
static const float kBeforeInteractiveMaxProgressValue   = 0.5f;
static const float kAfterInteractiveMaxProgressValue    = 0.9f;


const NSString *ButtonTintColor       = @"ButtonFillColor";
const NSString *ButtonBevelOpacity    = @"ButtonBevelOpacity";




#pragma mark -
#pragma mark Loading Bar Private Interface
@interface LoadingView : UIView
@end

@implementation LoadingView
- (void)tintColorDidChange { self.backgroundColor = self.tintColor; }
@end

#pragma mark -
#pragma mark Hidden Properties/Methods
@interface WebBrowserViewController () <UIWebViewDelegate>
{
    
    //The state of the UIWebView's scroll view before the rotation animation has started
    struct {
        CGSize     frameSize;
        CGSize     contentSize;
        CGPoint    contentOffset;
        CGFloat    zoomScale;
        CGFloat    minimumZoomScale;
        CGFloat    maximumZoomScale;
        CGFloat    topEdgeInset;
        CGFloat    bottomEdgeInset;
    } _webViewState;
    
    //State tracking for load progress of current page
    struct {
        NSInteger   loadingCount;       //Number of requests concurrently being handled
        NSInteger   maxLoadCount;       //Maximum number of load requests that was reached
        BOOL        interactive;        //Load progress has reached the point where users may interact with the content
        CGFloat     loadingProgress;    //Between 0.0 and 1.0, the load progress of the current page
    } _loadingProgressState;
}

/* View controller presentation state tracking */
@property (nonatomic,readonly) BOOL beingPresentedModally;              /* The controller was presented as a modal popup (eg, 'Done' button) */
@property (nonatomic,readonly) BOOL onTopOfNavigationControllerStack;   /* We're in, and not the root of a UINavigationController (eg, 'Back' button)*/

/* The main view components of the controller */
@property (nonatomic,readonly)  UINavigationBar *navigationBar;          /* Navigation bar shown along the top of the view */
@property (nonatomic,readonly)  UIToolbar *toolbar;                      /* Toolbar shown along the bottom */
@property (nonatomic,strong)    UIWebView *webView;                      /* The web view, where all the magic happens */
@property (nonatomic,strong)    LoadingView *loadingBarView;        /* The loading bar, displayed when a page is being loaded */
@property (nonatomic,strong)    UIImageView *webViewRotationSnapshot;    /* A snapshot of the web view, shown when rotating */

@property (nonatomic,strong) CAGradientLayer *gradientLayer;             /* Gradient effect for the background view behind the web view. */

/* Navigation Buttons */
@property (nonatomic,strong) UIButton *backButton;                       /* Moves the web view one page back */
@property (nonatomic,strong) UIButton *forwardButton;                    /* Moves the web view one page forward */
@property (nonatomic,strong) UIButton *reloadStopButton;                 /* Reload / Stop buttons */
@property (nonatomic,strong) UIButton *actionButton;                     /* Shows the UIActivityViewController */

/* Button placement metrics */
@property (nonatomic,assign) CGFloat buttonWidth;                        /* The size of each button */
@property (nonatomic,assign) CGFloat buttonSpacing;                      /* The size of the gap between each button */

/* Images for the Reload/Stop button */
@property (nonatomic,strong) UIImage *reloadIcon;
@property (nonatomic,strong) UIImage *stopIcon;

/* Theming attributes for generating navigation button art. */
@property (nonatomic,strong) NSMutableDictionary *buttonThemeAttributes;

/* See if we need to revert the toolbar to 'hidden' when we pop off a navigation controller. */
@property (nonatomic,assign) BOOL hideToolbarOnClose;
/* See if we need to revert the navigation bar to 'hidden' when we pop from a navigation controller */
@property (nonatomic,assign) BOOL hideNavBarOnClose;

//未对外开放
/* Disable the contextual popup that appears if the user taps and holds on a link. */
@property (nonatomic,assign)    BOOL disableContextualPopupMenu;

/* Hide the gray/linin background and all shadows and use the same colour as the current page */
@property (nonatomic,assign)    BOOL hideWebViewBoundaries;

/* When being presented as modal, this optional block can be performed after the users dismisses the controller. */
@property (nonatomic,copy)      void (^modalCompletionHandler)(void);

/* On iOS 6 or below, this can be used to override the default fill color of the navigation button icons */
@property (nonatomic,strong)    UIColor *buttonTintColor UI_APPEARANCE_SELECTOR;

/* On iOS 6 or below, this overrides the default opacity level of the bevel around the navigation buttons */
@property (nonatomic,assign)    CGFloat buttonBevelOpacity UI_APPEARANCE_SELECTOR;






/* Perform all common setup steps */
- (void)setup;

- (NSURL *)cleanURL:(NSURL *)url;

/* Init and configure various sections of the controller */
- (void)setUpNavigationButtons;
- (UIView *)containerViewWithNavigationButtons;

/* Review the current state of the web view and update the UI controls in the nav bar to match it */
- (void)refreshButtonsState;

/* Event callbacks for button taps */
- (void)backButtonTapped:(id)sender;
- (void)forwardButtonTapped:(id)sender;
- (void)reloadStopButtonTapped:(id)sender;
- (void)doneButtonTapped:(id)sender;



/* Methods related to tracking load progress of current page */
- (void)resetLoadProgress;
- (void)startLoadProgress;
- (void)incrementLoadProgress;
- (void)finishLoadProgress;
- (void)setLoadingProgress:(CGFloat)loadingProgress;
- (void)handleLoadRequestCompletion; //Called each time a request successfully (or unsuccessfully) ends

/* Methods to contain all of the functionality needed to properly animate the UIWebView rotating */
- (CGRect)rectForVisibleRegionOfWebViewAnimatingToOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)setUpWebViewForRotationToOrientation:(UIInterfaceOrientation)toOrientation withDuration:(NSTimeInterval)duration;
- (void)animateWebViewRotationToOrientation:(UIInterfaceOrientation)toOrientation withDuration:(NSTimeInterval)duration;
- (void)restoreWebViewFromRotationFromOrientation:(UIInterfaceOrientation)fromOrientation;

/* Methods to derive state information from the web view */
- (UIView *)webViewContentView;             //pull out the actual UIView used to display the web content so we can render a snapshot from it
- (BOOL)webViewPageWidthIsDynamic;          //The page will rescale its own content if the web view frame is changed (ie DON'T play a zooming animation)
- (UIColor *)webViewPageBackgroundColor;    //try and determine the background colour of the current page

@end

// -------------------------------------------------------

#pragma mark -
#pragma mark Class Implementation
@implementation WebBrowserViewController

- (instancetype)init
{
    if (self = [super init])
        [self setup];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
        [self setup];
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
        [self setup];
    
    return self;
}

- (instancetype)initWithURL:(NSURL *)url
{
    if (self = [self init])
        _url = [self cleanURL:url];
    
    return self;
}

#pragma mark - 处理数据
- (void)reciveWithData:(NSDictionary*)aDictionary withComplete:(void (^)(id responseData))completeBlock;
{
    _url = [self cleanURL:[NSURL URLWithString:aDictionary[@"ActionUrl"]]];
    
}


- (instancetype)initWithURLString:(NSString *)urlString
{
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (NSURL *)cleanURL:(NSURL *)url
{
    //If no URL scheme was supplied, defer back to HTTP.
    if (url.scheme.length == 0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", [url absoluteString]]];
    }
    
    return url;
}

- (void)setup
{
    //Direct ivar reference since we don't want to trigger their actions yet
    _buttonSpacing = (IPAD == NO) ? NAVIGATION_BUTTON_SPACING : NAVIGATION_BUTTON_SPACING_IPAD;
    _buttonWidth = NAVIGATION_BUTTON_WIDTH;
    _showLoadingBar = YES;
    _showUrlWhileLoading = YES;
    
    //Set the initial default style as full screen (But this can be easily overwritten)
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}

- (void)loadView
{
    //Create the all-encompassing container view
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    view.backgroundColor = (self.hideWebViewBoundaries ? [UIColor whiteColor] : BACKGROUND_COLOR);
#pragma clang diagnostic pop
    view.opaque = YES;
    view.clipsToBounds = YES;
    self.view = view;
    
    //create and add the detail gradient to the background view
    if (MINIMAL_UI == NO) {
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(id)[[UIColor colorWithWhite:0.0f alpha:0.0f] CGColor],(id)[[UIColor colorWithWhite:0.0f alpha:0.35f] CGColor]];
        self.gradientLayer.frame = self.view.bounds;
        [self.view.layer addSublayer:self.gradientLayer];
    }
    
    //Create the web view
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scalesPageToFit = YES;
    self.webView.contentMode = UIViewContentModeRedraw;
    self.webView.opaque = YES;
    [self.view addSubview:self.webView];
    
    //Set up the loading bar
    CGFloat y = self.webView.scrollView.contentInset.top;
    self.loadingBarView = [[LoadingView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.view.frame), LOADING_BAR_HEIGHT)];
    self.loadingBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //set the tint color for the loading bar
    if (MINIMAL_UI && self.loadingBarTintColor == nil) {
        if (self.navigationController && self.navigationController.view.window.tintColor)
            self.loadingBarView.backgroundColor = self.navigationController.view.window.tintColor;
        else if (self.view.window.tintColor)
            self.loadingBarView.backgroundColor = self.view.window.tintColor;
        else
            self.loadingBarView.backgroundColor = DEFAULT_BAR_TINT_COLOR;
    }
    else if (self.loadingBarTintColor)
        self.loadingBarView.backgroundColor = self.loadingBarTintColor;
    else
        self.loadingBarView.backgroundColor = DEFAULT_BAR_TINT_COLOR;
    
    //set up a subtle gradient to add over the loading bar
    if (MINIMAL_UI == NO) {
        CAGradientLayer *loadingBarGradientLayer = [CAGradientLayer layer];
        loadingBarGradientLayer.colors = @[(id)[[UIColor colorWithWhite:0.0f alpha:0.25f] CGColor],(id)[[UIColor colorWithWhite:0.0f alpha:0.0f] CGColor]];
        loadingBarGradientLayer.frame = self.loadingBarView.bounds;
        [self.loadingBarView.layer addSublayer:loadingBarGradientLayer];
    }
    
    //only load the buttons if we need to
    if (self.navigationButtonsHidden == NO)
        [self setUpNavigationButtons];
}

- (void)setUpNavigationButtons
{
    //set up the buttons for the navigation bar
    CGRect buttonFrame = CGRectZero; buttonFrame.size = NAVIGATION_BUTTON_SIZE;
    
    UIButtonType buttonType = UIButtonTypeCustom;
    if (MINIMAL_UI)
        buttonType = UIButtonTypeSystem;
    
    //set up the back button
    UIImage *backButtonImage = [self setBackButtonWithAttributes:self.buttonThemeAttributes];
    if (self.backButton == nil) {
        self.backButton = [UIButton buttonWithType:buttonType];
        [self.backButton setFrame:buttonFrame];
        [self.backButton setShowsTouchWhenHighlighted:YES];
    }
    [self.backButton setImage:backButtonImage forState:UIControlStateNormal];
    
    //set up the forward button (Don't worry about the frame at this point as it will be hidden by default)
    UIImage *forwardButtonImage = [self setForwardButtonWithAttributes:self.buttonThemeAttributes];
    if (self.forwardButton == nil) {
        self.forwardButton  = [UIButton buttonWithType:buttonType];
        [self.forwardButton setFrame:buttonFrame];
        [self.forwardButton setShowsTouchWhenHighlighted:YES];
    }
    [self.forwardButton setImage:forwardButtonImage forState:UIControlStateNormal];
    
    //set up the reload button
    if (self.reloadStopButton == nil) {
        self.reloadStopButton = [UIButton buttonWithType:buttonType];
        [self.reloadStopButton setFrame:buttonFrame];
        [self.reloadStopButton setShowsTouchWhenHighlighted:YES];
    }
    
    self.reloadIcon = [self setRefreshButtonWithAttributes:self.buttonThemeAttributes];
    self.stopIcon   = [self setStopButtonWithAttributes:self.buttonThemeAttributes];
    [self.reloadStopButton setImage:self.reloadIcon forState:UIControlStateNormal];
    
}

- (UIView *)containerViewWithNavigationButtons
{
    CGRect buttonFrame = CGRectZero;
    buttonFrame.size = NAVIGATION_BUTTON_SIZE;
    
    CGFloat width = (self.buttonWidth*3)+(self.buttonSpacing*2);
    
    //set up the icons for the navigation bar
    UIView *iconsContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, self.buttonWidth)];
    iconsContainerView.backgroundColor = [UIColor clearColor];
    
    //add the back button
    self.backButton.frame = buttonFrame;
    [iconsContainerView addSubview:self.backButton];
    
    //add the forward button too, but keep it hidden for now
    buttonFrame.origin.x = self.buttonWidth + self.buttonSpacing;
    self.forwardButton.frame = buttonFrame;
    [iconsContainerView addSubview:self.forwardButton];
    buttonFrame.origin.x += (self.buttonWidth + self.buttonSpacing);
    
    //add the reload button if the action button is hidden
    self.reloadStopButton.frame = buttonFrame;
    [iconsContainerView addSubview:self.reloadStopButton];
    buttonFrame.origin.x += (self.buttonWidth + self.buttonSpacing);
    

    return iconsContainerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //remove the shadow that lines the bottom of the webview
    if (MINIMAL_UI == NO) {
        for (UIView *view in self.webView.scrollView.subviews) {
            if ([view isKindOfClass:[UIImageView class]] && CGRectGetWidth(view.frame) == CGRectGetWidth(self.view.frame) && CGRectGetMinY(view.frame) > 0.0f + FLT_EPSILON)
                [view removeFromSuperview];
            else if ([view isKindOfClass:[UIImageView class]] && self.hideWebViewBoundaries)
                [view setHidden:YES];
        }
    }
    
    //if we are hiding the web view boundaries, hide the gradient layer
    if (self.hideWebViewBoundaries)
        self.gradientLayer.hidden = YES;
    
    //create the buttons view and add them to either the navigation bar or toolbar
    UIView *iconsContainerView = [self containerViewWithNavigationButtons];
    if (IPAD) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:iconsContainerView];
    }
    else {
        NSArray *items = @[BLANK_BARBUTTONITEM, [[UIBarButtonItem alloc] initWithCustomView:iconsContainerView], BLANK_BARBUTTONITEM];
        self.toolbarItems = items;
    }
    
    // Create the Done button
    if (self.beingPresentedModally && !self.onTopOfNavigationControllerStack) {
        NSString *title = @"完成";
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped:)];
        if (IPAD)
            self.navigationItem.leftBarButtonItem = doneButton;
        else
            self.navigationItem.rightBarButtonItem = doneButton;
    }
    
    //Set the appropriate actions to the buttons
    [self.backButton        addTarget:self action:@selector(backButtonTapped:)          forControlEvents:UIControlEventTouchUpInside];
    [self.forwardButton     addTarget:self action:@selector(forwardButtonTapped:)       forControlEvents:UIControlEventTouchUpInside];
    [self.reloadStopButton  addTarget:self action:@selector(reloadStopButtonTapped:)    forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //see if we need to show the toolbar
    if (self.navigationController) {
        self.hideToolbarOnClose = self.navigationController.toolbarHidden;
        self.hideNavBarOnClose  = self.navigationBar.hidden;
        
        if (IPAD == NO) { //iPhone
            if (self.beingPresentedModally == NO) { //being pushed onto a pre-existing stack, so
                [self.navigationController setToolbarHidden:NO animated:animated];
                [self.navigationController setNavigationBarHidden:NO animated:animated];
            }
            else { //Being presented modally, so control the
                self.navigationController.toolbarHidden = NO;
            }
        }
        else {
            [self.navigationController setNavigationBarHidden:NO animated:animated];
            [self.navigationController setToolbarHidden:YES animated:animated];
        }
    }
    
    //reset the gradient layer in case the bounds changed before display
    self.gradientLayer.frame = self.view.bounds;
    
    //start loading the initial page
    if (self.url && self.webView.request == nil)
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.beingPresentedModally == NO) {
        [self.navigationController setToolbarHidden:self.hideToolbarOnClose animated:animated];
        [self.navigationController setNavigationBarHidden:self.hideNavBarOnClose animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)shouldAutorotate
{
    if (self.webViewRotationSnapshot)
        return NO;
    
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (self.webViewRotationSnapshot)
        return NO;
    
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //get the web view ready for rotation
    [self setUpWebViewForRotationToOrientation:toInterfaceOrientation withDuration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //reset the gradient layer's frame to match the new bounds
    self.gradientLayer.frame = self.view.bounds;
    
    //update the loading bar to match the proper bounds
    self.loadingBarView.frame = ({
        CGRect frame = self.loadingBarView.frame;
        frame.origin.y = self.webView.scrollView.contentInset.top;
        frame.origin.x = -CGRectGetWidth(self.loadingBarView.frame) + (CGRectGetWidth(self.view.bounds) * _loadingProgressState.loadingProgress);
        frame;
    });
    
    //animate the web view snapshot into the proper place
    [self animateWebViewRotationToOrientation:toInterfaceOrientation withDuration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self restoreWebViewFromRotationFromOrientation:fromInterfaceOrientation];
}

#pragma mark -
#pragma mark State Tracking
- (BOOL)beingPresentedModally
{
    // Check if we have a parentl navigation controller being presented modally
    if (self.navigationController)
        return ([self.navigationController presentingViewController] != nil);
    else // Check if we're directly being presented modally
        return ([self presentingViewController] != nil);
    
    return NO;
}

- (BOOL)onTopOfNavigationControllerStack
{
    if (self.navigationController == nil)
        return NO;
    
    if ([self.navigationController.viewControllers count] && [self.navigationController.viewControllers indexOfObject:self] > 0)
        return YES;
    
    return NO;
}

#pragma mark -
#pragma mark Manual Property Accessors
- (void)setUrl:(NSURL *)url
{
    if (self.url == url)
        return;
    
    _url = [self cleanURL:url];
    
    if (self.webView.loading)
        [self.webView stopLoading];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)setLoadingBarTintColor:(UIColor *)loadingBarTintColor
{
    if (loadingBarTintColor == self.loadingBarTintColor)
        return;
    
    _loadingBarTintColor = loadingBarTintColor;
    
    self.loadingBarView.backgroundColor = self.loadingBarTintColor;
}

- (UINavigationBar *)navigationBar
{
    if (self.navigationController)
        return self.navigationController.navigationBar;
    
    return nil;
}

- (UIToolbar *)toolbar
{
    if (IPAD)
        return nil;
    
    if (self.navigationController)
        return self.navigationController.toolbar;
    
    return nil;
}

- (void)setNavigationButtonsHidden:(BOOL)navigationButtonsHidden
{
    if (navigationButtonsHidden == _navigationButtonsHidden)
        return;
    
    _navigationButtonsHidden = navigationButtonsHidden;
    
    if (_navigationButtonsHidden == NO)
    {
        [self setUpNavigationButtons];
        UIView *iconsContainerView = [self containerViewWithNavigationButtons];
        if (IPAD) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:iconsContainerView];
        }
        else {
            NSArray *items = @[BLANK_BARBUTTONITEM, [[UIBarButtonItem alloc] initWithCustomView:iconsContainerView], BLANK_BARBUTTONITEM];
            self.toolbarItems = items;
        }
    }
    else
    {
        if (IPAD) {
            self.navigationItem.rightBarButtonItem  = nil;
        }
        else {
            self.navigationController.toolbarItems = nil;
            self.navigationController.toolbarHidden = YES;
        }
        
        self.backButton = nil;
        self.forwardButton = nil;
        self.reloadIcon = nil;
        self.stopIcon = nil;
        self.reloadStopButton = nil;
        self.actionButton = nil;
    }
}

- (void)setButtonTintColor:(UIColor *)buttonTintColor
{
    if (buttonTintColor == _buttonTintColor)
        return;
    
    _buttonTintColor = buttonTintColor;
    
    if (self.buttonThemeAttributes == nil)
        self.buttonThemeAttributes = [NSMutableDictionary dictionary];
    
    self.buttonThemeAttributes[ButtonTintColor] = _buttonTintColor;
    [self setUpNavigationButtons];
}

- (void)setButtonBevelOpacity:(CGFloat)buttonBevelOpacity
{
    if (buttonBevelOpacity == _buttonBevelOpacity)
        return;
    
    _buttonBevelOpacity = buttonBevelOpacity;
    
    if (self.buttonThemeAttributes == nil)
        self.buttonThemeAttributes = [NSMutableDictionary dictionary];
    
    self.buttonThemeAttributes[ButtonBevelOpacity] = @(_buttonBevelOpacity);
    [self setUpNavigationButtons];
}

#pragma mark -
#pragma mark WebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL shouldStart = YES;
    
    //TODO: Implement TOModalWebViewController Delegate callback
    
    //if the URL is the load completed notification from JavaScript
    if ([request.URL.absoluteString isEqualToString:kCompleteRPCURL])
    {
        [self finishLoadProgress];
        return NO;
    }
    
    //If the URL contrains a fragement jump (eg an anchor tag), check to see if it relates to the current page, or another
    //If we're merely jumping around the same page, don't perform a new loading bar sequence
    BOOL isFragmentJump = NO;
    if (request.URL.fragment)
    {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    BOOL isHTTP = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"];
    if (shouldStart && !isFragmentJump && isHTTP && isTopLevelNavigation && navigationType != UIWebViewNavigationTypeBackForward)
    {
        //Save the URL in the accessor property
        _url = [request URL];
        [self resetLoadProgress];
    }
    
    return shouldStart;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //increment the number of load requests started
    _loadingProgressState.loadingCount++;
    
    //keep track if this is the highest number of concurrent requests
    _loadingProgressState.maxLoadCount = MAX(_loadingProgressState.maxLoadCount, _loadingProgressState.loadingCount);
    
    //start tracking the load state
    [self startLoadProgress];
    
    //update the navigation bar buttons
    [self refreshButtonsState];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self handleLoadRequestCompletion];
    [self refreshButtonsState];
    
    //see if we can set the proper page title at this point
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self handleLoadRequestCompletion];
    [self refreshButtonsState];
}

#pragma mark -
#pragma mark Button Callbacks
- (void)backButtonTapped:(id)sender
{
    [self.webView goBack];
    [self refreshButtonsState];
}

- (void)forwardButtonTapped:(id)sender
{
    [self.webView goForward];
    [self refreshButtonsState];
}

- (void)reloadStopButtonTapped:(id)sender
{
    if (self.webView.isLoading)
        [self.webView stopLoading];
    else
        [self.webView reload];
    
    [self refreshButtonsState];
}

- (void)doneButtonTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.modalCompletionHandler];
}


#pragma mark -
#pragma mark Page Load Progress Tracking Handlers
- (void)resetLoadProgress
{
    memset(&_loadingProgressState, 0, sizeof(_loadingProgressState));
    [self setLoadingProgress:0.0f];
}

- (void)startLoadProgress
{
    //If we haven't started loading yet, set the progress to small, but visible value
    if (_loadingProgressState.loadingProgress < kInitialProgressValue)
    {
        //reset the loading bar
        CGRect frame = self.loadingBarView.frame;
        frame.size.width = CGRectGetWidth(self.view.bounds);
        frame.origin.x = -frame.size.width;
        frame.origin.y = self.webView.scrollView.contentInset.top;
        self.loadingBarView.frame = frame;
        self.loadingBarView.alpha = 1.0f;
        
        //add the loading bar to the view
        if (self.showLoadingBar)
            [self.view insertSubview:self.loadingBarView aboveSubview:self.navigationBar];
        
        //kickstart the loading progress
        [self setLoadingProgress:kInitialProgressValue];
        
        //show that loading started in the status bar
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        //set the title to the URL until we load the page properly
        if (self.showUrlWhileLoading) {
            NSString *url = [self.url absoluteString];
            url = [url stringByReplacingOccurrencesOfString:@"http://" withString:@""];
            url = [url stringByReplacingOccurrencesOfString:@"https://" withString:@""];
            self.title = url;
        }
        
        if (self.reloadStopButton)
            [self.reloadStopButton setImage:self.stopIcon forState:UIControlStateNormal];
    }
}

- (void)incrementLoadProgress
{
    float progress          = _loadingProgressState.loadingProgress;
    float maxProgress       = _loadingProgressState.interactive ? kAfterInteractiveMaxProgressValue : kBeforeInteractiveMaxProgressValue;
    float remainingPercent  = (float)_loadingProgressState.loadingCount / (float)_loadingProgressState.maxLoadCount;
    float increment         = (maxProgress - progress) * remainingPercent;
    progress                = fmin((progress+increment), maxProgress);
    
    [self setLoadingProgress:progress];
}

- (void)finishLoadProgress
{
    //hide the activity indicator in the status bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //reset the load progress
    [self refreshButtonsState];
    [self setLoadingProgress:1.0f];
    
    //in case it didn't succeed yet, try setting the page title again
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (self.reloadStopButton)
        [self.reloadStopButton setImage:self.reloadIcon forState:UIControlStateNormal];
}

- (void)setLoadingProgress:(CGFloat)loadingProgress
{
    // progress should be incremental only
    if (loadingProgress > _loadingProgressState.loadingProgress || loadingProgress == 0)
    {
        _loadingProgressState.loadingProgress = loadingProgress;
        
        //Update the loading bar progress to match
        if (self.showLoadingBar)
        {
            CGRect frame = self.loadingBarView.frame;
            frame.origin.x = -CGRectGetWidth(self.loadingBarView.frame) + (CGRectGetWidth(self.view.bounds) * _loadingProgressState.loadingProgress);
            
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.loadingBarView.frame = frame;
            } completion:^(BOOL finished) {
                //once loading is complete, fade it out
                if (loadingProgress >= 1.0f - FLT_EPSILON)
                {
                    [UIView animateWithDuration:0.2f animations:^{
                        self.loadingBarView.alpha = 0.0f;
                    }];
                }
            }];
        }
    }
}

- (void)handleLoadRequestCompletion
{
    //decrement the number of concurrent requests
    _loadingProgressState.loadingCount--;
    
    //update the progress bar
    [self incrementLoadProgress];
    
    //Query the webview to see what load state JavaScript perceives it at
    NSString *readyState = [self.webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    //interactive means the page has loaded sufficiently to allow user interaction now
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive)
    {
        _loadingProgressState.interactive = YES;
        
        //if we're at the interactive state, attach a Javascript listener to inform us when the page has fully loaded
        NSString *waitForCompleteJS = [NSString stringWithFormat:   @"window.addEventListener('load',function() { "
                                       @"var iframe = document.createElement('iframe');"
                                       @"iframe.style.display = 'none';"
                                       @"iframe.src = '%@';"
                                       @"document.body.appendChild(iframe);"
                                       @"}, false);", kCompleteRPCURL];
        
        [self.webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
        
        //see if we can set the proper page title yet
        self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        
        //if we're matching the view BG to the web view, update the background colour now
        if (self.hideWebViewBoundaries)
            self.view.backgroundColor = [self webViewPageBackgroundColor];
        
        //finally, if the app desires it, disable the ability to tap and hold on links
        if (self.disableContextualPopupMenu)
            [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    }
    
    BOOL isNotRedirect = self.url && [self.url isEqual:self.webView.request.URL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect)
        [self finishLoadProgress];
}

#pragma mark -
#pragma mark Button State Handling
- (void)refreshButtonsState
{
    //update the state for the back button
    if (self.webView.canGoBack)
        [self.backButton setEnabled:YES];
    else
        [self.backButton setEnabled:NO];
    
    if (self.webView.canGoForward)
        [self.forwardButton setEnabled:YES];
    else
        [self.forwardButton setEnabled:NO];
}

#pragma mark -
#pragma mark UIWebView Attrbutes
- (UIView *)webViewContentView
{
    //loop through the views inside the webview, and pull out the one that renders the HTML content
    for (UIView *view in self.webView.scrollView.subviews)
    {
        if ([NSStringFromClass([view class]) rangeOfString:@"WebBrowser"].location != NSNotFound)
            return view;
    }
    
    return nil;
}

- (BOOL)webViewPageWidthIsDynamic
{
    //A bit of a crazy JavaScript that scans the HTML for a <meta name="viewport"> tag and retrieves its contents
    NSString *metaDataQuery =   @"(function() {"
    @"var metaTags = document.getElementsByTagName('meta');"
    @"for (i=0; i<metaTags.length; i++) {"
    @"if (metaTags[i].name=='viewport') {"
    @"return metaTags[i].getAttribute('content');"
    @"}"
    @"}"
    @"})()";
    
    NSString *pageViewPortContent = [self.webView stringByEvaluatingJavaScriptFromString:metaDataQuery];
    if ([pageViewPortContent length] == 0)
        return NO;
    
    //remove all white space and make sure it's all lower case
    pageViewPortContent = [[pageViewPortContent stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    
    //check if the max page zoom is locked at 1
    if ([pageViewPortContent rangeOfString:@"maximum-scale=1"].location != NSNotFound)
        return YES;
    
    //check if zooming is intentionally disabled
    if ([pageViewPortContent rangeOfString:@"user-scalable=no"].location != NSNotFound)
        return YES;
    
    //check if width is set to align to the width of the device
    if ([pageViewPortContent rangeOfString:@"width=device-width"].location != NSNotFound)
        return YES;
    
    //check if initial scale is being forced (Apple seem to blanket apply this in Safari)
    if ([pageViewPortContent rangeOfString:@"initial-scale=1"].location != NSNotFound)
        return YES;
    
    return NO;
}

- (UIColor *)webViewPageBackgroundColor
{
    //Pull the current background colour from the web view
    NSString *rgbString = [self.webView stringByEvaluatingJavaScriptFromString:@"window.getComputedStyle(document.body,null).getPropertyValue('background-color');"];
    
    //if it wasn't found, or if it isn't a proper rgb value, just return white as the default
    if ([rgbString length] == 0 || [rgbString rangeOfString:@"rgb"].location == NSNotFound)
        return [UIColor whiteColor];
    
    //Assuming now the input is either 'rgb(255, 0, 0)' or 'rgba(255, 0, 0, 255)'
    
    //remove the 'rgba' componenet
    rgbString = [rgbString stringByReplacingOccurrencesOfString:@"rgba" withString:@""];
    //conversely, remove the 'rgb' component
    rgbString = [rgbString stringByReplacingOccurrencesOfString:@"rgb" withString:@""];
    //remove the brackets
    rgbString = [rgbString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    rgbString = [rgbString stringByReplacingOccurrencesOfString:@")" withString:@""];
    //remove all spaces
    rgbString = [rgbString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //we should now have something like '0,0,0'. Split it up via the commas
    NSArray *componenets = [rgbString componentsSeparatedByString:@","];
    
    //Final output componenets
    CGFloat red, green, blue, alpha = 1.0f;
    
    //if the alpha value is 0, this indicates the RGB value wasn't actually set in the page, so just return white
    if ([componenets count] < 3 || ([componenets count] >= 4 && [[componenets objectAtIndex:3] integerValue] == 0))
        return [UIColor whiteColor];
    
    red     = (CGFloat)[[componenets objectAtIndex:0] integerValue] / 255.0f;
    green   = (CGFloat)[[componenets objectAtIndex:1] integerValue] / 255.0f;
    blue    = (CGFloat)[[componenets objectAtIndex:2] integerValue] / 255.0f;
    
    if ([componenets count] >= 4)
        alpha = (CGFloat)[[componenets objectAtIndex:3] integerValue] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark -
#pragma mark UIWebView Interface Rotation Handler
- (CGRect)rectForVisibleRegionOfWebViewAnimatingToOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGRect  rect            = CGRectZero;
    CGPoint contentOffset   = self.webView.scrollView.contentOffset;
    CGSize  webViewSize     = self.webView.bounds.size;
    CGSize  contentSize     = self.webView.scrollView.contentSize;
    CGFloat topInset        = self.webView.scrollView.contentInset.top;
    
    //we're in portrait now, target orientation is landscape
    //(So since we're zooming in, we don't need to worry about content outside the visible boundaries)
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        //save the current scroll offset and size of the web view
        rect.origin = contentOffset;
        rect.size   = webViewSize;
        
        //There's no point in capturing content beyond the scroll content bounds (eg edgeInsets)
        //Clip the rect to the scrollbounds
        if (contentOffset.y < 0.0f + FLT_EPSILON) {
            rect.origin.y = 0.0f;
            rect.size.height -= MAX(contentOffset.y + topInset, 0);
        }
        else if (contentOffset.y + CGRectGetHeight(rect) > contentSize.height) {
            rect.size.height = contentSize.height - contentOffset.y;
        }
    }
    else //rotating from landscape to portrait. We need to make sure we capture content outside the visible region so it can pan back in
    {
        CGFloat heightInPortraitMode = webViewSize.width;
        //dirty hack for pre-iOS 7 devices, where we can't derive the target
        //height of the webview with the UINavigationController changing the bounds
        if (MINIMAL_UI == NO) {
            if (self.navigationBar)
                heightInPortraitMode -= 44.0f;
            
            if (self.toolbar)
                heightInPortraitMode -= 44.0f;
            
            if ([UIApplication sharedApplication].statusBarHidden == NO)
                heightInPortraitMode -= [[UIApplication sharedApplication] statusBarFrame].size.width;
        }
        
        CGSize  contentSize   = self.webView.scrollView.contentSize;
        
        if ([self webViewPageWidthIsDynamic])
        {
            //set the content offset for the view to be rendered
            rect.origin = contentOffset;
            if (contentOffset.y + heightInPortraitMode > contentSize.height )
                rect.origin.y = contentSize.height - heightInPortraitMode;
            
            rect.size.width = webViewSize.width;
            rect.size.height = heightInPortraitMode; //make it as tall as it is wide
        }
        else
        {
            //set the scroll offset
            rect.origin = contentOffset;
            
            //The height of the region we're animating to, in the same space as the current content
            CGFloat portraitWidth = webViewSize.height;
            if (MINIMAL_UI == NO) {
                if (self.navigationBar)
                    portraitWidth += CGRectGetHeight(self.navigationBar.frame);
                
                if (self.toolbar)
                    portraitWidth += CGRectGetHeight(self.toolbar.frame);
                
                if ([UIApplication sharedApplication].statusBarHidden == NO)
                    heightInPortraitMode -= [[UIApplication sharedApplication] statusBarFrame].size.width;
            }
            
            CGFloat scaledHeight = heightInPortraitMode * (webViewSize.width / portraitWidth);
            
            //assume we're animating outwards with the visible region being the center.
            //so make sure to capture everything above and below it
            rect.origin.y = (contentOffset.y+(webViewSize.height*0.5f)) - (scaledHeight*0.5f);
            
            //if this takes us past the visible region, clamp it
            if (rect.origin.y < 0)
                rect.origin.y = 0;
            else if (rect.origin.y + scaledHeight > contentSize.height)
                rect.origin.y = contentSize.height - scaledHeight;
            
            rect.size.width = webViewSize.width;
            rect.size.height = scaledHeight;
        }
    }
    
    return rect;
}

/* Called outside of the animation block. All of the views are currently in their 'before' state. */
- (void)setUpWebViewForRotationToOrientation:(UIInterfaceOrientation)toOrientation withDuration:(NSTimeInterval)duration
{
    // form sheet style controllers' bounds don't change, so none of this is necessary
    if (IPAD && self.modalPresentationStyle == UIModalPresentationFormSheet)
        return;
    
    //if there's already a snapshot in place (shouldn't be possible), just in case, remove it
    if (self.webViewRotationSnapshot)
    {
        [self.webViewRotationSnapshot removeFromSuperview];
        self.webViewRotationSnapshot = nil;
    }
    
    //Save the current state so we can use it to properly transition after the rotation is complete
    _webViewState.frameSize         = self.webView.frame.size;
    _webViewState.contentSize       = self.webView.scrollView.contentSize;
    _webViewState.zoomScale         = self.webView.scrollView.zoomScale;
    _webViewState.contentOffset     = self.webView.scrollView.contentOffset;
    _webViewState.minimumZoomScale  = self.webView.scrollView.minimumZoomScale;
    _webViewState.maximumZoomScale  = self.webView.scrollView.maximumZoomScale;
    _webViewState.topEdgeInset      = self.webView.scrollView.contentInset.top;
    _webViewState.bottomEdgeInset   = self.webView.scrollView.contentInset.bottom;
    
    UIView  *webContentView         = [self webViewContentView];
    UIColor *pageBackgroundColor    = [self webViewPageBackgroundColor];
    UIColor *webViewBackgroundColor = [self view].backgroundColor;
    CGRect  renderBounds            = [self rectForVisibleRegionOfWebViewAnimatingToOrientation:toOrientation];
    
    //generate a snapshot of the webview that we can animate more smoothly
    CGFloat scale = 1.0f;
    if (UIInterfaceOrientationIsLandscape(toOrientation))
        scale = 0.0f;
    
    UIGraphicsBeginImageContextWithOptions(renderBounds.size, YES, scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        //fill the whole canvas with the base color background colour
        CGContextSetFillColorWithColor(context, webViewBackgroundColor.CGColor);
        CGContextFillRect(context, CGRectMake(0,0,CGRectGetWidth(renderBounds),CGRectGetHeight(renderBounds)));
        //offset the scroll view by the necessary amount
        CGContextTranslateCTM(context, -renderBounds.origin.x, -renderBounds.origin.y);
        //render the webview to the context
        [webContentView.layer renderInContext:context];
        //grab the image
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //save the image to the image view
        self.webViewRotationSnapshot = [[UIImageView alloc] initWithImage:image];
    }
    UIGraphicsEndImageContext();
    
    //work out the starting frame for the snapshot based on page state and current orientation
    CGRect frame = (CGRect){CGPointZero, renderBounds.size};
    
    //If we're presently portrait, and animating to landscape
    if (UIInterfaceOrientationIsLandscape(toOrientation))
    {
        //If the current web page zoom is locked (eg, it's a mobile site), set an appropriate background colour and don't zoom the image
        if ([self webViewPageWidthIsDynamic])
        {
            self.webViewRotationSnapshot.backgroundColor = pageBackgroundColor;
            self.webViewRotationSnapshot.contentMode = UIViewContentModeTop;
        }
        else {
            self.webViewRotationSnapshot.contentMode = UIViewContentModeScaleAspectFill;
        }
        
        //if we have a content inset along the top, line up the image along the proper inset
        if (_webViewState.contentOffset.y < 0.0f) {
            frame.origin.y = _webViewState.topEdgeInset - (_webViewState.topEdgeInset + _webViewState.contentOffset.y);
            frame.origin.y = MAX(0, frame.origin.y);
        }
    }
    else //if we're currently landscape and we're animating to portrait
    {
        //If the current web page zoom is locked like above,
        if ([self webViewPageWidthIsDynamic])
        {
            self.webViewRotationSnapshot.backgroundColor = pageBackgroundColor;
            
            //if the landscape scrolloffset is outside the bounds of the portrait mode, animate from the bottom to line it up properly
            CGFloat heightInPortraitMode = CGRectGetWidth(self.webView.frame);
            if (self.webView.scrollView.contentOffset.y + heightInPortraitMode > self.webView.scrollView.contentSize.height )
                self.webViewRotationSnapshot.contentMode = UIViewContentModeBottomLeft;
            else
                self.webViewRotationSnapshot.contentMode = UIViewContentModeTopLeft;
        }
        else
        {
            self.webViewRotationSnapshot.contentMode = UIViewContentModeScaleAspectFill;
            
            frame.size  = self.webViewRotationSnapshot.image.size;
            
            if ((_webViewState.contentOffset.y + _webViewState.topEdgeInset) > FLT_EPSILON) {
                //Work out the content offset of the snapshot view if we positioned it over the middle of the web view
                CGFloat webViewMidPoint  = _webViewState.contentOffset.y + (_webViewState.frameSize.height * 0.5f);
                CGFloat topContentOffset = webViewMidPoint - (renderBounds.size.height * 0.5f);
                CGFloat bottomContentOffset = webViewMidPoint + (renderBounds.size.height * 0.5f);
                
                if (topContentOffset < -_webViewState.topEdgeInset) {
                    frame.origin.y = -_webViewState.contentOffset.y;
                }
                else if (bottomContentOffset > _webViewState.contentSize.height) {
                    CGFloat bottomOfScrollContentView = _webViewState.contentSize.height - (_webViewState.contentOffset.y + _webViewState.frameSize.height);
                    frame.origin.y = (_webViewState.frameSize.height + bottomOfScrollContentView) - CGRectGetHeight(frame);
                }
                else {
                    frame.origin.y = ((CGRectGetHeight(self.webView.frame)*0.5) - CGRectGetHeight(frame)*0.5);
                }
            }
            else {
                frame.origin.y = _webViewState.topEdgeInset;
            }
        }
    }
    
    self.webViewRotationSnapshot.frame = frame;
    [self.view insertSubview:self.webViewRotationSnapshot belowSubview:self.navigationBar];
    
    //This is a dirty, dirty, DIRTY hack. When a UIWebView's frame changes (At least on iOS 6), in certain conditions,
    //the content view will NOT resize with it. This can result in visual artifacts, such as black bars up the side,
    //and weird touch feedback like not being able to properly zoom out until the user has first zoomed in and released the touch.
    //So far, the only way I've found to actually correct this is to invoke a trivial zoom animation, and this will
    //trip the webview into redrawing its content.
    //Once the view has finished rotating, we'll figure out the proper placement + zoom scale and reset it.
    
    //This animation must be complete by the time the view rotation animation is complete, else we'll have incorrect bounds data. This will speed it up to near instant.
    self.webView.scrollView.layer.speed = 9999.0f;
    
    //zoom into the mid point of the scale. Zooming into either extreme doesn't work.
    CGFloat zoomScale = (self.webView.scrollView.minimumZoomScale+self.webView.scrollView.maximumZoomScale) * 0.5f;
    [self.webView.scrollView setZoomScale:zoomScale animated:YES];
    
    //hide the webview while the snapshot is animating
    self.webView.hidden = YES;
}

/* Called within the animation block. All views will be set to their 'destination' state. */
- (void)animateWebViewRotationToOrientation:(UIInterfaceOrientation)toOrientation withDuration:(NSTimeInterval)duration
{
    /// form sheet style controllers' bounds don't change, so implemeting this is rather pointless
    if (IPAD && self.modalPresentationStyle == UIModalPresentationFormSheet)
        return;
    
    //remove all animations presently applied to the web view
    [self.webView.layer removeAllAnimations];
    [self.webView.scrollView.layer removeAllAnimations];
    
    //animate the image view rotating to the proper dimensions
    CGRect frame = self.webView.bounds;
    
    //We only need to scale/translate the image view if the web page has a static width
    if ([self webViewPageWidthIsDynamic] == NO)
    {
        CGFloat scale = CGRectGetHeight(self.webViewRotationSnapshot.frame)/CGRectGetWidth(self.webViewRotationSnapshot.frame);
        frame.size.height = CGRectGetWidth(frame) * scale;
        
        //If we're not scrolled at the very top, animate towards the center of the view.
        //If we're at either extreme (top or bottom) where rotating from the centre would
        //push us past oour scroll bounds, lock the snapshot to the necessary edge
        if ((_webViewState.contentOffset.y + _webViewState.topEdgeInset) > FLT_EPSILON) {
            //Work out the offset we're rotating to
            CGFloat scale = (CGRectGetHeight(self.webView.frame) / CGRectGetWidth(self.webView.frame));
            CGFloat destinationBoundsHeight = self.webView.bounds.size.height; //destiantion height we'll be animating to
            CGFloat destinationHeight = destinationBoundsHeight * scale; //the expected height of the visible bounds (in pre-anim rotation scale)
            CGFloat webViewOffsetOrigin = (_webViewState.contentOffset.y + (_webViewState.frameSize.height * 0.5f)); //the content offset of the middle of the web view
            CGFloat topContentOffset = webViewOffsetOrigin - (destinationHeight * 0.5f); // in the pre-animated space, the top content offset
            CGFloat bottomContentOffset = webViewOffsetOrigin + (destinationHeight * 0.5f); // the bottom offset
            
            //adjust as needed to fit the top or bottom
            if (topContentOffset < -_webViewState.topEdgeInset) { //re-align to the top
                frame.origin.y = self.webView.scrollView.contentInset.top;
            }
            else if (bottomContentOffset > _webViewState.contentSize.height) { // re-align along the bottom
                frame.origin.y = (CGRectGetMaxY(self.webView.frame) - (CGRectGetHeight(frame) + self.webView.scrollView.contentInset.bottom));
            }
            else { //position the webview in the center
                frame.origin.y = ((destinationBoundsHeight*0.5f) - (CGRectGetHeight(frame)*0.5f));
                
                //If we're partially scrolled below zero, then the snapshot will need to be offset to account for its smaller size
                if (_webViewState.contentOffset.y < 0.0f) {
                    CGFloat delta = _webViewState.topEdgeInset - (_webViewState.topEdgeInset + _webViewState.contentOffset.y);
                    frame.origin.y += (delta * (_webViewState.frameSize.height/_webViewState.frameSize.width));
                }
            }
        }
        else {
            frame.origin.y = self.webView.scrollView.contentInset.top;
        }
    }
    else {
        //If we're partially scrolled below zero, then the snapshot will need to be offset to account for its smaller size
        if (_webViewState.contentOffset.y < 0.0f) {
            CGFloat delta = _webViewState.topEdgeInset - (_webViewState.topEdgeInset + _webViewState.contentOffset.y);
            
            if (UIInterfaceOrientationIsLandscape(toOrientation))
                frame.origin.y += delta - (_webViewState.topEdgeInset - self.webView.scrollView.contentInset.top);
            else
                frame.origin.y -= (_webViewState.topEdgeInset - self.webView.scrollView.contentInset.top);
        }
    }
    
    
    self.webViewRotationSnapshot.frame = frame;
}

- (void)restoreWebViewFromRotationFromOrientation:(UIInterfaceOrientation)fromOrientation
{
    /// form sheet style controllers' bounds don't change, so implemeting this isn't required
    if (IPAD && self.modalPresentationStyle == UIModalPresentationFormSheet)
        return;
    
    //Side Note: When a UIWebView has just had its bounds change, its minimumZoomScale and maximumZoomScale become completely (almost arbitrarily) different.
    //But, it WILL rest back to minimumZoomScale = 1.0f, after the next time the user interacts with it.
    //For resetting the state right now (as the user hasn't touched it yet), we must use the 'different' values, and translate the original state to them.
    //---
    //So from this point, we need to 'coax' the web view content to align to the new zoom scale. The transition NEEDS to be instant,
    //but we can't use animated:NO since that won't commit the zoom properly and will cause visual glitches (ie HAS to be animated:YES).
    //So to solve this, we're accessing the core animation layer and temporarily increasing the animation speed of the scrollview.
    //The zoom event is still occurring, but it's so fast, it seems instant
    CGFloat translatedScale = ((_webViewState.zoomScale/_webViewState.minimumZoomScale) * self.webView.scrollView.minimumZoomScale);
    
    //if we ended up scrolling past the max zoom size, just extend it.
    if (translatedScale > self.webView.scrollView.maximumZoomScale)
        self.webView.scrollView.maximumZoomScale = translatedScale;
    
    [self.webView.scrollView.layer removeAllAnimations];
    self.webView.scrollView.layer.speed = 9999.0f;
    [self.webView.scrollView setZoomScale:translatedScale animated:YES];
    
    //Pull out the animation and attach a delegate so we can receive an event when it's finished, to clean it up properly
    CABasicAnimation *anim = [[self.webView.scrollView.layer animationForKey:@"bounds"] mutableCopy];
    if (anim == nil) { //anim may be nil if the zoomScale wasn't sufficiently different to warrant an animation
        [self animationDidStop:anim finished:YES];
        return;
    }
    
    [self.webView.scrollView.layer removeAnimationForKey:@"bounds"];
    [anim setDelegate:self];
    [self.webView.scrollView.layer addAnimation:anim forKey:@"bounds"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //when the rotation and animation is complete, FINALLY unhide the web view
    self.webView.hidden = NO;
    
    CGSize contentSize = self.webView.scrollView.contentSize;
    CGPoint translatedContentOffset = _webViewState.contentOffset;
    
    //if the page is a mobile site, just re-add the original content offset. It'll size itself properly
    if ([self webViewPageWidthIsDynamic])
    {
        //adjust the offset for any UINavigationBar size changess
        CGFloat delta = (_webViewState.topEdgeInset - self.webView.scrollView.contentInset.top);
        translatedContentOffset.y += delta;
    }
    else //else, determine the magnitude we zoomed in/out by and translate the scroll offset to line it up properly
    {
        CGFloat magnitude = contentSize.width / _webViewState.contentSize.width;
        
        //transform the translated offset
        translatedContentOffset.x *= magnitude;
        translatedContentOffset.y *= magnitude;
        
        //if we were sufficiently scrolled from the top, make sure to line up to the middle, not the top
        if ((_webViewState.contentOffset.y + _webViewState.topEdgeInset) > FLT_EPSILON)
        {
            if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
                translatedContentOffset.y += (CGRectGetHeight(self.webViewRotationSnapshot.frame)*0.5f) - (CGRectGetHeight(self.webView.frame)*0.5f);
            }
            else {
                //Work out the offset we're rotating to
                CGFloat scale = (_webViewState.frameSize.width / _webViewState.frameSize.height);
                CGFloat destinationBoundsHeight = self.webView.bounds.size.height; //destiantion height we'll be animating to
                CGFloat destinationHeight = destinationBoundsHeight * scale; //the expected height of the visible bounds (in pre-anim rotation scale)
                CGFloat webViewOffsetOrigin = (_webViewState.contentOffset.y + _webViewState.frameSize.height * 0.5f); //the content offset of the middle of the web view
                CGFloat bottomContentOffset = webViewOffsetOrigin + (destinationHeight * 0.5f); // the bottom offset
                
                //If our original state meant we clipped the bottom of the scroll view, just clamp it to the bottom
                if (bottomContentOffset > _webViewState.contentSize.height)
                    translatedContentOffset.y = self.webView.scrollView.contentSize.height - (CGRectGetHeight(self.webView.frame)) + self.webView.scrollView.contentInset.top;
                else
                    translatedContentOffset.y -= (CGRectGetHeight(self.webView.frame)*0.5f) - (((_webViewState.frameSize.height*magnitude)*0.5f));
            }
        }
        else { //otherwise, just reset the origin to the top
            translatedContentOffset.y = -self.webView.scrollView.contentInset.top;
        }
    }
    
    //clamp it to the actual scroll region
    translatedContentOffset.x = MAX(translatedContentOffset.x, -self.webView.scrollView.contentInset.left);
    translatedContentOffset.x = MIN(translatedContentOffset.x, contentSize.width - CGRectGetWidth(self.webView.frame));
    
    translatedContentOffset.y = MAX(translatedContentOffset.y, -self.webView.scrollView.contentInset.top);
    translatedContentOffset.y = MIN(translatedContentOffset.y, contentSize.height - (CGRectGetHeight(self.webView.frame) - self.webView.scrollView.contentInset.bottom));
    
    //apply the translated offset (Thankfully, this one doens't have to be animated in order to work properly)
    [self.webView.scrollView setContentOffset:translatedContentOffset animated:NO];
    
    //restore proper scroll speed
    self.webView.scrollView.layer.speed = 1.0f;
    
    //remove the rotation screenshot
    [self.webViewRotationSnapshot removeFromSuperview];
    self.webViewRotationSnapshot = nil;
    
    //Slight hack to jump start orientation detection again
    UIViewController *dummyController = [UIViewController new];
    NSLog(@"------%@",dummyController);
//    [self presentViewController:dummyController animated:NO completion:^{
//        [self dismissViewControllerAnimated:NO completion:nil];
//    }];
}
#pragma Navigtion Buttons
- (UIColor *)fillColorFromAttributes:(NSDictionary *)attributes
{
    UIColor *fillColor = attributes[ButtonTintColor];
    if (fillColor == nil) {
        if (IPAD)
            fillColor = DEFAULT_IPAD_BUTTON_TINT;
        else
            fillColor = DEFAULT_IPHONE_BUTTON_TINT;
    }
    
    return fillColor;
}

- (CGFloat)bevelOpacityFromAttributes:(NSDictionary *)attributes
{
    NSNumber *opacityNumber = attributes[ButtonBevelOpacity];
    if (opacityNumber == nil) {
        if (IPAD)
            return DEFAULT_IPAD_BEVEL_OPACITY;
        else
            return DEFAULT_IPHONE_BEVEL_OPACITY;
    }
    
    return opacityNumber.floatValue;
}

- (void)drawBevelFromFillColor:(UIColor *)fillColor opacity:(CGFloat)opacity
{
    CGFloat hue = 0.0f, saturation = 0.0f, brightness = 0.0f, alpha = 0.0f;
    [fillColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    //Use dark beveling if the image is REALLY close to white
    BOOL shouldUseDarkBevel = (saturation < 0.3f && brightness > 0.85f);
    
    CGSize offset = (CGSize){0.0f, 1.0f};
    if (shouldUseDarkBevel)
        offset.height = -1.0f;
    
    //Set up the Core Graphics context to render a shadow
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *bevelColor = nil;
    if (shouldUseDarkBevel)
        bevelColor = [UIColor colorWithWhite:0.0f alpha:opacity];
    else
        bevelColor = [UIColor colorWithWhite:1.0f alpha:opacity];
    
    CGContextSetShadowWithColor(context, offset, 0.0f, bevelColor.CGColor);
    
    //Set the following draw commands to be offset one pixel if drawing the dark bevel above it
    if (shouldUseDarkBevel)
        CGContextTranslateCTM(context, 0, 1.0f);
}

- (UIImage *)setBackButtonWithAttributes:(NSDictionary *)attributes
{
    UIImage *backButtonImage = nil;
    if (MINIMAL_UI) {
        UIGraphicsBeginImageContextWithOptions((CGSize){12,21}, NO, [[UIScreen mainScreen] scale]);
        {
            //// Color Declarations
            UIColor* backColor = [UIColor blackColor];
            
            //// BackButton Drawing
            UIBezierPath* backButtonPath = [UIBezierPath bezierPath];
            [backButtonPath moveToPoint: CGPointMake(10.9, 0)];
            [backButtonPath addLineToPoint: CGPointMake(12, 1.1)];
            [backButtonPath addLineToPoint: CGPointMake(1.1, 11.75)];
            [backButtonPath addLineToPoint: CGPointMake(0, 10.7)];
            [backButtonPath addLineToPoint: CGPointMake(10.9, 0)];
            [backButtonPath closePath];
            [backButtonPath moveToPoint: CGPointMake(11.98, 19.9)];
            [backButtonPath addLineToPoint: CGPointMake(10.88, 21)];
            [backButtonPath addLineToPoint: CGPointMake(0.54, 11.21)];
            [backButtonPath addLineToPoint: CGPointMake(1.64, 10.11)];
            [backButtonPath addLineToPoint: CGPointMake(11.98, 19.9)];
            [backButtonPath closePath];
            [backColor setFill];
            [backButtonPath fill];
            
            backButtonImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
    }
    else {
        UIGraphicsBeginImageContextWithOptions((CGSize){15,18}, NO, [[UIScreen mainScreen] scale]);
        {
            UIColor *backColor = [self fillColorFromAttributes:attributes];
            CGFloat bevelOpacity = [self bevelOpacityFromAttributes:attributes];
            [self drawBevelFromFillColor:backColor opacity:bevelOpacity];
            
            //// BackButton Drawing
            UIBezierPath* backButtonPath = [UIBezierPath bezierPath];
            [backButtonPath moveToPoint: CGPointMake(15, 17)];
            [backButtonPath addLineToPoint: CGPointMake(15, 0)];
            [backButtonPath addLineToPoint: CGPointMake(0, 8.5)];
            [backButtonPath addLineToPoint: CGPointMake(15, 17)];
            [backButtonPath closePath];
            [backColor setFill];
            [backButtonPath fill];
            
            backButtonImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
    }
    
    return backButtonImage;
}
- (UIImage *)setForwardButtonWithAttributes:(NSDictionary *)attributes
{
    UIImage *forwardButtonImage = nil;
    if (MINIMAL_UI) {
        UIGraphicsBeginImageContextWithOptions((CGSize){12,21}, NO, [[UIScreen mainScreen] scale]);
        {
            //// Color Declarations
            UIColor* forwardColor = [UIColor blackColor];
            
            //// BackButton Drawing
            UIBezierPath* forwardButtonPath = [UIBezierPath bezierPath];
            [forwardButtonPath moveToPoint: CGPointMake(1.1, 0)];
            [forwardButtonPath addLineToPoint: CGPointMake(0, 1.1)];
            [forwardButtonPath addLineToPoint: CGPointMake(10.9, 11.75)];
            [forwardButtonPath addLineToPoint: CGPointMake(12, 10.7)];
            [forwardButtonPath addLineToPoint: CGPointMake(1.1, 0)];
            [forwardButtonPath closePath];
            [forwardButtonPath moveToPoint: CGPointMake(0.02, 19.9)];
            [forwardButtonPath addLineToPoint: CGPointMake(1.12, 21)];
            [forwardButtonPath addLineToPoint: CGPointMake(11.46, 11.21)];
            [forwardButtonPath addLineToPoint: CGPointMake(10.36, 10.11)];
            [forwardButtonPath addLineToPoint: CGPointMake(0.02, 19.9)];
            [forwardButtonPath closePath];
            [forwardColor setFill];
            [forwardButtonPath fill];
            
            forwardButtonImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
    }
    else {
        UIGraphicsBeginImageContextWithOptions((CGSize){15,18}, NO, [[UIScreen mainScreen] scale]);
        {
            UIColor *forwardColor = [self fillColorFromAttributes:attributes];
            CGFloat bevelOpacity = [self bevelOpacityFromAttributes:attributes];
            [self drawBevelFromFillColor:forwardColor opacity:bevelOpacity];
            
            //// BackButton Drawing
            UIBezierPath* forwardButtonPath = [UIBezierPath bezierPath];
            [forwardButtonPath moveToPoint: CGPointMake(0, 17)];
            [forwardButtonPath addLineToPoint: CGPointMake(0, 0)];
            [forwardButtonPath addLineToPoint: CGPointMake(15, 8.5)];
            [forwardButtonPath addLineToPoint: CGPointMake(0, 17)];
            [forwardButtonPath closePath];
            [forwardColor setFill];
            [forwardButtonPath fill];
            
            forwardButtonImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
    }
    
    return forwardButtonImage;
}

- (UIImage *)setRefreshButtonWithAttributes:(NSDictionary *)attributes
{
    UIImage *refreshButtonImage = nil;
    if (MINIMAL_UI) {
        UIGraphicsBeginImageContextWithOptions((CGSize){19,22}, NO, [[UIScreen mainScreen] scale]);
        {
            //// Color Declarations
            UIColor* refreshColor = [UIColor blackColor];
            
            //// RefreshButton Drawing
            UIBezierPath* refreshIconPath = [UIBezierPath bezierPath];
            [refreshIconPath moveToPoint: CGPointMake(18.98, 12)];
            [refreshIconPath addCurveToPoint: CGPointMake(19, 12.8) controlPoint1: CGPointMake(18.99, 12.11) controlPoint2: CGPointMake(19, 12.69)];
            [refreshIconPath addCurveToPoint: CGPointMake(9.5, 22) controlPoint1: CGPointMake(19, 17.88) controlPoint2: CGPointMake(14.75, 22)];
            [refreshIconPath addCurveToPoint: CGPointMake(0, 12.8) controlPoint1: CGPointMake(4.25, 22) controlPoint2: CGPointMake(0, 17.88)];
            [refreshIconPath addCurveToPoint: CGPointMake(10, 3.5) controlPoint1: CGPointMake(0, 7.72) controlPoint2: CGPointMake(4.75, 3.5)];
            [refreshIconPath addCurveToPoint: CGPointMake(10, 5) controlPoint1: CGPointMake(10.02, 3.5) controlPoint2: CGPointMake(10.02, 5)];
            [refreshIconPath addCurveToPoint: CGPointMake(1.69, 12.8) controlPoint1: CGPointMake(5.69, 5) controlPoint2: CGPointMake(1.69, 8.63)];
            [refreshIconPath addCurveToPoint: CGPointMake(9.5, 20.36) controlPoint1: CGPointMake(1.69, 16.98) controlPoint2: CGPointMake(5.19, 20.36)];
            [refreshIconPath addCurveToPoint: CGPointMake(17.31, 12) controlPoint1: CGPointMake(13.81, 20.36) controlPoint2: CGPointMake(17.31, 16.18)];
            [refreshIconPath addCurveToPoint: CGPointMake(17.28, 12) controlPoint1: CGPointMake(17.31, 11.89) controlPoint2: CGPointMake(17.28, 12.11)];
            [refreshIconPath addLineToPoint: CGPointMake(18.98, 12)];
            [refreshIconPath closePath];
            [refreshIconPath moveToPoint: CGPointMake(10, 0)];
            [refreshIconPath addLineToPoint: CGPointMake(17.35, 4.62)];
            [refreshIconPath addLineToPoint: CGPointMake(10, 9.13)];
            [refreshIconPath addLineToPoint: CGPointMake(10, 0)];
            [refreshIconPath closePath];
            [refreshColor setFill];
            [refreshIconPath fill];
            
            refreshButtonImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
    }
    else {
        UIGraphicsBeginImageContextWithOptions((CGSize){17,20}, NO, [[UIScreen mainScreen] scale]);
        {
            UIColor *refreshColor = [self fillColorFromAttributes:attributes];
            CGFloat bevelOpacity = [self bevelOpacityFromAttributes:attributes];
            [self drawBevelFromFillColor:refreshColor opacity:bevelOpacity];
            
            //// RefreshButton Drawing
            UIBezierPath* refreshIconPath = [UIBezierPath bezierPath];
            [refreshIconPath moveToPoint: CGPointMake(17, 10.56)];
            [refreshIconPath addCurveToPoint: CGPointMake(17, 10.56) controlPoint1: CGPointMake(17, 10.56) controlPoint2: CGPointMake(17, 10.55)];
            [refreshIconPath addCurveToPoint: CGPointMake(8.5, 19) controlPoint1: CGPointMake(17, 15.04) controlPoint2: CGPointMake(13.19, 19)];
            [refreshIconPath addCurveToPoint: CGPointMake(0, 10.88) controlPoint1: CGPointMake(3.81, 19) controlPoint2: CGPointMake(0, 15.36)];
            [refreshIconPath addCurveToPoint: CGPointMake(8, 2.76) controlPoint1: CGPointMake(0, 6.44) controlPoint2: CGPointMake(3.37, 2.84)];
            [refreshIconPath addLineToPoint: CGPointMake(8, 0)];
            [refreshIconPath addLineToPoint: CGPointMake(14.17, 4.03)];
            [refreshIconPath addLineToPoint: CGPointMake(14.17, 4.16)];
            [refreshIconPath addLineToPoint: CGPointMake(8, 8.44)];
            [refreshIconPath addLineToPoint: CGPointMake(8, 5.41)];
            [refreshIconPath addCurveToPoint: CGPointMake(2.74, 10.88) controlPoint1: CGPointMake(4.89, 5.47) controlPoint2: CGPointMake(2.74, 7.89)];
            [refreshIconPath addCurveToPoint: CGPointMake(8.47, 16.35) controlPoint1: CGPointMake(2.74, 13.9) controlPoint2: CGPointMake(5.31, 16.35)];
            [refreshIconPath addCurveToPoint: CGPointMake(14.2, 10.56) controlPoint1: CGPointMake(11.63, 16.35) controlPoint2: CGPointMake(14.2, 13.58)];
            [refreshIconPath addCurveToPoint: CGPointMake(14.2, 10.56) controlPoint1: CGPointMake(14.2, 10.55) controlPoint2: CGPointMake(14.2, 10.56)];
            [refreshIconPath addLineToPoint: CGPointMake(17, 10.56)];
            [refreshIconPath closePath];
            [refreshColor setFill];
            [refreshIconPath fill];
            
            refreshButtonImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
    }
    
    return refreshButtonImage;
}

- (UIImage *)setStopButtonWithAttributes:(NSDictionary *)attributes
{
    UIImage *stopButtonImage = nil;
    if (MINIMAL_UI) {
        UIGraphicsBeginImageContextWithOptions((CGSize){19,19}, NO, [[UIScreen mainScreen] scale]);
        {
            //// Color Declarations
            UIColor* stopColor = [UIColor blackColor];
            
            //// StopButton Drawing
            UIBezierPath* stopButtonPath = [UIBezierPath bezierPath];
            [stopButtonPath moveToPoint: CGPointMake(19, 17.82)];
            [stopButtonPath addLineToPoint: CGPointMake(17.82, 19)];
            [stopButtonPath addLineToPoint: CGPointMake(9.5, 10.68)];
            [stopButtonPath addLineToPoint: CGPointMake(1.18, 19)];
            [stopButtonPath addLineToPoint: CGPointMake(0, 17.82)];
            [stopButtonPath addLineToPoint: CGPointMake(8.32, 9.5)];
            [stopButtonPath addLineToPoint: CGPointMake(0, 1.18)];
            [stopButtonPath addLineToPoint: CGPointMake(1.18, 0)];
            [stopButtonPath addLineToPoint: CGPointMake(9.5, 8.32)];
            [stopButtonPath addLineToPoint: CGPointMake(17.82, 0)];
            [stopButtonPath addLineToPoint: CGPointMake(19, 1.18)];
            [stopButtonPath addLineToPoint: CGPointMake(10.68, 9.5)];
            [stopButtonPath addLineToPoint: CGPointMake(19, 17.82)];
            [stopButtonPath closePath];
            [stopColor setFill];
            [stopButtonPath fill];
            
            stopButtonImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
    }
    else {
        UIGraphicsBeginImageContextWithOptions((CGSize){15,16}, NO, [[UIScreen mainScreen] scale]);
        {
            UIColor *stopColor = [self fillColorFromAttributes:attributes];
            CGFloat bevelOpacity = [self bevelOpacityFromAttributes:attributes];
            [self drawBevelFromFillColor:stopColor opacity:bevelOpacity];
            
            //// RefreshButton Drawing
            UIBezierPath* stopButtonPath = [UIBezierPath bezierPath];
            [stopButtonPath moveToPoint: CGPointMake(14.57, 2.53)];
            [stopButtonPath addLineToPoint: CGPointMake(9.59, 7.51)];
            [stopButtonPath addLineToPoint: CGPointMake(14.55, 12.47)];
            [stopButtonPath addCurveToPoint: CGPointMake(14.55, 14.57) controlPoint1: CGPointMake(15.13, 13.05) controlPoint2: CGPointMake(15.13, 13.99)];
            [stopButtonPath addCurveToPoint: CGPointMake(12.45, 14.57) controlPoint1: CGPointMake(13.97, 15.14) controlPoint2: CGPointMake(13.03, 15.14)];
            [stopButtonPath addLineToPoint: CGPointMake(7.5, 9.61)];
            [stopButtonPath addLineToPoint: CGPointMake(2.55, 14.57)];
            [stopButtonPath addCurveToPoint: CGPointMake(0.45, 14.57) controlPoint1: CGPointMake(1.97, 15.14) controlPoint2: CGPointMake(1.03, 15.14)];
            [stopButtonPath addCurveToPoint: CGPointMake(0.45, 12.47) controlPoint1: CGPointMake(-0.13, 13.99) controlPoint2: CGPointMake(-0.13, 13.05)];
            [stopButtonPath addLineToPoint: CGPointMake(5.41, 7.51)];
            [stopButtonPath addLineToPoint: CGPointMake(0.43, 2.53)];
            [stopButtonPath addCurveToPoint: CGPointMake(0.43, 0.43) controlPoint1: CGPointMake(-0.14, 1.95) controlPoint2: CGPointMake(-0.14, 1.01)];
            [stopButtonPath addCurveToPoint: CGPointMake(2.53, 0.43) controlPoint1: CGPointMake(1.01, -0.14) controlPoint2: CGPointMake(1.95, -0.14)];
            [stopButtonPath addLineToPoint: CGPointMake(7.5, 5.41)];
            [stopButtonPath addLineToPoint: CGPointMake(12.47, 0.43)];
            [stopButtonPath addCurveToPoint: CGPointMake(14.57, 0.43) controlPoint1: CGPointMake(13.05, -0.14) controlPoint2: CGPointMake(13.99, -0.14)];
            [stopButtonPath addCurveToPoint: CGPointMake(14.57, 2.53) controlPoint1: CGPointMake(15.14, 1.01) controlPoint2: CGPointMake(15.14, 1.95)];
            [stopButtonPath closePath];
            [stopColor setFill];
            [stopButtonPath fill];
            
            stopButtonImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
    }
    
    return stopButtonImage;
}

@end
