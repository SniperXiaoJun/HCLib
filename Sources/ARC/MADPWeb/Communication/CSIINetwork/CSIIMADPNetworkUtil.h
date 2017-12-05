//
//  CSIINetworkCheck.h
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 10-12-13.
//  Copyright 2010 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CSIIMADPReachability;
@interface CSIIMADPNetworkUtil : NSObject
{
    CSIIMADPReachability* hostReach;
    CSIIMADPReachability* internetReach;
//    CSIIReachability* wifiReach;
}
+ (CSIIMADPNetworkUtil *)sharedInstance;
+(BOOL)isExistenceNetwork;
-(void)listening;


-(void)updateImage:(NSString *)path withDic:(NSDictionary *)dic withImageView:(UIImage *)image withParams:(NSString *)Identitys;


@end
