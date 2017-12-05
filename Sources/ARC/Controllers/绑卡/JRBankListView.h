//
//  JRBankListView.h
//  CsiiMobileFinance
//
//  Created by 张平辉 on 2017/8/1.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseBankViewDelegate <NSObject>
- (void)chooseBank:(NSDictionary *)dict;
@end

@interface JRBankListView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) id<ChooseBankViewDelegate> delegate;

@end
