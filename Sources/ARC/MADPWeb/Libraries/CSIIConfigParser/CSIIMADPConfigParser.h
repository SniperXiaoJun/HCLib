//
//  CSIIMADPConfigParser.h
//  CSIIPlatformLib
//
//  Created by liurenpeng on 6/18/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSIIMADPConfigParser : NSObject
{
    NSString* featureName;
}

@property (nonatomic, readonly, strong) NSMutableDictionary* pluginsDict;
@property (nonatomic, readonly, strong) NSMutableDictionary* settings;
@property (nonatomic, readonly, strong) NSMutableArray* whitelistHosts;
@property (nonatomic, readonly, strong) NSMutableArray* startupPluginNames;
@property (nonatomic, readonly, strong) NSString* startPage;
@end
