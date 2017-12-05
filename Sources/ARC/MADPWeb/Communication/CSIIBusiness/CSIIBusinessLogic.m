//
//  CSIIBusinessLogic.m
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-22.
//  Copyright (c) 2013年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import "CSIIBusinessLogic.h"
#import <objc/runtime.h>
#import "CPUIActivityIndicator.h"

@implementation CSIIBusinessLogic
@synthesize runningTransactions;
static CSIIBusinessLogic *_sharedInstance;
- (id)init {
  self = [super init];
  if (self) {
    self.runningTransactions = [[NSMutableDictionary alloc] init];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(cancelTransaction:)
               name:@"kCancelTransaction"
             object:nil];
  }
  return self;
}
- (void)cancelWithPage:(NSString *)pageId;
{
  NSMutableArray *pageRunningTransactions =
      [self.runningTransactions objectForKey:pageId];
  if (pageRunningTransactions &&
      [pageRunningTransactions isKindOfClass:[NSArray class]]) {
    for (int i = 0; i < [pageRunningTransactions count]; i++) {
      if (((CSIIBusinessTransaction *)[pageRunningTransactions objectAtIndex:i])
              .caller.isCanCancel) {
        [((CSIIBusinessTransaction *)[pageRunningTransactions objectAtIndex:i])
                cancel];
        [pageRunningTransactions removeObjectAtIndex:i];
        //隐藏转轮
          [[CPUIActivityIndicator sharedInstance] hidden];
      }
    }
    if ([pageRunningTransactions count] == 0) {
      [self.runningTransactions removeObjectForKey:pageId];
    }
  }
}
- (void)cancelWithTransaction:(NSString *)transactionId;
{
  NSArray *keyArray = [self.runningTransactions allKeys];
  for (int j = 0; j < [keyArray count]; j++) {
    NSMutableArray *pageRunningTransactions =
        [self.runningTransactions objectForKey:[keyArray objectAtIndex:j]];
    for (int i = 0; i < [pageRunningTransactions count]; i++) {
      if ([((CSIIBusinessTransaction *)
                [pageRunningTransactions objectAtIndex:i])
                  .caller.transactionId isEqualToString:transactionId]) {
        [((CSIIBusinessTransaction *)[pageRunningTransactions objectAtIndex:i])
                cancel];
        [pageRunningTransactions removeObjectAtIndex:i];
        //隐藏转轮
          [[CPUIActivityIndicator sharedInstance] hidden];
        break;
      }
    }
    if ([pageRunningTransactions count] == 0) {
      [self.runningTransactions removeObjectForKey:[keyArray objectAtIndex:j]];
    }
  }
}
- (void)cancelTransaction:(NSNotification *)notification;
{
  NSArray *keyArray = [self.runningTransactions allKeys];
  for (int j = 0; j < [keyArray count]; j++) {
    NSMutableArray *pageRunningTransactions =
        [self.runningTransactions objectForKey:[keyArray objectAtIndex:j]];
    for (int i = 0; i < [pageRunningTransactions count]; i++) {
      if (((CSIIBusinessTransaction *)[pageRunningTransactions objectAtIndex:i])
              .caller.isCanCancel) {
        [((CSIIBusinessTransaction *)[pageRunningTransactions objectAtIndex:i])
                cancel];
        [pageRunningTransactions removeObjectAtIndex:i];
        //隐藏转轮
        [[CPUIActivityIndicator sharedInstance]hidden];
      }
    }
    if ([pageRunningTransactions count] == 0) {
      [self.runningTransactions removeObjectForKey:[keyArray objectAtIndex:j]];
    }
  }
  //[CSIIUIActivityIndicator sharedInstance].cancelButton.hidden = YES;
}

- (void)cancelAllTransaction;
{
  NSArray *keyArray = [self.runningTransactions allKeys];
  for (int j = 0; j < [keyArray count]; j++) {
    NSMutableArray *pageRunningTransactions =
        [self.runningTransactions objectForKey:[keyArray objectAtIndex:j]];
    for (int i = 0; i < [pageRunningTransactions count]; i++) {
      [((CSIIBusinessTransaction *)[pageRunningTransactions objectAtIndex:i])
              cancel];
      [pageRunningTransactions removeObjectAtIndex:i];
      //隐藏转轮
       [[CPUIActivityIndicator sharedInstance] hidden];
    }
    if ([pageRunningTransactions count] == 0) {
      [self.runningTransactions removeObjectForKey:[keyArray objectAtIndex:j]];
    }
  }
  // [CSIIUIActivityIndicator sharedInstance].cancelButton.hidden = YES;
}

/*!
 * @method
 * @abstract数据校验方法
 * @discussion 此处有可能会影响运行效率 （判断条件太多）
 */

+ (BOOL)checkTransactionValue:(CSIIBusinessCaller *)caller;
{
  BOOL isChecked = YES;
//  NSString *errorMessage = @"";
//  if ((caller.pageId &&
//       [caller.pageId isEqualToString:@"LoginViewController"])) { //登陆
//    if ([caller.transactionId isEqualToString:login]) {
//      if ([[caller.checkArgument objectForKey:@"UserId"] length] == 0) {
//        isChecked = NO;
//        errorMessage = @"请输入用户名";
//      } else if ([self stringWithSting:[caller.checkArgument
//                                           objectForKey:@"UserId"]]) {
//        if ([[caller.checkArgument objectForKey:@"UserId"] length] != 11) {
//          isChecked = NO;
//          errorMessage = @"请输入11位手机号码";
//        }
//      } else if ([[caller.checkArgument objectForKey:@"UserId"] length] < 6 ||
//                 [[caller.checkArgument objectForKey:@"UserId"] length] > 20) {
//        isChecked = NO;
//        errorMessage = @"登录名请输入6-20位数字或字母";
//      } else if ([[caller.checkArgument objectForKey:@"Password"] length] ==
//                 0) {
//        isChecked = NO;
//        errorMessage = @"请输入密码";
//      } else if ([[caller.checkArgument objectForKey:@"_vTokenName"] length] ==
//                 0) {
//        isChecked = NO;
//        errorMessage = @"请输入验证码";
//      }
//    }
//  }
//
//  if (isChecked == NO) {
//    //[[CSIIUIAlert sharedInstance]showAlert:[[CSIIBusinessCaller alloc]init]
//    //title:kAlertErrorTitle message:errorMessage];
//  }
//  isChecked = isChecked && [Context checkTransactionValue:caller];

  return isChecked;
}

/*!
 * @method
 * @abstract 数据校验方法
 * @discussion 解决复杂的判断逻辑 （判断条件太多）
 */
- (NSString *)checkTransactiontId:(CSIIBusinessCaller *)caller;
{

  if (!caller.pageId) {
    return nil;
  }
  NSMutableArray *callPageIdArr = [NSMutableArray array];
  [callPageIdArr addObject:@"LoginViewController"];
  NSUInteger index = [callPageIdArr indexOfObject:caller.pageId];
  switch (index) {
  case 0: {
  } break;

  default: { return nil; } break;
  }
  return nil;
}

- (void)executeTransaction:(CSIIBusinessCaller *)caller
          transactionBlock:(TransactionBlock)_transactionBlock;
{
  if (caller) {
    caller.transactionBlock = _transactionBlock;
    [self executeTransaction:caller];
  }
}
/**
 * 执行交易方法
 */
- (void)executeTransaction:(CSIIBusinessCaller *)caller;
{
  @synchronized(caller) {
    if (caller) {
//      if (![Context checkPowerWithTransactionId:caller.transactionId]) {
//          
//
//        //[[CSIIUIAlert sharedInstance]showAlert:[[CSIIBusinessCaller
//        //alloc]init] title:kNetworkErrorTitle message:kPageNoOTPPowerMessage];
//        return;
//      }
      // 进行网络检测
      if ([CSIIMADPNetworkUtil isExistenceNetwork]) {
        caller.originalClass = object_getClass(caller.delegate);
        // 加入运行队列
        if ([self.runningTransactions objectForKey:caller.pageId]) {
          for (int i = 0;
               i <
               [[self.runningTransactions objectForKey:caller.pageId] count];
               i++) {
            CSIIBusinessTransaction *transaction = (CSIIBusinessTransaction *)
                [[self.runningTransactions objectForKey:caller.pageId]
                    objectAtIndex:i];
            if (([transaction.caller.pageId isEqualToString:caller.pageId] &&
                 [transaction.caller.transactionId
                     isEqualToString:caller.transactionId] &&
                 [transaction.caller.transactionArgument
                     isEqualToDictionary:caller.transactionArgument]) ||
                [transaction.caller isEqual:caller]) {
              return;
            }
          }
          if ([[self class] checkTransactionValue:caller]) {
            NSMutableArray *pageRunningTransactions =
                [self.runningTransactions objectForKey:caller.pageId];
            [pageRunningTransactions addObject:[[CSIIBusinessTransaction alloc]
                                                   initWithTransaction:self
                                                                caller:caller]];
            [self.runningTransactions setObject:pageRunningTransactions
                                         forKey:caller.pageId];
          }
        } else {
          if ([[self class] checkTransactionValue:caller]) {
            [self.runningTransactions
                setObject:[[NSMutableArray alloc]
                              initWithObjects:[[CSIIBusinessTransaction alloc]
                                                  initWithTransaction:self
                                                               caller:caller],
                                              nil]
                   forKey:caller.pageId];
          }
        }
      } else {
        if ((((long)[[NSDate date] timeIntervalSince1970]) -
             Context.currentTime) > NETWORKERROR_TIME) {
          Context.currentTime = ((long)[[NSDate date] timeIntervalSince1970]);
            
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"网络连接失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];

          // [[CSIIUIAlert sharedInstance]showAlert:[[CSIIBusinessCaller
          // alloc]init] title:kNetworkErrorTitle
          // message:kNetworkLinkErrorMessage];
          // 网络不通提示信息
          Context.isLoginFlag = NO;
          [[NSNotificationCenter defaultCenter] postNotificationName:logout
                                                              object:nil];
        }
      }
    }
  }
}

+ (CSIIBusinessLogic *)sharedInstance;
{
  @synchronized(self) {
    if (!_sharedInstance)
      _sharedInstance = [[CSIIBusinessLogic alloc] init];
    return _sharedInstance;
  }
}

- (void)transactionSucceeded:(CSIIBusinessTransaction *)transaction;
{
  if (transaction.caller.originalClass ==
      object_getClass(transaction.caller.delegate)) {
    if (transaction.caller.transactionBlock) {
      transaction.caller.isSuccess = YES;
      if (transaction.caller.isWeb) {
      } else {
        transaction.caller.transactionResult = transaction.resultObject;
      }
      transaction.caller.transactionBlock(transaction.caller);
    } else {
      if ([transaction.caller.delegate
              respondsToSelector:@selector(transactionCallback:)]) {
        transaction.caller.isSuccess = YES;
        if (transaction.caller.isWeb) {
        } else {
          transaction.caller.transactionResult = transaction.resultObject;
        }
        [transaction.caller.delegate transactionCallback:transaction.caller];
      }
    }
  }

  [self removeTransaction:transaction.caller];
  if ([self.runningTransactions count] == 0) {
    if (transaction.caller.isShowActivityIndicator) {
      //关闭转轮
      [[CPUIActivityIndicator sharedInstance] close];
    }
  }
}

- (void)transactionFailed:(CSIIBusinessTransaction *)transaction;
{
  if (transaction.caller.originalClass ==
      object_getClass(transaction.caller.delegate)) {
    if (transaction.caller.transactionBlock) {
      transaction.caller.isSuccess = NO;
      transaction.caller.transactionResult = transaction.resultObject;
      transaction.caller.error = transaction.error;
      transaction.caller.transactionBlock(transaction.caller);
    } else {
      if ([transaction.caller.delegate
              respondsToSelector:@selector(transactionCallback:)]) {
        transaction.caller.isSuccess = NO;
        transaction.caller.transactionResult = transaction.resultObject;
        transaction.caller.error = transaction.error;
        [transaction.caller.delegate transactionCallback:transaction.caller];
      }
    }
  }

  [self removeTransaction:transaction.caller];
  if ([self.runningTransactions count] == 0) {
    if (transaction.caller.isShowActivityIndicator) {
      //关闭转轮
      [[CPUIActivityIndicator sharedInstance] close];
    }
  }
}

- (void)removeTransaction:(CSIIBusinessCaller *)caller;
{
  NSMutableArray *pageRunningTransactions =
      [self.runningTransactions objectForKey:caller.pageId];
  for (int i = 0; i < [pageRunningTransactions count]; i++) {
    CSIIBusinessTransaction *transaction =
        (CSIIBusinessTransaction *)[pageRunningTransactions objectAtIndex:i];
    if ([transaction.caller.pageId isEqualToString:caller.pageId] &&
        [transaction.caller.transactionId
            isEqualToString:caller.transactionId]) {
      [pageRunningTransactions removeObjectAtIndex:i];
      [self.runningTransactions setObject:pageRunningTransactions
                                   forKey:caller.pageId];
      return;
    }
  }
}
+ (NSString *)passwordErrorMsg:(NSString *)errorType {

  NSString *msg = nil;

  switch ([errorType intValue]) {
  case -1:
    msg = @"密码为空！";
    break;
  case -2:
    msg = @"请输入六位数密码！";
    break;
  case -3:
    msg = @"密码格式错误！";
    break;
  case -4:
    msg = @"时间戳不能为空！";
    break;
  case -5:
    msg = @"加密公钥不能为空！";
    break;
  }
  return msg;
}
+ (NSString *)passwordErrorMessage:(NSString *)errorType {

  NSString *msg = nil;
  switch ([errorType intValue]) {
  case -1:
    msg = @"登陆密码为空！";
    break;
  case -2:
    msg = @"请输入8-20位登陆密码！";
    break;
  case -3:
    msg = @"密码格式错误！";
    break;
  case -4:
    msg = @"时间戳不能为空！";
    break;
  case -5:
    msg = @"加密公钥不能为空！";
    break;
  }
  return msg;
}
+ (BOOL)stringWithSting:(NSString *)srt {
  unichar c;
  for (int i = 0; i < srt.length; i++) {
    c = [srt characterAtIndex:i];
    if (!isdigit(c)) {
      return NO;
    }
  }
  return YES;
}

@end
