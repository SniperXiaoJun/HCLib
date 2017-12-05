//
//  CSIIBusinessCaller.h
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-22.
//  Copyright (c) 2013年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CSIIBusinessCaller;

typedef enum {
    TransactionStateSuccess = 1,
    TransactionStateFailure = 0,
    TransactionStateCancel = -1
} TransactionState;

typedef enum {
    ResponsTypeOfJson = 0,
    ResponsTypeOfString = 1,
    ResponsTypeOfImageData = 2,
    ResponsTypeOfWeb=3
} ResponsType;

typedef void (^TransactionBlock)(CSIIBusinessCaller* returnCaller);
typedef void (^AlertBlock)(CSIIBusinessCaller* returnCaller);
typedef void (^PickerBlock)(CSIIBusinessCaller* returnCaller);

@protocol CSIIBusinessCallerDelegate <NSObject>
@required
@optional
- (void)transactionCallback:(CSIIBusinessCaller*)returnCaller;
- (void)alertCallback:(CSIIBusinessCaller*)returnCaller;
- (void)pickerCallback:(CSIIBusinessCaller*)returnCaller;
@end

@interface CSIIBusinessCaller : NSObject <NSCoding, NSCoding, NSMutableCopying> {
    TransactionBlock transactionBlock;
    AlertBlock alertBlock;
    PickerBlock pickerBlock;
    NSString* pageId; //调用页面id
    NSString* transactionId; //调用交易id
    NSMutableDictionary* transactionArgument; //调用交易参数
    NSMutableDictionary* checkArgument; //提交校验辅助参数
    NSString* fieldId; //字段id
    NSString* controlType; //控件类型
    NSString* activityIndicatorText; //活动指示器文字
    BOOL isShowActivityIndicator; //是否显示活动指示器
    BOOL isCanCancel; //是否支持交易取消
    BOOL isHavePassword; //是否包含加密字段
    NSString* publicKey; //加密使用的公钥
    NSArray* passwordFields; //需要加密的字段
    NSNumber* timeStamp; //加密用的时间戳

#if __has_feature(objc_arc_weak)
    __weak id<CSIIBusinessCallerDelegate> delegate;
#else
    __unsafe_unretained id<CSIIBusinessCallerDelegate> delegate;
#endif
    TransactionState isSuccess;
    ResponsType responsType;
    NSDictionary* transactionResult;
    NSError* error;

    unsigned long textFieldHash;
    NSDictionary* value;

    BOOL confirmState;

    Class originalClass;

    BOOL isWeb;
    id webData;
    NSMutableDictionary* webInfo;
    NSString* webMethod;

    NSMutableDictionary* httpHeader;
    BOOL isImgFile;
}
@property (nonatomic, assign) BOOL isWeb;
@property (nonatomic, assign) BOOL isImgFile;
@property (nonatomic, strong) NSMutableDictionary* webInfo;
@property (nonatomic, strong) id webData;
@property (nonatomic, copy) NSString* webMethod;
@property (nonatomic, strong) NSMutableDictionary* httpHeader;

#if __has_feature(objc_arc_weak)
@property (nonatomic, weak) id<CSIIBusinessCallerDelegate> delegate;
#else
@property (nonatomic, unsafe_unretained) id<CSIIBusinessCallerDelegate> delegate;
#endif

@property (nonatomic, copy) TransactionBlock transactionBlock;
@property (nonatomic, copy) AlertBlock alertBlock;
@property (nonatomic, copy) PickerBlock pickerBlock;

@property (nonatomic, assign) TransactionState isSuccess;
@property (nonatomic, assign) ResponsType responsType;
@property (nonatomic, strong) NSDictionary* transactionResult;
@property (nonatomic, strong) NSError* error;

@property (nonatomic, assign) unsigned long textFieldHash;
@property (nonatomic, strong) NSDictionary* value;
@property (nonatomic, assign) BOOL confirmState;

@property (nonatomic, assign) Class originalClass;

@property (copy, nonatomic) NSString* pageId;
@property (copy, nonatomic) NSString* transactionId;
@property (strong, nonatomic) NSMutableDictionary* transactionArgument;
@property (strong, nonatomic) NSMutableDictionary* checkArgument;
@property (copy, nonatomic) NSString* fieldId;
@property (copy, nonatomic) NSString* controlType;
@property (copy, nonatomic) NSString* activityIndicatorText;
@property (nonatomic) BOOL isShowActivityIndicator;
@property (nonatomic) BOOL isCanCancel;
@property (nonatomic) BOOL isHavePassword;
@property (copy, nonatomic) NSString* publicKey;
@property (strong, nonatomic) NSArray* passwordFields;
@property (nonatomic, strong) NSNumber* timeStamp;
@end
