//
//  CPContext.h
//  CPPlugins
//
//  Created by liurenpeng on 7/26/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^CPContextPluginCallBack)(id pluginResponseData);
@interface CPContext : NSObject
@property (nonatomic,strong)CPContextPluginCallBack pluginCallBack;
@property (nonatomic,strong)NSDictionary *pluginsDictionary;
@property (nonatomic,strong)UIViewController *tabBarController;
@property (nonatomic,assign)BOOL isReadZip;
@property (nonatomic,assign)BOOL isUrlProtocol;
@property (nonatomic,assign)BOOL isShowMask;


+ (CPContext *)sharedInstance;
@end
