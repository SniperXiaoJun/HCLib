//
//  CSIIBusinessCaller.m
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-22.
//  Copyright (c) 2013年 北京科蓝软件系统股份有限公司. All rights reserved.
//

#import "CSIIBusinessCaller.h"
#import "CSIIConfigGlobalImport.h"
@implementation CSIIBusinessCaller
@synthesize transactionBlock;
@synthesize alertBlock;
@synthesize pickerBlock;
@synthesize pageId;
@synthesize transactionId;
@synthesize transactionArgument;
@synthesize checkArgument;
@synthesize fieldId;
@synthesize controlType;
@synthesize activityIndicatorText;
@synthesize isShowActivityIndicator;
@synthesize isCanCancel;
@synthesize isHavePassword;
@synthesize publicKey;
@synthesize passwordFields;
@synthesize timeStamp;

@synthesize delegate;
@synthesize isSuccess;
@synthesize responsType;
@synthesize transactionResult;
@synthesize error;
@synthesize textFieldHash;
@synthesize value;
@synthesize confirmState;
@synthesize originalClass;
@synthesize isWeb;
@synthesize isImgFile;
@synthesize webInfo;
@synthesize webData;
@synthesize webMethod;
@synthesize httpHeader;
- (id)init
{
    self = [super init];
    if (self) {
        self.pageId = @"";
        self.transactionId = @"";
        self.transactionArgument = [[NSMutableDictionary alloc]init];
        self.checkArgument = [[NSMutableDictionary alloc]init];
        self.fieldId = @"";
        self.controlType = @"";
        self.activityIndicatorText = @"";
        self.isShowActivityIndicator = YES;
        self.isCanCancel = NO;
        self.isHavePassword = NO;
        self.publicKey = PUBLICKEY;
        self.passwordFields = [NSArray array];
        self.transactionBlock = nil;
        self.alertBlock = nil;
        self.pickerBlock = nil;
        self.isWeb = NO;
        self.isImgFile = NO;
        self.webInfo = [[NSMutableDictionary alloc]init];
        self.webMethod = @"GET";
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:pageId forKey:@"pageId"];
    [coder encodeObject:transactionId forKey:@"transactionId"];
    [coder encodeObject:transactionArgument forKey:@"transactionArgument"];
    [coder encodeObject:checkArgument forKey:@"checkArgument"];
    [coder encodeObject:fieldId forKey:@"fieldId"];
    [coder encodeObject:controlType forKey:@"controlType"];
    [coder encodeObject:activityIndicatorText forKey:@"activityIndicatorText"];
    [coder encodeObject:[NSNumber numberWithBool:isShowActivityIndicator] forKey:@"isShowActivityIndicator"];
    [coder encodeObject:[NSNumber numberWithBool:isCanCancel] forKey:@"isCanCancel"];
    [coder encodeObject:[NSNumber numberWithBool:isHavePassword] forKey:@"isHavePassword"];
    [coder encodeObject:transactionId forKey:@"publicKey"];
    [coder encodeObject:transactionId forKey:@"passwordFields"];
    [coder encodeObject:transactionId forKey:@"timeStamp"];

}
- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self) {
        self.pageId = [coder decodeObjectForKey:@"pageId"];
        self.transactionId = [coder decodeObjectForKey:@"transactionId"];
        self.transactionArgument = [coder decodeObjectForKey:@"transactionArgument"];
        self.checkArgument = [coder decodeObjectForKey:@"checkArgument"];
        self.fieldId = [coder decodeObjectForKey:@"fieldId"];
        self.controlType = [coder decodeObjectForKey:@"controlType"];
        self.activityIndicatorText = [coder decodeObjectForKey:@"activityIndicatorText"];
        self.isShowActivityIndicator = [[coder decodeObjectForKey:@"isShowActivityIndicator"]boolValue];
        self.isCanCancel = [[coder decodeObjectForKey:@"isCanCancel"]boolValue];
        self.isHavePassword = [[coder decodeObjectForKey:@"isHavePassword"]boolValue];
        self.publicKey = [coder decodeObjectForKey:@"publicKey"];
        self.passwordFields = [coder decodeObjectForKey:@"passwordFields"];
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone
{
	CSIIBusinessCaller *caller = [[CSIIBusinessCaller alloc]init];
    [caller setPageId:self.pageId];
    [caller setTransactionId:self.transactionId];
    [caller setTransactionArgument:self.transactionArgument];
    [caller setCheckArgument:self.checkArgument];
    [caller setFieldId:self.fieldId];
    [caller setControlType:self.controlType];
    [caller setActivityIndicatorText:self.activityIndicatorText];
    [caller setIsShowActivityIndicator:self.isShowActivityIndicator];
    [caller setIsCanCancel:self.isCanCancel];
    [caller setIsHavePassword:self.isHavePassword];
    [caller setPublicKey:self.publicKey];
    [caller setPasswordFields:self.passwordFields];
	return caller;
}
- (id)mutableCopyWithZone:(NSZone *)zone;
{
    CSIIBusinessCaller *caller = [[CSIIBusinessCaller alloc]init];
    [caller setPageId:self.pageId];
    [caller setTransactionId:self.transactionId];
    [caller setTransactionArgument:self.transactionArgument];
    [caller setCheckArgument:self.checkArgument];
    [caller setFieldId:self.fieldId];
    [caller setControlType:self.controlType];
    [caller setActivityIndicatorText:self.activityIndicatorText];
    [caller setIsShowActivityIndicator:self.isShowActivityIndicator];
    [caller setIsCanCancel:self.isCanCancel];
    [caller setIsHavePassword:self.isHavePassword];
    [caller setPublicKey:self.publicKey];
    [caller setPasswordFields:self.passwordFields];
	return caller;
}
@end
