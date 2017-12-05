//
//  CSIIUIPickerViewObject.h
//  iPhoneTZBankClient
//
//  Created by 刘旺 on 12-5-31.
//  Copyright (c) 2012年 科蓝公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
@interface CSIIUIPickerViewObject : UIView {
    @private
	CALayer *titleLabelLayer;
    UILabel *titleLabel;
    BOOL isRun;
}
@property (nonatomic,assign) BOOL isRun;
@property (nonatomic,retain) CALayer *titleLabelLayer;
@property (nonatomic,retain) UILabel *titleLabel;
-(id)initWithTitle:(NSString*)titleStr;
-(void)startAnimation;
-(void)endAnimation;
@end
