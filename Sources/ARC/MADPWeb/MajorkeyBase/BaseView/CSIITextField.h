//
//  CSIITextField.h
//  SDPocProject
//
//  Created by Yuxiang on 13-3-2.
//  Copyright (c) 2013年 liuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPCustomUIToolbar.h"
#import "CSIIUIToolbarDelegate.h"
#import "CSIIUIPickerViewObject.h"
#import "MajorBaseViewController.h"

typedef enum
{
    textFieldType_None,
    textFieldType_AcCard,
    textFieldType_Email,
    textFieldType_UserName,
    textFieldType_Login,
    textFieldType_Phone,
    textFieldType_IDNum,
    textFieldType_Mess,
    textFieldType_Amount
    
}textFieldType;

@interface CSIITextField : UITextField<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>{
    //CSIIUIToolbar *textFieldToolbar;
    UIPickerView *inputPickerView;
    UIDatePicker *inputDatePickerView;
    NSMutableArray *inputPickerData;
    NSDictionary *configData;
    NSMutableArray *returnDataArray;
    NSMutableDictionary *returnData;
    NSDateFormatter *dateFormatter;
    NSDate *date;
    NSString *value;
    NSInteger index;
    BOOL isRemarkText;
    BOOL isPayeeBookText;
    BOOL isCardNumber;
    CGRect beginFrame;
    NSMutableArray *pickerViewObjectArr;
    NSInteger currentIndex;
    
    NSArray *accountsPP;
    
    BOOL isAmount;              //新加
    int length;                 //
}
@property (nonatomic, assign)CGRect beginFrame;
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, assign)BOOL isRemarkText;
@property (nonatomic, assign)BOOL isPayeeBookText;
@property (nonatomic, assign)BOOL isCardNumber;

@property (nonatomic, retain) NSMutableArray *pickerViewObjectArr;
@property (nonatomic, retain) CPCustomUIToolbar *textFieldToolbar;
@property (nonatomic, retain) UIPickerView *inputPickerView;
@property (nonatomic, retain) UIDatePicker *inputDatePickerView;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, retain , setter=setInputPickerData:) NSMutableArray *inputPickerData;
@property (nonatomic, retain) NSDictionary *configData;
@property (nonatomic, retain) NSMutableArray *returnDataArray;
@property (nonatomic, retain) NSMutableDictionary *returnData;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

@property (nonatomic, assign)BOOL isAmount;        //新加
@property (nonatomic, assign)int length;           //
@property (nonatomic, assign)BOOL MustInput;
@property (nonatomic) textFieldType TFType;       //输入框类型    如：手机号，卡号，


-(id)initWithAccount:(id)delegateParam pickerData:(NSDictionary*)pickerData;
-(id)initWithAccount:(id)delegateParam frame:(CGRect)frame pickerData:(NSMutableArray*)pickerData;
-(id)initWithDate:(CGRect)frame pickerData:(NSDictionary*)pickerData;
-(id)initWithDate:(NSDictionary*)pickerData;
-(id)initWithProvinces:(id)delegateParam frame:(CGRect)frame pickerData:(NSDictionary*)pickerData;

-(id)initWithPicker:(CGRect)frame pickerData:(NSMutableArray*)pickerData;
- (id)initAmountTextfieldWithFrame:(CGRect)frame;
- (BOOL) validateTextFormat;
@end
