//
//  CSIIBusinessLogic.h
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-22.
//  Copyright (c) 2013年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSIIBusinessTransaction.h"
#import "CSIIConfigGlobalImport.h"
@interface CSIIBusinessLogic : NSObject<CSIITransaction>{
    NSMutableDictionary *runningTransactions;  //调用交易参数
}
@property (strong, nonatomic) NSMutableDictionary *runningTransactions;
+(CSIIBusinessLogic *)sharedInstance;
-(void)executeTransaction:(CSIIBusinessCaller*)caller;
-(void)executeTransaction:(CSIIBusinessCaller*)caller transactionBlock:(TransactionBlock)_transactionBlock;
+(BOOL)checkTransactionValue:(CSIIBusinessCaller*)caller;
-(void)cancelWithPage:(NSString*)pageId;
-(void)cancelWithTransaction:(NSString*)transactionId;
-(void)cancelAllTransaction;
+(NSString*)passwordErrorMsg:(NSString*)errorType;
+(NSString*)passwordErrorMessage:(NSString*)errorType;
+(BOOL)stringWithSting:(NSString *)srt;
@end
