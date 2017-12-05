//
//  CSIIBusinessContext.h
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-26.
//  Copyright (c) 2013年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CSIIConfigGlobalImport.h"
@interface CSIIBusinessContext : NSObject {
    BOOL isLoginFlag;
    BOOL isLoading;
    BOOL isOTPUserFlag;
    int tabIndex;
    NSMutableArray* navigationArray;
    int navigationStep;
    BOOL isNavigation;

    NSMutableDictionary* menuDictionary;
    long currentTime;
    NSMutableDictionary* sendDictionaryData;
    NSMutableArray* sendArrayData;
    NSString* sendStringData;

    BOOL isNoAnimationFlag;
    NSString* tempAnimationType;

    NSMutableDictionary* memoryCache;

    NSMutableDictionary* submitTransactionData;

    BOOL isSelfRegistration;
    BOOL isInLoginType;
    BOOL isShowLoginViewController;
}
@property (nonatomic, assign) int tabIndex;
@property (assign, nonatomic) BOOL isShowLoginViewController;
@property (assign, nonatomic) BOOL isLoginFlag;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL isOTPUserFlag;
@property (assign, nonatomic) BOOL isSelfRegistration;
@property (nonatomic, assign) BOOL isInLoginType;
@property (strong, nonatomic) NSMutableArray* navigationArray;
@property (strong, nonatomic) UINavigationController* rootNavViewController;

@property (strong, nonatomic) NSString * clientVersionId;

@property (assign, nonatomic) int navigationStep;

@property (assign, nonatomic) NSString* strStyleGesture;

@property (assign, nonatomic) BOOL isNoAnimationFlag;
@property (assign, nonatomic) BOOL isNavigation;
@property (strong, nonatomic) NSMutableDictionary* menuDictionary;

@property (assign, nonatomic) long currentTime;

@property (nonatomic, strong) NSMutableDictionary* sendDictionaryData;
@property (nonatomic, strong) NSMutableArray* sendArrayData;
@property (nonatomic, strong) NSString* sendStringData;
@property (nonatomic, strong) NSMutableDictionary* memoryCache;
@property (nonatomic, strong) NSMutableDictionary* submitTransactionData;
@property (nonatomic, strong) NSString* tempAnimationType;
@property (nonatomic, strong) NSMutableDictionary* curPluginsDict;
@property (nonatomic, strong) NSString* serverUrl;

@property (nonatomic, strong) NSMutableDictionary* userInfoDic; //存储用户登录信息
@property (nonatomic, strong) NSMutableDictionary* PublicArgument; //公共参数


@property (nonatomic, strong) NSString* serverPath;
+ (CSIIBusinessContext*)sharedInstance;

/*!
 * @abstract登出操作处理
 */
- (void)logoutAction;

/*!
 * @abstract用角色去判断交易权限
 */
- (BOOL)checkPowerWithTransactionId:(NSString*)transactionId;
/*!
 * @abstract 用角色去判断页面权限
 */
- (BOOL)checkPowerWithPageId:(NSString*)pageId;
/*!
 * @abstract用角色去判断网络权限
 */
- (BOOL)isNoPowerOnNoNetwork:(NSString*)pageName;

/*!
 * @abstract添加HTTP请求头
 */
- (NSMutableDictionary*)addHTTPRequestHeader;
/*!
 * @abstract过滤参数
 */
- (NSDictionary*)filterArgument:(NSDictionary*)argument caller:(CSIIBusinessCaller*)_caller;
/*!
 * @abstract添加公共参数
 */
- (NSDictionary*)addPublicArgument:(NSDictionary*)argument;
/*!
 * @abstract处理参数
 */
- (NSDictionary*)disposeArgument:(NSDictionary*)argument caller:(CSIIBusinessCaller*)_caller;
/*!
 * @abstract参数校验
 */
- (BOOL)checkTransactionValue:(CSIIBusinessCaller*)caller;
/*!
 * @abstract从框架中取得图片路径
 */
- (NSString*)imagePath:(NSString*)imageName;
/*!
 * @abstract从框架中取得图片路径（带二级目录）
 */
- (NSString*)imagePath:(NSString*)imageName inDirectory:(NSString*)directoryName;

- (NSBundle*)bundle:(NSString*)bundleName;
@end
