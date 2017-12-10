//
//  MAJPlugin.h
//  CPBaseManager
//
//  Created by 刘任朋 on 15/11/6.
//  Copyright © 2015年 刘认朋. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MAJDelegate.h"

typedef void (^MAJPluginResponseCallback)(BOOL states, id responseData);
typedef void (^MAJPluginBHandler)(id data,
                                  MAJPluginResponseCallback responseCallback);

@interface MAJPlugin : NSObject {
  id pluginData;
  id rigistPluginObject;
}
//@property(nonatomic, assign) id<MAJDelegate> majDelegate;
@property(nonatomic, strong) id pluginData;
@property(nonatomic, strong) id rigistPluginObject;
@property(nonatomic, strong) MAJPluginResponseCallback pluginResponse;
/**
 *  注册插件
 *
 *  @param object 注册插件时用到的对象
 *  @param data   注册插件是用到的数据
 */
- (void)registPluginWithObject:(id)object withData:(id)data;

- (void)registPluginWithObject:(id)object
                      withData:(id)data
                      complete:(void (^)(id responseData))completeBlock;
@end
