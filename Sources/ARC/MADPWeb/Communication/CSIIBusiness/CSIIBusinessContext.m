//
//  CSIIBusinessContext.m
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-26.
//  Copyright (c) 2013年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import "CSIIBusinessContext.h"

@implementation CSIIBusinessContext
static CSIIBusinessContext* _sharedInstance;
@synthesize isLoginFlag;
@synthesize isLoading;
@synthesize isOTPUserFlag;
@synthesize isNoAnimationFlag;
@synthesize tempAnimationType;
@synthesize navigationArray;
@synthesize navigationStep;
@synthesize isNavigation;
@synthesize menuDictionary;
@synthesize rootNavViewController;

@synthesize currentTime;
@synthesize sendDictionaryData, sendArrayData, sendStringData;
@synthesize memoryCache;
@synthesize submitTransactionData;
@synthesize isSelfRegistration;
@synthesize isInLoginType;
@synthesize isShowLoginViewController;

@synthesize tabIndex;

@synthesize curPluginsDict;
@synthesize serverPath;
@synthesize serverUrl;
@synthesize PublicArgument;
+ (void)load
{
    DebugLog(@"框架初始化");
}

- (id)init
{
    self = [super init];
    if (self) {
        self.curPluginsDict = [[NSMutableDictionary alloc] init];
        self.PublicArgument = [[NSMutableDictionary alloc] init];
        self.tabIndex = -1;
        self.navigationArray = [[NSMutableArray alloc] init];
        self.sendDictionaryData = [[NSMutableDictionary alloc] init];
        self.sendArrayData = [[NSMutableArray alloc] init];
        self.sendStringData = @"";
        self.navigationArray = [[NSMutableArray alloc] init];
        self.navigationStep = 0;
        self.isNoAnimationFlag = NO;
        self.memoryCache = [[NSMutableDictionary alloc] init];
        self.isLoginFlag = NO;
        self.tempAnimationType = nil;
        self.submitTransactionData = [[NSMutableDictionary alloc] init];
        self.isSelfRegistration = NO;
        self.isInLoginType = NO;
        self.isShowLoginViewController = NO;
    }
    return self;
}

+ (CSIIBusinessContext*)sharedInstance;
{
    @synchronized(self)
    {
        if (!_sharedInstance)
            _sharedInstance = [[CSIIBusinessContext alloc] init];
        return _sharedInstance;
    }
}
- (void)logoutAction;
{
    Context.isLoginFlag = NO;
    Context.isOTPUserFlag = NO;
    Context.navigationArray = nil;
    Context.navigationStep = 0;
    Context.isNavigation = NO;
    Context.memoryCache = [[NSMutableDictionary alloc] init];
}
- (BOOL)checkPowerWithTransactionId:(NSString*)transactionId;
{
    return YES;
    if (Context.isLoginFlag) {
        if (!Context.isOTPUserFlag) {
            //            if ([transactionId isEqualToString:InlineTransferConfirm]) {
            //                return NO;
            //            }
            //            else if ([transactionId
            //            isEqualToString:ProfolioCommissionCancelConfirm]) {
            //                return NO;
            //            }
        }
        else {
            return YES;
        }
    }
    return YES;
}

- (BOOL)checkPowerWithPageId:(NSString*)pageId;
{
    return YES;
//    if (Context.isLoginFlag) {
//        if (!Context.isOTPUserFlag) {
//            if ([pageId isEqualToString:@"TransLimitSetViewController"]) {
//                return NO;
//            }
//            else if ([pageId isEqualToString:@"CrossTransferEnter"]) {
//                return NO;
//            }
//            else if ([pageId isEqualToString:@"Ex_CrossTransferEnter"]) {
//                return NO;
//            }
//            else if ([pageId isEqualToString:@"CreditCardViewController"]) {
//                return NO;
//            }
//            else if ([pageId isEqualToString:@"ChangePhoneNumberViewController"]) {
//                return NO;
//            }
//            else if ([pageId isEqualToString:@"InvestmentProSelectEnter"]) {
//                return NO;
//            }
//            else if ([pageId isEqualToString:@"ScheduledToCurrencyEnter"]) {
//                return NO;
//            }
//            else if ([pageId isEqualToString:@"NotificationToCurrencyEnter"]) {
//                return NO;
//            }
//            else if ([pageId isEqualToString:@"DisburseMenuViewController"]) {
//                return NO;
//            }
//        }
//        else {
//            return YES;
//        }
//    }
//    return YES;
}

- (BOOL)isNoPowerOnNoNetwork:(NSString*)pageName;
{

    if (![CSIIMADPNetworkUtil isExistenceNetwork]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"无网络连接！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];

        //      [[CSIIUIAlert sharedInstance]showAlert:[[CSIIBusinessCaller alloc]init]
        //  title:kNetworkErrorTitle message:kPageNoNetworkErrorMessage];
        //      网络不通提示信息
        return YES;
    }
    return NO;
}

- (NSMutableDictionary*)addHTTPRequestHeader;
{
    DebugLog(@"添加HTTP请求头");
    // liu_修改
    NSMutableDictionary* httpHeader =
        [NSMutableDictionary dictionaryWithDictionary:SERVER_HEADER];
    return httpHeader;
}

- (NSDictionary*)filterArgument:(NSDictionary*)argument
                         caller:(CSIIBusinessCaller*)_caller;
{
    DebugLog(@"过滤参数");
    return argument;
}

- (NSDictionary*)addPublicArgument:(NSDictionary*)argument;
{
    DebugLog(@"添加公共参数");
    NSMutableDictionary* dict =
        [[NSMutableDictionary alloc] initWithDictionary:argument];

    NSMutableArray* errorKeyArr = [[NSMutableArray alloc] init];
    for (NSObject* obj in [dict keyEnumerator]) {
        if ([dict objectForKey:obj] == [NSNull null]) {
            [errorKeyArr addObject:obj];
        }
    }

    for (int i = 0; i < [errorKeyArr count]; i++) {
        [dict removeObjectForKey:[errorKeyArr objectAtIndex:i]];
    }
    if ([errorKeyArr count] != 0) {
        DebugLog(@"\n\n\n\n\n参数错误！\n%@\n\n\n", errorKeyArr);
    }

    //  for (NSObject * obj in [dict keyEnumerator]) {
    //    //       DebugLog(@"%@:%@",obj,[[dict objectForKey:obj]class]);
    //  }
    
    
    [dict addEntriesFromDictionary:self.PublicArgument];
    
    return dict;
}

- (NSDictionary*)disposeArgument:(NSDictionary*)argument
                          caller:(CSIIBusinessCaller*)_caller;
{
    DebugLog(@"处理参数");
    return argument;
}

- (BOOL)checkTransactionValue:(CSIIBusinessCaller*)caller;
{
    DebugLog(@"参数校验");

    BOOL isChecked = YES;
    NSString* errorMessage = @"";
    //转账限额设置
    if ((caller.pageId &&
            [caller.pageId
                isEqualToString:@"InternalFundsViewController"])) { //资金转出
        if ([caller.transactionId isEqualToString:@"AcctLost.do"]) {
            if ([[caller.transactionArgument objectForKey:@"TrsAmount"] floatValue] <= 0.00) {
                isChecked = NO;
                errorMessage = @"交易金额不能为空！";
            }
        }
    }
    if (isChecked == NO) {
        //        [[CSIIUIAlert sharedInstance]showAlert:[[CSIIBusinessCaller
        //        alloc]init] title:kAlertErrorTitle message:errorMessage];
    }
    return isChecked;
}
/**
 * 从框架中取得图片路径
 */
- (NSString*)imagePath:(NSString*)imageName;
{
    return [[NSBundle mainBundle] pathForResource:imageName
                                           ofType:nil
                                      inDirectory:@"CSIILibResources"];
}
/**
 * 从框架中取得图片路径（带二级目录）
 */
- (NSString*)imagePath:(NSString*)imageName
           inDirectory:(NSString*)directoryName;
{
    return [[NSBundle mainBundle]
        pathForResource:imageName
                 ofType:nil
            inDirectory:[NSString stringWithFormat:@"%@/%@", @"CSIILibResources",
                                  directoryName]];
}
- (NSBundle*)bundle:(NSString*)bundleName
{

    NSString* bundlePath =
        [[NSBundle mainBundle]
                .resourcePath stringByAppendingPathComponent:bundleName];
    NSBundle* bundle = [NSBundle bundleWithPath:bundlePath];
    return bundle;
}
@end
