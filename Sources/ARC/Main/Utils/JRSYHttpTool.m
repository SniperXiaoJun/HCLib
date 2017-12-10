//
//  JRSYHttpTool.m
//  SYWeiBo
//
//  Created by Shen Yu on 15/10/27.
//  Copyright © 2015年 Shen Yu. All rights reserved.
//

#import "JRSYHttpTool.h"
#import "SYAFNetworking.h"
#import "SYAFHTTPRequestOperationManager.h"

@implementation JRSYHttpTool
    
+ (void)post:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void(^)(id json))success failure:(void(^)(NSError *error))failure{
    MaskShow
    
    DebugLog(@"\nInterface    %@\nMethod       POST     \nRequestData  ->->->->->\n%@",URLString,parameters);
    
    

    SYAFHTTPRequestOperationManager *mgr = [SYAFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [SYAFHTTPRequestSerializer serializer];
//    mgr.responseSerializer = [SYAFHTTPResponseSerializer serializer];
    
    [mgr.requestSerializer setValue:@"image/*" forHTTPHeaderField:@"Accept"];

    mgr.securityPolicy.allowInvalidCertificates = YES;

    
    if ([URLString hasPrefix:@"https"]) {
        [mgr.requestSerializer setValue:@"1" forHTTPHeaderField:@"USESSL"];
    }else{
        [mgr.requestSerializer setValue:@"0" forHTTPHeaderField:@"USESSL"];
    }
    mgr.requestSerializer=[SYAFJSONRequestSerializer serializer];
    // TODO: 超时时间 900
//    mgr.requestSerializer.timeoutInterval = 20.0f;

    NSString *remixStr = [URLString hasPrefix:@"http"] ?  URLString : [NSString stringWithFormat:@"%@%@",SERVER_URL,URLString];
    DebugLog(@"当前URL = %@", remixStr);
    
    //CSII客户端参数加密
    NSDictionary *transactionDict = [NSDictionary dictionary];
    transactionDict = [[LibAesSingle shareInstance] getTransactionEncryptDict:parameters currentUrl:remixStr];

    
    //因加密 parameters 替换为 transactionDict
    [mgr POSTONE:remixStr parameters:transactionDict success:^(SYAFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            // TODO:SHENYU 居然会话超时错误码 888888
            if ([[responseObject objectForKey:RETURNCODE] isEqualToString: SESSION_FAILED]) {
                // 会话超时
                Singleton.isLogin = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:Login_Out_Notification object:nil];
//                [[Routable sharedRouter] open:@"login" animated:YES];
                [JRPluginUtil needReLogin];;

                if (![[[Singleton.rootViewController viewControllers] lastObject] isKindOfClass:NSClassFromString(@"LoginViewController")]) {
//                    [[Routable sharedRouter] open:@"login" animated:YES];
                    [JRPluginUtil needReLogin];;

                }
                
            }
            
            if (![URLString hasPrefix:@"Timestamp"]) {
                MaskHide
            }
            
            DebugLog(@"\nInterface     %@     \nState         Succeeded\nResponseData  <-<-<-<-<-\n%@",URLString,responseObject);

            if (![URLString isEqualToString:Login_do] && ![URLString hasPrefix:@"RealNameAuth.do"]) {
                if (responseObject[@"_RejCode"]  && ![responseObject[@"_RejCode"] isEqualToString:@"000000"]) {
                    alertView(responseObject[@"jsonError"]);
                }
            }
            success(responseObject);

        }
    } failure:^(SYAFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            MaskHide
            DebugLog(@"\nInterface     %@     \nState         Error\nResponseData  <-<-<-<-<-\n%@",URLString,error);
            if (error.userInfo[@"NSLocalizedDescription"]) {
                alertView(error.userInfo[@"NSLocalizedDescription"]);
            }
            failure(error);
        }
    }];
}
+ (void)get:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void(^)(id json))success failure:(void(^)(NSError *error))failure{
    DebugLog(@"\nInterface    %@\nMethod       GET     \nRequestData  ->->->->->\n%@",URLString,parameters);

    SYAFHTTPRequestOperationManager *mgr = [SYAFHTTPRequestOperationManager manager];
    mgr.securityPolicy.allowInvalidCertificates = YES;


    if ([URLString hasPrefix:@"https"]) {
        [mgr.requestSerializer setValue:@"1" forHTTPHeaderField:@"USESSL"];
    }else{
        [mgr.requestSerializer setValue:@"0" forHTTPHeaderField:@"USESSL"];
    }
    
    NSString *remixStr = [URLString hasPrefix:@"http"] ?  URLString : [NSString stringWithFormat:@"%@%@",SERVER_URL,URLString];
    
    //CSII客户端参数加密
    NSDictionary *transactionDict = [NSDictionary dictionary];
    transactionDict = [[LibAesSingle shareInstance] getTransactionEncryptDict:parameters currentUrl:remixStr];

    
    //因加密 parameters 替换为 transactionDict
    [mgr GETONE:remixStr parameters:transactionDict success:^(SYAFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
//            DebugLog(@"\nInterface     %@     \nState         Succeeded\nResponseData  <-<-<-<-<-\n%@",URLString,responseObject);
            
            
            
            
            success(responseObject);
        }
    } failure:^(SYAFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            MaskHide
            //DebugLog(@"\nInterface     %@     \nState         Error\nResponseData  <-<-<-<-<-\n%@",URLString,error);
            if (error.userInfo[@"NSLocalizedDescription"]) {
                alertView(error.userInfo[@"NSLocalizedDescription"]);
            }
            failure(error);
        }
    }];
}
//    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];

//mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//如果报接受类型不一致请替换一致text/html或别的
//mgr.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型

+ (void)post_no_alert:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void(^)(id json))success failure:(void(^)(NSError *error))failure{
    MaskShow
    
    DebugLog(@"\nInterface    %@\nMethod       POST     \nRequestData  ->->->->->\n%@",URLString,parameters);
    
    SYAFHTTPRequestOperationManager *mgr = [SYAFHTTPRequestOperationManager manager]
    ;
    mgr.securityPolicy.allowInvalidCertificates = YES;

    mgr.requestSerializer = [SYAFHTTPRequestSerializer serializer];
    //    mgr.responseSerializer = [SYAFHTTPResponseSerializer serializer];
    
    if ([URLString hasPrefix:@"https"]) {
        [mgr.requestSerializer setValue:@"1" forHTTPHeaderField:@"USESSL"];
    }else{
        [mgr.requestSerializer setValue:@"0" forHTTPHeaderField:@"USESSL"];
    }
    mgr.requestSerializer=[SYAFJSONRequestSerializer serializer];
    // TODO: 超时时间 900
    //    mgr.requestSerializer.timeoutInterval = 20.0f;
    
    NSString *remixStr = [URLString hasPrefix:@"http"] ?  URLString : [NSString stringWithFormat:@"%@%@",SERVER_URL,URLString];
    
    //CSII客户端参数加密
    NSDictionary *transactionDict = [NSDictionary dictionary];
    transactionDict = [[LibAesSingle shareInstance] getTransactionEncryptDict:parameters currentUrl:remixStr];

    //因加密 parameters 替换为 transactionDict
    [mgr POSTONE:remixStr parameters:transactionDict success:^(SYAFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            if (![URLString hasPrefix:@"Timestamp"]) {
                MaskHide
            }
            DebugLog(@"\nInterface     %@     \nState         Succeeded\nResponseData  <-<-<-<-<-\n%@",URLString,responseObject);
            
            if ( responseObject[@"_RejCode"]  && ![responseObject[@"_RejCode"] isEqualToString:@"000000"]) {
                alertView(responseObject[@"jsonError"]);
            }
            success(responseObject);
            
        }
    } failure:^(SYAFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            MaskHide
            DebugLog(@"\nInterface     %@     \nState         Error\nResponseData  <-<-<-<-<-\n%@",URLString,error);
            if (error.userInfo[@"NSLocalizedDescription"]) {
                alertView(error.userInfo[@"NSLocalizedDescription"]);
            }
            failure(error);
        }
    }];
}

+(void)getFileContentFromServerActionName:(NSString *)actionName WithArgument:(NSDictionary *)argument onSuccessAnyObjectBlock:(void(^)(id result))onSuccessBlock onFailureBlock:(void(^)(NSError* error))onFailureBlock {
    
    
   
        SYAFHTTPRequestOperationManager *manager = [SYAFHTTPRequestOperationManager manager];
    //返回图片数据流NSData对象
//    manager.responseSerializer = [SYAFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/*", nil];
            manager.responseSerializer = [SYAFImageResponseSerializer serializer]; //接收只处理NSData image数据流, 并可返回UIImage
    
//        [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    
        manager.securityPolicy.allowInvalidCertificates = YES;
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *remixStr = [actionName hasPrefix:@"http"] ?  actionName : [NSString stringWithFormat:@"%@%@",SERVER_URL,actionName];

        //GET方式
        [manager GETONE:remixStr parameters:nil success:^(SYAFHTTPRequestOperation *operation, id responseObject) {
    
//            DebugLog(@"响应头:\n%@",operation.response);//打印响应头内容
    
//            DebugLog(@"\n <====收到响应 \n actionName: %@ \n resultString : %@",actionName,[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
    
            if ([manager.responseSerializer isKindOfClass:[SYAFImageResponseSerializer class]]) {
                // responseObject 为UIImage
                UIImage *image = responseObject;
                onSuccessBlock(image);
            }else{
                // responseObject 为NSData
                id result = nil;
    
                id jsonObject = nil;
                if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
                    jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                }
    
                if (jsonObject==nil && operation.responseString) {
                    //交易成功，结果为普通字符串
                    result = operation.responseString; //回传NSString类型数据
    
                }else if (jsonObject==nil && operation.responseData) {
                    //交易成功，结果为数据流，例如Image图片流, 文件内容
                    result = operation.responseData; //回传NSData类型数据
                }
    
                if(onSuccessBlock){
                    onSuccessBlock(result);  //一定要回传
                }
            }
    
        } failure:^(SYAFHTTPRequestOperation *operation, NSError *error) {
            
            DebugLog(@"----err:%@",error);
            if(onFailureBlock){
                onFailureBlock(error);
            }
        
        }];
}




@end

