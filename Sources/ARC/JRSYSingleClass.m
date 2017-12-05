//
//  JRSYSingleClass.m
//  ProductInfoFlow
//
//  Created by Shen Yu on 16/4/6.
//  Copyright © 2016年 Shen Yu. All rights reserved.
//

#import "JRSYSingleClass.h"

@implementation JRSYSingleClass
+ (instancetype)shareInstance{
    static JRSYSingleClass *instances = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instances = [[JRSYSingleClass alloc] init];
        instances.navigationDC = [[NSMutableDictionary alloc] initWithCapacity:0];
    });
    return instances;
}
//    params.put("LoginType", "T");
//    params.put("_locale", "zh_CN");
- (NSDictionary *)publicParamsDict{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"zh_CN",@"_locale",@"99999",@"BankId",@"IOS",@"ChannelId",
            nil];
}

-(void)removeAllPic{
    NSString *extension = @"png";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSEnumerator *enumerator = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [enumerator nextObject])) {
        if ([[filename pathExtension] isEqualToString:extension]) {
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:nil];
        }  
    }
}
@end
