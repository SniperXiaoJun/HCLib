//
//  CPPushView.m
//  CSIIPlatformLib
//
//  Created by liurenpeng on 6/23/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CPAction.h"
#import "CPContext.h"
#import "CPPluginsUtility.h"

@implementation CPAction

/**
 * @method
 * @abstract 打开原生页面窗口
 * @discussion：参数格式：JSON
 * @param js端传过来的参数
 * @result 返回值通过pluginResponseCallback  类型 string
 */

- (void)StartNativeAction {

  NSString *urlpath = self.curData[@"data"][@"Params"][@"Url"];
  if ([urlpath length] > 0) {

    SEL method = NSSelectorFromString(@"loadViewWithData:");

    id class =
        NSClassFromString(self.curData[@"data"][@"Params"][@"ClassName"]);
    if (!class) {
      [self.webView
          loadRequest:[CPPluginsUtility managerUrlPath:self.curData[@"data"][
                                                           @"Params"][@"Url"]]];
      return;
    }

    UIViewController *obj = [[class alloc] init];
    self.cpwebDelegate = (id)obj;
    if ([self.cpwebDelegate respondsToSelector:@selector(loadViewWithData:)]) {
      [self.cpwebDelegate
          performSelector:@selector(loadViewWithData:)
               withObject:self.curData[@"data"][@"Params"][@"Url"]];
      [self performSelectorOnMainThread:@selector(pushNativeView:)
                             withObject:obj
                          waitUntilDone:NO];
    } else {
      NSAssert([obj respondsToSelector:method],
               @"the @selector(loadViewWithData:) not find");
    }

  } else {
    NSString *className = self.curData[@"data"][@"Params"][@"ClassName"];
    id obj = nil;
    if ([className hasSuffix:@".storyboard"]) {

      className = [className substringToIndex:(className.length - 11)];
      UIStoryboard *viewStoryboard =
          [UIStoryboard storyboardWithName:className bundle:nil];
      obj = [viewStoryboard instantiateInitialViewController];
    } else {
      id class = NSClassFromString(className);
      obj = [[class alloc] init];
    }
    [self performSelectorOnMainThread:@selector(pushNativeView:)
                           withObject:obj
                        waitUntilDone:NO];
  }
}
- (void)pushNativeView:(id)obj {

  [CPContext sharedInstance].pluginCallBack = self.pluginResponseCallback;
  [self.curViewController.navigationController pushViewController:obj
                                                         animated:YES];
}
/**
 * @method
 * @abstract 调用系统浏览器显示url
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (void)StartSystemBrowserAction {
  NSString *urlText = [NSString stringWithFormat:@"http://www.baidu.com"];
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}
- (NSURLRequest *)managerUrlPath:(NSString *)urlpath {
  NSString *encodePath =
      [urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSString *urlStr = nil;
  if ([urlpath hasPrefix:@"http:"] || [urlpath hasPrefix:@"https:"]) {
    urlStr = encodePath;
  } else {
    encodePath = [[[NSBundle mainBundle] resourcePath]
        stringByAppendingPathComponent:urlpath];
    urlStr = [NSString stringWithFormat:@"file://%@", encodePath];
  }

  NSURL *url = [NSURL URLWithString:urlStr];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  return request;
}
@end
