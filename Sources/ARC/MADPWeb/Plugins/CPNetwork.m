//
//  CPNetwork.m
//  CSIIPlatformLib
//
//  Created by liurenpeng on 7/15/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CPNetwork.h"
#import "CSIIBusinessContext.h"

@implementation CPNetwork
- (void)RequestGetForString {
    
    // by liangsuhua 2017.1.4
    NSString *action2 = self.curData[@"data"][@"Params"][@"Url"];
    action2 = [action2 lastPathComponent];
//    [[CSIIBusinessContext sharedInstance] adjustServerUrlWithTransactionId:action2];
    
    
    if ([CSIIMADPNetworkUtil isExistenceNetwork]){
        
        NSString *action = self.curData[@"data"][@"Params"][@"Url"];
        action = [action lastPathComponent];
        DebugLog(@"%@", action);
        new_transaction_caller caller.transactionId = action;
        caller.transactionArgument = [self returnDictionary:[self.curData objectForKey:@"Params"]];; //上传参数
        caller.webMethod = GET;
        caller.isShowActivityIndicator=NO;
        caller.responsType = ResponsTypeOfWeb;
        execute_transaction_block_caller(^(CSIIBusinessCaller *returnCaller) {
            if (TransactionIsSuccess) {
                
                if (returnCaller.transactionResult) {
                    [self managerRequsetData:returnCaller.transactionResult isSuccess:YES];
                    
                }else
                    [self managerRequsetData:returnCaller.webData isSuccess:YES];
                
                
                
            }else {
                
                if (returnCaller.transactionResult) {
                    [self managerRequsetData:returnCaller.transactionResult isSuccess:YES];
                }else
                    [self managerRequsetData:returnCaller.error isSuccess:YES];
                
            }
            
        });
    }else{
        
        [self managerRequsetData:@"网络连接失败，请您检查网络" isSuccess:NO];
        
        
    }
}
- (void)RequestPostForString {
    
    // by liangsuhua 2017.1.4
    NSString *action2 = self.curData[@"data"][@"Params"][@"Url"];
    action2 = [action2 lastPathComponent];
//    [[CSIIBusinessContext sharedInstance] adjustServerUrlWithTransactionId:action2];
    
    
    if ([CSIIMADPNetworkUtil isExistenceNetwork]){
        NSString *action = self.curData[@"data"][@"Params"][@"Url"];
        DebugLog(@"%@", self.curData);
        action = [action lastPathComponent];
        
        
        new_transaction_caller caller.transactionId = action;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]
                                    initWithDictionary:[(NSMutableDictionary *)self.curData
                                                        objectForKey:@"data"]];
//        caller.transactionArgument = [[dic objectForKey:@"Params"]
//                                      objectForKey:@"Params"]; //上传参数

        NSMutableDictionary *sendParams = [[dic objectForKey:@"Params"]
                                           objectForKey:@"Params"];

        [sendParams addEntriesFromDictionary:Singleton.publicParamsDict];

        caller.transactionArgument = [NSMutableDictionary dictionaryWithDictionary:sendParams];

        caller.webMethod = POST;
        caller.isShowActivityIndicator=NO;
        
        caller.responsType = ResponsTypeOfWeb;
        execute_transaction_block_caller(^(CSIIBusinessCaller *returnCaller) {
            if (TransactionIsSuccess) {
//                DebugLog(@"----%@", returnCaller.transactionResult);
                
                if (returnCaller.transactionResult) {
                    [self managerRequsetData:returnCaller.transactionResult isSuccess:YES];
                    
                }else
                    [self managerRequsetData:returnCaller.webData isSuccess:YES];
            }else{
                if (returnCaller.transactionResult) {
                    [self managerRequsetData:returnCaller.transactionResult isSuccess:YES];
                    
                }else
                    [self managerRequsetData:returnCaller.error isSuccess:YES];
                
            }
            
        });
    }else{
        [self managerRequsetData:@"网络连接失败，请您检查网络" isSuccess:NO];
    }
    
}

- (void)RequestImageForDownload {
    DebugLog(@"%@", self.curData);
    
    NSString *action = self.curData[@"data"][@"Params"][@"Url"];
    action = [action lastPathComponent];
    new_transaction_caller caller.transactionId = action;
    caller.transactionArgument = [self returnDictionary:[self.curData objectForKey:@"Params"]]; //上传参数
    caller.webMethod = POST;
    caller.isShowActivityIndicator=NO;
    
    caller.responsType = ResponsTypeOfImageData;
    execute_transaction_block_caller(^(CSIIBusinessCaller *returnCaller) {
        if (TransactionIsSuccess) {
            // [self managerRequsetData:returnCaller.webData isSuccess:YES];
        }
        
    });
}
- (void)RequestImageForUpload {
    DebugLog(@"%@", self.curData);
    
    NSString *action = self.curData[@"data"][@"Params"][@"Url"];
    action = [action lastPathComponent];
    new_transaction_caller caller.transactionId = action;
    caller.webMethod = POST;
    caller.responsType = ResponsTypeOfImageData;
    execute_transaction_block_caller(^(CSIIBusinessCaller *returnCaller) {
        if (TransactionIsSuccess) {
            self.pluginResponseCallback(returnCaller.webData);
        }
        
    });
}

#pragma mark - 处理返回结果
- (void)managerRequsetData:(id)data isSuccess:(BOOL)success;
{
//    DebugLog(@"%@", data);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (success) {
        if (data != nil) {
            [dic setObject:@"200" forKey:@"status"];
            [dic setObject:data forKey:@"data"];
        } else {
            [dic setObject:@"0" forKey:@"status"];
            [dic setObject:@"" forKey:@"data"];
        }
    }else{
        
        [dic setObject:@"0" forKey:@"status"];
        [dic setObject:@"网络连接失败，请您检查网络" forKey:@"data"];
        
        
    }
    if (self.pluginResponseCallback) {
        self.pluginResponseCallback(dic);
    }
}
- (NSString *)stringEscape:(NSString *)string {
    NSMutableString *tempString = [[NSMutableString alloc] init];
    unsigned int tempChar; //这里注意
    for (int i = 0; i < [string length]; i++) {
        tempChar = [string characterAtIndex:i];
        if ((tempChar <= 'z' && tempChar >= 'a') ||
            (tempChar <= 'Z' && tempChar >= 'A') ||
            (tempChar <= '9' && tempChar >= '0')) {
            [tempString appendFormat:@"%c", tempChar];
        } else if (tempChar < 256) {
            [tempString appendString:@"%"];
            if (tempChar < 16) {
                [tempString appendString:@"0"];
            }
            [tempString appendFormat:@"%x", tempChar];
            
        } else {
            [tempString appendString:@"%u"];
            
            [tempString appendFormat:@"%x", tempChar];
        }
    }
    return tempString;
}
- (NSMutableDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *responseJSON =
    [NSJSONSerialization JSONObjectWithData:JSONData
                                    options:NSJSONReadingMutableLeaves
                                      error:nil];
    responseJSON = [self returnDictionary:responseJSON];
    
    return responseJSON;
}
- (NSMutableDictionary *)returnDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *reDic= [NSMutableDictionary dictionaryWithDictionary:[dic copy]];
    NSArray *array = dic.allKeys;
    for (NSString * key in array) {
        if (reDic[key]&&([reDic[key] isKindOfClass:[NSDictionary class]]||[reDic[key] isKindOfClass:[NSArray class]])) {
            
        }else{
            reDic[key] = [reDic[key] description];
        }
    }
    return reDic;
}
@end
