//
//  CPCamera.m
//  CPPlugins
//
//  Created by 任兴 on 15/7/20.
//  Copyright (c) 2015年 刘任朋. All rights reserved.
//

#import "CPImage.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height-200
#define PAGE_CONTROL_HEIGHT 20
#define IMAGE_COUNT 10

@interface CPImage ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
{
    UIImagePickerController *imagePicker;
    BOOL isImagePath;
    BOOL isPhotoCrop;


}
@end
@implementation CPImage

-(void)CaptureImage{
    isImagePath=NO;
    isPhotoCrop=YES;

    [self showImage];
}
- (void)CapturePhoto{
    isImagePath=YES;
    isPhotoCrop=NO;

    [self showImage];

}
- (void)CapturePhotoCrop{
    isImagePath=YES;
    isPhotoCrop=YES;
    [self showImage];
    
}


-(void)showImage{
    if ([self.curData[@"data"][@"Params"] isEqualToString:@"photo"]) {
        UIActionSheet * sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:nil, nil];
        [sheet showInView:self.curViewController.view];
        
    }else   if ([self.curData[@"data"][@"Params"] isEqualToString:@"photograph"]) {
        
        UIActionSheet * sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:nil, nil];
        [sheet showInView:self.curViewController.view];
        
    }else{
        
        UIActionSheet * sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
        [sheet showInView:self.curViewController.view];
        
    }

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0://照相机
        {
            
            if ([self.curData[@"data"][@"Params"] isEqualToString:@"photo"]) {
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    
                    imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.delegate = self;
                    if (isPhotoCrop) {
                        imagePicker.allowsEditing = YES;

                    }else{
                        imagePicker.allowsEditing = NO;
                    }
                    
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self.curViewController presentViewController:imagePicker animated:YES completion:nil];
                }else{
                    DebugLog(@"模拟器无法打开相机");
                }
                
                
            }else{
                
                imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                if (isPhotoCrop) {
                    imagePicker.allowsEditing = YES;
                    
                }else{
                    imagePicker.allowsEditing = NO;
                }
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //            [self presentModalViewController:imagePicker animated:YES];
                [self.curViewController presentViewController:imagePicker animated:YES completion:nil];
            }
            
            
            
        }
            break;
        case 1://本地相簿
        {
            
            
            if ([self.curData[@"data"][@"Params"] isEqualToString:@"photo"]||[self.curData[@"data"][@"Params"] isEqualToString:@"photograph"]) {
                
                [imagePicker dismissViewControllerAnimated:YES completion:nil];
            }else{
                
                
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    
                    imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.delegate = self;
                    if (isPhotoCrop) {
                        imagePicker.allowsEditing = YES;
                        
                    }else{
                        imagePicker.allowsEditing = NO;
                    }
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self.curViewController presentViewController:imagePicker animated:YES completion:nil];
                }else{
                    DebugLog(@"模拟器无法打开相机");
                }
                
                
            }
            
            
        }
            break;
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    CGSize size = CGSizeMake(200,200);  // 设置尺寸
    UIImage *  image;
    if (isPhotoCrop){
        image=[info objectForKey:UIImagePickerControllerEditedImage];

    
    }else{
        image=[info objectForKey:UIImagePickerControllerOriginalImage];

    }
    UIImage *img = [self thumbnailWithImageWithoutScale:image size:size];
    
    if (isImagePath) {
        self.pluginResponseCallback([self saveImage:img]);
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else{
        //转换成base64
        NSData *_data;
        
        if (UIImagePNGRepresentation(img)) {
            //返回为png图像。
            _data = UIImagePNGRepresentation(img);
        }else {
            //返回为JPEG图像。
            _data = UIImageJPEGRepresentation(img, 1.0);
        }
        
        /**需对图片缩放*/
        NSString * _encodedImageStr = [_data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        self.pluginResponseCallback(_encodedImageStr);
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [picker dismissViewControllerAnimated:YES completion:nil];
}

//保存图片
- (NSString * )saveImage:(UIImage *)image {
    
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Picture"] ;
    
    
    if (![fileManager fileExistsAtPath:documentsDirectory]) {
        [fileManager createDirectoryAtPath:documentsDirectory
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    
    NSString *  imageType;
    if (UIImagePNGRepresentation(image)) {
        imageType=@"png";
    }else{
        imageType=@"jpg";
        
    }
    NSDateFormatter * form=[[NSDateFormatter alloc]init];
    [form setDateFormat:@"yyyyMMddHHmmss"];
    NSString *   dateTime=[form stringFromDate:[NSDate date]];
    
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",dateTime,imageType]];
    
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    return imageFilePath;
}
//生成图片缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    
    UIImage *newImage = nil;
    
    CGSize originalSize = image.size;//获取原始图片size
    
    CGFloat originalWidth = originalSize.width;//宽
    
    CGFloat originalHeight = originalSize.height;//高
    
    if ((originalWidth <= asize.width) && (originalHeight <= asize.height)) {
        
        newImage = image;//宽和高同时小于要压缩的尺寸时返回原尺寸
        
    }
    
    else{
        
        //新图片的宽和高
        
        CGFloat scale = (float)asize.width/originalWidth < (float)asize.height/originalHeight ? (float)asize.width/originalWidth : (float)asize.height/originalHeight;
        
        CGSize newImageSize = CGSizeMake(originalWidth*scale , originalHeight*scale );
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newImageSize.width , newImageSize.height ), NO, 0);
        
        [image drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        if (newImage == nil) {
            
            NSLog(@"image ");
            
        }
        
        UIGraphicsEndImageContext();
        
    }
    
    return newImage;
    
}




@end
