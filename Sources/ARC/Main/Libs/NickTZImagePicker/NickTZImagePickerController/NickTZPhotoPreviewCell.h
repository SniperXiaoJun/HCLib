//
//  NickTZPhotoPreviewCell.h
//  NickTZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NickTZAssetModel;
@interface NickTZAssetPreviewCell : UICollectionViewCell
@property (nonatomic, strong) NickTZAssetModel *model;
@property (nonatomic, copy) void (^singleTapGestureBlock)();
- (void)configSubviews;
- (void)photoPreviewCollectionViewDidScroll;
@end


@class NickTZAssetModel,NickTZProgressView,NickTZPhotoPreviewView;
@interface NickTZPhotoPreviewCell : NickTZAssetPreviewCell

@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);

@property (nonatomic, strong) NickTZPhotoPreviewView *previewView;

@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;

- (void)recoverSubviews;

@end


@interface NickTZPhotoPreviewView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) NickTZProgressView *progressView;

@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;

@property (nonatomic, strong) NickTZAssetModel *model;
@property (nonatomic, strong) id asset;
@property (nonatomic, copy) void (^singleTapGestureBlock)();
@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);

@property (nonatomic, assign) int32_t imageRequestID;

- (void)recoverSubviews;
@end


@class AVPlayer, AVPlayerLayer;
@interface NickTZVideoPreviewCell : NickTZAssetPreviewCell
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIImage *cover;
- (void)pausePlayerAndShowNaviBar;
@end


@interface NickTZGifPreviewCell : NickTZAssetPreviewCell
@property (strong, nonatomic) NickTZPhotoPreviewView *previewView;
@end

