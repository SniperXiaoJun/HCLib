//
//  JRSYImagePickerViewController.h
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/5/5.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRRootViewController.h"

@interface JRSYImagePickerViewController : JRRootViewController

@property (nonatomic, assign) NSInteger style;

@property (nonatomic,strong) NSDictionary *paramsUpload;

@property (nonatomic,copy) void (^uploadDone)(NSString *str);

@property (nonatomic,copy)  void (^HeightChangeBlock)(NSUInteger listCount,NSIndexPath *indexPath);
@property (nonatomic, copy) void(^SYCellTransmitInfoBlock) (NSDictionary *dataDict);



@end
