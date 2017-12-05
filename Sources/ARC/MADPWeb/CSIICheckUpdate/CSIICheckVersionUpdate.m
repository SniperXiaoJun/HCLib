//
//  CSIICheckVersionUpdate.m
//  CSIIPlatformLib
//
//  Created by liurenpeng on 10/20/15.
//  Copyright © 2015 刘任朋. All rights reserved.
//

#import "CSIICheckVersionUpdate.h"
#import "CSIIDownLoadUtility.h"
#import "CSIIMADPAFHTTPClient.h"
#import "CSIIMADPNetworkUtil.h"
#import "CSIIMADPAFHTTPRequestOperation.h"
#import "CPCacheUtility.h"
#import "CSIIBusinessContext.h"
@interface CSIICheckVersionUpdate () <UIAlertViewDelegate> {
    NSMutableArray* operationArr;
    CSIIMADPAFHTTPClient* httpclient;
    NSString* path;
    NSDictionary* versionInfo;
}

@end
@implementation CSIICheckVersionUpdate
@synthesize checkCallBack;
- (void)checkAppVersion:(NSString*)url
              withParam:(NSMutableDictionary*)params
            checkFinish:
                (void (^)(id responsdata, BOOL success))responsCallBackBlock;
{
    self.checkCallBack = responsCallBackBlock;
    [self checkVerion:^(id respondData) {

    if ([CSIIMADPNetworkUtil isExistenceNetwork]){
        NSArray* arr =[[CPCacheUtility sharedInstance] getTamperFileArr];
        [params setObject:arr forKey:@"LocalZipList"];

        DebugLog(@"versionParms:%@", params);
        httpclient =
            [[CSIIMADPAFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
        httpclient.parameterEncoding = AFCSIIMADPJSONParameterEncoding;
        [self addHTTPRequestHeader];
        path = [NSString
            stringWithFormat:@"%@/%@", [CSIIBusinessContext sharedInstance].serverPath, @"ClientVersionQry.do"];

        NSURLRequest* request =
            [httpclient requestWithMethod:@"POST"
                                     path:path
                               parameters:params];
        CSIIMADPAFHTTPRequestOperation* operation =
            [httpclient HTTPRequestOperationWithRequest:request
                success:^(__unused CSIIMADPAFHTTPRequestOperation* operation, id JSON) {
                    NSDictionary* responDic = [NSJSONSerialization
                        JSONObjectWithData:operation.responseData
                                   options:NSJSONReadingMutableContainers
                                     error:nil];
                    DebugLog(@"BasicMessage success!%@", responDic);
                    __weak typeof(self) weakself = self;
                    versionInfo = responDic;
                    
                    if ([[versionInfo objectForKey:@"ClientUpdate"] intValue]==0) {
                        
                        if ([[versionInfo objectForKey:@"ForceUpdate"] intValue]==0) {
                            //TODO: 先注释强制更新，以后修改，暂时注释
                            //强制
//                        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"更新提示" message:[versionInfo objectForKey:@"HintMessage"] delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil, nil];
//                            
//                            alert.tag=1001;
//
//                            [alert show];
                        }else {
                            NSString * str=[versionInfo objectForKey:@"HintMessage"];
                            DebugLog(@"-----%@",str);
                            if ([str isKindOfClass:[NSNull class]]){
                                str=@"请更新客户端";
                            }else
                                str=[versionInfo objectForKey:@"HintMessage"];

                            //非强制
                            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"更新提示" message:str delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"稍后更新", nil];
                            alert.tag=1002;
                            [alert show];
                        }
                        
                        
                    }else {
                        
                        [weakself downLoadZip];

                    
                    }
                }
                failure:^(__unused CSIIMADPAFHTTPRequestOperation* operation,
                            NSError* error) {

                    
                    NSString * str=[error.userInfo objectForKey:@"NSLocalizedDescription"];
                    
                    ShowAlertView(@"温馨提示",str,self, @"确定", nil);

                    DebugLog(@"BasicMessage Error!%@:", error);

                    responsCallBackBlock(error, NO);
                }];

        [httpclient setAllowsInvalidSSLCertificate:SERVER_CHECKSSL];
        [httpclient enqueueHTTPRequestOperation:operation];
        
        
            
    }else{
        if ((((long)[[NSDate date] timeIntervalSince1970]) -
             Context.currentTime) > NETWORKERROR_TIME) {
            Context.currentTime = ((long)[[NSDate date] timeIntervalSince1970]);
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"网络连接失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        // 网络不通提示信息
//            Context.isLoginFlag = NO;
//            [[NSNotificationCenter defaultCenter] postNotificationName:logout
//                                                                object:nil];
        }
    }
    }];

}


- (void)checkVerion:(void (^)(id respondData))respondBlock;
{
    [[CPCacheUtility sharedInstance] checkWithZipIntegrity:respondBlock];
}

- (void)addHTTPRequestHeader
{
    NSMutableDictionary* httpHeader =
        [NSMutableDictionary dictionaryWithDictionary:@{
            @"Accept-Language" : @"zh-CN,zh;q=0.8",
            @"Content-Type" : @"application/json; charset=utf-8",
            @"Connection" : @"Keep-Alive",
            @"Accept" : @"text/xml,application/json"
        }];
    for (NSString* key in [httpHeader keyEnumerator]) {
        [httpclient setDefaultHeader:key value:[httpHeader objectForKey:key]];
    }
}

- (void)cancel
{
    [httpclient cancelAllHTTPOperationsWithMethod:@"POST" path:path];
}
- (void)downLoadZip
{
    NSArray* arr = [NSArray arrayWithArray:versionInfo[@"ZipList"]];
    NSMutableArray* updateArr = [NSMutableArray array];
    for (NSDictionary* dic in arr) {
        if ([dic[@"ZipUpdate"] isEqualToString:@"0"]) {
            [updateArr addObject:dic];
        }
    }
    if (updateArr.count == 0 || !updateArr) {
//        [self requestMenu];
        return;
    }

    CSIIDownLoadUtility* download =
    [[CSIIDownLoadUtility alloc] initWithFrame:[UIScreen mainScreen].bounds];
    __weak typeof(self) weakself = self;
    
    [download downLoadWithList:updateArr
                downLoadFinish:^(id responsdata, BOOL success) {
                    
                    [weakself showAlertViewWtihCheckResult:success];
                }];

    [[UIApplication sharedApplication].keyWindow addSubview:download];

}

- (void)showAlertViewWtihCheckResult:(BOOL)statues
{
    if (statues) {
        
//        [self requestMenu];

        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"更新完成"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        alert.tag = 100;
        [alert show];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"更新失败"
                                                       delegate:self
                                              cancelButtonTitle:@"退出"
                                              otherButtonTitles:@"重试", nil];
        alert.tag = 101;
        [alert show];
    }
}

- (void)alertView:(UIAlertView*)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {

//        [self requestMenu];
    }
    else if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            self.checkCallBack(versionInfo, NO);
            exit(0);
        }
        else {
            [self downLoadZip];
        }
    }else if (alertView.tag == 1001) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[versionInfo objectForKey:@"ClientVersionURL"]]];

    }else if (alertView.tag == 1002) {
        
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[versionInfo objectForKey:@"ClientVersionURL"]]];
        }
        else {
            [self downLoadZip];
        }

    }
}
- (void)requestMenu
{
    new_transaction_caller
        caller.transactionId = @"GetMenuData.do"; //交易名
    caller.webMethod = POST; // POST  GET
    caller.responsType = ResponsTypeOfJson; //返回数据处理
    execute_transaction_block_caller(^(CSIIBusinessCaller* returnCaller) {
        if (TransactionIsSuccess) {
            
        if ([[returnCaller.transactionResult  objectForKey:@"_RejCode"] isEqualToString:@"000000"] ) {

            NSError* parseError = nil;
            NSData* jsonData =
                [NSJSONSerialization dataWithJSONObject:returnCaller.transactionResult
                                                options:NSJSONWritingPrettyPrinted
                                                  error:&parseError];

            NSString* str = [[NSString alloc] initWithData:jsonData
                                                  encoding:NSUTF8StringEncoding];
            DebugLog(@"returnCaller.transactionResult=-------%@",
                str);
            [[CPCacheUtility sharedInstance] saveDisplayMenuToSql:str];
            self.checkCallBack(versionInfo, YES);
        }else{
        
            NSArray *jsonErrorArray =[returnCaller.transactionResult  objectForKey:@"jsonError"];
            ShowAlertView(@"温馨提示", [[jsonErrorArray firstObject] objectForKey:@"_exceptionMessage"], self, @"确定", nil);
            }
        }
        else {
//        if ([[returnCaller.transactionResult  objectForKey:@"_RejCode"] isEqualToString:@"999999"] ) {
                NSArray *jsonErrorArray =[returnCaller.transactionResult  objectForKey:@"jsonError"];
                    ShowAlertView(@"温馨提示", [[jsonErrorArray firstObject] objectForKey:@"_exceptionMessage"], self, @"确定", nil);
//            }

            NSAssert1(0, @"%@", @"菜单下载失败");
            exit(0);
        }
    });
}
@end
