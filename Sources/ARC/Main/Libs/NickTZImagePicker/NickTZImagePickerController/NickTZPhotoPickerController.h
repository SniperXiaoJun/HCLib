//
//  NickTZPhotoPickerController.h
//  NickTZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NickTZAlbumModel;
@interface NickTZPhotoPickerController : UIViewController

@property (nonatomic, assign) BOOL isFirstAppear;
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, strong) NickTZAlbumModel *model;
@end


@interface NickTZCollectionView : UICollectionView

@end
