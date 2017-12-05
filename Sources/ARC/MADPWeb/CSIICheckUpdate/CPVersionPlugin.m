//
//  VersionPlugin.m
//  MainPlatform
//
//  Created by 刘任朋 on 15/11/8.
//  Copyright © 2015年 刘认朋. All rights reserved.
//

#import "CPVersionPlugin.h"
#import "CSIICheckVersionUpdate.h"
#import "CPConfigGlobalDefine.h"
#import "CSIIBusinessContext.h"
@implementation CPVersionPlugin {
  CSIICheckVersionUpdate *update;
}

//ClientType 1  ios   0 android
- (void)checkVersion {
    
    [CSIIBusinessContext sharedInstance].serverUrl = @"http://124.207.70.118:9074";
    Context.clientVersionId = @"1";
    [CSIIBusinessContext sharedInstance].serverPath = @"pmobile";
    
    NSString * strClientVersionId;
    if (!Context.clientVersionId || ![Context.clientVersionId isEqualToString:@""]) {
        strClientVersionId=Context.clientVersionId;

    }else
        strClientVersionId=@"1";

  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{
    @"ClientType" : @"1",
    @"ClientVersionId" : strClientVersionId
  }];

  update = [[CSIICheckVersionUpdate alloc] init];
  [update checkAppVersion:[CSIIBusinessContext sharedInstance].serverUrl
                withParam:dic
              checkFinish:^(id responsdata, BOOL success) {
                // self.pluginResponse(YES, @"");
                self.pluginResponseCallback(@"liu ren peng");

              }];
}
@end
