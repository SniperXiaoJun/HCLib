//
//  ViewController.h
//  TrustSignPDFTest
//
//  Created by WangLi on 2016/9/28.
//  Copyright © 2016年 CFCA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PDFCallBack)(NSString *isBack);

@interface JRSYPDFViewController : JRRootViewController

- (instancetype)initWithFilePath:(NSString *)filePath
                        fileName:(NSString *)fileName
                        pdfBlock:(PDFCallBack)pdfBlock
                          isSign:(NSInteger)isSign;



/*!
 * @property
 * @abstract 返回按钮
 */
@property (nonatomic, strong) CPUIBackButton* backButton;

@property (nonatomic, strong) UIButton* refreshButton;


@property (nonatomic, strong) PDFCallBack pdfCallBackBlock;

@property (nonatomic, copy) NSString *pdfUrlStr;
@end



