//
//  CPPluginsUtility.m
//  CPPlugins
//
//  Created by liurenpeng on 7/29/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CPPluginsUtility.h"

@implementation CPPluginsUtility
+ (NSURLRequest *)managerUrlPath:(NSString *)urlpath {
    
    //TODO:// 不转义url地址
    //  DebugLog(@"sy===urlpath===%@",urlpath);
//      NSString *encodePath =  [urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //  DebugLog(@"sy===encodePath===%@",encodePath);
    
  NSString *encodePath = urlpath; // 当url里面有#号时用这个
  NSString *urlStr = nil;
  if ([urlpath hasPrefix:@"http:"] || [urlpath hasPrefix:@"https:"]) {
    urlStr = encodePath;
  } else {
    NSRange range =
        [urlpath rangeOfString:[[NSBundle mainBundle] resourcePath]];
    if (!range.length) {
      urlpath = [[[NSBundle mainBundle] resourcePath]
          stringByAppendingPathComponent:urlpath];
      urlStr = [NSString stringWithFormat:@"file://%@", urlpath];
    } else {
      urlStr = [NSString stringWithFormat:@"file://%@", urlpath];
    }
  }
  NSURL *url = [NSURL URLWithString:urlStr];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  return request;
}
@end
