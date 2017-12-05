//
//  PDFViewController.h
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/5/8.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFViewController : JRRootViewController

/*!
 * @property
 * @abstract 返回按钮
 */
@property (nonatomic, strong) CPUIBackButton* backButton;

@property (nonatomic,strong) NSString *Url;


@end
