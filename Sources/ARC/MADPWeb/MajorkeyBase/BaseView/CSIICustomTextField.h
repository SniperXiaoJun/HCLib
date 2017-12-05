//
//  CustomTextField.h
//  MobileClient
//
//  Created by xiaoxin on 15/7/30.
//  Copyright (c) 2015年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPCustomUIToolbar.h"
typedef enum
{
    CustomTextFieldType_None,
    CustomTextFieldType_IDCard,
    CustomTextFieldType_Email,
    CustomTextFieldType_UserName,
    CustomTextFieldType_Login,
    CustomTextFieldType_Phone,
    CustomTextFieldType_IDNum
    
}CustomTextFieldType;


@class CSIICustomTextField;
@protocol CustomTextFieldPickerViewDelegate <NSObject>

@optional
-(void) myPickerView:(CSIICustomTextField *)pickerView DidSlecetedAtRow:(int) row;

@end

@protocol LWYDoneDelegate <NSObject>

@optional
-(void)LWYDoneClick;

@end


@interface CSIICustomTextField : UITextField<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,CSIIUIToolbarDoneDelegate>
@property(nonatomic,assign)BOOL MustInput;
@property(nonatomic,strong) NSString *checkProperty;
@property(nonatomic,strong) NSMutableArray *pickerDataMArray;
@property(nonatomic,assign) id<CustomTextFieldPickerViewDelegate> pickerViewDelegate;
@property(nonatomic,retain) UIPickerView *pickerView;
@property(nonatomic,retain) UIDatePicker *datePicer;
@property (nonatomic) CustomTextFieldType lwyType;


- (id)initWithFrame:(CGRect)frame
        placeholder:(NSString *) placeholder;
- (BOOL) validateTextFormat;
- (BOOL) textLengthEqualZero;
@end

@interface CSIICustomTextField (datePickerCreation)
- (NSDate *)getThreeMonthBeforeDate;
-(id) initDatePicerViewWithFrame:(CGRect) frame beginDate:(BOOL)isBegin;
-(id) initDatePicerViewWithFrame:(CGRect) frame;
+(BOOL)pickerChanged:(CSIICustomTextField*)BeginDate End:(CSIICustomTextField*)EndDate;//判断日期间隔三个月
+(BOOL)pickerChangedOne:(CSIICustomTextField*)BeginDate End:(CSIICustomTextField*)EndDate;//判断日期间隔一个月
-(id) initDatePicerViewWithFrame:(CGRect) frame CDate:(BOOL)isCDate;

-(void)reloadDataArray:(NSMutableArray*)array;

-(id) initOneMouthDatePicerViewWithFrame:(CGRect) frame beginDate:(BOOL)isBegin;
- (NSDate *)getOneMonthBeforeDate;
+ (NSDate *)getOneMonthBeforeDate;
-(id) initOneMonthEnDDatePicerViewWithFrame:(CGRect) frame;
@end



@interface CSIICustomTextField (pickerCreation)

-(id) initPicerViewWithFrame:(CGRect) frame picerDataArray:(NSMutableArray *) dataArray;

@end
