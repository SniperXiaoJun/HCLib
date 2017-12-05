//
//  LibAesSingle.h
//  CsiiMobileFinance
//
//  Created by 何崇 on 2017/10/18.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibAesSingle : NSObject

+ (instancetype)shareInstance;

//获取加密字典（go服务不加密，其余加密）
- (NSDictionary *)getTransactionEncryptDict:(NSDictionary *)sendDict currentUrl:(NSString *)url;
@end
