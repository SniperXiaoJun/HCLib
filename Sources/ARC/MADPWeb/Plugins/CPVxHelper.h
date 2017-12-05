//
//  CPVxHelper.h
//  CPPlugins
//
//  Created by liurenpeng on 8/20/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CPPlugin.h"
#import "CPWebViewDelegate.h"
@protocol CPPluginDelegate <NSObject>
@end
@interface CPVxHelper : CPPlugin
@property (nonatomic, assign) id<CPWebViewDelegate> delegate;

- (void)GetActionId;
- (void)GetParams;
///  皮肤
@end
