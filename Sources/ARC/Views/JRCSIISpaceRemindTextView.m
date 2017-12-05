//
//  JRCSIISpaceRemindTextView.m
//  CsiiMobileFinance
//
//  Created by  高鹏飞 on 2017/3/6.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRCSIISpaceRemindTextView.h"

#import "PowerEnterUITextField.h"

@interface JRCSIISpaceRemindTextView ()<UITextFieldDelegate>{
    PowerEnterUITextField *pwdTF;
    UIView *retDicView;
    UILabel *leftLabel;
    UILabel *rightLabel;
    
    UIImageView *image;
    NSMutableArray *dotArray; //用于存放黑色的点点
    NSString *timestamp;
    UIButton *confirmBtn;   //确认按钮
    UIView *dotView;
    UIImageView *confirmImg;
    UIImageView *passWordimg;
    
    NSMutableDictionary *params;
    
    
    NSMutableDictionary * dataDic;
    NSMutableDictionary *formData;
    NSMutableDictionary *pinData;
    NSMutableArray *uiData;
}

@end

static JRCSIISpaceRemindTextView *csiiSpaceRemindTextView = nil;


@implementation JRCSIISpaceRemindTextView

@synthesize dataDict,formDic,TrsPassword;

#define IMAGE(Str) JRBundeImage(Str)
#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数

+(JRCSIISpaceRemindTextView *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        csiiSpaceRemindTextView = [[JRCSIISpaceRemindTextView alloc] initWithFrame:CGRectMake((ScreenWidth - 645 * scaleW)/2, (ScreenHeight - 745 *scaleH)/2, 645 * scaleW, 845 * scaleH)];
        [((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]).rootViewController.view addSubview:csiiSpaceRemindTextView];
    });
    
    return csiiSpaceRemindTextView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.0;
        self.layer.borderWidth = 1.0;
        //        self.layer.borderColor = [[UIColor grayColor] CGColor];
        self.userInteractionEnabled = YES;
        [self craetUI];
    }
    
    return self;
}


- (void)test1 {
    NSString*filePath = [[NSBundle mainBundle]pathForResource:@"SpaceRemindTextandText"ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"解析失败--%@", error);
        return;
    }
    NSLog(@"-json: %@",json);
    params = [NSMutableDictionary dictionaryWithDictionary:json];
    
    uiData = [json objectForKey:@"List"];
    NSLog(@"--song array: %@",uiData);
    
}
-(void)show:(JRCSIISpaceRemindTextViewBlock)JRCSIISpaceRemindTextViewBlock{
    [self test1];
    
    dataDic = [NSMutableDictionary dictionaryWithDictionary:dataDict];
    NSLog(@"传给submitView 参数");
    
    int type = uiData.count;

    self.JRCSIISpaceRemindTextViewBlock = JRCSIISpaceRemindTextViewBlock;
    retDicView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, csiiSpaceRemindTextView.size.width-15, 450*scaleH)];
    [self addSubview:retDicView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, csiiSpaceRemindTextView.size.width-30, 100*scalePH)];
    titleLabel.text = params[@"func"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [retDicView addSubview:titleLabel];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100*scalePH, csiiSpaceRemindTextView.size.width-30, 200*scalePH)];
    tipsLabel.text = params[@"tips"];
    tipsLabel.textColor = [UIColor redColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont systemFontOfSize:12.0f];
    tipsLabel.adjustsFontSizeToFitWidth = YES;
    tipsLabel.numberOfLines = 0;
    [retDicView addSubview:tipsLabel];
    
    for (int i=0; i<type; i++) {
        leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50+50*scaleH+550*scalePH/type*i, csiiSpaceRemindTextView.size.width/type, 350*scalePH/type)];
        leftLabel.text = [[uiData objectAtIndex:i] valueForKey:@"LeftText"];
        [retDicView addSubview:leftLabel];
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(5+csiiSpaceRemindTextView.size.width/type , 50+50*scaleH+550*scalePH/type*i, csiiSpaceRemindTextView.size.width, 350*scalePH/type)];
        rightLabel.text = [[uiData objectAtIndex:i] valueForKey:@"RightText"];
        [retDicView addSubview:rightLabel];
    }
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [csiiSpaceRemindTextView.layer addAnimation:popAnimation forKey:nil];
    csiiSpaceRemindTextView.hidden = NO;
    
}

-(void)craetUI{
    [self creatCancelBtn];
    [self creatPasswordUI];
}
-(void)creatCancelBtn{
    
    UIImageView *cancelViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200 * scalePW, 150 * scalePW)];
    UIImageView *cancelView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10,50 * scalePW, 50 * scalePW)];
    cancelView.image = IMAGE(@"关闭");
    cancelView.userInteractionEnabled = YES;
    cancelViewBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *cancelLoginTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelLoginTaped)];
    [cancelViewBg addGestureRecognizer:cancelLoginTap];
    [cancelViewBg addSubview:cancelView];
    [self addSubview:cancelViewBg];
}
-(void)creatPasswordUI{
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 800 * scalePH, self.frame.size.width, 1)];
    line.image = IMAGE(@"line");
    [self addSubview:line];
    
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(60*scalePW, CGRectGetMaxY(line.frame) + 45*scalePH, self.frame.size.width - 120* scalePW, 60*scalePH)];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.text = @"请输入交易密码";
    textlabel.textColor = [UIColor grayColor];
    textlabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:textlabel];
    passWordimg = [[UIImageView alloc] initWithFrame:CGRectMake(60*scalePW, CGRectGetMaxY(line.frame) + 150*scalePH, self.frame.size.width - 120* scalePW, 150*scalePH)];
    passWordimg.userInteractionEnabled = YES;
    passWordimg.image = IMAGE(@"密码框_背景");
    [self addSubview:passWordimg];
    passWordimg.layer.cornerRadius = 10.0f;
    
    pwdTF = [[PowerEnterUITextField alloc] initWithFrame:CGRectMake(0, 0, passWordimg.size.width, 150*scalePH)];
    pwdTF.backgroundColor = [UIColor clearColor];
    //输入的文字颜色为白色
    pwdTF.textColor = [UIColor clearColor];
    //输入框光标的颜色为白色
    pwdTF.tintColor = [UIColor clearColor];
    pwdTF.delegate = self;
    pwdTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    pwdTF.passwordKeyboardType = Number;
    pwdTF.isSound = NO;
    pwdTF.isRoundam = YES;
    pwdTF.borderStyle = UITextBorderStyleNone;
    pwdTF.isHighlightKeybutton = PopupBtn;
    [pwdTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    pwdTF.minLength = 2;                    //设置输入最小长度为2
    pwdTF.maxLength =6;                    //设置输入最大长度为20
    pwdTF.placeholder = @"";
    [passWordimg addSubview:pwdTF];
    //输入框
    image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 120* scalePW, 150*scalePH)];
    image.backgroundColor = [UIColor clearColor];
    image.image = IMAGE(@"密码框");
    [pwdTF addSubview:image];
    
    CGFloat width = (image.size.width)/ kDotCount;
    
    dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < kDotCount; i++) {
        dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(pwdTF.frame) + (width - kDotCount) / 2 + i * width, CGRectGetMinY(pwdTF.frame) + (image.size.height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [image addSubview:dotView];
        //把创建的黑色点加入到数组中
        [dotArray addObject:dotView];
    }
    pwdTF.doneButtonAction = ^(PowerEnterUITextField *powerEnterUITextField){
        NSLog(@"点击完成按钮，密码密文为：%@",powerEnterUITextField.value);
    };
    pwdTF.inputContentsChanged = ^(PowerEnterUITextField *powerEnterUITextField){
        NSLog(@"已输入密码长度为：%lu",(unsigned long)powerEnterUITextField.text.length);
        for (int i = 0; i<6; i++) {
            UIImageView *heidian = image.subviews[i];
            heidian.hidden = YES;
        }
        int num =(int)powerEnterUITextField.text.length;
        for (int i = 0; i <num; i++) {
            UIImageView *heidian = image.subviews[i];
            heidian.hidden = NO;
        }
        //TODO: 判断6位  隐藏密码框，发交易
        if (num == 6) {
            [self JRAlertPassWordHide];
        }
    };
    confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(60*scalePW, CGRectGetMaxY(passWordimg.frame)+60*scalePH, self.frame.size.width - 120* scalePW, 45)];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithRed:223/255.0 green:160/255.0 blue:26/255.0 alpha:1.0] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(submitConfirm) forControlEvents:UIControlEventTouchDown];
    confirmBtn.adjustsImageWhenHighlighted = NO;
    confirmBtn.userInteractionEnabled = YES;
    confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    confirmImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 120* scalePW, 45)];
    confirmImg.image = IMAGE(@"按钮背景");
    [confirmBtn setBackgroundImage:confirmImg.image forState:UIControlStateNormal];
    [self addSubview:confirmBtn];
    

    
}
#pragma mark --- 按钮事件
    
    /*
     *  取消视图 “x号”
     */
- (void)cancelLoginTaped{
        
    for (int i = 0; i<dotArray.count; i++) {
        ((UIView *)[dotArray objectAtIndex:i]).hidden = YES;
    }
    csiiSpaceRemindTextView.hidden = YES;
    pwdTF.text = nil;
    [params removeAllObjects];
    //    retDicView = nil;
    [retDicView removeFromSuperview];
    [pwdTF resignFirstResponder];
}
-(void)JRAlertPassWordHide{
    [pwdTF resignFirstResponder];
    
}
-(void)submitConfirm{
    if ([pwdTF.text isEqualToString:@""]) {
        alertView(@"请输入交易密码");
    }
    [NickMBProgressHUD showMessage:@"请稍后"];
    
    pwdTF.timestamp = [formData valueForKey:@"timestamp"];
    self.TrsPassword = [pwdTF getValue];
    
    self.formDic = formData;
    //TODO: 这里执行block
    if (self.JRCSIISpaceRemindTextViewBlock) {
        self.JRCSIISpaceRemindTextViewBlock();
    }
    [self CSIISubmitViewHide];
}
    
-(void)CSIISubmitViewHide{
    for (int i = 0; i<dotArray.count; i++) {
        ((UIView *)[dotArray objectAtIndex:i]).hidden = YES;
    }
    [uiData removeAllObjects];
    csiiSpaceRemindTextView.hidden = YES;
    pwdTF.text = nil;
}
    
/**
*  重置显示的点
*/
-(void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    for (dotView in dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[dotArray objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length == kDotCount) {
        NSLog(@"输入完毕");
    }
}
    
#pragma mark --- 键盘代理事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

-(void) animateTextField: (UITextField *) textField up: (BOOL) up
{
    //设置视图上移的距离，单位像素
    const int movementDistance = 100;
    //三目运算，判定是否需要上移视图或者不变
    int movement = (up ? -movementDistance : movementDistance);
    //设置动画的名字
    [UIView beginAnimations: @"Animation" context: nil];
    //设置动画的开始移动位置
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置动画的间隔时间
    [UIView setAnimationDuration: 0.20];
    //设置视图移动的位移
    self.frame = CGRectOffset(self.frame, 0, movement);
    //设置动画结束
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for(UIView *view in self.subviews)
    {
        [view resignFirstResponder];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 101) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 6 && range.length!=1){
            textField.text = [toBeString substringToIndex:6];
            return NO;
        }
        return YES;
    }
    return YES;
}

@end
