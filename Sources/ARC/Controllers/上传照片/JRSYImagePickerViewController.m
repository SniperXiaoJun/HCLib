//
//  JRSYImagePickerViewController.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/5/5.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRSYImagePickerViewController.h"
#import "NickTZImagePickerController.h"
#import "UIView+NickLayout.h"
#import "NickTZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "NickLxGridViewFlowLayout.h"
#import "NickTZImageManager.h"
#import "NickTZVideoPlayerController.h"
#import "NickTZPhotoPreviewController.h"
#import "NickTZGifPhotoPreviewController.h"
#import "NickTZLocationManager.h"
#import "JRAllSuccessViewController.h"

@interface JRSYImagePickerViewController ()<NickTZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}


@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) NickLxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;


// 6个设置开关
@property (weak, nonatomic)  UISwitch *showTakePhotoBtnSwitch;  ///< 在内部显示拍照按钮
@property (weak, nonatomic)  UISwitch *sortAscendingSwitch;     ///< 照片排列按修改时间升序
@property (weak, nonatomic)  UISwitch *allowPickingVideoSwitch; ///< 允许选择视频
@property (weak, nonatomic)  UISwitch *allowPickingImageSwitch; ///< 允许选择图片
@property (weak, nonatomic)  UISwitch *allowPickingGifSwitch;
@property (weak, nonatomic)  UISwitch *allowPickingOriginalPhotoSwitch; ///< 允许选择原图
@property (weak, nonatomic)  UISwitch *showSheetSwitch; ///< 显示一个sheet,把拍照按钮放在外面
@property (weak, nonatomic)  UITextField *maxCountTF;  ///< 照片最大可选张数，设置为1即为单选模式
@property (weak, nonatomic)  UITextField *columnNumberTF;
@property (weak, nonatomic)  UISwitch *allowCropSwitch;
@property (weak, nonatomic)  UISwitch *needCircleCropSwitch;
@property (weak, nonatomic)  UISwitch *allowPickingMuitlpleVideoSwitch;



@end


#define maxCount  9

#define insideColumnNumber 4
@implementation JRSYImagePickerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片上传";
//    self.view.backgroundColor = BIGBGColor;
    self.view.backgroundColor = [UIColor whiteColor];

    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    [self configCollectionView];
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenHeight-43*DeviceScaleX, ScreenWidth, 43*DeviceScaleX)];
    nextButton.backgroundColor = RGB_COLOR(38,150,196);
    nextButton.titleLabel.font = DeviceFont(16);
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitle:@"保存并返回" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}
- (void)upload{
    /*
     MaxImgCount = 9,
     ImgType = GZZM,
     type = FJLB_05,
     name = GZZM,
     CifType = P
     */
    if (_selectedPhotos.count == 0) {
        alertView(@"图片不能为空");
    }
    DebugLog(@"上传中");
    DebugLog(@"_selectedPhotos   %@",_selectedPhotos);
    
//    self.paramsUpload = [NSDictionary dictionaryWithObjectsAndKeys:@"HH",@"ImgType",@"P",@"CifType",@"9",@"MaxImgCount", nil];
    
    NSMutableArray *pathArr = [[NSMutableArray alloc] initWithCapacity:_selectedPhotos.count];
    
    for (int i = 1; i <= _selectedPhotos.count;  i++) {
        
        UIImage *imagesave = _selectedPhotos[i-1];
        NSString *path_sandox = NSHomeDirectory();
        //设置一个图片的存储路径
        NSString *name = [NSString stringWithFormat:@"%@_%d.png",self.paramsUpload[@"ImgType"], i];
        NSString *picPath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",name]];

        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        [UIImagePNGRepresentation(imagesave) writeToFile:picPath atomically:YES];
        DebugLog(@"picPath: %@",picPath);
        [pathArr addObject:picPath];
    }
   
    DebugLog(@"_selectedAssets   %@",pathArr);
    
    NSMutableArray *attachInfoArr = [NSMutableArray array];

    NSMutableDictionary *img_params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
    NSMutableDictionary *fileDic = [[NSMutableDictionary alloc] init];
    for (int i = 1; i <= _selectedPhotos.count; i++ ) {
        [fileDic setObject:pathArr[i-1] forKey:[NSString stringWithFormat:@"ImgFile%d",i]];
        [img_params setObject:self.paramsUpload[@"CifType"] forKey:[NSString stringWithFormat:@"CifType%d",i]];
        if ([self.paramsUpload[@"MaxImgCount"] isEqualToString:@"1"]) {
            [img_params setObject:self.paramsUpload[@"ImgType"] forKey:[NSString stringWithFormat:@"ImgType%d",i]];

        }else{
            [img_params setObject:[NSString stringWithFormat:@"%@_%d",self.paramsUpload[@"ImgType"],i] forKey:[NSString stringWithFormat:@"ImgType%d",i]];
        }
        
        
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        [tempDict setObject:[NSString stringWithFormat:@"GRFCXX_%d",i] forKey:@"name"];
        [tempDict setObject:@"FJLB_06" forKey:@"type"];
        [attachInfoArr addObject:tempDict];

    }


    [img_params setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:@"UserId"];
    [img_params setObject:fileDic forKey:@"file"];
    [img_params setObject:[NSString stringWithFormat:@"%lu",(unsigned long)_selectedPhotos.count] forKey:@"counter"];

    new_transaction_caller
    caller.transactionId = @"ImgUpload.do";
    caller.webMethod = POST;
    caller.transactionArgument=img_params;
    caller.responsType = ResponsTypeOfImageData;
    execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
        if (TransactionIsSuccess) {
            DebugLog(@"哈哈哈--上传成功");
            self.uploadDone(@"图片上传成功");
            
            if (self.style == 0)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];

                [params setObject:@"P" forKey:@"PWDType"];
                
                if ([Singleton.userInfo[@"CifNo"] length]>0) {
                    [params setObject:Singleton.userInfo[@"CifNo"] forKey:@"custId"];
                }
                
                
                [params setObject:attachInfoArr forKey:@"attachInfos"];

                
                new_transaction_caller
                caller.transactionId = @"CtInformationUpload.do";
                caller.webMethod = POST;
                caller.transactionArgument=params;
                caller.responsType = ResponsTypeOfJson;
                caller.isShowActivityIndicator = YES;

                execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
                    if (TransactionIsSuccess) {
                       
                        JRAllSuccessViewController *r = [[JRAllSuccessViewController alloc]init];
//                        r.content = @"上传房产证成功";
//                        r.title = @"房产证上传";
                        [self.navigationController pushViewController:r animated:YES];
                    }else{
                        alerErr
                    }
                }));
                

            }
        }else{
          alerErr
        }
    }));
    
    
    
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[NickTZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[NickTZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    NickLxGridViewFlowLayout *layout = [[NickLxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 3 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH + 36);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.tz_width, self.view.tz_height-43) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    
    CGFloat rgb = 244/ 255.0;
    
//    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
//    _collectionView.backgroundColor = BIGBGColor;
    _collectionView.backgroundColor = [UIColor whiteColor];

    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[NickTZTestCell class] forCellWithReuseIdentifier:@"NickTZTestCell"];
}


#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NickTZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NickTZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = JRBundeImage(@"AlbumAddBtn");
        cell.deleteBtn.hidden = NO;
        [cell.deleteBtn setTitle:@"增加" forState:UIControlStateNormal];
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
        [cell.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];

    }
    if (!self.allowPickingGifSwitch.isOn) {
        cell.gifLable.hidden = YES;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        BOOL showSheet = self.showSheetSwitch.isOn;
        if (showSheet) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
            [sheet showInView:self.view];
        } else {
            [self pushImagePickerController];
        }
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        if ([[asset valueForKey:@"filename"] containsString:@"GIF"] && self.allowPickingGifSwitch.isOn) {
            NickTZGifPhotoPreviewController *vc = [[NickTZGifPhotoPreviewController alloc] init];
            NickTZAssetModel *model = [NickTZAssetModel modelWithAsset:asset type:NickTZAssetModelMediaTypePhotoGif timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else if (isVideo) { // perview video / 预览视频
            NickTZVideoPlayerController *vc = [[NickTZVideoPlayerController alloc] init];
            NickTZAssetModel *model = [NickTZAssetModel modelWithAsset:asset type:NickTZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            NickTZImagePickerController *imagePickerVc = [[NickTZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = maxCount;
            imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch.isOn;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    if (maxCount <= 0) {
        return;
    }
    NickTZImagePickerController *imagePickerVc = [[NickTZImagePickerController alloc] initWithMaxImagesCount:[self.paramsUpload[@"MaxImgCount"] intValue] columnNumber:insideColumnNumber delegate:self pushPhotoPickerVc:YES];
    
    
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    if (maxCount > 1) {
        //        // 1.设置目前已经选中的图片数组
                imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    
    
    
//#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
//    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
//    
//    if (maxCount > 1) {
//        // 1.设置目前已经选中的图片数组
//        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
//    }
//    imagePickerVc.allowTakePicture = self.showTakePhotoBtnSwitch.isOn; // 在内部显示拍照按钮
//    
//    // 2. Set the appearance
//    // 2. 在这里设置imagePickerVc的外观
//    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
//    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
//    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
//    // imagePickerVc.navigationBar.translucent = NO;
//    
//    // 3. Set allow picking video & photo & originalPhoto or not
//    // 3. 设置是否可以选择视频/图片/原图
//    imagePickerVc.allowPickingVideo = self.allowPickingVideoSwitch.isOn;
//    imagePickerVc.allowPickingImage = self.allowPickingImageSwitch.isOn;
//    imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch.isOn;
//    imagePickerVc.allowPickingGif = self.allowPickingGifSwitch.isOn;
//    
//    // 4. 照片排列按修改时间升序
//    imagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
//    
//    // imagePickerVc.minImagesCount = 3;
//    // imagePickerVc.alwaysEnableDoneBtn = YES;
//    
//    // imagePickerVc.minPhotoWidthSelectable = 3000;
//    // imagePickerVc.minPhotoHeightSelectable = 2000;
//    
//    /// 5. Single selection mode, valid when maxImagesCount = 1
//    /// 5. 单选模式,maxImagesCount为1时才生效
//    imagePickerVc.showSelectBtn = NO;
//    imagePickerVc.allowCrop = self.allowCropSwitch.isOn;
//    imagePickerVc.needCircleCrop = self.needCircleCropSwitch.isOn;
//    imagePickerVc.circleCropRadius = 100;
//    /*
//     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
//     cropView.layer.borderColor = [UIColor redColor].CGColor;
//     cropView.layer.borderWidth = 2.0;
//     }];*/
//    
//    //imagePickerVc.allowPreview = NO;
//#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([NickTZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([NickTZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[NickTZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        NickTZImagePickerController *tzImagePickerVc = [[NickTZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[NickTZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[NickTZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(NickTZAlbumModel *model) {
                    [[NickTZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<NickTZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        NickTZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (self.allowCropSwitch.isOn) { // 允许裁剪,去裁剪
                            NickTZImagePickerController *imagePicker = [[NickTZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            }];
                            imagePicker.needCircleCrop = self.needCircleCropSwitch.isOn;
                            imagePicker.circleCropRadius = 100;
                            [self presentViewController:imagePicker animated:YES completion:nil];
                        } else {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        }
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];

    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(NickTZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(NickTZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    if (iOS8Later) {
        for (PHAsset *phAsset in assets) {
            NSLog(@"location:%@",phAsset.location);
        }
    }
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(NickTZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(NickTZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [_collectionView reloadData];
}

// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
    /*
     if ([albumName isEqualToString:@"个人收藏"]) {
     return NO;
     }
     if ([albumName isEqualToString:@"视频"]) {
     return NO;
     }*/
    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(id)asset {
    /*
     if (iOS8Later) {
     PHAsset *phAsset = asset;
     switch (phAsset.mediaType) {
     case PHAssetMediaTypeVideo: {
     // 视频时长
     // NSTimeInterval duration = phAsset.duration;
     return NO;
     } break;
     case PHAssetMediaTypeImage: {
     // 图片尺寸
     if (phAsset.pixelWidth > 3000 || phAsset.pixelHeight > 3000) {
     // return NO;
     }
     return YES;
     } break;
     case PHAssetMediaTypeAudio:
     return NO;
     break;
     case PHAssetMediaTypeUnknown:
     return NO;
     break;
     default: break;
     }
     } else {
     ALAsset *alAsset = asset;
     NSString *alAssetType = [[alAsset valueForProperty:ALAssetPropertyType] stringValue];
     if ([alAssetType isEqualToString:ALAssetTypeVideo]) {
     // 视频时长
     // NSTimeInterval duration = [[alAsset valueForProperty:ALAssetPropertyDuration] doubleValue];
     return NO;
     } else if ([alAssetType isEqualToString:ALAssetTypePhoto]) {
     // 图片尺寸
     CGSize imageSize = alAsset.defaultRepresentation.dimensions;
     if (imageSize.width > 3000) {
     // return NO;
     }
     return YES;
     } else if ([alAssetType isEqualToString:ALAssetTypeUnknown]) {
     return NO;
     }
     }*/
    return YES;
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"增加"]) {
        return;
    }

    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

- (IBAction)showTakePhotoBtnSwitchClick:(UISwitch *)sender {
    if (sender.isOn) {
        [_showSheetSwitch setOn:NO animated:YES];
        [_allowPickingImageSwitch setOn:YES animated:YES];
    }
}

- (IBAction)showSheetSwitchClick:(UISwitch *)sender {
    if (sender.isOn) {
        [_showTakePhotoBtnSwitch setOn:NO animated:YES];
        [_allowPickingImageSwitch setOn:YES animated:YES];
    }
}

- (IBAction)allowPickingOriginPhotoSwitchClick:(UISwitch *)sender {
    if (sender.isOn) {
        [_allowPickingImageSwitch setOn:YES animated:YES];
        [self.needCircleCropSwitch setOn:NO animated:YES];
        [self.allowCropSwitch setOn:NO animated:YES];
    }
}

- (IBAction)allowPickingImageSwitchClick:(UISwitch *)sender {
    if (!sender.isOn) {
        [_allowPickingOriginalPhotoSwitch setOn:NO animated:YES];
        [_showTakePhotoBtnSwitch setOn:NO animated:YES];
        [_allowPickingVideoSwitch setOn:YES animated:YES];
        [_allowPickingGifSwitch setOn:NO animated:YES];
    }
}

- (IBAction)allowPickingGifSwitchClick:(UISwitch *)sender {
    if (sender.isOn) {
        [_allowPickingImageSwitch setOn:YES animated:YES];
    } else if (!self.allowPickingVideoSwitch.isOn) {
        [self.allowPickingMuitlpleVideoSwitch setOn:NO animated:YES];
    }
}

- (IBAction)allowPickingVideoSwitchClick:(UISwitch *)sender {
    if (!sender.isOn) {
        [_allowPickingImageSwitch setOn:YES animated:YES];
        if (!self.allowPickingGifSwitch.isOn) {
            [self.allowPickingMuitlpleVideoSwitch setOn:NO animated:YES];
        }
    }
}

- (IBAction)allowCropSwitchClick:(UISwitch *)sender {
    if (sender.isOn) {
        self.maxCountTF.text = @"1";
        [self.allowPickingOriginalPhotoSwitch setOn:NO animated:YES];
    } else {
        if ([self.maxCountTF.text isEqualToString:@"1"]) {
            self.maxCountTF.text = @"9";
        }
        [self.needCircleCropSwitch setOn:NO animated:YES];
    }
}

- (IBAction)needCircleCropSwitchClick:(UISwitch *)sender {
    if (sender.isOn) {
        [self.allowCropSwitch setOn:YES animated:YES];
        self.maxCountTF.text = @"1";
        [self.allowPickingOriginalPhotoSwitch setOn:NO animated:YES];
    }
}

- (IBAction)allowPickingMultipleVideoSwitchClick:(UISwitch *)sender {

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        NSLog(@"图片名字:%@",fileName);
    }
}










- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#pragma clang diagnostic pop

@end
