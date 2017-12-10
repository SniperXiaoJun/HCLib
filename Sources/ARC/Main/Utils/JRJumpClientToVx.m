//
//  JRJumpClientToVx.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/4/7.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRJumpClientToVx.h"
#import "JRJumpTool.h"

@implementation JRJumpClientToVx
+ (void)jumpWithZipID:(NSString *)zipID controller:(UIViewController *)controller{
   
    [self jumpWithZipID:zipID controller:controller params:nil];
}


+ (void)jumpWithZipID:(NSString *)zipID controller:(UIViewController *)controller params:(NSDictionary *)params{

    
    NSMutableDictionary *params_app = [NSMutableDictionary dictionary];
    [params_app setObject:zipID forKey:@"id"];
    [params_app setObject:@"" forKey:@"wsid"];
    [JRSYHttpTool get:ZipInfo parameters:params_app success:^(id json) {
        DebugLog(@"Retrieval-json==%@",json);
        
        if (params)
        {
            NSMutableDictionary *currentDict = [NSMutableDictionary dictionaryWithDictionary:params];

            if ([params[@"applyNo"] length]>0) {
                [currentDict setObject:params[@"applyNo"] forKey:@"applyNo"];
            }

            NSMutableDictionary *dictRemix = [NSMutableDictionary dictionaryWithDictionary:json];

            [dictRemix setObject:currentDict forKey:PartCellInfo];


            [JRJumpTool jumpWithDictionary:dictRemix baseUrl:Singleton.baseUrl controller:controller];
        }
        else
        {
            [JRJumpTool jumpWithDictionary:json baseUrl:Singleton.baseUrl controller:controller];
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
