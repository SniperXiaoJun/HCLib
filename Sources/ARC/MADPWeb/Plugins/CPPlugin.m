//
//  CPPlugin.m
//  CSIIPlatformLib
//
//  Created by liurenpeng on 6/18/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CPPlugin.h"
#import "CPDebug.h"
#import <objc/message.h>
#import <objc/runtime.h>
@interface CPPlugin ()
;
@end
@implementation CPPlugin
;
@synthesize webView, curViewController;
@synthesize commondName, curData, pluginResponseCallback;
@synthesize cpwebDelegate;
@synthesize aPluginData, aObject;
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)registPluginWithObject:(id)object withData:(id)data;
{
    self.aObject = object;
    self.aPluginData = data;
    self.curData = data;
    self.curViewController = (UIViewController *)object;
    
}

- (void)registPluginWithObject:(id)object
                      withData:(id)data
                      complete:(void (^)(id responseData))completeBlock;
{
    self.aObject = object;
    self.aPluginData = data;
    self.curData = data;
    self.curViewController = (UIViewController *)object;
    __weak typeof(self) weakSelf = self;
    
    self.pluginResponseCallback = ^(id responseData){
        
        NSLog(@"----------%@",weakSelf.curData);
        if([weakSelf.curData isKindOfClass:[NSDictionary class]]) {
            
            if ([weakSelf.curData objectForKey:@"callbackId"]) {
                
                NSDictionary *msg = @{
                                      @"responseId" : [weakSelf.curData objectForKey:@"callbackId"],
                                      @"responseData" : [weakSelf
                                                         otherTojson:responseData]
                                      };
                completeBlock(msg);
                
            }else{
                completeBlock([weakSelf
                               otherTojson:responseData]);
                
            }
        }else{
            completeBlock([weakSelf
                           otherTojson:responseData]);
        }
    };
}
- (void)registPluginWithObject:(id)object
                   withWebView:(UIWebView *)aWebView
                      withData:(id)data
                      complete:(void (^)(id responseData))completeBlock;
{
    self.aObject = object;
    self.aPluginData = data;
    self.curData = data;
    self.webView = aWebView;
    self.curViewController = (UIViewController *)object;
    __weak typeof(self) weakSelf = self;
    self.pluginResponseCallback = ^(id responseData){
        
        if([weakSelf.curData isKindOfClass:[NSDictionary class]]) {
            
            
            if ([weakSelf.curData objectForKey:@"callbackId"]) {
                
                NSDictionary *msg = @{
                                      @"responseId" : [weakSelf.curData objectForKey:@"callbackId"],
                                      @"responseData" : [weakSelf
                                                         otherTojson:responseData]
                                      };
                completeBlock(msg);
                
            }else{
                completeBlock([weakSelf
                               otherTojson:responseData]);
                
            }
            
            
        }else{
            completeBlock([weakSelf
                           otherTojson:responseData]);
            
            
            
        }
    };
    
}
- (NSString*)otherTojson:(id)other
{
    
    if (other != nil) {
        BOOL isTurnableToJSON = [NSJSONSerialization isValidJSONObject:other];
        if (isTurnableToJSON) {
            
            NSData* jsondata =
            [NSJSONSerialization dataWithJSONObject:other
                                            options:NSJSONWritingPrettyPrinted
                                              error:nil];
            NSString* jsonStr = [[NSString alloc] initWithData:jsondata
                                                      encoding:NSUTF8StringEncoding];
            
            return jsonStr;
        }
        else {
            
            return other;
        }
    }
    return nil;
}




- (void)dispose;
{
    self.webView = nil;
    self.curViewController = nil;
    self.curData = nil;
    self.aObject=nil;
}
//- (void)dealloc {
//  self.webView = nil;
//  self.curViewController = nil;
//  self.curData = nil;
//}
@end
