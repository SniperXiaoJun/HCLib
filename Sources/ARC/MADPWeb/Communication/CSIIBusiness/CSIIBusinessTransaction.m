//
//  CSIIBusinessTransaction.m
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-22.
//  Copyright (c) 2013年 北京科蓝软件系统股份有限公司. All rights reserved.
//


#import "CSIIBusinessTransaction.h"
#import <objc/runtime.h>
#import "CPUIActivityIndicator.h"
#import "CSIIConfigGlobalImport.h"
#import "JRPluginUtil.h"

// static long currentTime;
@implementation CSIIBusinessTransaction

@synthesize delegate, resultObject, error, isJumpToFailurePage,
    isTransmissionError, caller;
@synthesize originalClass;
- (id)init {
  self = [super init];
  if (self) {
      
    self.isJumpToFailurePage = NO;
    self.isTransmissionError = NO;
    
  }
  return self;
}

- (id)initWithTransaction:(id)_delegate caller:(CSIIBusinessCaller *)_caller;
{
  self = [self init];
  if (self) {
    self.delegate = _delegate;
    self.originalClass = object_getClass(self.delegate);
    self.caller = _caller;
    /*
     * 添加公共参数
     */
    self.caller.transactionArgument = [NSMutableDictionary
        dictionaryWithDictionary:
            [self disposeArgument:
                      [self addPublicArgument:
                                [self filterArgument:
                                          self.caller.transactionArgument]]]];
    /*
     * 发送数据
     */
    Log_TransactionInfo(
        @"\nExecuteTransaction\nInterface     %@\nRequestData  ->->->->->\n%@",
        self.caller.transactionId, self.caller.transactionArgument);
    /*
     * 显示转轮
     */
      if (self.caller.responsType != ResponsTypeOfWeb){
          
          if (self.caller.isShowActivityIndicator) {
              //显示转轮
              [[CPUIActivityIndicator sharedInstance] show];
          }
          
      }

#ifdef DO_DATA_FROM_LOCAL
    //离线版，从本地读取交易数据
    NSDictionary *dataDic = nil;
    NSString *htmlString = nil;

    {
      self.caller.transactionArgument = nil;

      if ([caller.transactionId rangeOfString:@".do"].length != 0 ||
          [caller.transactionId rangeOfString:@".json"].length != 0) {
#ifdef DO_FROM_LOCAL

        dataDic = [self getDataFromLocalFile_DO:caller.transactionId];

        self.caller.webData = dataDic;

#endif

      } else if ([caller.transactionId rangeOfString:@".html"].length != 0) {
#ifdef HTML_FROM_LOCAL
        //网页代码string
        htmlString = [self getDataFromLocalFile_HTML:caller.transactionId];
        self.caller.webData = htmlString;

#endif
      }

      if (self.originalClass == object_getClass(self.delegate)) {
        [self.delegate transactionSucceeded:self];
      }
      if (self.caller.isShowActivityIndicator) {
        //隐藏转轮
        [[CPUIActivityIndicator sharedInstance] hidden];
        // [[CPMask sharedInstance] HideMask];
      }

      return self;
    }

#else

    if ([self.caller.transactionId rangeOfString:@".do"].length != 0 ||
        [self.caller.transactionId rangeOfString:@".json"].length != 0) {

      client = [[CSIIMADPNetworkHttpClient alloc]
          initWithTransaction:self.caller.transactionId
          message:self.caller.transactionArgument
          caller:self.caller
          argument:nil
          onSuccessBlock:^(NSString *string, NSMutableDictionary *webInfo) {
#ifdef DEBUG
#ifndef INNERSERVER_PORT
#ifdef WRITE_LOCAL_WEB
            [string
                writeToFile:[[[[NSBundle mainBundle] resourcePath]
                                stringByAppendingPathComponent:LOCAL_WEB]
                                stringByAppendingPathComponent:
                                    [[SERVER_PATH stringByAppendingString:@"/"]
                                        stringByAppendingString:
                                            self.caller.transactionId]]
                 atomically:YES
                   encoding:NSUTF8StringEncoding
                      error:nil];
#endif
#endif
#endif
              if (self.caller.responsType == ResponsTypeOfWeb){
                  
                  self.caller.webInfo = webInfo;
                  if (self.originalClass == object_getClass(self.delegate)) {
                      id json = [NSJSONSerialization
                                 JSONObjectWithData:
                                 [string dataUsingEncoding:NSUTF8StringEncoding]
                                 options:NSJSONReadingMutableContainers
                                 error:nil];
                      if (json != nil && [json isKindOfClass:[NSDictionary class]]) {
                          self.caller.webData = json;
                          self.resultObject = [NSJSONSerialization
                                               JSONObjectWithData:[string
                                                                   dataUsingEncoding:NSUTF8StringEncoding]
                                               options:NSJSONReadingMutableContainers
                                               error:nil];
                          
                          Log_TransactionInfo(
                                              @"\nInterface     %@     \nState         "
                                              @"transactionSucceeded\nResponseData  <-<-<-<-<-\n%@",
                                              self.caller.transactionId, self.caller.webData);
                          if (self.resultObject) {
                              [self disposeReturnCode:self.resultObject];
                          }
                          
                          
                      } else if (json != nil &&
                                 [json isKindOfClass:[NSArray class]]) {
                          self.caller.webData = json;
                          self.resultObject = [NSJSONSerialization
                                               JSONObjectWithData:[string
                                                                   dataUsingEncoding:NSUTF8StringEncoding]
                                               options:NSJSONReadingMutableContainers
                                               error:nil];
                          if (self.resultObject) {
                              [self disposeReturnCode:self.resultObject];
                          }
                          
                          Log_TransactionInfo(
                                              @"\nInterface     %@     \nState         "
                                              @"transactionSucceeded\nResponseData  <-<-<-<-<-\n%@",
                                              self.caller.transactionId, self.caller.webData);
                      } else {
                          self.caller.webData = string;
                          Log_TransactionInfo(
                                              @"\nInterface     %@     \nState         "
                                              @"transactionSucceeded\nResponseData  <-<-<-<-<-\n%@",
                                              self.caller.transactionId, self.caller.webData);
                          if (self.originalClass == object_getClass(self.delegate)) {
                              if ([self.delegate
                                   conformsToProtocol:@protocol(CSIITransaction)]) {
                                  if ([self.delegate
                                       respondsToSelector:@selector(
                                                                    transactionSucceeded:)]) {
                                           [self.delegate transactionSucceeded:self];
                                       }
                              }
                          }
                      }
                  }
              }else if (self.caller.responsType == ResponsTypeOfString) {

              self.caller.webInfo = webInfo;
              if (self.originalClass == object_getClass(self.delegate)) {
                id json = [NSJSONSerialization
                    JSONObjectWithData:
                        [string dataUsingEncoding:NSUTF8StringEncoding]
                               options:NSJSONReadingMutableContainers
                                 error:nil];
                if (json != nil && [json isKindOfClass:[NSDictionary class]]) {
                  self.caller.webData = json;
                 self.resultObject = [NSJSONSerialization
                                         JSONObjectWithData:[string
                                                             dataUsingEncoding:NSUTF8StringEncoding]
                                         options:NSJSONReadingMutableContainers
                                         error:nil];
                    
                    Log_TransactionInfo(
                                        @"\nInterface     %@     \nState         "
                                        @"transactionSucceeded\nResponseData  <-<-<-<-<-\n%@",
                                        self.caller.transactionId, self.caller.webData);
                  if (self.resultObject) {
                    [self disposeReturnCode:self.resultObject];
                  }


                } else if (json != nil &&
                           [json isKindOfClass:[NSArray class]]) {
                  self.caller.webData = json;
                self.resultObject = [NSJSONSerialization
                                         JSONObjectWithData:[string
                                                             dataUsingEncoding:NSUTF8StringEncoding]
                                         options:NSJSONReadingMutableContainers
                                         error:nil];
                  if (self.resultObject) {
                    [self disposeReturnCode:self.resultObject];
                  }

                    [[CPUIActivityIndicator sharedInstance]hidden];

                  Log_TransactionInfo(
                      @"\nInterface     %@     \nState         "
                      @"transactionSucceeded\nResponseData  <-<-<-<-<-\n%@",
                      self.caller.transactionId, self.caller.webData);
                } else {
                  self.caller.webData = string;
                  Log_TransactionInfo(
                      @"\nInterface     %@     \nState         "
                      @"transactionSucceeded\nResponseData  <-<-<-<-<-\n%@",
                      self.caller.transactionId, self.caller.webData);
                  if (self.originalClass == object_getClass(self.delegate)) {
                    if ([self.delegate
                            conformsToProtocol:@protocol(CSIITransaction)]) {
                      if ([self.delegate
                              respondsToSelector:@selector(
                                                     transactionSucceeded:)]) {
                        [self.delegate transactionSucceeded:self];
                        [[CPUIActivityIndicator sharedInstance]hidden];
                      }
                    }
                  }
                }
              }

              if (self.caller.isShowActivityIndicator) {
                //隐藏转轮
                [[CPUIActivityIndicator sharedInstance]hidden];
              }
            } else {
              self.resultObject = [NSJSONSerialization
                  JSONObjectWithData:[string
                                         dataUsingEncoding:NSUTF8StringEncoding]
                             options:NSJSONReadingMutableContainers
                               error:nil];
              if (self.resultObject) {
                [self disposeReturnCode:self.resultObject];
              } else {
                NSDictionary *errorInfo =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"服务器返回数据异常！",
                                      NSLocalizedDescriptionKey, @"999999",
                                      NSLocalizedFailureReasonErrorKey, nil];
                self.error =
                    [NSError errorWithDomain:@"NSApplicationErrorDomain"
                                        code:1
                                    userInfo:errorInfo];
                self.resultObject = [NSDictionary dictionary];
                Log_TransactionInfo(
                    @"\nSERVER_c.ERROR\nInterface     %@     \nState         "
                    @"transactionFailed\nResponseData  <-<-<-<-<-\n%@",
                    self.caller.transactionId, self.resultObject);
//                [self showFailureMessage];
                if (self.originalClass == object_getClass(self.delegate)) {
                  if ([self.delegate
                          conformsToProtocol:@protocol(CSIITransaction)]) {
                    if ([self.delegate
                            respondsToSelector:@selector(transactionFailed:)]) {
                      [self.delegate transactionFailed:self];
                    }
                  }
                }
              }
              if (self.caller.isShowActivityIndicator) {
                //隐藏转轮
                [[CPUIActivityIndicator sharedInstance] hidden];
              }
            }

          }
          onFailureBlock:^(NSError *_error, NSMutableDictionary *webInfo) {
              
              if (self.caller.responsType == ResponsTypeOfWeb){
                  
                  
                  self.caller.webInfo = webInfo;
                  self.error = _error;
                  NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
                  NSMutableArray *  errArray=[[NSMutableArray alloc]init];
                  
                  [dict setObject:errArray forKey:@"jsonError"];
                  
                  
                  NSMutableDictionary * messageDic=[[NSMutableDictionary alloc]init];
                  
                  [messageDic setObject:[self.error.userInfo objectForKey:@"NSLocalizedDescription"] forKey:@"_exceptionMessage"];
                  [errArray addObject:messageDic];
                  
                  self.resultObject = dict;
                  Log_TransactionInfo(
                                      @"\nSERVER_c.ERROR\nInterface     %@     \nState         "
                                      @"transactionFailed\nResponseData  <-<-<-<-<-\n%@",
                                      self.caller.transactionId, self.caller.webInfo);
                  //通讯返回异常标志
                  self.isTransmissionError = YES;
                  if (self.originalClass == object_getClass(self.delegate)) {
                      if ([self.delegate
                           conformsToProtocol:@protocol(CSIITransaction)]) {
                          if ([self.delegate
                               respondsToSelector:@selector(transactionFailed:)]) {
                              [self.delegate transactionFailed:self];
                          }
                      }
                  }
              }else
            if (self.caller.responsType == ResponsTypeOfString) {
                
                
              self.caller.webInfo = webInfo;
              self.error = _error;
                NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
                NSMutableArray *  errArray=[[NSMutableArray alloc]init];

                [dict setObject:errArray forKey:@"jsonError"];
                
                
                NSMutableDictionary * messageDic=[[NSMutableDictionary alloc]init];

                
                //崩溃修改 setObject 设置空值崩溃
                if (self.error &&
                    self.error.userInfo &&
                    [[self.error.userInfo objectForKey:@"NSLocalizedDescription"] length]>0) {
                    [messageDic setObject:[self.error.userInfo objectForKey:@"NSLocalizedDescription"] forKey:@"_exceptionMessage"];

                }
                
                
                [errArray addObject:messageDic];
            
              self.resultObject = dict;
              Log_TransactionInfo(
                  @"\nSERVER_c.ERROR\nInterface     %@     \nState         "
                  @"transactionFailed\nResponseData  <-<-<-<-<-\n%@",
                  self.caller.transactionId, self.caller.webInfo);
              [self showFailureMessage];
//                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[self.error.userInfo objectForKey:@"NSLocalizedDescription"] delegate:delegate cancelButtonTitle:@"" otherButtonTitles:nil, nil];
//                [alert show];
              //通讯返回异常标志
              self.isTransmissionError = YES;
              if (self.originalClass == object_getClass(self.delegate)) {
                if ([self.delegate
                        conformsToProtocol:@protocol(CSIITransaction)]) {
                  if ([self.delegate
                          respondsToSelector:@selector(transactionFailed:)]) {
                    [self.delegate transactionFailed:self];
                  }
                }
              }
              if (self.caller.isShowActivityIndicator) {
                //隐藏转轮
                  [[CPUIActivityIndicator sharedInstance] hidden];
              }
            } else {

                self.error = _error;
                NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
                NSMutableArray *  errArray=[[NSMutableArray alloc]init];
                
                [dict setObject:errArray forKey:@"jsonError"];
                
                NSMutableDictionary * messageDic=[[NSMutableDictionary alloc]init];
                
                [messageDic setObject:[self.error.userInfo objectForKey:@"NSLocalizedDescription"] forKey:@"_exceptionMessage"];
                [errArray addObject:messageDic];
                
                self.resultObject = dict;
              Log_TransactionInfo(
                  @"\nSERVER_c.ERROR\nInterface     %@     \nState         "
                  @"transactionFailed\nResponseData  <-<-<-<-<-\n%@",
                  self.caller.transactionId, self.resultObject);
              [self showFailureMessage];
              //通讯返回异常标志
              self.isTransmissionError = YES;
              if (self.originalClass == object_getClass(self.delegate)) {
                if ([self.delegate
                        conformsToProtocol:@protocol(CSIITransaction)]) {
                  if ([self.delegate
                          respondsToSelector:@selector(transactionFailed:)]) {
                    [self.delegate transactionFailed:self];
                  }
                }
              }
              if (self.caller.isShowActivityIndicator) {
                //隐藏转轮
                  [[CPUIActivityIndicator sharedInstance] hidden];
              }
            }
          }];
      self.caller.transactionArgument = nil;
    }

#endif
  }
  return self;
}

/*!
 * @method
 * @abstract取消交易
 */
- (void)cancel;
{ [client cancel]; }

/*!
 * @method
 * @abstract过滤参数
 */
- (NSDictionary *)filterArgument:(NSDictionary *)argument;
{ return [Context filterArgument:argument caller:self.caller]; }

/*!
 * @method
 * @abstract添加公共参数
 */
- (NSDictionary *)addPublicArgument:(NSDictionary *)argument;
{ return [Context addPublicArgument:argument]; }

/*!
 * @method
 * @abstract处理请求数据 根据需要进行加密
 */
- (NSDictionary *)disposeArgument:(NSDictionary *)argument {
  // NSData *data = nil;
  if (argument) {
    if (self.caller.isHavePassword) {
      /*
       NSNumber *timestamp = self.caller.timeStamp;
       int8_t *applicationPlatformModulus = (int8_t*)[self.caller.publicKey
       cStringUsingEncoding:NSASCIIStringEncoding];
       Modulus modulus = {
       applicationPlatformModulus,
       NULL
       };
       NSStringEncoding enc = NSISOLatin1StringEncoding;
       NSMutableDictionary *argumentEdit = [NSMutableDictionary
       dictionaryWithDictionary:argument];
       for (int i=0; i<[self.caller.passwordFields count]; i++) {
       int8_t *passwordField = NULL;
       csiiEncrypt(STANDARD, &modulus, &passwordField,
       (int8_t*)[[argumentEdit objectForKey:[self.caller.passwordFields
       objectAtIndex:i]] cStringUsingEncoding:enc],
       [[timestamp stringValue] cStringUsingEncoding:enc]);
       [argumentEdit setObject:[NSString stringWithCString:(const
       char*)passwordField encoding:NSISOLatin1StringEncoding]
       forKey:[self.caller.passwordFields objectAtIndex:i]];
       free(passwordField);
       }
       argument = [NSDictionary dictionaryWithDictionary:argumentEdit];
       */
      //            data = [argument JSONData];
    } else {
      //            data = [argument JSONData];
    }
  }
  return [Context disposeArgument:argument caller:self.caller];
}

/*!
 * @method
 * @abstract处理返回结果
 */
- (void)disposeReturnCode:(NSDictionary *)result;
{
//  if (Context.isLoginFlag) {
//    if ([result objectForKey:@"logoutFlag"] != nil &&
//        [result objectForKey:@"logoutFlag"] != [NSNull null] &&
//        [[result objectForKey:@"logoutFlag"] isEqualToString:@"true"]) {
//      new_transaction(alertCaller);
//        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"会话超时" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//      Context.isLoginFlag = NO;
//      [[NSNotificationCenter defaultCenter] postNotificationName:@"logout.do"
//                                                          object:nil];
//      return;
//    }
//  }

    // TODO:SHENYU 居然会话超时错误码 888888
    if ([[result objectForKey:RETURNCODE] isEqualToString: SESSION_FAILED]) {
        // 会话超时
        
        Singleton.isLogin = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:Login_Out_Notification object:nil];
//        [[Routable sharedRouter] open:@"login" animated:YES];
        [JRPluginUtil needReLogin];;

        if (![[[Singleton.rootViewController viewControllers] lastObject] isKindOfClass:NSClassFromString(@"LoginViewController")]) {
//            [[Routable sharedRouter] open:@"login" animated:YES];
            [JRPluginUtil needReLogin];;

        }
    }
  if ([result objectForKey:RETURNMESSAGE] != nil &&
      [result objectForKey:RETURNMESSAGE] != [NSNull null]) {
      
      if ([[result objectForKey:RETURNMESSAGE] isKindOfClass:[NSArray class]]) {
          NSDictionary *errorInfo =
          [NSDictionary dictionaryWithObjectsAndKeys:
           [[[result objectForKey:RETURNMESSAGE] objectAtIndex:0]
            objectForKey:@"_exceptionMessage"],
           NSLocalizedDescriptionKey,
           [[[result objectForKey:RETURNMESSAGE] objectAtIndex:0]
            objectForKey:@"_exceptionMessageCode"],
           NSLocalizedFailureReasonErrorKey, nil];
          self.error = [NSError errorWithDomain:@"NSApplicationErrorDomain"
                                           code:1
                                       userInfo:errorInfo];

          
      }else {
          self.error = [NSError errorWithDomain:@"NSApplicationErrorDomain"
                                           code:1
                                       userInfo:result];
      
      }
//    self.resultObject = [NSDictionary dictionary];
      
      // 去掉注释
    Log_TransactionInfo(@"\nLOGIC_b.ERROR\nInterface     %@     \nState        "
                        @" transactionFailed\nResponseData  <-<-<-<-<-\n%@",
                        self.caller.transactionId, self.resultObject);

//    if (Context.isLoginFlag) {
//      if (![caller.transactionId isEqualToString:@"logout"]) {
//          
//          if ([[result objectForKey:RETURNMESSAGE] isKindOfClass:[NSArray class]]) {
//
//        if ([[[[result objectForKey:RETURNMESSAGE] objectAtIndex:0]
//                objectForKey:@"_exceptionMessageCode"]
//                isEqualToString:@"role.invalid_user"] ||
//            [[[[result objectForKey:RETURNMESSAGE] objectAtIndex:0]
//                objectForKey:@"_exceptionMessage"]
//                isEqualToString:@"会话已超时"]) {
//          Context.isLoginFlag = NO;
//          [[NSNotificationCenter defaultCenter] postNotificationName:logout
//                                                              object:nil];
//            }}else{
//            
//                self.error = [NSError errorWithDomain:@"NSApplicationErrorDomain"
//                                                 code:1
//                                             userInfo:result];
//
//            }
//      }
//    }

    [self showFailureMessage];
    //跳转错误页面标志
    /*
     if (YES) {
     self.isJumpToFailurePage = YES;
     }
     */
    if (self.originalClass == object_getClass(self.delegate)) {
      if ([self.delegate conformsToProtocol:@protocol(CSIITransaction)]) {
        if ([self.delegate respondsToSelector:@selector(transactionFailed:)]) {
          [self.delegate transactionFailed:self];
        }
      }
    }

  } else {
//    TODO: 去掉注释
//    Log_TransactionInfo(@"\nInterface     %@     \nState         "
//                        @"transactionSucceeded\nResponseData  <-<-<-<-<-\n%@",
//                        self.caller.transactionId, self.resultObject);
    if (self.originalClass == object_getClass(self.delegate)) {
      if ([self.delegate conformsToProtocol:@protocol(CSIITransaction)]) {
        if ([self.delegate
                respondsToSelector:@selector(transactionSucceeded:)]) {
          [self.delegate transactionSucceeded:self];
        }
      }
    }
  }

  return;

}

/*!
 * @method
 * @abstract处理返回错误信息（根据接口决定 或者提示错误信息 或者跳转页面
 * 或者不做处理）
 */
- (void)showFailureMessage;
{
    
    [[CPUIActivityIndicator sharedInstance] hidden];

//  if ([self.caller.transactionId isEqualToString:logout] ||
//      [self.caller.transactionId isEqualToString:TransferOut]) {
//    //这里是出错后 ERROR——2.或者跳转错误页面 ERROR——3.或者不进行任何操作 的逻辑
//  } else {
//    Log_TransactionInfo(@"返回错误信息的逻辑!");
//    //这里是出错后 ERROR——4.返回错误信息的逻辑
//
//    if ([self.error.localizedFailureReason
//            isEqualToString:@"validation.wrong.tu.pwd.is.max"]) {
//
//    } else if ([self.error.localizedFailureReason
//                   isEqualToString:@"validation.wrong.tu.pwd.flag"]) {
//
//    } else if ([self.error.localizedFailureReason
//                   isEqualToString:@"validation.tuxpassword.is.null"]) {
//
//    } else {
//      //[[CSIIUIAlert sharedInstance]showAlert:[[CSIIBusinessCaller alloc]init]
//      // title:kLogicErrorTitle message:[self.error.localizedDescription
//      // stringByTrimmingCharactersInSet:[NSCharacterSet
//      // whitespaceCharacterSet]]];
//      Log_TransactionInfo(@"返回错误信息的逻辑!%@",
//                          self.error.localizedDescription);
//    }
//  }
}
#pragma mark - 内部挡板数据读取
- (NSDictionary *)getDataFromLocalFile_DO:(NSString *)action {
  NSString *fileName = [[[NSBundle mainBundle] resourcePath]
      stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@",
                                                                @"pweb/sample",
                                                                @"do", action]];
  DebugLog(@"getDataFromLocalFile:%@", fileName);

  //交易数据
  NSData *jsonData = [[NSData alloc] initWithContentsOfFile:fileName];
  if (jsonData == nil) {
    [[[UIAlertView alloc]
            initWithTitle:@"提示"
                  message:[NSString
                              stringWithFormat:
                                  @"Web/" @"portal目录下没有对应的%@文件!"
                                  @"请自行添加该文件，内容为json,"
                                  @"字段根据具体情况添加。",
                                  action]
                 delegate:nil
        cancelButtonTitle:@"确定"
        otherButtonTitles:nil, nil] show];

    return nil;
  }

  NSError *JSONObjectWithDataError = nil;
  NSDictionary *dict =
      [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&JSONObjectWithDataError];
  if (JSONObjectWithDataError) {
    DebugLog(@"JSON Parsing Error: %@", JSONObjectWithDataError);
    [[[UIAlertView alloc] initWithTitle:@"提示"
                                message:@"返回交易数据，JSON解析出错"
                               delegate:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil, nil] show];
    return nil;
  }
  DebugLog(@"dict:%@", dict);
  return dict;
}

- (NSString *)getDataFromLocalFile_HTML:(NSString *)action {
  //网页代码string
  NSString *fileName = [[[NSBundle mainBundle] resourcePath]
      stringByAppendingPathComponent:
          [NSString stringWithFormat:@"%@/%@", LOCAL_WEB, action]];
  DebugLog(@"getDataFromLocalFile:%@", fileName);
  NSString *htmlstr = [NSString stringWithContentsOfFile:fileName
                                                encoding:NSUTF8StringEncoding
                                                   error:nil];
  return htmlstr;
}

@end
