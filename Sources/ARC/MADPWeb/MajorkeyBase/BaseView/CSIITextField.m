//
//  CSIITextField.m
//  SDPocProject
//
//  Created by Yuxiang on 13-3-2.
//  Copyright (c) 2013年 liuwang. All rights reserved.
//

#import "CSIITextField.h"

@implementation CSIITextField
@synthesize beginFrame;
@synthesize currentIndex;
@synthesize index;
@synthesize isRemarkText;
@synthesize isPayeeBookText;
@synthesize pickerViewObjectArr;
@synthesize textFieldToolbar;
@synthesize inputPickerView;
@synthesize inputDatePickerView;
@synthesize value;
@synthesize date;
@synthesize inputPickerData;
@synthesize configData;
@synthesize returnDataArray;
@synthesize returnData;
@synthesize dateFormatter;
@synthesize isAmount;
@synthesize length;
@synthesize isCardNumber;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTextField];
    }
    return self;
}

- (id)initAmountTextfieldWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAmountTextField];        //创建金额输入框
    }
    return self;
}


-(id)init{
    self = [super init];
    if(self != nil){
        [self createTextField];
    }
    return self;
}


-(void)createTextField;
{
    self.textFieldToolbar = [[CPCustomUIToolbar alloc]init];
    self.textFieldToolbar.delegate = self;
    self.inputAccessoryView = self.textFieldToolbar;
    self.returnKeyType=UIReturnKeyDone;
    self.text = @"";
    self.borderStyle = UITextBorderStyleNone;
//    self.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.keyboardType = UIKeyboardTypeDefault;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.borderStyle= UITextBorderStyleNone;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor colorWithRed:0.87f green:0.91f blue:0.98f alpha:1.00f].CGColor;
//    self.layer.cornerRadius = 3;
//    self.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont systemFontOfSize:14];
    
#pragma mark - 覆盖下拉文本框
    UIImage*img = JRBundeImage(@"textfieldBG");
//    UIImage*backImg = [img resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, CGRectGetWidth(self.frame)-img.size.width, img.size.height) resizingMode:UIImageResizingModeStretch];
    //覆盖文本框
    self.background = img;
    
    //新加
    [self addTarget:self action:@selector(onEditingDidBeginAction:) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(onEditingDidEndAction:) forControlEvents:UIControlEventEditingDidEnd];
    [self addTarget:self action:@selector(onEditingChangedAction:) forControlEvents:UIControlEventEditingChanged];
 
}

////控制placeHolder的颜色、字体
//- (void)drawPlaceholderInRect:(CGRect)rect
//{
//    //CGContextRef context = UIGraphicsGetCurrentContext();
//    //CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
//    [[UIColor colorWithRed:0.82f green:0.88f blue:0.99f alpha:1.00f] setFill];
//    
//    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:12]];
//}

-(void)createPicker;
{
    [self addTarget:self action:@selector(onEditingDidBeginAction:) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(onEditingDidEndAction:) forControlEvents:UIControlEventEditingDidEnd];
    self.textFieldToolbar = [[CPCustomUIToolbar alloc]init];
    self.textFieldToolbar.delegate = self;
    self.inputAccessoryView = self.textFieldToolbar;
    self.borderStyle = UITextBorderStyleNone;
    self.clearButtonMode=UITextFieldViewModeNever;
    CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];

    self.inputPickerView = [ [ UIPickerView alloc ] initWithFrame: CGRectMake(0.0, bounds.size.height - 216.0, 0.0, 0.0) ];
    self.inputPickerView.delegate = self;
    self.inputPickerView.dataSource = self;
    self.inputPickerView.showsSelectionIndicator = YES;
    self.inputView = self.inputPickerView;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.borderStyle= UITextBorderStyleRoundedRect;
}

-(void)createDatePicker;
{
    self.textFieldToolbar = [[CPCustomUIToolbar alloc]init];
    self.textFieldToolbar.delegate = self;
    self.inputAccessoryView = self.textFieldToolbar;
    
    self.clearButtonMode=UITextFieldViewModeNever;
    self.borderStyle = UITextBorderStyleNone;
    self.returnKeyType=UIReturnKeyDone;
    CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ];
    
    self.inputDatePickerView = [[  UIDatePicker alloc ] initWithFrame: CGRectMake(0.0, bounds.size.height - 216.0, 0.0, 0.0) ];
    [self.inputDatePickerView addTarget:self action:@selector(setDateInfo:) forControlEvents:UIControlEventValueChanged];
    self.inputDatePickerView.datePickerMode = UIDatePickerModeDate;
    self.inputView = self.inputDatePickerView;
    ((CPCustomUIToolbar*)self.inputAccessoryView).segmentedControl1s.hidden = NO;
    [((UIDatePicker*)self.inputView) sendActionsForControlEvents:UIControlEventValueChanged];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.borderStyle= UITextBorderStyleRoundedRect;
}

-(void)createAmountTextField;
{
    self.textFieldToolbar = [[CPCustomUIToolbar alloc]init];
    self.textFieldToolbar.delegate = self;
    self.inputAccessoryView = self.textFieldToolbar;
    self.returnKeyType=UIReturnKeyDone;
    self.text = @"";
    self.borderStyle = UITextBorderStyleNone;
    //    self.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.keyboardType = UIKeyboardTypeDecimalPad;
    self.TFType = textFieldType_Amount;
    self.isAmount = YES;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.borderStyle= UITextBorderStyleRoundedRect;
    
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //新加
    [self addTarget:self action:@selector(onEditingDidBeginAction:) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(onEditingDidEndAction:) forControlEvents:UIControlEventEditingDidEnd];
    [self addTarget:self action:@selector(onEditingChangedAction:) forControlEvents:UIControlEventEditingChanged];
}


-(void)setDateInfo:(UIDatePicker*)sender;
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.date = sender.date;
    self.text = [self.dateFormatter stringFromDate:sender.date];
}
-(void)setToday;
{
    [((UIDatePicker*)self.inputView) setDate:[[NSDate alloc]init] animated:YES];
    [((UIDatePicker*)self.inputView) sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark -- 格式校验 --
- (BOOL) validateTextFormat{//正则表达式
    
    if (self.text.length == 0) {
        if (_MustInput==YES) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:self.placeholder delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return  NO;
        }
        else{
            self.text = @"";
        }
    }
    
    
    if (self.TFType == textFieldType_AcCard) {    //银行卡号
        
        if (self.text.length<10||self.text.length>23) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"请输入正确位数的卡号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return NO;
        }
       // 注掉
//        if (![[[MajorBaseViewController alloc]init]isPureInt:self.text]) {
//            
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"请输入正确格式的卡号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            
//            return NO;
//        }
    }
    
    
    if (self.TFType == textFieldType_Phone) {
        
        if (self.text.length!=11) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"电话号码位数不符，请重新填写" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return NO;
        }
        
//        NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
//        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//        BOOL isMatch = [pred evaluateWithObject:self.text];
//        
//        if (!isMatch) {
//        
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"手机号码格式不正确，请重新输入手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];
//        
//                    return NO;
//        }
        
        
    }
    
    if (self.TFType == textFieldType_Mess) {
        
        if (self.text.length!=6) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"短信验证码格式不正确，请重新输入短信验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return NO;
        }
    }
    
    
    if (self.TFType == textFieldType_IDNum&&_MustInput == YES) {
        if (self.text.length!=15&&self.text.length!=18) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"证件号码格式不正确，请重新输入证件号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return NO;
        }
    }
    
    if (self.TFType == textFieldType_Email) {

        NSString *regex = @"^([a-zA-Z0-9_.-])+@(([a-zA-Z0-9-])+.)+([a-zA-Z0-9]{2,4})+$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:self.text];
        
        if (!isMatch) {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"邮箱格式不正确，请重新输入邮箱" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return NO;
        }
        
    }
    
    return YES;
}

#pragma mark - 重载UItextfield方法 控制placeHolder、显示文本、编辑文本的位置
//控制placeHolder的位置
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+5, bounds.origin.y+6, bounds.size.width-5, bounds.size.height);
    return inset;
}
//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+5, bounds.origin.y, bounds.size.width-10, bounds.size.height);
    return inset;
}
//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+5, bounds.origin.y, bounds.size.width-30, bounds.size.height);
    return inset;
}


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender

{
    
    if ([UIMenuController sharedMenuController]) {
        
        [UIMenuController sharedMenuController].menuVisible = NO;
        
    }
    
    return NO; 
    
}


//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (self.TFType == textFieldType_Amount) {  //判断金额输入框  输入框限制只能输入两位小数
//        
//        if (textField.text.length>3&&[[textField.text substringWithRange:NSMakeRange(textField.text.length-3, 1)]isEqualToString:@"."]&&![string isEqualToString:@""]) {
//            return NO;
//        }
//    }
//    return YES;
//}


#pragma mark - UIPickerView
-(void)onEditingDidBeginAction:(id)sender;
{
    if (self.isAmount) {
        if([self.text isEqualToString:@"0.00"]){
            self.text = @"";
        }
    }if(self.isCardNumber){
     
//     self.text = @"";
    } else{
        if([[self.inputPickerData objectAtIndex:0] count]==0){
            return;
        }
        [((CSIIUIPickerViewObject*)[self.pickerViewObjectArr objectAtIndex:self.currentIndex])startAnimation];
    }
}
-(void)onEditingDidEndAction:(CSIITextField*)sender;
{
    if (self.isAmount) {
        self.text = [[self getMoneyString:self.text]isEqualToString:@"0.00"]?@"":[self getMoneyString:self.text];
        if (sender.text && ![sender.text isEqualToString:@""]) {
            if ([self getTextLengthAccurate:sender.text] >= 0) {
                sender.text = [self catTextLengthAccurate:sender.text cutLength:[self getTextLengthAccurate:sender.text]];
            }
        }
    }else if(self.isCardNumber){
        
        self.text = [[self getCardNumber:self.text]isEqualToString:@"0.00"]?@"":[self getCardNumber:self.text];
        if (sender.text && ![sender.text isEqualToString:@""]) {
            if ([self getTextLengthAccurate:sender.text] >= 0) {
                sender.text = [self catTextLengthAccurate:sender.text cutLength:[self getTextLengthAccurate:sender.text]];
            }
        }

    }else{
        if([[self.inputPickerData objectAtIndex:0] count]==0){
            return;
        }
        [((CSIIUIPickerViewObject*)[self.pickerViewObjectArr objectAtIndex:self.currentIndex])endAnimation];
    }

}

-(void)onEditingChangedAction:(CSIITextField*)sender;
{
    if (!self.inputPickerView) {
        if (self.isAmount) {
            if (sender.text && ![sender.text isEqualToString:@""]) {
                //限制金额输入
                if (sender.text.length > 15) {//10000，00000，00000
                    sender.text = [sender.text substringToIndex:15];
                }
                else{
                    NSString *oldString = sender.text;
                    if (!matchString([NSRegularExpression regularExpressionWithPattern:
                                      @"^([0-9]{1}|[1-9]{1}[0-9]{1,}|[0-9]{1}\\.[0-9]{0,2}|[1-9]{1}[0-9]{1,}\\.[0-9]{0,2})$"options:0 error:nil], oldString)) {
                        sender.text = [oldString substringToIndex:oldString.length-1];
                    }
                }
            }
        }
        if (self.length>0) {
            if (sender.text && ![sender.text isEqualToString:@""]) {
                NSString *oldString = sender.text;
                if (sender.text.length>self.length) {
                    sender.text = [oldString substringToIndex:self.length];
                }
            }
        }
    }
}

- (NSString*)getMoneyString:(NSString*)moneyStr;
{
    NSString *str = [NSString stringWithFormat:@"%f",[moneyStr doubleValue]];
    NSInteger end = [str rangeOfString:@"."].location+3;
    NSRange sdf = NSMakeRange(0, end);
    return [str substringWithRange:sdf];
}

- (NSString *)getCardNumber:(NSString *)cardNumber{

    NSString *str = [NSString stringWithFormat:@"%lld",[cardNumber longLongValue]];
    if([str isEqualToString:@"0"]){
    
        str = @"";
    }
    return str;
}
-(float)getTextLengthAccurate:(NSString*)moneyStr;
{
    float number = 0.0;
    for (int x = 0; x < [moneyStr length]; x++)
    {
        NSString *character = [moneyStr substringWithRange:NSMakeRange(x, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }else{
            number = number + 0.5;
        }
    }
    return number;
}

-(NSString*)catTextLengthAccurate:(NSString*)moneyStr cutLength:(float)cutLength;
{
    NSMutableString *result = [[NSMutableString alloc]initWithString:@""];
    float number = 0.0;
    for (int x = 0; x < [moneyStr length]; x++)
    {
        NSString *character = [moneyStr substringWithRange:NSMakeRange(x, 1)];
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
            if (number <= cutLength) {
                [result appendString:character];
            }else{
                break;
            }
        }
        else
        {
            number = number + 0.5;
            if (number <= cutLength) {
                [result appendString:character];
            }else{
                break;
            }
        }
    }
    return result;
}

BOOL matchString(NSRegularExpression *regex, NSString *string)
{
    NSTextCheckingResult *match = [regex firstMatchInString:string
                                                    options:0
                                                      range:NSMakeRange(0, [string length])];
    if (match) {
        NSRange matchRange = [match range];
        if (matchRange.length == [string length]) {
            return TRUE;
        }
    }
    return FALSE;
}

-(id)initWithPicker:(CGRect)frame pickerData:(NSMutableArray*)pickerData;
{
    self = [super initWithFrame:frame];
    if(self != nil){
        [self createPicker];
        self.inputPickerData = pickerData;
    }
    return self;
}
-(id)initWithPicker:(NSMutableArray*)pickerData;
{
    self = [super init];
    if(self != nil){
        [self createPicker];
        self.inputPickerData = pickerData;
    }
    return self;
}


-(void)setInputPickerData:(NSMutableArray*)data;
{
    if (inputPickerData != data) {
        self.pickerViewObjectArr = [[NSMutableArray alloc]init];
        for (int i =0; i<[[data objectAtIndex:0] count]; i++) {
            CSIIUIPickerViewObject *pickerViewObject = [[CSIIUIPickerViewObject alloc]initWithTitle:[[data objectAtIndex:0] objectAtIndex:i]];
            [self.pickerViewObjectArr addObject:pickerViewObject];
        }
    }
    self.currentIndex=0;
}

- (void)pickerView:(NSInteger)row inComponent:(NSInteger)component;
{
    self.inputPickerData=(NSMutableArray *)accountsPP;
    
    if([[self.inputPickerData objectAtIndex:0] count]==0){
        self.enabled = NO;
        if ([self.delegate isKindOfClass:[MajorBaseViewController class]]) {
        }
//        else if ([self.delegate isKindOfClass:[CSIIUISuperTableViewController class]]) {
//            [(CSIIUISuperTableViewController*)self.delegate setPickerReturnData:self data:nil];
//        }
        return;
    }else {
        self.enabled = YES;
    }
    
    [((CSIIUIPickerViewObject*)[self.pickerViewObjectArr objectAtIndex:self.currentIndex])endAnimation];
    [((CSIIUIPickerViewObject*)[self.pickerViewObjectArr objectAtIndex:row])startAnimation];
    self.currentIndex = row;
    
    
    [self.inputPickerView selectRow:row inComponent:component animated:NO];
    self.text = [[self.inputPickerData objectAtIndex:component]objectAtIndex:row];
    self.index = row;
    
    self.returnData = [[NSMutableDictionary alloc]init];
    
    [self.returnData setObject:[[NSNumber alloc]initWithInt:(int )self.index] forKey:@"index"];
    [self.returnData setObject:self.text forKey:@"text"];
    if ([self.returnDataArray count]>0) {
        [self.returnData setObject:[self.returnDataArray objectAtIndex:row] forKey:@"data"];
    }
    if ([self.delegate isKindOfClass:[MajorBaseViewController class]]) {
    }
//    else if ([self.delegate isKindOfClass:[CSIIUISuperTableViewController class]]) {
//        [(CSIIUISuperTableViewController*)self.delegate setPickerReturnData:self data:self.returnData];
//    }
}








-(id)initWithDate:(CGRect)frame pickerData:(NSDictionary*)pickerData;
{
    self = [super initWithFrame:frame];
    if(self != nil){
        self.configData = pickerData;
        [self createDatePicker];
    }
    return self;
}
-(id)initWithDate:(NSDictionary*)pickerData;
{
    self = [super init];
    if(self != nil){
        self.configData = pickerData;
        [self createDatePicker];
    }
    return self;
}


-(id)initWithAccount:(id)delegateParam frame:(CGRect)frame pickerData:(NSMutableArray*)pickerData;//
{
    self = [super initWithFrame:frame];
    if(self != nil){
//        NSString *path;
//        path=[[NSBundle mainBundle] pathForResource:@"PayerAcNoList" ofType:@"json"];
//        accountsPP = [[NSArray alloc]init];
        accountsPP =pickerData;
        
        self.delegate = delegateParam;
        [self createPicker];
        if(accountsPP!=nil)
            self.text=[[accountsPP objectAtIndex:0]objectForKey:@"AcNo"];
    }
    return self;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;{
    return [[accountsPP objectAtIndex:row]objectForKey:@"AcNo"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
//    [self pickerView:row inComponent:component];
    self.text=[[accountsPP objectAtIndex:row]objectForKey:@"AcNo"];

}
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [accountsPP count];
}

-(id)initWithAccount:(id)delegateParam pickerData:(NSDictionary*)pickerData;{
    self = [super init];
    if(self != nil){
        self.delegate = delegateParam;
        [self createPicker];
        self.returnDataArray = [[NSMutableArray alloc]init];
        
    }
    return self;
}

-(id)initWithPayerAcNo:(id)delegateParam frame:(CGRect)frame pickerData:(NSDictionary*)pickerData;
{
    self = [super initWithFrame:frame];
    if(self != nil){
        self.delegate = delegateParam;
        [self createPicker];
        self.returnDataArray = [[NSMutableArray alloc]init];

    }
    return self;
}
-(id)initWithPayerAcNo:(id)delegateParam pickerData:(NSDictionary*)pickerData;
{
    self = [super init];
    if(self != nil){
        self.delegate = delegateParam;
        [self createPicker];
        self.returnDataArray = [[NSMutableArray alloc]init];

    }
    return self;
}

-(id)initWithProvinces:(id)delegateParam frame:(CGRect)frame pickerData:(NSDictionary*)pickerData{
    self = [super initWithFrame:frame];
    if(self != nil){
        self.delegate = delegateParam;
        [self createPicker];
        self.returnDataArray = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
