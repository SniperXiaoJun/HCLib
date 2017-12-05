//
//  CPConfigGlobalDefine.h
//  CPBaseManager
//
//  Created by 刘任朋 on 15/11/5.
//  Copyright © 2015年 刘认朋. All rights reserved.
//
#define Context [CSIIBusinessContext sharedInstance]

#define ShowAlertView(T,M,D,BT,OBT) UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:T message:M delegate:D cancelButtonTitle:BT otherButtonTitles:OBT, nil];[alertView show];

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width


/*
//UI图根据375*667计算
#define DeviceWidth 375
#define DeviceHeight 667
#define DeviceLineWidth 1

#define DeviceScaleX (ScreenWidth/DeviceWidth)
#define DeviceScaleY (ScreenHeight/DeviceHeight)

//frame换算比例
#define ScaleFrame(A,B,C,D) CGRectMake((A)*DeviceScaleX, (B)*DeviceScaleX, (C)*DeviceScaleX, (D)*(DeviceScaleX<1?DeviceScaleX*1:DeviceScaleX))
//字体换算
#define DeviceFont(font) [UIFont systemFontOfSize:(font)*(DeviceScaleX>1?DeviceScaleX*0.94:(DeviceScaleX==1?DeviceScaleX:DeviceScaleX*1))]
#define DeviceBoldFont(font) [UIFont boldSystemFontOfSize:(font)*(DeviceScaleX>1?DeviceScaleX*0.94:(DeviceScaleX==1?DeviceScaleX:DeviceScaleX*1))]


#define JRBundeImage(imgName) [UIImage imageNamed:imgName inbundle:@"JRBundle.bundle" withPath:@""]

#define DeviceTextNormalColor RGB_COLOR(34,34,34)
*/


#define CELL_TEXTLABEL_FONT [UIFont systemFontOfSize:14]

#define CELL_STYLE cell.selectionStyle = UITableViewCellSelectionStyleNone; cell = [CSIIUIUtil cellText:cell];

// 交易页面顶部页面进度跟中展示字体设置

#define ADD_HEIGHT IOS7_OR_LATER


/***********************************************************************/

#define DOCUMENT_FOLDER(fileName) [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:fileName]
#define LIBRARY_FOLDER(fileName) [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]stringByAppendingPathComponent:fileName]
#define CACHE_FOLDER(fileName) [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Web/%@",fileName] ofType:@""]

#define APPLICATIONFRAME [[UIScreen mainScreen] applicationFrame]
#define BOUNDS [[UIScreen mainScreen] bounds]



#define IPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONE4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONE6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define IMAGE_TYPE [UIScreen mainScreen].scale==3 ? @"@3x" :([UIScreen mainScreen].scale==2? @"@2x" :@"" )

#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] intValue] >= 7)


#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] intValue] >= 8)





