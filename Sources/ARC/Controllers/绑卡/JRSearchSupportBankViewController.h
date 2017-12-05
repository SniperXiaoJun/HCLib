//
//  JRSearchSupportBankViewController.h
//  CsiiMobileFinance
//
//  Created by 张平辉 on 2017/7/25.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseBankDelegate <NSObject>
- (void)chooseBank:(NSString *)bankName;
@end

@interface JRSearchSupportBankViewController : JRRootViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) id<ChooseBankDelegate> delegate;
@end
