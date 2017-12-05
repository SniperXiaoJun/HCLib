//
//  CPContext.m
//  CPPlugins
//
//  Created by liurenpeng on 7/26/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CPContext.h"

@implementation CPContext
@synthesize pluginCallBack;
@synthesize pluginsDictionary;
@synthesize tabBarController;
@synthesize isReadZip;
@synthesize isUrlProtocol;
@synthesize isShowMask;
static CPContext *_sharedInstance;

- (id)init
{
    self = [super init];
    if (self) {
        self.pluginCallBack = nil;
    }
    return self;
}

+ (CPContext *)sharedInstance;
{
    @synchronized(self)
    {
        if (!_sharedInstance)
            _sharedInstance = [[CPContext alloc] init];
        return _sharedInstance;
    }
}
@end
