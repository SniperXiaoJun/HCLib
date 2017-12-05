//
//  CPWebViewDelegate.h
//  CPPlugins
//
//  Created by liurenpeng on 8/22/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

@protocol CPWebViewDelegate <NSObject>

@optional
- (void)loadViewWithData:(id)data;
@optional
- (NSString*)getActionIdWithWebView;
- (NSDictionary*)getParamsWithWebView;

@end
