//
//  CPServer.m
//  CPBaseManager
//
//  Created by 刘任朋 on 15/11/16.
//  Copyright © 2015年 刘认朋. All rights reserved.
//

#import "CPServer.h"
#import "CSIIConfigGlobalImport.h"
@implementation CPServer
- (void)setRequestUrl;
{ //
  [CSIIBusinessContext sharedInstance].serverUrl =
      self.aPluginData[@"serverurl"];
  [CSIIBusinessContext sharedInstance].serverPath =
      self.aPluginData[@"serverpath"];
}
@end
