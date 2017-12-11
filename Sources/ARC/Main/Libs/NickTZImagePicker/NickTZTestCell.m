//
//  NickTZTestCell.m
//  NickTZImagePickerController
//
//  Created by 谭真 on 16/1/3.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "NickTZTestCell.h"
#import "UIView+NickLayout.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NickTZImagePickerController/NickTZImagePickerController.h"

@implementation NickTZTestCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
        
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.image = [UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlayjr"];
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImageView.hidden = YES;
        [self addSubview:_videoImageView];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_deleteBtn setImage:[UIImage imageNamed:@"photo_delete"] forState:UIControlStateNormal];
//        _deleteBtn.frame = CGRectMake(self.tz_width - 36, 0, 36, 36);
//        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, -10);

        _deleteBtn.frame = CGRectMake(0, self.tz_height-36,self.tz_width, 36);
        [_deleteBtn setTitleColor:RGB_COLOR(38,150,196) forState:UIControlStateNormal];
        [_deleteBtn setBackgroundColor:[UIColor whiteColor]];
        _deleteBtn.titleLabel.font = DeviceFont(13);
        [self addSubview:_deleteBtn];
        
        _gifLable = [[UILabel alloc] init];
        _gifLable.text = @"GIF";
        _gifLable.textColor = [UIColor whiteColor];
        _gifLable.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _gifLable.textAlignment = NSTextAlignmentCenter;
        _gifLable.font = [UIFont systemFontOfSize:10];
        [self addSubview:_gifLable];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    _imageView.frame = self.bounds;
    _imageView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height-36);

    CGFloat width = self.tz_width / 3.0;
    _videoImageView.frame = CGRectMake(width, width, width, width);
}

- (void)setAsset:(id)asset {
    _asset = asset;
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        _videoImageView.hidden = phAsset.mediaType != PHAssetMediaTypeVideo;
        _gifLable.hidden = ![[phAsset valueForKey:@"filename"] tz_containsString:@"GIF"];
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = asset;
        _videoImageView.hidden = ![[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        _gifLable.hidden = YES;
    }
 }

- (void)setRow:(NSInteger)row {
    _row = row;
    _deleteBtn.tag = row;
}

- (UIView *)snapshotView {
    UIView *snapshotView = [[UIView alloc]init];
    
    UIView *cellSnapshotView = nil;
    
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    } else {
        CGSize size = CGSizeMake(self.bounds.size.width + 20, self.bounds.size.height + 20);
        UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];
    }
    
    snapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    
    [snapshotView addSubview:cellSnapshotView];
    return snapshotView;
}

@end
