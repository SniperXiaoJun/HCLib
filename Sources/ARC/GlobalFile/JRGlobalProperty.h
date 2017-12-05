//
//  JRGlobalProperty.h
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/6/7.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#ifndef JRGlobalProperty_h
#define JRGlobalProperty_h

// 字体字号规范
#define kLabelFont      [UIFont systemFontOfSize:17]  // 普通label字体
#define kSubmitBtnFont  [UIFont systemFontOfSize:16]  // 提交按钮 字体

#define kCommonCellH            52                    // 列表高度
#define kSubmitBtnH             41                    // 提交按钮高度



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


#endif /* JRGlobalProperty_h */
