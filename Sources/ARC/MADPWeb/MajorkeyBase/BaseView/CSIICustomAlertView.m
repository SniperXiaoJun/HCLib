#import "CSIICustomAlertView.h"
//#import "UIScreen+Frame.h"

#define MAX_CATEGORY_NAME_LENGTH 9
#define kTagViewTextFieldJalBreakPassW (1001)

@implementation CSIICustomAlertView


@synthesize customDelegate = _customDelegate;
@synthesize contentLabel;
@synthesize textField;

- (id)initRemindAlert{
    return nil;
}
//含有title，提示内容以及两个button.
- (id)initWithTitle:(NSString*)title  msg:(NSString*)msg rightBtnTitle:(NSString*)rightTitle leftBtnTitle:(NSString*)leftTitle  delegate:(id<CustomAlertViewDelegate>) _delegate
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen]bounds]]))
    {
        // Initialization code
        _alertViewType=CustomAlertViewType_Msg_TwoBtn;
        self.customDelegate=_delegate;
        
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_bgView];
        
        CGRect alertRect = [self getAlertBounds];
        _alertView = [[UIView alloc] initWithFrame:alertRect];
        _alertView.layer.cornerRadius = 10;
        _alertView.layer.masksToBounds = YES;
        
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertRect.size.width, alertRect.size.height)];
        alertBg.backgroundColor = [UIColor whiteColor];
        alertBg.image = JRBundeImage(@"AlertView_background.png");
        [_alertView addSubview:alertBg];
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.text =title;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:titleLabel];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 260, 40)];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:15.0];
        contentLabel.text =msg;
        contentLabel.textAlignment=NSTextAlignmentCenter;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.numberOfLines = 0;
        [_alertView addSubview:contentLabel];
        
        //UIImage* unselectedImg=[UIImage imageNamed:@"button_unselected.png"];
        UIImage* selectedImg=JRBundeImage(@"button_selected.png");
        
        rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
            rightBtn.layer.borderWidth = 1.0f;
        else
            rightBtn.layer.borderWidth = 0.5f;
        rightBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [rightBtn setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor colorWithRed:23.0/255 green:92.0/255 blue:212.0/255 alpha:1.0] forState:UIControlStateNormal];
        rightBtn.frame=CGRectMake(_alertView.frame.size.width/2, _alertView.frame.size.height-40, _alertView.frame.size.width/2, 40);
        [rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:rightBtn];
        
        leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
            leftBtn.layer.borderWidth = 1.0f;
        else
            leftBtn.layer.borderWidth = 0.5f;
        leftBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [leftBtn setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor colorWithRed:23.0/255 green:92.0/255 blue:212.0/255 alpha:1.0] forState:UIControlStateNormal];
        leftBtn.frame=CGRectMake(0, _alertView.frame.size.height-40, _alertView.frame.size.width/2, 40);
        [leftBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:leftBtn];
        
        [self addSubview:_alertView];
        
    }
    return self;
}


//可修改字体
- (id)initWithTitle:(NSString*)title
                msg:(NSString*)msg
      rightBtnTitle:(NSString*)rightTitle
       leftBtnTitle:(NSString*)leftTitle
           delegate:(id<CustomAlertViewDelegate>) _delegate
        msgFontSize:(CGFloat)fontSize
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        // Initialization code
        _alertViewType=CustomAlertViewType_Msg_TwoBtn;
        self.customDelegate=_delegate;
        
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_bgView];
        
        CGRect alertRect = [self getAlertBounds];
        _alertView = [[UIView alloc] initWithFrame:alertRect];
        _alertView.layer.cornerRadius = 10;
        _alertView.layer.masksToBounds = YES;
        
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertRect.size.width, alertRect.size.height)];
        alertBg.backgroundColor = [UIColor whiteColor];
        alertBg.image = JRBundeImage(@"AlertView_background.png");
        [_alertView addSubview:alertBg];
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 20)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.text =title;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:titleLabel];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 260, 40)];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:fontSize];
        contentLabel.text =msg;
        contentLabel.textAlignment=NSTextAlignmentCenter;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.numberOfLines = 0;
        [_alertView addSubview:contentLabel];
        
        //UIImage* unselectedImg=[UIImage imageNamed:@"button_unselected.png"];
        UIImage* selectedImg=JRBundeImage(@"button_selected.png");
        
        rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
            rightBtn.layer.borderWidth = 1.0f;
        else
            rightBtn.layer.borderWidth = 0.5f;
        rightBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [rightBtn setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor colorWithRed:23.0/255 green:92.0/255 blue:212.0/255 alpha:1.0] forState:UIControlStateNormal];
        rightBtn.frame=CGRectMake(_alertView.frame.size.width/2, _alertView.frame.size.height-40, _alertView.frame.size.width/2, 40);
        [rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:rightBtn];
        
        leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
            leftBtn.layer.borderWidth = 1.0f;
        else
            leftBtn.layer.borderWidth = 0.5f;
        leftBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [leftBtn setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor colorWithRed:23.0/255 green:92.0/255 blue:212.0/255 alpha:1.0] forState:UIControlStateNormal];
        leftBtn.frame=CGRectMake(0, _alertView.frame.size.height-40, _alertView.frame.size.width/2, 40);
        [leftBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:leftBtn];
        
        [self addSubview:_alertView];

    }
    return self;
}


- (id)initWithTitle:(NSString*)title  msg:(NSString*)msg centerBtnTitle:(NSString*)centerTitle
{
    
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if(self)
    {
        _alertViewType=CustomAlertViewType_Msg_OneBtn;
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_bgView];
        
        CGRect alertRect = [self getAlertBounds];
        _alertView = [[UIView alloc] initWithFrame:alertRect];
        _alertView.layer.cornerRadius = 10;
        _alertView.layer.masksToBounds = YES;
        
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertRect.size.width, alertRect.size.height)];
        alertBg.backgroundColor = [UIColor whiteColor];
        alertBg.image = JRBundeImage(@"AlertView_background.png");
        [_alertView addSubview:alertBg];
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300, 20)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.text =title;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:titleLabel];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 260, 20)];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:15.0];
        contentLabel.text = msg;
        contentLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:contentLabel];
        
        UIImage* selectedImg=JRBundeImage(@"bigbuttonbkimg.png");
        centerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
            centerBtn.layer.borderWidth = 1.0f;
        else
            centerBtn.layer.borderWidth = 0.5f;
        centerBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //[centerBtn setBackgroundImage:selectedImg forState:UIControlStateNormal];
        [centerBtn setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        centerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [centerBtn setTitle:centerTitle forState:UIControlStateNormal];
        [centerBtn setTitleColor:[UIColor colorWithRed:23.0/255 green:92.0/255 blue:212.0/255 alpha:1.0] forState:UIControlStateNormal];
        centerBtn.frame=CGRectMake(0, _alertView.frame.size.height-40, 300, 40);
        [_alertView addSubview:centerBtn];
        [centerBtn addTarget:self action:@selector(centerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_alertView];

    }
    return self;
}


//含有title，UIActivityIndicatorView控件,提示内容以及一个button.
- (id)initProgressAlertViewWithTitle:(NSString*)title  msg:(NSString*)msg centerBtnTitle:(NSString*)centerTitle  delegate:(id<CustomAlertViewDelegate>) _delegate
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        // Initialization code
        _alertViewType=CustomAlertViewType_ActivityIndiAndMsg_OneBtn;
        self.customDelegate=_delegate;
        
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_bgView];
        
        CGRect alertRect = [self getAlertBounds];
        _alertView = [[UIView alloc] initWithFrame:alertRect];
        _alertView.layer.cornerRadius = 10;
        _alertView.layer.masksToBounds = YES;
        
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertRect.size.width, alertRect.size.height)];
        alertBg.backgroundColor = [UIColor whiteColor];
        alertBg.image = JRBundeImage(@"AlertView_background.png");
        [_alertView addSubview:alertBg];
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300, 20)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.text =title;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:titleLabel];
        
        indicatorView= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(80.0, 45.0, 30.0, 30.0)];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicatorView.hidesWhenStopped=NO;
        [_alertView addSubview:indicatorView];
        [indicatorView startAnimating];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 50.0, 150.0, 20.0)];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont boldSystemFontOfSize:15.0];
        contentLabel.text =msg;
        contentLabel.textAlignment=NSTextAlignmentLeft;
        [_alertView addSubview:contentLabel];
        
        UIImage* selectedImg=JRBundeImage(@"button_selected.png");
        centerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        //[centerBtn setBackgroundImage:selectedImg forState:UIControlStateNormal];
        [centerBtn setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        centerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [centerBtn setTitle:centerTitle forState:UIControlStateNormal];
        [centerBtn setTitleColor:[UIColor colorWithRed:23.0/255 green:92.0/255 blue:212.0/255 alpha:1.0] forState:UIControlStateNormal];
        centerBtn.frame=CGRectMake(27, 85, 249, 40);
        [_alertView addSubview:centerBtn];
        [centerBtn addTarget:self action:@selector(centerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_alertView];

    }
    return self;
}

//含有title，一个定制的UIView控件以及一个button.
- (id)initWithCustomView:(UIView*)customView title:(NSString*)title centerBtnTitle:(NSString*)centerTitle  delegate:(id<CustomAlertViewDelegate>) _delegate
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        // Initialization code
        _alertViewType=CustomAlertViewType_View_OneBtn;
        self.customDelegate=_delegate;
        
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_bgView];
        
        CGRect alertRect = [self getAlertBounds];
        alertRect.size.height = 30 + customView.frame.size.height + 45;
        alertRect.origin.y = (self.frame.size.height-alertRect.size.height)/2;
        _alertView = [[UIView alloc] initWithFrame:alertRect];
        _alertView.layer.cornerRadius = 10;
        _alertView.layer.masksToBounds = YES;
        
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertRect.size.width, alertRect.size.height)];
        alertBg.backgroundColor = [UIColor whiteColor];
        alertBg.image = JRBundeImage(@"AlertView_background.png");
        [_alertView addSubview:alertBg];
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300, 20)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.text =title;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:titleLabel];
        
        [_alertView addSubview:customView];

        UIImage* selectedImg=JRBundeImage(@"button_selected.png");
        centerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
            centerBtn.layer.borderWidth = 1.0f;
        else
            centerBtn.layer.borderWidth = 0.5f;
        centerBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //[centerBtn setBackgroundImage:selectedImg forState:UIControlStateNormal];
        [centerBtn setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        centerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [centerBtn setTitle:centerTitle forState:UIControlStateNormal];
        [centerBtn setTitleColor:[UIColor colorWithRed:23.0/255 green:92.0/255 blue:212.0/255 alpha:1.0] forState:UIControlStateNormal];
        centerBtn.frame=CGRectMake(0, _alertView.frame.size.height-40, 300, 40);
        [_alertView addSubview:centerBtn];
        [centerBtn addTarget:self action:@selector(centerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_alertView];

    }
    return self;
}

//含有title，定制的textfield，提示内容以及两个button.
- (id)initWithCustomTextField:(UITextField*)customTextField title:(NSString*)title  msg:(NSString*)msg rightBtnTitle:(NSString*)rightTitle leftBtnTitle:(NSString*)leftTitle delegate:(id<CustomAlertViewDelegate>) _delegate
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        // Initialization code
        _alertViewType=CustomAlertViewType_Msg_CustomTextField_TwoBtn;
        self.customDelegate=_delegate;
        
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_bgView];
        
        CGRect alertRect = [self getAlertBounds];
        alertRect.size.height = customTextField.frame.origin.y + customTextField.frame.size.height + 15 + 45;
        alertRect.origin.y = (self.frame.size.height-alertRect.size.height)/2 - 20 - 20;
        _alertView = [[UIView alloc] initWithFrame:alertRect];
        _alertView.layer.cornerRadius = 10;
        _alertView.layer.masksToBounds = YES;
        
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertRect.size.width, alertRect.size.height)];
        alertBg.backgroundColor = [UIColor whiteColor];
        alertBg.image = JRBundeImage(@"AlertView_background.png");
        [_alertView addSubview:alertBg];
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, 300, 20)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.text =title;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:titleLabel];
        
        if(msg != nil && msg.length != 0)
        {
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 33.0, 300.0, 12.0)];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont boldSystemFontOfSize:8.0];
        contentLabel.textAlignment=NSTextAlignmentCenter;
        contentLabel.text = msg;
        [_alertView addSubview:contentLabel];
        }
        
        [_alertView addSubview:customTextField];
        self.textField = customTextField;
        
        //UIImage* unselectedImg=[UIImage imageNamed:@"button_unselected.png"];
        UIImage* selectedImg=JRBundeImage(@"button_selected.png");
        
        rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
            rightBtn.layer.borderWidth = 1.0f;
        else
            rightBtn.layer.borderWidth = 0.5f;
        rightBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [rightBtn setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor colorWithRed:23.0/255 green:92.0/255 blue:212.0/255 alpha:1.0] forState:UIControlStateNormal];
        rightBtn.frame=CGRectMake(_alertView.frame.size.width/2, _alertView.frame.size.height-40, _alertView.frame.size.width/2, 40);
        [rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:rightBtn];
        
        leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
            leftBtn.layer.borderWidth = 1.0f;
        else
            leftBtn.layer.borderWidth = 0.5f;
        leftBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [leftBtn setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor colorWithRed:23.0/255 green:92.0/255 blue:212.0/255 alpha:1.0] forState:UIControlStateNormal];
        leftBtn.frame=CGRectMake(0, _alertView.frame.size.height-40, _alertView.frame.size.width/2, 40);
        [leftBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:leftBtn];
        
        [self addSubview:_alertView];

    }
    return self;
}


//含有title，textfield，提示内容以及两个button.
- (id)initTextFieldWithTitle:(NSString*)title  msg:(NSString*)msg rightBtnTitle:(NSString*)rightTitle leftBtnTitle:(NSString*)leftTitle delegate:(id<CustomAlertViewDelegate>) _delegate
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        // Initialization code
        _alertViewType=CustomAlertViewType_Msg_TextField_TwoBtn;
        self.customDelegate=_delegate;
        
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_bgView];
        
        CGRect alertRect = [self getAlertBounds];
        _alertView = [[UIView alloc] initWithFrame:alertRect];
        _alertView.layer.cornerRadius = 10;
        _alertView.layer.masksToBounds = YES;
        
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertRect.size.width, alertRect.size.height)];
        alertBg.backgroundColor = [UIColor whiteColor];
        alertBg.image = JRBundeImage(@"AlertView_background.png");
        [_alertView addSubview:alertBg];
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, 300, 20)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.text =title;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:titleLabel];
        
        if(msg != nil && msg.length != 0)
        {
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 33.0, 300.0, 12.0)];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont boldSystemFontOfSize:8.0];
        contentLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:contentLabel];
        }
        
        textField =[[UITextField alloc]initWithFrame:CGRectMake(21, 45, 260, 30)];
        //[[UITextField alloc] initWithFrame:CGRectMake(21, 45, 260, 30)] ;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.placeholder = msg;
        [textField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
        [_alertView addSubview:textField];
        
        //UIImage* unselectedImg=[UIImage imageNamed:@"button_unselected.png"];
        UIImage* selectedImg=JRBundeImage(@"button_selected.png");
        
        rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
            rightBtn.layer.borderWidth = 1.0f;
        else
            rightBtn.layer.borderWidth = 0.5f;
        rightBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [rightBtn setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor colorWithRed:23.0/255 green:92.0/255 blue:212.0/255 alpha:1.0] forState:UIControlStateNormal];
        rightBtn.frame=CGRectMake(_alertView.frame.size.width/2, _alertView.frame.size.height-40, _alertView.frame.size.width/2, 40);
        [rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:rightBtn];
        
        leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
            leftBtn.layer.borderWidth = 1.0f;
        else
            leftBtn.layer.borderWidth = 0.5f;
        leftBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [leftBtn setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor colorWithRed:23.0/255 green:92.0/255 blue:212.0/255 alpha:1.0] forState:UIControlStateNormal];
        leftBtn.frame=CGRectMake(0, _alertView.frame.size.height-40, _alertView.frame.size.width/2, 40);
        [leftBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:leftBtn];
        
        [self addSubview:_alertView];

    }
    return self;
}



-(id)initLoginWithDelegate:(id<CustomAlertViewDelegate>)delegate userId:(NSString*)userid title:(NSString*)strTitle rightBtnTitle:(NSString*)strRbt
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        
        _alertViewType = CustomAlertViewType_JalBreakBuy_Login;
        self.customDelegate = delegate;
        
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_bgView];
        
        CGRect alertRect = [self getAlertBounds];
        _alertView = [[UIView alloc] initWithFrame:alertRect];
        _alertView.layer.cornerRadius = 10;
        _alertView.layer.masksToBounds = YES;
        
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertRect.size.width, alertRect.size.height)];
        alertBg.backgroundColor = [UIColor whiteColor];
        alertBg.image = JRBundeImage(@"AlertView_background.png");
        [_alertView addSubview:alertBg];
        
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 280, 20)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.text = strTitle;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [_alertView addSubview:titleLabel];
        
        CGFloat xLabel1 = 20;
        CGFloat xLabel2 = 120;
        CGFloat yLevel1 = 50;
        CGFloat yLevel2 = 100;
        
        
        
        UILabel* label = nil;
        label = [[UILabel alloc]initWithFrame:CGRectMake(xLabel1, yLevel1, 100, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"账号:";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:17.0];
        label.textAlignment = NSTextAlignmentCenter;
        [_alertView addSubview:label];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(xLabel2, yLevel1,140, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.text = userid;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:17.0];
        label.textAlignment = NSTextAlignmentCenter;
        [_alertView addSubview:label];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(xLabel1, yLevel2, 100, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"密码:";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:17.0];
        label.textAlignment = NSTextAlignmentCenter;
        [_alertView addSubview:label];
        
        textField = [[UITextField alloc]initWithFrame:CGRectMake(xLabel2, yLevel2, 140, 40)] ;
        textField.delegate = self;
//        textField.textColor = kColorLoginInput;
        textField.tag= kTagViewTextFieldJalBreakPassW;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.secureTextEntry = YES;
        textField.returnKeyType = UIReturnKeyDone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.font = [UIFont systemFontOfSize:17];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.keyboardType = UIKeyboardTypeASCIICapable ;
        [_alertView addSubview:textField];
        
//        UIImage* unselectedImg=[UIImage imageNamed:@"button_unselected.png"];
        UIImage* selectedImg=JRBundeImage(@"button_selected.png");
        
        rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
            rightBtn.layer.borderWidth = 1.0f;
        else
            rightBtn.layer.borderWidth = 0.5f;
        rightBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [rightBtn setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [rightBtn setTitle:strRbt forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor colorWithRed:23.0/255 green:92.0/255 blue:212.0/255 alpha:1.0] forState:UIControlStateNormal];
        rightBtn.frame=CGRectMake(_alertView.frame.size.width/2, _alertView.frame.size.height-40, _alertView.frame.size.width/2, 40);
        [rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:rightBtn];
        
        leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
            leftBtn.layer.borderWidth = 1.0f;
        else
            leftBtn.layer.borderWidth = 0.5f;
        leftBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [leftBtn setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor colorWithRed:23.0/255 green:92.0/255 blue:212.0/255 alpha:1.0] forState:UIControlStateNormal];
        leftBtn.frame=CGRectMake(0, _alertView.frame.size.height-40, _alertView.frame.size.width/2, 40);
        [leftBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:leftBtn];
        
        [self addSubview:_alertView];
        
    }
    
    return self;
    
}
- (id)initWithFrame:(CGRect)frame WithMsg:(NSString*)msg;
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _alertViewType=CustomAlertViewType_View_OneBtn;
        _bgView = [[UIView alloc] initWithFrame:frame];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        _bgView.layer.cornerRadius = 5.0;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
        [_bgView addSubview:_alertView];
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,10, self.frame.size.width, 20)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        titleLabel.text =msg;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [_bgView addSubview:titleLabel];
        
        [self addSubview:_alertView];
  
    }
    
    return self;
    
}



-(void)showAfterDelay:(NSTimeInterval)delay
{
   [self performSelector:@selector(show) withObject:nil afterDelay:delay]; 
}

-(void)show
{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    
//    NSArray* windowSubviews = [window subviews];
//    if(windowSubviews && [windowSubviews count]>0){
//        UIView* topSubView = [windowSubviews objectAtIndex:windowSubviews.count-1];
//        for(UIView* aView in topSubView.subviews)
//        {
//            [aView.layer removeAllAnimations];
//        }
//        [topSubView addSubview:self];
//    }
 
    //-----------------------------------------//
    
//    for(UIView* aView in window.subviews)
//    {
//        [aView.layer removeAllAnimations]; //清除动画，会清除提示等待的菊花遮罩
//    }
    [window addSubview:self];
    
    [self showBackground];
    [self showAlertAnmation];
}

- (void)showBackground
{
    _bgView.alpha = 0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _bgView.alpha = 0.3;
    [UIView commitAnimations];
}

-(void) showAlertAnmation
{
    /*
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_alertView.layer addAnimation:animation forKey:nil];
    */
    
    DebugLog(@"showAlertAnmation");
    
    CGFloat screenWidth;
    //CGFloat screenHeight;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])){//竖屏
        screenWidth = [[UIScreen mainScreen]bounds].size.width;
        //screenHeight = [[UIScreen mainScreen]bounds].size.height;
    }else{//iPAD 横屏
        screenWidth = [UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height;
        //screenHeight = [UIScreen mainScreen].bounds.size.height < [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width;
    }
    
    CGRect originalFrame =  _alertView.frame;
    CGRect tempFrame = originalFrame;
    tempFrame.origin.x = screenWidth;
//    _alertView.frame = tempFrame;
    
     _alertView.frame = originalFrame; //最终frame

    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            animation.duration = 0.5;
            NSMutableArray *values = [NSMutableArray array];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
            animation.values = values;
            [_alertView.layer addAnimation:animation forKey:nil];

    
//    [UIView beginAnimations:@"moveLeft" context:nil];
//    [UIView setAnimationDuration:0.35];
//    [UIView commitAnimations];
    
}

-(void) hideAlertAnmation
{
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.3];
    _bgView.alpha = 0.0;
    [UIView commitAnimations];
}



-(CGRect)getAlertBounds
{
    CGRect retRect;
    
    if (_alertViewType == CustomAlertViewType_JalBreakBuy_Login)
    {
        
        retRect= CGRectMake((self.frame.size.width-300)/2, (self.frame.size.height-200)/2, 300, 220);
        
    }
    else
    {
        
        retRect= CGRectMake((self.frame.size.width-300)/2, (self.frame.size.height-200)/2, 300, 220);
    }
    
    return retRect;
}


- (void) hideAlertView
{
    _alertView.hidden = YES;
    [self hideAlertAnmation];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
}

-(void) removeFromSuperview
{
    [super removeFromSuperview];
}


- (void) leftBtnPressed:(id)sender
{
    if (_customDelegate && [_customDelegate respondsToSelector:@selector(leftBtnPressedWithinalertView:)])
    {
        [_customDelegate leftBtnPressedWithinalertView:self];
    }
    else
    {
        [self hideAlertView];
    }
}

- (void) rightBtnPressed:(id)sender
{
    if (_customDelegate && [_customDelegate respondsToSelector:@selector(rightBtnPressedWithinalertView:)])
    {
        [_customDelegate rightBtnPressedWithinalertView:self];
    }
    else
    {
        [self hideAlertView];
    }
}

- (void) centerBtnPressed:(id)sender
{
    if (_customDelegate && [_customDelegate respondsToSelector:@selector(centerBtnPressedWithinalertView:)])
    {
        [_customDelegate centerBtnPressedWithinalertView:self];
    }
    else
    {
        [self hideAlertView];
    }
}

-(void) setTitle:(NSString*) title
{
    titleLabel.text = title;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}


-(void) textFieldChanged
{
    if ([textField.text length] > MAX_CATEGORY_NAME_LENGTH)
    {
        textField.text = [textField.text substringToIndex:MAX_CATEGORY_NAME_LENGTH];
    }
}

#pragma mark - DelegateTextField


- (BOOL)textFieldShouldReturn:(UITextField *)_textField
{
    if (_textField.tag == kTagViewTextFieldJalBreakPassW)
    {
        [self rightBtnPressed:nil];
        return NO;
    }
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField_ shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField_.tag == kTagViewTextFieldJalBreakPassW)
    {
        
        if (string && [string length] && [textField_.text length]>15)
        {
            return NO;
        }
        
    }
    
    return YES;
    
}


@end
