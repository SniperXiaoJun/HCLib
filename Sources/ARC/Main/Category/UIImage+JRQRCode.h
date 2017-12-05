//
//  UIImage+JRQRCode.h
//  QRCodeDemo
//
//  Created by GongHui_YJ on 16/6/7.
//  Copyright © 2016年 YangJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JRQRCode)

#pragma mark - 生成二维码
//Avilable in iOS 7.0 and later
+ (UIImage *)qrCodeImageWithContent:(NSString *)content
                      codeImageSize:(CGFloat)size
                               logo:(UIImage *)logo
                          logoFrame:(CGRect)logoFrame
                                red:(CGFloat)red
                              green:(CGFloat)green
                               blue:(NSInteger)blue;


#pragma mark - 生成条形码
//Avilable in iOS 8.0 and later
+ (UIImage *)barcodeImageWithContent:(NSString *)content
                       codeImageSize:(CGSize)size
                                 red:(CGFloat)red
                               green:(CGFloat)green
                                blue:(NSInteger)blue;

@end
