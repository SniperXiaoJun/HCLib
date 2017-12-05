//
//  CPApp.m
//  CSIIPlatformLib
//
//  Created by liurenpeng on 6/30/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CPApp.h"
#import "CPPluginsUtility.h"
@implementation CPApp

- (void)LoadUrl;
{

  if (self.curData[@"data"][@"Params"]) {
    [self.webView
        loadRequest:[CPPluginsUtility
                        managerUrlPath:self.curData[@"data"][@"Params"]]];
  }
}
- (void)GoBack {
  [self goBack:self.curData];
}
- (void)goBack:(id)data {

  if ([self.webView canGoBack]) {
    [self.webView goBack];
  } else {
    [self.curViewController.navigationController popViewControllerAnimated:YES];
  }
}

- (void)Exit {
  [self exit:self.curData];
}

- (void)exit:(id)data {
  if (self.curViewController) {
    [self.curViewController.navigationController popViewControllerAnimated:YES];
    self.pluginResponseCallback(@"exit");
    [self ClearCache];
  }
}
    
- (void)ClearHistory {
  [self clearHistory:self.curData];
}
- (void)clearHistory:(id)data {
  self.webView.delegate = nil;
  self.cpwebDelegate = nil;
  self.webView = nil;
  self.curViewController = nil;
  self.pluginResponseCallback = nil;
}

- (void)ClearCache {

  [self clearCache:self.curData];
}
- (void)clearCache:(id)data {
  [[NSURLCache sharedURLCache] removeAllCachedResponses];
  self.webView.delegate = nil;
  self.cpwebDelegate = nil;
  self.webView = nil;
  self.curViewController = nil;
  self.pluginResponseCallback = nil;
}
@end
