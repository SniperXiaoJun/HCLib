//
//  NickTZAssetCell.h
//  NickTZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef enum : NSUInteger {
    NickTZAssetCellTypePhoto = 0,
    NickTZAssetCellTypeLivePhoto,
    NickTZAssetCellTypePhotoGif,
    NickTZAssetCellTypeVideo,
    NickTZAssetCellTypeAudio,
} NickTZAssetCellType;

@class NickTZAssetModel;
@interface NickTZAssetCell : UICollectionViewCell

@property (weak, nonatomic) UIButton *selectPhotoButton;
@property (nonatomic, strong) NickTZAssetModel *model;
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);
@property (nonatomic, assign) NickTZAssetCellType type;
@property (nonatomic, assign) BOOL allowPickingGif;
@property (nonatomic, assign) BOOL allowPickingMultipleVideo;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) int32_t imageRequestID;

@property (nonatomic, copy) NSString *photoSelImageName;
@property (nonatomic, copy) NSString *photoDefImageName;

@property (nonatomic, assign) BOOL showSelectBtn;
@property (assign, nonatomic) BOOL allowPreview;

@end


@class NickTZAlbumModel;

@interface NickTZAlbumCell : UITableViewCell

@property (nonatomic, strong) NickTZAlbumModel *model;
@property (weak, nonatomic) UIButton *selectedCountButton;

@end


@interface NickTZAssetCameraCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end
