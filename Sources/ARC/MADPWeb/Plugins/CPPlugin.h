//
//  CPPlugin.h
//  CSIIPlatformLib
//
//  Created by liurenpeng on 6/18/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CPWebViewDelegate.h"
typedef void (^PluginResponseCallback)(id pluginResponseData);
/*!
 * @class
 * @abstract
 * 客户端插件扩展类，客户端扩展插件，需要继承此类，在扩展插件中方法定义遵循public、void、唯一参数PluginEntity条件。
 */

@interface CPPlugin : NSObject {
@protected
  NSString *commondName;
@protected
  id curData;
@protected
  PluginResponseCallback pluginResponseCallback;

  id aPluginData;
  id aObject;
}

/*!
 * @property
 * @abstract 当前的webView
 */
@property(nonatomic, strong) UIWebView *webView;
/*!
 * @property
 * @abstract 当前的ViewController
 */

@property(nonatomic, strong) UIViewController *curViewController;
@property(nonatomic, copy) NSString *commondName;
@property(nonatomic, strong) id aPluginData;
@property(nonatomic, strong) id aObject;

/*!
 * @property
 * @abstract 当前的webView
 */

@property(nonatomic, assign) id<CPWebViewDelegate> cpwebDelegate;
/*!
 * @property
 * @abstract js端传过来的参数
 */
@property(nonatomic, strong) id curData;

/*!
 * @property
 * @abstract 数据回调block
 */
@property(nonatomic, strong) PluginResponseCallback pluginResponseCallback;

/**
 *  注册插件
 *
 *  @param object 注册插件时用到的对象
 *  @param data   注册插件是用到的数据
 */
- (void)registPluginWithObject:(id)object withData:(id)data;

/**
 *  注册插件
 *
 *  @param object        一个对象 调用插件所需要的对象
 *  @param data          一个数据 调用插件所需要的数据
 *  @param completeBlock 代码块
 */
- (void)registPluginWithObject:(id)object
                      withData:(id)data
                      complete:(void (^)(id responseData))completeBlock;
/**
 *  注册插件
 *
 *  @param object        一个对象 调用插件所需要的对象
 *  @param aWebView      webview对象
 *  @param data          一个数据 调用插件所需要的数据
 *  @param completeBlock 回调函数
 */
- (void)registPluginWithObject:(id)object
                   withWebView:(UIWebView *)aWebView
                      withData:(id)data
                      complete:(void (^)(id responseData))completeBlock;
- (void)dispose;
@end
