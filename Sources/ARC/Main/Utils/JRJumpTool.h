//
//  JRJumpTool.h
//  CsiiMobileFinance
//
//  Created by ShenYu on 2016/12/5.
//  Copyright © 2016年 Shen Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRJumpTool : NSObject
+ (void)jumpWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller;
@end
