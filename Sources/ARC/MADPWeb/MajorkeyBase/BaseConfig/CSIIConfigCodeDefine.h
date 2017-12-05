//
//  CSIIConfigCodeDefine.h
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-5-17.
//  Copyright (c) 2013年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#define Context [CSIIBusinessContext sharedInstance]

#define CurrentPageTransaction(kTransaction) [returnCaller.pageId isEqualToString:NSStringFromClass([self class])]&&[returnCaller.transactionId isEqualToString:kTransaction]

#define TransactionIsSuccess returnCaller.isSuccess
#define TransReturnInfo returnCaller.transactionResult

#define isEqualTextField(textField) returnCaller.textFieldHash == textField.hash

#define new_transaction_caller  CSIIBusinessCaller * caller = [[CSIIBusinessCaller alloc] init];\
                                caller.pageId = NSStringFromClass([self class]);\
                                caller.delegate = (id<CSIIBusinessCallerDelegate>)self;

#define execute_transaction_caller [[CSIIBusinessLogic sharedInstance]executeTransaction:caller];
#define execute_transaction_block_caller(block) [[CSIIBusinessLogic sharedInstance]executeTransaction:caller transactionBlock:block];



#define new_transaction(caller) CSIIBusinessCaller * caller = [[CSIIBusinessCaller alloc] init];\
                                caller.pageId = NSStringFromClass([self class]);\
                                caller.delegate = (id<CSIIBusinessCallerDelegate>)self;


#define execute_transaction(caller) [[CSIIBusinessLogic sharedInstance]executeTransaction:caller];
#define execute_transaction_block(caller,block) [[CSIIBusinessLogic sharedInstance]executeTransaction:caller transactionBlock:block];

#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name : NSObject @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end
/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

