//
//  CSIINetWorkTestRequest.h
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 11-7-27.
//  Copyright (c) 2011年 北京科蓝软件系统股份有限公司. All rights reserved.
//
#import <Foundation/Foundation.h>
@class CSIIMADPAFHTTPClient;
@class CSIIBusinessCaller;
typedef void(^OnSuccessBlock)(NSString* string,NSMutableDictionary* info);
typedef void(^OnFailureBlock)(NSError* error,NSMutableDictionary *info);

@interface CSIIMADPNetworkHttpClient : NSObject {
    CSIIMADPAFHTTPClient *httpclient;
    NSString *httpMethod;
    NSString *path;
    NSMutableDictionary *callerHttpHeader;
}

-(id)initWithTransaction:(CSIIBusinessCaller*)caller onSuccessBlock:(OnSuccessBlock)onSuccessBlock onFailureBlock:(OnFailureBlock)onFailureBlock;
-(id)initWithTransaction:(NSString*)transaction message:(NSDictionary*)message caller:(CSIIBusinessCaller*)caller argument:(NSDictionary*)argument onSuccessBlock:(OnSuccessBlock)onSuccessBlock onFailureBlock:(OnFailureBlock)onFailureBlock;

-(id)initWithTransactionforImage:(CSIIBusinessCaller*)caller onSuccessBlock:(OnSuccessBlock)onSuccessBlock onFailureBlock:(OnFailureBlock)onFailureBlock;

-(void)cancel;
+ (NSString*)getURIWithTransaction:(NSString*)transactionId argument:(NSDictionary*)argument;
+ (NSString*)getURLStringWithTransaction:(NSString*)transactionId argument:(NSDictionary*)argument;

@end
