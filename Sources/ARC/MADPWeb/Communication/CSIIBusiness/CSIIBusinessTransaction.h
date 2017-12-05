//
//  CSIIBusinessTransaction.h
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-22.
//  Copyright (c) 2013年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSIIMADPNetworkHttpClient.h"

@protocol CSIITransaction;
@interface CSIIBusinessTransaction : NSObject {
@private
    CSIIMADPNetworkHttpClient *client;
    NSDictionary *resultObject;
    NSError *error;
    
#if __has_feature(objc_arc_weak)
    __weak id<CSIITransaction> delegate;
#else
	__unsafe_unretained id<CSIITransaction> delegate;
#endif
    
    CSIIBusinessCaller *caller;
    BOOL isJumpToFailurePage;
    BOOL isTransmissionError;
    Class originalClass;
}

#if __has_feature(objc_arc_weak)
@property (nonatomic, weak) id<CSIITransaction> delegate;
#else
@property (nonatomic, unsafe_unretained) id<CSIITransaction> delegate;
#endif

@property (nonatomic, strong) NSDictionary *resultObject;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) CSIIBusinessCaller *caller;
@property (nonatomic,assign) Class originalClass;
@property BOOL isJumpToFailurePage;
@property BOOL isTransmissionError;
- (id)initWithTransaction:(id)_delegate caller:(CSIIBusinessCaller*)_caller;
- (void)cancel;
@end

@protocol CSIITransaction<NSObject>
@required
- (void)transactionSucceeded:(CSIIBusinessTransaction*)transaction;
- (void)transactionFailed:(CSIIBusinessTransaction *)transaction;
@end
