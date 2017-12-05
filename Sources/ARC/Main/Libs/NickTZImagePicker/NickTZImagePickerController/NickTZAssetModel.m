//
//  NickTZAssetModel.m
//  NickTZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "NickTZAssetModel.h"
#import "NickTZImageManager.h"

@implementation NickTZAssetModel

+ (instancetype)modelWithAsset:(id)asset type:(NickTZAssetModelMediaType)type{
    NickTZAssetModel *model = [[NickTZAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = type;
    return model;
}

+ (instancetype)modelWithAsset:(id)asset type:(NickTZAssetModelMediaType)type timeLength:(NSString *)timeLength {
    NickTZAssetModel *model = [self modelWithAsset:asset type:type];
    model.timeLength = timeLength;
    return model;
}

@end



@implementation NickTZAlbumModel

- (void)setResult:(id)result {
    _result = result;
    BOOL allowPickingImage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tz_allowPickingImage"] isEqualToString:@"1"];
    BOOL allowPickingVideo = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tz_allowPickingVideo"] isEqualToString:@"1"];
    [[NickTZImageManager manager] getAssetsFromFetchResult:result allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage completion:^(NSArray<NickTZAssetModel *> *models) {
        _models = models;
        if (_selectedModels) {
            [self checkSelectedModels];
        }
    }];
}

- (void)setSelectedModels:(NSArray *)selectedModels {
    _selectedModels = selectedModels;
    if (_models) {
        [self checkSelectedModels];
    }
}

- (void)checkSelectedModels {
    self.selectedCount = 0;
    NSMutableArray *selectedAssets = [NSMutableArray array];
    for (NickTZAssetModel *model in _selectedModels) {
        [selectedAssets addObject:model.asset];
    }
    for (NickTZAssetModel *model in _models) {
        if ([[NickTZImageManager manager] isAssetsArray:selectedAssets containAsset:model.asset]) {
            self.selectedCount ++;
        }
    }
}

- (NSString *)name {
    if (_name) {
        return _name;
    }
    return @"";
}

@end

