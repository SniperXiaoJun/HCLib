//
//  JRCSIIGeneralConfirmView.m
//  CsiiMobileFinance
//
//  Created by  高鹏飞 on 2017/3/6.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRCSIIGeneralConfirmView.h"

@interface JRCSIIGeneralConfirmView (){

    UIView *retDicView;
    UIImageView *confirmImg;
    UIButton *confirmBtn;   //确认按钮
    NSMutableDictionary *params;
    NSMutableDictionary * dataDic;
    NSMutableArray *uiData;

}

@end

static JRCSIIGeneralConfirmView *csiiGeneraConfirmView = nil;

@implementation JRCSIIGeneralConfirmView

@synthesize dataDict,formDic,TrsPassword;

#define IMAGE(Str) JRBundeImage(Str)

+(JRCSIIGeneralConfirmView *)shareInstance{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        csiiGeneraConfirmView = [[JRCSIIGeneralConfirmView alloc] initWithFrame:CGRectMake((ScreenWidth - 645 * scaleW)/2, (ScreenHeight - 745 *scaleH)/2, 645 * scaleW, 650 * scaleH)];
        [((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]).rootViewController.view addSubview:csiiGeneraConfirmView];
    });
    
    return csiiGeneraConfirmView;
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
    NSString*filePath = [[NSBundle mainBundle]pathForResource:@"GenernalPwdConfirm"ofType:@"json"];
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

-(void)show:(JRCSIIGeneralConfirmViewBlock)JRCSIIGeneralConfirmViewBlock{
    [self test1];
    dataDic = [NSMutableDictionary dictionaryWithDictionary:dataDict];
    NSLog(@"传给submitView 参数");
    
    self.JRCSIIGeneralConfirmViewBlock = JRCSIIGeneralConfirmViewBlock;
    retDicView = [[UIView alloc] initWithFrame:CGRectMake(15, 35+50*scaleH, csiiGeneraConfirmView.frame.size.width-15, 350*scaleH)];
    [self addSubview:retDicView];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(retDicView.frame)-115*scaleW, 0, 115*scaleW, 114*scaleH)];
    iconImage.image = IMAGE(@"doneIcon");
    [retDicView addSubview:iconImage];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImage.frame)+50*scaleH, retDicView.frame.size.width-15, 150*scaleH)];
    tipsLabel.text = params[@"tips"];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.numberOfLines = 0;
    [retDicView addSubview:tipsLabel];
    
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
    [csiiGeneraConfirmView.layer addAnimation:popAnimation forKey:nil];
    csiiGeneraConfirmView.hidden = NO;
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
    
    confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(60*scalePW, CGRectGetMaxY(line.frame)+50*scalePH, self.frame.size.width - 120* scalePW, 45)];
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

    csiiGeneraConfirmView.hidden = YES;
    [params removeAllObjects];
    //    retDicView = nil;
    [retDicView removeFromSuperview];
}

-(void)submitConfirm{

    [NickMBProgressHUD showMessage:@"请稍后"];
    
    //    pwdTF.timestamp = [formData valueForKey:@"timestamp"];
    
    //    self.formDic = formData;
    //TODO: 这里执行block
    if (self.JRCSIIGeneralConfirmViewBlock) {
        self.JRCSIIGeneralConfirmViewBlock();
    }
    [self CSIISubmitViewHide];
}

-(void)CSIISubmitViewHide{

    [uiData removeAllObjects];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
