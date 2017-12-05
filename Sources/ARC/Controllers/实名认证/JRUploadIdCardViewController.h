//
//  JRUploadIdCardViewController.h
//  Double
//
//  Created by 何崇 on 2017/11/29.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "JRRootViewController.h"
#import "JRBLMCameraViewController.h"

@interface JRUploadIdCardViewController : JRRootViewController
<UIImagePickerControllerDelegate,UINavigationControllerDelegate,JRBLMCameraViewControllerDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) NSString *phoneNumber;
@end
