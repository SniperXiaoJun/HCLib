//
//  JRCSIINoCardDrawView.m
//  CsiiMobileFinance
//
//  Created by  高鹏飞 on 2017/3/6.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRCSIINoCardDrawView.h"
#import "PowerEnterUITextField.h"

@interface JRCSIINoCardDrawView ()<UITextFieldDelegate>{

    PowerEnterUITextField *passwordTF;
    PowerEnterUITextField *confirmTF;
    UIView *retDicView;
    UIImageView *confirmImg;
    UIButton *confirmBtn;   //确认按钮
    NSMutableDictionary *params;
    NSMutableDictionary * dataDic;
    NSMutableArray *uiData;
}

@end

static JRCSIINoCardDrawView *csiiNoCardDrawView = nil;

@implementation JRCSIINoCardDrawView

@synthesize dataDict,formDic,TrsPassword;

#define IMAGE(Str) JRBundeImage(Str)

+(JRCSIINoCardDrawView *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        csiiNoCardDrawView = [[JRCSIINoCardDrawView alloc] initWithFrame:CGRectMake((ScreenWidth - 645 * scaleW)/2, (ScreenHeight - 745 *scaleH)/2, 645 * scaleW, 650 * scaleH)];
        [((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]).rootViewController.view addSubview:csiiNoCardDrawView];
    });
    return csiiNoCardDrawView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.0;
        self.layer.borderWidth = 1.0;
        self.userInteractionEnabled = YES;
        [self craetUI];
    }
    return self;
}
- (void)test1 {
    NSString*filePath = [[NSBundle mainBundle]pathForResource:@"AddAcount"ofType:@"json"];
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

-(void)show:(JRCSIINoCardDrawViewBlock)JRCSIINoCardDrawViewBlock{

    [self test1];
    dataDic = [NSMutableDictionary dictionaryWithDictionary:dataDict];
    NSLog(@"传给submitView 参数");
    
    //    int type = uiData.count;
    self.JRCSIINoCardDrawViewBlock = JRCSIINoCardDrawViewBlock;
    
    
    retDicView = [[UIView alloc] initWithFrame:CGRectMake(5, 50*scaleH, self.size.width-10, 900*scalePH)];
    //    retDicView.backgroundColor = [UIColor redColor];
    [self addSubview:retDicView];
    [self cteatTopUI];
    
    
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
    [csiiNoCardDrawView.layer addAnimation:popAnimation forKey:nil];
    csiiNoCardDrawView.hidden = NO;
}

-(void)craetUI{
    [self creatCancelBtn];
    [self creatPasswordUI];
    
}

-(void)cteatTopUI{
    
    
    UILabel *titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, retDicView.size.width, 50*scalePH)];
    titelLabel.text = @"取现密码设置";
    titelLabel.textAlignment = NSTextAlignmentCenter;
    [retDicView addSubview:titelLabel];
    
    UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titelLabel.frame)+100*scalePH, 300*scalePW, 150*scalePH)];
    Label1.text = @"取现密码:";
    [retDicView addSubview:Label1];
    
    confirmTF = [[PowerEnterUITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(Label1.frame), CGRectGetMinY(Label1.frame), 700*scalePW, 150*scalePH)];
    confirmTF.tag = 101;
    confirmTF.delegate = self;
    confirmTF.placeholder = @"请输入取现密码";
    confirmTF.passwordKeyboardType = Number;
    [retDicView addSubview:confirmTF];
    
    UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(Label1.frame)+100*scalePH, 300*scalePW, 150*scalePH)];
    Label2.text = @"账户密码:";
    [retDicView addSubview:Label2];
    
    passwordTF = [[PowerEnterUITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(Label2.frame), CGRectGetMinY(Label2.frame), 700*scalePW, 150*scalePH)];
    passwordTF.passwordKeyboardType = Number;
    passwordTF.tag = 102;
    passwordTF.placeholder = @"请确认取现密码";
    passwordTF.delegate = self;
    [retDicView addSubview:passwordTF];
    
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
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 700*scalePH, self.frame.size.width, 1)];
    line.image = IMAGE(@"line");
    [self addSubview:line];
    
    confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(60*scalePW, CGRectGetMaxY(line.frame)+100*scalePH, self.frame.size.width - 120* scalePW, 45)];
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
    
    csiiNoCardDrawView.hidden = YES;
    [params removeAllObjects];
    //    retDicView = nil;
    [retDicView removeFromSuperview];
}

-(void)submitConfirm{
    
    [NickMBProgressHUD showMessage:@"请稍后"];
    
    NSLog(@"谢谢");
    
    //    pwdTF.timestamp = [formData valueForKey:@"timestamp"];
    
    //    self.formDic = formData;
    //TODO: 这里执行block
    //    if (self.JRCSIIAddAccountViewBlock) {
    //        self.JRCSIIAddAccountViewBlock();
    //    }
    [self CSIISubmitViewHide];
}

-(void)CSIISubmitViewHide{
    
    [uiData removeAllObjects];
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
    
    if (textField.tag == 101||textField.tag == 102) {
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
