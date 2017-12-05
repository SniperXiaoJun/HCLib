//
//  CPImgUpload.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/5/5.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "CPImgUpload.h"

//需要重写
#import "JRSYImagePickerViewController.h"

@implementation CPImgUpload
- (void)imgUpload{

    DebugLog(@"插件  图片 上传");
    DebugLog(@"imgUpload-------%@",self.curData[@"data"][@"Params"]);

    
    JRSYImagePickerViewController *picker = [[JRSYImagePickerViewController alloc] init];
    picker.style = 0;
    picker.paramsUpload = self.curData[@"data"][@"Params"];
    picker.uploadDone = ^(NSString *str) {
        self.pluginResponseCallback(@"success");
    };
    [Singleton.rootViewController pushViewController:picker animated:YES];


}
@end
