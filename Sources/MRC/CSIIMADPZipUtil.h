//  CSIIMADPZipUtil.h
//  ShangHangKuaiXianWebLib
//
//  Created by liuwang on 15-1-29.
//  Copyright (c) 2015年 刘旺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSIIMADPZipUtil : NSObject
{
    NSMutableArray *dirFileList;
@private
	NSThread *_testThread;
}
+(void) zipWithPassword;
+(void) unZipFromBundleWithPassword:(NSString *) fileName;
+(void) unZipFromCachesWithPassword;

/**打包某一个文件夹下的所有内容*/
+(void) zipWithPasswordForDictionary:(NSString *) dirName;
/**将下载下来的zip包解压到ReactNative资源文件引用目录下*/
+(void) unZipFromDocumentToReactNativeBundle:(NSString *) fileName;

+(void) copyReactNativeBundleImages:(NSString *) dirName;

@end
