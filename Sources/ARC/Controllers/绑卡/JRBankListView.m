//
//  JRBankListView.m
//  CsiiMobileFinance
//
//  Created by 张平辉 on 2017/8/1.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRBankListView.h"

@interface JRBankListView ()
{
//    NSMutableArray *dataArray;
    UITableView *myTableView;
    NSMutableArray *bankArray;
    NSMutableArray *lastArray;
    
    NSDictionary *tempDict;
}
@end

@implementation JRBankListView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"limitList.json" ofType:@""];
    NSData *data = [NSData dataWithContentsOfFile:file];
    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
    bankArray = d[@"limitList"];
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    titLab.text = @"请选择银行";
    titLab.textColor = AllTextColorTit;
    titLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titLab];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(20, 5, 30, 30);
    [cancelBtn setImage:JRBundeImage(@"密码框_关闭@3x") forState:UIControlStateNormal];
//    cancelBtn.backgroundColor = [UIColor grayColor];
    [self addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, self.frame.size.width, 1)];
    line.backgroundColor = AllLineColor;
    [self addSubview:line];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(ScreenWidth - 20 - 50, 5, 50, 30);
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn setTitleColor:AllTextColorTit forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:AllTextFont];
    [self addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIPickerView *pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40)];
    // 显示选中框
    pickView.showsSelectionIndicator=YES;
    pickView.dataSource = self;
    pickView.delegate = self;
    [self addSubview:pickView];
    
    
}


- (void)cancelAction
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = ScreenHeight;
        self.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return ScreenWidth;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *dict = self.dataArray[row];
    
    tempDict = dict;
}


- (void)sureAction:(UIButton *)btn
{
    if (tempDict == nil)
    {
        tempDict = self.dataArray[0];
    }
    [self.delegate chooseBank:tempDict];
    [self cancelAction];
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    NSDictionary *dict = self.dataArray[row];
//    
//    NSString *ci;
//    NSString *ri;
//    NSString *lastStr;
//    for (NSDictionary *d in bankArray)
//    {
//        
//        if ([d[@"bankId"] isEqualToString:dict[@"BankId"]])
//        {
//            ci = [self handDataWithString:d[@"dealLimit"][@"aLimit"]];
//            ri = [self handDataWithString:d[@"dealLimit"][@"dayLimit"]];
//            
//            NSString *bank = dict[@"BankName"];
//            NSString *detail = [NSString stringWithFormat:@"(单笔限额:%@，日累积限额:%@)",ci, ri];
//            
//            NSString *returnStr = [NSString stringWithFormat:@"%@%@", bank, detail];
//            
//            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:returnStr attributes:nil];
//            
//            [attributedString addAttribute:NSForegroundColorAttributeName value:AllTextColorDetail range:NSMakeRange(bank.length + 1,(returnStr.length - bank.length - 1))];
//            
//            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AllTextFont] range:NSMakeRange(0,bank.length)];
//            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ScreenWidth==320?11:13] range:NSMakeRange(bank.length + 1,(returnStr.length - bank.length - 1))];
//            
//            lastStr = [attributedString string];
//        }
//    }
//    
//    return lastStr;
//}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50.0;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 50)];
    
    NSDictionary *dict = self.dataArray[row];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    leftLabel.text = dict[@"BankName"];
    leftLabel.textColor = AllTextColorTit;
    leftLabel.font = [UIFont systemFontOfSize:AllTextFont];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:leftLabel];
    
    
    NSString *ci;
    NSString *ri;
    for (NSDictionary *d in bankArray)
    {
        
        if ([d[@"bankId"] isEqualToString:dict[@"BankId"]])
        {
            ci = [self handDataWithString:d[@"dealLimit"][@"aLimit"]];
            ri = [self handDataWithString:d[@"dealLimit"][@"dayLimit"]];
            
            NSString *bank = dict[@"BankName"];
            NSString *detail = [NSString stringWithFormat:@"(单笔限额:%@，日累积限额:%@)",ci, ri];
            
            NSString *returnStr = [NSString stringWithFormat:@"%@%@", bank, detail];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:returnStr attributes:nil];
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:AllTextColorDetail range:NSMakeRange(bank.length,(returnStr.length - bank.length))];
            
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AllTextFont] range:NSMakeRange(0,bank.length)];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ScreenWidth==320?11:13] range:NSMakeRange(bank.length,(returnStr.length - bank.length))];
            
            leftLabel.attributedText = attributedString;
        }
    }
    
    
    return backView;
}

- (CGFloat)getWidthWithText:(NSString *)str
{
    UIFont *font = [UIFont systemFontOfSize:AllTextFont];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(ScreenWidth-40, 999)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:font}
                                    context:nil];
    return rect.size.width;
}

- (NSString *)handDataWithString:(NSString *)str
{
    NSString *moneyString = [NSString string];
    
    NSInteger length = str.length;
    
    if (length <= 3)
    {
        moneyString = [str stringByAppendingString:@"元"];
    }
    if (length == 4)
    {
        moneyString = [[str substringToIndex:1] stringByAppendingString:@"千元"];
    }
    if (length >= 5)
    {
        moneyString = [[str substringToIndex:length-4] stringByAppendingString:@"万元"];
    }
    return moneyString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    [self.delegate chooseBank:dict[@"BankName"]];
    [self cancelAction];
}

@end
