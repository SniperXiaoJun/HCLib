//
//  WebViewJavascriptBridge.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 6/14/13.
//  Copyright (c) 2013 Marcus Westin. All rights reserved.
//

#import "CPWebViewJavascriptBridge.h"
#import "CPBase64.h"
#import "CPCacheUtility.h"
#import "CPDebug.h"
#if __has_feature(objc_arc_weak)
#define WVJB_WEAK __weak
#else
#define WVJB_WEAK __unsafe_unretained
#endif

typedef NSDictionary WVJBMessage;

@implementation CPWebViewJavascriptBridge {
  WVJB_WEAK WVJB_WEBVIEW_TYPE *_webView;
  WVJB_WEAK id _webViewDelegate;
  NSMutableArray *_startupMessageQueue;
  NSMutableDictionary *_responseCallbacks;
  NSMutableDictionary *_messageHandlers;
  NSMutableArray *_messageHandlersArray;

  long _uniqueId;
  WVJBHandler _messageHandler;

  NSBundle *_resourceBundle;

#if defined WVJB_PLATFORM_IOS
  NSUInteger _numRequestsLoading;
#endif
}

/* API
 *****/

static bool logging = false;
+ (void)enableLogging {
  logging = true;
}

+ (instancetype)bridgeForWebView:(WVJB_WEBVIEW_TYPE *)webView
                         handler:(WVJBHandler)handler {
  return [self bridgeForWebView:webView webViewDelegate:nil handler:handler];
}

+ (instancetype)bridgeForWebView:(WVJB_WEBVIEW_TYPE *)webView
                 webViewDelegate:(WVJB_WEBVIEW_DELEGATE_TYPE *)webViewDelegate
                         handler:(WVJBHandler)messageHandler {
  return [self bridgeForWebView:webView
                webViewDelegate:webViewDelegate
                        handler:messageHandler
                 resourceBundle:nil];
}

+ (instancetype)bridgeForWebView:(WVJB_WEBVIEW_TYPE *)webView
                 webViewDelegate:(WVJB_WEBVIEW_DELEGATE_TYPE *)webViewDelegate
                         handler:(WVJBHandler)messageHandler
                  resourceBundle:(NSBundle *)bundle {
  CPWebViewJavascriptBridge *bridge = [[CPWebViewJavascriptBridge alloc] init];
  [bridge _platformSpecificSetup:webView
                 webViewDelegate:webViewDelegate
                         handler:messageHandler
                  resourceBundle:bundle];
  return bridge;
}

- (void)send:(id)data {
  [self send:data responseCallback:nil];
}

- (void)send:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
  [self _sendData:data responseCallback:responseCallback handlerName:nil];
}

- (void)callHandler:(NSString *)handlerName {
  [self callHandler:handlerName data:nil responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName data:(id)data {
  [self callHandler:handlerName data:data responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName
               data:(id)data
   responseCallback:(WVJBResponseCallback)responseCallback {
  [self _sendData:data
      responseCallback:responseCallback
           handlerName:handlerName];
}

- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler {
  _messageHandlers[handlerName] = [handler copy];
}

/* Platform agnostic internals
 *****************************/

- (id)init {
  if (self = [super init]) {
    _startupMessageQueue = [NSMutableArray array];
    _responseCallbacks = [NSMutableDictionary dictionary];
    _uniqueId = 0;
  }
  return self;
}

- (void)dealloc {
  [self _platformSpecificDealloc];

  _webView = nil;
  _webViewDelegate = nil;
  _startupMessageQueue = nil;
  _responseCallbacks = nil;
  _messageHandlers = nil;
  _messageHandler = nil;
  _messageHandlersArray = nil;
}

- (void)_sendData:(id)data
 responseCallback:(WVJBResponseCallback)responseCallback
      handlerName:(NSString *)handlerName {
  NSMutableDictionary *message = [NSMutableDictionary dictionary];

  if (data) {
    message[@"data"] = data;
  }

  if (responseCallback) {
    NSString *callbackId =
        [NSString stringWithFormat:@"objc_cb_%ld", ++_uniqueId];
    _responseCallbacks[callbackId] = [responseCallback copy];
    message[@"callbackId"] = callbackId;
  }

  if (handlerName) {
    message[@"handlerName"] = handlerName;
  }
  [self _queueMessage:message];
}

- (void)_queueMessage:(WVJBMessage *)message {
  if (_startupMessageQueue) {
    [_startupMessageQueue addObject:message];
  } else {
    [self _dispatchMessage:message];
  }
}

- (void)_dispatchMessage:(WVJBMessage *)message {
  NSString *messageJSON = [self _serializeMessage:message];
  [self _log:@"SEND" json:messageJSON];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\"
                                                       withString:@"\\\\"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\""
                                                       withString:@"\\\""];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'"
                                                       withString:@"\\\'"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n"
                                                       withString:@"\\n"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r"
                                                       withString:@"\\r"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f"
                                                       withString:@"\\f"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028"
                                                       withString:@"\\u2028"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029"
                                                       withString:@"\\u2029"];

  NSString *javascriptCommand = [NSString
      stringWithFormat:@"WebViewJavascriptBridge._handleMessageFromObjC('%@');",
                       messageJSON];
  if ([[NSThread currentThread] isMainThread]) {
    [_webView stringByEvaluatingJavaScriptFromString:javascriptCommand];
  } else {
    __strong WVJB_WEBVIEW_TYPE *strongWebView = _webView;
    dispatch_sync(dispatch_get_main_queue(), ^{

      [strongWebView stringByEvaluatingJavaScriptFromString:javascriptCommand];
    });
  }
}

- (void)_flushMessageQueue {
  NSString *messageQueueString =
      [_webView stringByEvaluatingJavaScriptFromString:
                    @"WebViewJavascriptBridge._fetchQueue();"];

  id messages = [self _deserializeMessageJSON:messageQueueString];
  if (![messages isKindOfClass:[NSArray class]]) {
    NSLog(@"CPWebViewJavascriptBridge: WARNING: Invalid %@ received: %@",
             [messages class], messages);
    return;
  }
  for (WVJBMessage *message in messages) {
    if (![message isKindOfClass:[WVJBMessage class]]) {
      NSLog(@"CPWebViewJavascriptBridge: WARNING: Invalid %@ received: %@",
               [message class], message);
      continue;
    }
    [self _log:@"RCVD" json:message];

    NSString *responseId = message[@"responseId"];
    if (responseId) {
      WVJBResponseCallback responseCallback = _responseCallbacks[responseId];
      responseCallback(message[@"responseData"]);
      [_responseCallbacks removeObjectForKey:responseId];
    } else {
      WVJBResponseCallback responseCallback = NULL;
      NSString *callbackId = message[@"callbackId"];
      if (callbackId) {
        responseCallback = ^(id responseData) {
            
//            NSLog(@"Callback1");
          if (responseData == nil) {
            responseData = [NSNull null];
          }

//          WVJBMessage *msg = @{
//            @"responseId" : callbackId,
//            @"responseData" : responseData
//          };
          [self _queueMessage:responseData];
        };
      } else {
        responseCallback = ^(id ignoreResponseData) {
          // Do nothing
        };
      }

      WVJBHandler handler;
      if (message[@"handlerName"]) {

        handler = _messageHandlers[message[@"handlerName"]];
      } else {
        handler = _messageHandler;
      }

      if (!handler) {
        [NSException raise:@"WVJBNoHandlerException"
                    format:@"No handler for message from JS: %@", message];
      }
      NSDictionary *dic = [self dataFromBase64Econding:message];
      handler(dic, responseCallback);
    }
  }
}

- (NSString *)_serializeMessage:(id)message {
  return [[NSString alloc]
      initWithData:
          [NSJSONSerialization dataWithJSONObject:message options:0 error:nil]
          encoding:NSUTF8StringEncoding];
}

- (NSArray *)_deserializeMessageJSON:(NSString *)messageJSON {
  return [NSJSONSerialization
      JSONObjectWithData:[messageJSON dataUsingEncoding:NSUTF8StringEncoding]
                 options:NSJSONReadingAllowFragments
                   error:nil];
}

- (void)_log:(NSString *)action json:(id)json {
  if (!logging) {
    return;
  }
  if (![json isKindOfClass:[NSString class]]) {
    json = [self _serializeMessage:json];
  }
  if ([json length] > 500) {
//      DebugLog(@"--%@",json);
    NSLog(@"WVJB %@: %@ [...]", action, [json substringToIndex:500]);
  } else {
    NSLog(@"WVJB %@: %@", action, json);
  }
}
- (NSDictionary *)dataFromBase64Econding:(NSDictionary *)baseDic;
{
  NSMutableDictionary *dic =
      [NSMutableDictionary dictionaryWithDictionary:baseDic];
  if (dic[@"data"] && [dic[@"data"] isKindOfClass:[NSString class]]) {
      NSData *data = [CPBase64 decode:dic[@"data"]];
      
    NSError *error = nil;
    NSString *jsData =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingMutableContainers
                                          error:&error];
    if (error) {
      NSAssert(!error, @"NSJSONSerialization faild with csiiBase64");
    } else {
      [dic setObject:jsData forKey:@"data"];
    }
  }
  return dic;
}

/* Platform specific internals: OSX
 **********************************/
#if defined WVJB_PLATFORM_OSX

/* Platform specific internals: iOS
 **********************************/
#elif defined WVJB_PLATFORM_IOS

- (void)_platformSpecificSetup:(WVJB_WEBVIEW_TYPE *)webView
               webViewDelegate:(id<UIWebViewDelegate>)webViewDelegate
                       handler:(WVJBHandler)messageHandler
                resourceBundle:(NSBundle *)bundle {
  _messageHandler = messageHandler;
  _webView = webView;
  _webViewDelegate = webViewDelegate;
  _messageHandlers = [NSMutableDictionary dictionary];
  _messageHandlersArray = [[NSMutableArray alloc] init];

  _webView.delegate = self;
  _resourceBundle = bundle;
}

- (void)_platformSpecificDealloc {
  _webView.delegate = nil;
  [_webView stopLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  if (webView != _webView) {
    return;
  }

  _numRequestsLoading--;

  if (_numRequestsLoading == 0 &&
      ![[webView stringByEvaluatingJavaScriptFromString:
                     @"typeof WebViewJavascriptBridge == 'object'"]
          isEqualToString:@"true"]) {
    NSBundle *bundle =
        _resourceBundle ? _resourceBundle : [NSBundle mainBundle];
    NSString *filePath =
        [bundle pathForResource:@"CPWebViewJavascriptBridge.js" ofType:@"txt"];
    NSString *js = [NSString stringWithContentsOfFile:filePath
                                             encoding:NSUTF8StringEncoding
                                                error:nil];
    [webView stringByEvaluatingJavaScriptFromString:js];
  }

  if (_startupMessageQueue) {
    for (id queuedMessage in _startupMessageQueue) {
      [self _dispatchMessage:queuedMessage];
    }
    _startupMessageQueue = nil;
  }

  __strong WVJB_WEBVIEW_DELEGATE_TYPE *strongDelegate = _webViewDelegate;
  if (strongDelegate &&
      [strongDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
    [strongDelegate webViewDidFinishLoad:webView];
  }

  [[NSUserDefaults standardUserDefaults]
      setInteger:0
          forKey:@"WebKitCacheModelPreferenceKey"];
  [[NSUserDefaults standardUserDefaults]
      setBool:NO
       forKey:@"WebKitDiskImageCacheEnabled"];
  [[NSUserDefaults standardUserDefaults]
      setBool:NO
       forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  if (webView != _webView) {
    return;
  }

  _numRequestsLoading--;

  __strong WVJB_WEBVIEW_DELEGATE_TYPE *strongDelegate = _webViewDelegate;
  if (strongDelegate &&
      [strongDelegate
          respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
    [strongDelegate webView:webView didFailLoadWithError:error];
  }
}
/*
 * 方法的返回值是BOOL值。
 * 返回YES：表示让浏览器执行默认操作，比如某个a链接跳转
 * 返回NO：表示不执行浏览器的默认操作，
 //这里因为通过url协议来判断js执行native的操作，肯定不是浏览器默认操作，故返回NO
 */

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {

//  CPDLog(@"request:%@", request);
  if (webView != _webView) {
    return YES;
  }
  NSURL *url = [request URL];
  __strong WVJB_WEBVIEW_DELEGATE_TYPE *strongDelegate = _webViewDelegate;
  if ([[url scheme] isEqualToString:kCustomProtocolScheme]) {
    if ([[url host] isEqualToString:kQueueHasMessage]) {
      [self _flushMessageQueue];
    } else {
      NSLog(@"CPWebViewJavascriptBridge: WARNING: Received unknown "
               @"CPWebViewJavascriptBridge command %@://%@",
               kCustomProtocolScheme, [url path]);
    }
    return NO;
  } else if (strongDelegate &&
             [strongDelegate
                 respondsToSelector:@selector(webView:
                                        shouldStartLoadWithRequest:
                                                    navigationType:)]) {
    return [strongDelegate webView:webView
        shouldStartLoadWithRequest:request
                    navigationType:navigationType];
  } else {
    return YES;
  }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  if (webView != _webView) {
    return;
  }

  _numRequestsLoading++;

  __strong WVJB_WEBVIEW_DELEGATE_TYPE *strongDelegate = _webViewDelegate;
  if (strongDelegate &&
      [strongDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
    [strongDelegate webViewDidStartLoad:webView];
  }
}

#endif

@end
