//
//  JRAlertPassWord.m
//  ZXBAuthentication
//
//  Created by Summer on 16/1/27.
//  Copyright © 2016年 Shen Yu. All rights reserved.
//

#import "JRAlertPassWord.h"
#import "PowerEnterUITextField.h"
//#import "MADPPluginSDK.h"
//#import "ZxbSingleton.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
// bundle读图片
#define IMAGE(Str) [UIImage imageWithContentsOfFile:[self getFileWithName:Str]]
#define SCALE ScreenWidth/320

static JRAlertPassWord *alertPassWord=nil;

@implementation JRAlertPassWord
{
    UIView *backView;
    PowerEnterUITextField *passWord;
    UIImageView *image;
    
}
@synthesize JRAlertPassWordBlock;
+(JRAlertPassWord*)shareJRAlertPassWord{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertPassWord = [[JRAlertPassWord alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//        [((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:1]).rootViewController.view addSubview:alertPassWord];
    });
    
    return alertPassWord;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        alertPassWord.hidden = YES;
        
        //    根View
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.33];
        
        // 添加背景View   737 × 530
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-416*SCALE, ScreenWidth,200*SCALE)];
        backView.userInteractionEnabled = YES;
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        //  X图标
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0*SCALE, 0, ScreenWidth, 40*SCALE)];
        label.text  = @"请输入交易密码";
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = 1;
        [backView addSubview:label];
        
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 40*SCALE-0.5, ScreenWidth, 0.5)];
        la.backgroundColor =  [UIColor lightGrayColor];;
        [label addSubview:la];
        
        UIButton *backBnt = [[UIButton alloc] initWithFrame:CGRectMake(backView.frame.size.width - 40*SCALE, 0, 40*SCALE, 40*SCALE)];
        //        backBnt.backgroundColor = [UIColor redColor];
        [backBnt setImage:JRBundeImage(@"密码框_关闭") forState:UIControlStateNormal] ;
//        [backBnt addTarget:self action:@selector(JRAlertPassWordHide) forControlEvents:UIControlEventTouchUpInside];
        [backBnt addTarget:self action:@selector(JRAlertPassWordHideWithCancelBlock) forControlEvents:UIControlEventTouchUpInside];

        //        backBnt.hidden = YES;
        [backView addSubview:backBnt];

        NSLog(@"---%@",Context.sendDictionaryData);
        UILabel *moneyL = [[UILabel alloc] initWithFrame:CGRectMake(0, 40*SCALE, ScreenWidth, 30*SCALE)];
        moneyL.text = @"1";

        moneyL.textAlignment = 1;
//        [backView addSubview:moneyL];
        
        UILabel *moneyL1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 70*SCALE, ScreenWidth, 20*SCALE)];
        moneyL1.text = @"6228****2222";
        moneyL1.textAlignment = 1;
        moneyL1.font = [UIFont systemFontOfSize:14];
//        [backView addSubview:moneyL1];


        CGFloat  bottomH = 80 * SCALE;
        
        passWord = [[PowerEnterUITextField alloc]initWithFrame:CGRectMake(20*SCALE, bottomH, ScreenWidth - 140, (ScreenWidth-140)*89/625)];
        passWord.isRoundam = NO;    //将键盘按键设置为非随机乱序
        passWord.passwordKeyboardType = Number;
        passWord.borderStyle = UITextBorderStyleRoundedRect;
        passWord.isHighlightKeybutton = PopupBtn;
        passWord.minLength = 2;                    //设置输入最小长度为2
        passWord.maxLength = 20;                    //设置输入最大长度为20
        passWord.valueType = DefaultPassword;      //设置加密类型
        passWord.accepts = @"";
//        passWord.accepts = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,20}";                    //设置可接受的内容，正则表达式
//        passWord.platformPublicKey = @"82e260832f1e41bfca70b6d7e109f11bc882873ba8b686f110a168ea228d2d56c4227926e230ca724071ee4749c0a4ec99433d98439c08386baa734ab4b44ac44df4590606ad18a5a557086ccae3db6e86e1c806c7de90f79d4db4bec5671caed9a315c065beccd95580564a03d9dc2d2c0b19acefdeadb5617b5d8f719d08ed";                            //设置平台密钥
        passWord.placeholder = @"请输入交易密码";
        passWord.timestamp = @"1234567890";                 //设置时间戳(需要再提交获取密码密文之前，从服务端获取)
        [backView addSubview:passWord];
        [passWord becomeFirstResponder];
        
        
        //输入框  625 89
        image = [[UIImageView alloc] initWithFrame:CGRectMake(20*SCALE, bottomH, ScreenWidth - 40*SCALE, (ScreenWidth-40*SCALE)*99/650)];
        image.backgroundColor = [UIColor whiteColor];
        image.image = JRBundeImage(@"密码框_输入框");
        [backView addSubview:image];
        
        passWord.doneButtonAction = ^(PowerEnterUITextField *powerEnterUITextField){
            NSLog(@"点击完成按钮，密码密文为：%@",powerEnterUITextField.value);
        };
        passWord.inputContentsChanged = ^(PowerEnterUITextField *powerEnterUITextField){
            NSLog(@"已输入密码长度为：%lu",(unsigned long)powerEnterUITextField.text.length);
            for (UIView *view in image.subviews) {
                [view removeFromSuperview];
            }
            for (int i = 0; i < powerEnterUITextField.text.length; i++) {
                UIImageView *dian = [[UIImageView alloc] initWithFrame:CGRectMake(20*SCALE+i*46*SCALE, 16*SCALE, 10, 10)];
                dian.image= JRBundeImage(@"密码框_黑点");
                [image addSubview:dian];
            }
            if (powerEnterUITextField.text.length == 6) {
            
                [self centerBtnClick];
            }
            
        };
}
    return self;
}
-(void)centerBtnClick{
    
    //发时间戳
    new_transaction_caller
    caller.transactionId = @"Timestamp.do"; //交易名
    caller.responsType = ResponsTypeOfString; //返回数据处理
    caller.transactionArgument = nil;   //上传参数
    execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
        if (TransactionIsSuccess) {
            passWord.timestamp = returnCaller.webData;
            self.value = passWord.value;
            Context.sendStringData = self.value;
            if (self.JRAlertPassWordBlock != nil) {
                self.JRAlertPassWordBlock();
            }
            [self JRAlertPassWordHide];
        }else{

        }
    }));
}
-(void)cancleBtnClick{
    [self JRAlertPassWordHide];
}
-(void)show:(JRAlertPassWordBlock)JRAlertPassWordBlockObj;
{
    self.JRAlertPassWordBlock = JRAlertPassWordBlockObj;
    [passWord becomeFirstResponder];

    
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
    [alertPassWord.layer addAnimation:popAnimation forKey:nil];
    
    alertPassWord.hidden = YES;
}


-(void)show:(JRAlertPassWordBlock)JRAlertPassWordBlock withCancelBlock:(CancelPassWordBlock)cancelBlcok {
    self.JRAlertPassWordBlock = JRAlertPassWordBlock;
    self.cancelPassWordBlock = cancelBlcok;

    [passWord becomeFirstResponder];


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
    [alertPassWord.layer addAnimation:popAnimation forKey:nil];

    alertPassWord.hidden = YES;

}

-(void)JRAlertPassWordHide{
    [passWord clear];
    [passWord resignFirstResponder];
    
    [self removeFromSuperview];
    alertPassWord.hidden = YES;
    CATransition *transiton = [CATransition animation];
    
    transiton.duration = 1.0;
    //    动画效果
    transiton.type = @"rippleEffect";
    //    动画方向
    [transiton setSubtype:kCATransitionFromLeft];
    [alertPassWord.layer addAnimation:transiton forKey:nil];

}

-(void)JRAlertPassWordHideWithCancelBlock{
    [passWord clear];
    [passWord resignFirstResponder];

    [self removeFromSuperview];
    alertPassWord.hidden = YES;
    CATransition *transiton = [CATransition animation];

    transiton.duration = 1.0;
    //    动画效果
    transiton.type = @"rippleEffect";
    //    动画方向
    [transiton setSubtype:kCATransitionFromLeft];
    [alertPassWord.layer addAnimation:transiton forKey:nil];

    if (self.cancelPassWordBlock) {
        self.cancelPassWordBlock();
    }

}

#define BUNDLE_NAME @ "MADPAuthenticationResource.bundle/Resources"
- (NSString *)getFileWithName:(NSString *)filename
{
    NSBundle * libBundle = [NSBundle bundleWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: BUNDLE_NAME]] ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

@end
