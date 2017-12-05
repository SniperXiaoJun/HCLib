//
//  CPVxHelper.m
//  CPPlugins
//
//  Created by liurenpeng on 8/20/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CPVxHelper.h"
#import "CPDebug.h"
@implementation CPVxHelper
@synthesize delegate;
- (void)GetActionId;
{
    self.delegate = (id)self.webView;
    if ([self.delegate respondsToSelector:@selector(getActionIdWithWebView)]) {
        NSString* action =
            [self.delegate performSelector:@selector(getActionIdWithWebView)];
        self.pluginResponseCallback(action);
    }
}

- (void)GetParams
{
    self.delegate = (id)self.webView;
    if ([self.delegate respondsToSelector:@selector(getParamsWithWebView)]) {
        NSDictionary* params =
            [self.delegate performSelector:@selector(getParamsWithWebView)];
        self.pluginResponseCallback(params);
    }
}
@end
