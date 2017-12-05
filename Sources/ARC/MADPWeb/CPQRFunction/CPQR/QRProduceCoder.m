//
//  QRProduceCoder.m
//  CPQRFunction
//
//  Created by liurenpeng on 8/1/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "QRProduceCoder.h"
#import "QRCodeGenerator.h"
@implementation QRProduceCoder
@synthesize productResult;
@synthesize colorQRcode;
@synthesize sizeQRcode;
@synthesize qrPositionType;
@synthesize qrPointType;
@synthesize qrInfo;
- (id)initWithInfo:(NSString*)info withResult:(CPProduceResult)result;
{
    self = [super init];
    if (self) {
        self.qrInfo = info;
        self.productResult = result;
        self.colorQRcode = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        self.sizeQRcode = CGSizeMake(200, 200);
        self.qrPointType = CPQRPointRect;
        self.qrPositionType = CPQRPositionNormal;
    }
    return self;
}
- (void)produceQRcode
{

    if (self.qrInfo.length == 0 || self.qrInfo == nil) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"生成二维码信息不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    QRPointType pointType = QRPointRect;
    QRPositionType positionType = QRPositionNormal;
    switch (self.qrPointType) {
    case CPQRPointRect: {
        pointType = QRPointRect;
    } break;
    case CPQRPointRound: {
        pointType = QRPointRound;
    } break;

    default:
        break;
    }
    switch (self.qrPositionType) {
    case CPQRPositionNormal: {
        positionType = QRPositionNormal;
    } break;
    case CPQRPositionRound: {
        positionType = QRPositionRound;
    } break;

    default:
        break;
    }

    UIImage* codeImage = [QRCodeGenerator qrImageForString:self.qrInfo imageSize:self.sizeQRcode.width withPointType:pointType withPositionType:positionType withColor:self.colorQRcode];
    if (codeImage) {
        self.productResult(codeImage, YES);
    }
}
@end
