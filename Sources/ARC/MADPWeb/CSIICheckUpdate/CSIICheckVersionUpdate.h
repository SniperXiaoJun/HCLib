//
//  CSIICheckVersionUpdate.h
//  CSIIPlatformLib
//
//  Created by liurenpeng on 10/20/15.
//  Copyright © 2015 刘任朋. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CSIICheckUtilityCallback)(id responsdata, BOOL success);

@interface CSIICheckVersionUpdate : NSObject
@property (nonatomic, strong) CSIICheckUtilityCallback checkCallBack;
- (void)checkAppVersion:(NSString*)url withParam:(NSMutableDictionary*)params checkFinish:(CSIICheckUtilityCallback)responsCallBackBlock;
@end
