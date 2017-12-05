//
//  QRProduceCoder.h
//  CPQRFunction
//
//  Created by liurenpeng on 8/1/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum CPQRPointType{
    CPQRPointRect = 0,
    CPQRPointRound
};
enum CPQRPositionType{
    CPQRPositionNormal = 0,
    CPQRPositionRound
};

typedef void(^CPProduceResult)(UIImage* result,BOOL isSucceed);
@interface QRProduceCoder : NSObject
/*!
 * @property
 * @abstract 回调函数 返回二维码image
 * @discussion NULL
 * @result NULL
 */
@property (nonatomic ,strong)CPProduceResult productResult;
/*!
 * @property
 * @abstract 二维码颜色
 * @discussion NULL
 * @result NULL
 */
@property (nonatomic ,strong)UIColor *colorQRcode;
/*!
 * @property
 * @abstract 二维码像素
 * @discussion NULL
 * @result NULL
 */
@property (nonatomic ,assign)CGSize sizeQRcode;
@property (nonatomic ,assign)enum CPQRPointType qrPointType;
@property (nonatomic ,assign)enum CPQRPositionType qrPositionType;
/*!
 * @property
 * @abstract 二维码信息
 * @discussion NULL
 * @result NULL
 */
@property (nonatomic ,copy)NSString *qrInfo;
/*!
 * @method
 * @abstract 初始化方法
 * @discussion NULl
 * @param1 生成二维码的信息
 * @param2 回调block 返回image
 * @result NULL
 */
- (id)initWithInfo:(NSString *)info  withResult:(CPProduceResult)result;
/*!
 * @method
 * @abstract 生成二维码
 * @discussion NULL
 * @result NULL
 */
- (void)produceQRcode;
@end
