//
//  CPNetwork.h
//  CSIIPlatformLib
//
//  Created by liurenpeng on 7/15/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CPPlugin.h"

@interface CPNetwork : CPPlugin
- (void)RequestGetForString;
- (void)RequestPostForString;
- (void)RequestImageForDownload;
- (void)RequestImageForUpload;
@end
