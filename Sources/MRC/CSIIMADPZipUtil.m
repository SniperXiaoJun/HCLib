//
//  CSIIMADPZipUtil.m
//  ShangHangKuaiXianWebLib
//
//  Created by liuwang on 15-1-29.
//  Copyright (c) 2015年 刘旺. All rights reserved.
//

#import "CSIIMADPZipUtil.h"
#import "CSIIMADPZipFile.h"
#import "CSIIMADPZipException.h"
#import "CSIIMADPFileInZipInfo.h"
#import "CSIIMADPZipWriteStream.h"
#import "CSIIMADPZipReadStream.h"

//文件夹名称
#define NATIVE_FOLDERNAME @"reactNative"
#define DOCUMENTS         @"Documents"

@implementation CSIIMADPZipUtil


//返回需要加密文件的全路径
+ (NSMutableArray *)allFilesAtPath:(NSString *)dirString{
    NSError *error = nil;
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirString error:&error];
    for (NSString *fileName in contentOfFolder) {
        NSString * fullPath = [dirString stringByAppendingPathComponent:fileName];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir){
            // ignore .DS_Store
            if (![[fileName substringToIndex:1] isEqualToString:@"."]) {
                [dirFileList addObject:fullPath];
            }
        }else{
            [[self class] allFilesAtPath:fullPath];
        }
    }
    if(contentOfFolder==nil || contentOfFolder.count==0)
    {
        if (![[ [dirString lastPathComponent] substringToIndex:1] isEqualToString:@"."]) {
            [dirFileList addObject:dirString];
        }
    }
    return dirFileList;
}

static NSMutableArray *dirFileList;

+(void)zipWithPasswordForDictionary:(NSString *) dirName{
  [dirFileList removeAllObjects];
  dirFileList = nil;
  dirFileList = [[NSMutableArray alloc] init];
  NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
  @try {
    NSString *zipName = [[dirName componentsSeparatedByString:@"/"] lastObject];
    NSString *zipFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:DOCUMENTS] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",zipName]];
    [[NSFileManager defaultManager] removeItemAtPath:zipFilePath error:nil];
    
    CSIIMADPZipFile *zipFile = [[CSIIMADPZipFile alloc] initWithFileName:zipFilePath mode:CSIIMADPZipFileModeCreate];
    NSError *error = nil;
    NSString *documentDir = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dirName];
    NSMutableArray *dirFileListArray = [[self class] allFilesAtPath:documentDir];
    for (NSString *dirFileName in dirFileListArray) {
      NSInteger index = [dirFileName rangeOfString:zipName].location;
      NSString * fileName = [dirFileName substringFromIndex:index];
      if (![fileName isEqualToString:@".DS_Store"]) {
        // 获取文件创建日期
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:dirFileName error:&error];
        NSDate *date = [attributes objectForKey:NSFileCreationDate];
        //加密压缩文件
        CSIIMADPZipWriteStream *writeStream = [zipFile writeFileInZipWithName:fileName  fileDate:date compressionLevel:ZipCompressionLevelFastest password:@"123456" crc32:0];
        NSData *data = [NSData dataWithContentsOfFile:dirFileName];
        [writeStream writeData:data];
        [writeStream finishedWriting];
      }
    }
    // 关闭zip文件
    [zipFile close];
    [zipFile release];
  }@catch (id e) {
    //NSLog(@"Exception caught: %@ - %@", [[e class] description], [e description]);
  }
  [pool drain];
}

/**解压Document目录下的某个文件*/
+(void)unZipWithPasswordForDocument:(NSString *)fileName{
  NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
  @try {
    NSString *zipFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:DOCUMENTS] stringByAppendingPathComponent:fileName];
    NSString *unzipFileDir = [NSHomeDirectory() stringByAppendingPathComponent:DOCUMENTS];
    NSLog(@"____解压地址：%@",unzipFileDir);
    if( ! [[NSFileManager defaultManager] fileExistsAtPath:zipFilePath])
    {
      return;
    }
    CSIIMADPZipFile *unzipFile= [[CSIIMADPZipFile alloc] initWithFileName:zipFilePath mode:CSIIMADPZipFileModeUnzip];
    int num = (uInt)[unzipFile numFilesInZip];
    if (num < 1)
    {
      return;
    }
    [unzipFile goToFirstFileInZip];
    for (int i= 0; i < num; i++)
    {
      CSIIMADPZipReadStream *readStream= [unzipFile readCurrentFileInZipWithPassword:@"123456"];
      CSIIMADPFileInZipInfo *info= [unzipFile getCurrentFileInZipInfo];
      NSString *fileNamePath = info.name;
      NSString *fileFullPath = [unzipFileDir stringByAppendingPathComponent:fileNamePath];
      if(info.length > 0 || [info.name rangeOfString:@"."].location != NSNotFound)
      {
        NSData *data = [readStream readDataOfLength:info.length];
        NSString *fileFullDir = [fileFullPath stringByDeletingLastPathComponent];
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:fileFullDir withIntermediateDirectories:YES attributes:nil error:&error];
        [[NSFileManager defaultManager] createFileAtPath:fileFullPath contents:data attributes:nil];
      }
      else
      {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:fileFullPath withIntermediateDirectories:YES attributes:nil error:&error];
      }
      [readStream finishedReading];
      if ((i +1) < num)
      {
        [unzipFile goToNextFileInZip];
      }
    }
    [unzipFile close];
    [unzipFile release];
  } @catch (id e) {
    //NSLog(@"Exception caught: %@ - %@", [[e class] description], [e description]);
  }
  [pool drain];
}

+(void)copyReactNativeBundleImages:(NSString *)dirName{
  [dirFileList removeAllObjects];
  dirFileList = nil;
  dirFileList = [[NSMutableArray alloc] init];
  //判断资源文件夹是否存在
  NSString *documentZipFilePath= [[NSHomeDirectory() stringByAppendingPathComponent:DOCUMENTS] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",dirName]];
  if([[NSFileManager defaultManager] fileExistsAtPath:documentZipFilePath]){
    NSLog(@"___文件已存在，无需复制。");
    return;
  }
  NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
  @try {
    
    [[self class] zipWithPasswordForDictionary:dirName];
    
    NSString *documentZipFilePath= [[NSHomeDirectory() stringByAppendingPathComponent:DOCUMENTS] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",dirName]];
    NSString *unzipFileDir = [NSHomeDirectory() stringByAppendingPathComponent:DOCUMENTS];
    if( ! [[NSFileManager defaultManager] fileExistsAtPath:documentZipFilePath])
    {
      return;
    }
    CSIIMADPZipFile *unzipFile= [[CSIIMADPZipFile alloc] initWithFileName:documentZipFilePath mode:CSIIMADPZipFileModeUnzip];
    int num = (uInt)[unzipFile numFilesInZip];
    if (num < 1)
    {
      return;
    }
    [unzipFile goToFirstFileInZip];
    for (int i= 0; i < num; i++)
    {
      CSIIMADPZipReadStream *readStream= [unzipFile readCurrentFileInZipWithPassword:@"123456"];
      CSIIMADPFileInZipInfo *info= [unzipFile getCurrentFileInZipInfo];
      NSString *fileNamePath = info.name;
      NSString *fileFullPath = [unzipFileDir stringByAppendingPathComponent:fileNamePath];
      if(info.length > 0 || [info.name rangeOfString:@"."].location != NSNotFound)
      {
        NSData *data = [readStream readDataOfLength:info.length];
        NSString *fileFullDir = [fileFullPath stringByDeletingLastPathComponent];
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:fileFullDir withIntermediateDirectories:YES attributes:nil error:&error];
        [[NSFileManager defaultManager] createFileAtPath:fileFullPath contents:data attributes:nil];
      }
      else
      {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:fileFullPath withIntermediateDirectories:YES attributes:nil error:&error];
      }
      [readStream finishedReading];
      if ((i +1) < num)
      {
        [unzipFile goToNextFileInZip];
      }
    }
    [unzipFile close];
    [unzipFile release];
  } @catch (id e) {
    //NSLog(@"Exception caught: %@ - %@", [[e class] description], [e description]);
  }
  [pool drain];
  
  NSString *zipFilePath= [[NSHomeDirectory() stringByAppendingPathComponent:DOCUMENTS] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",dirName]];
  [[NSFileManager defaultManager] removeItemAtPath:zipFilePath error:nil];
}

+(void)unZipFromDocumentToReactNativeBundle:(NSString *)fileName{
  //先copy
  [[self class] copyReactNativeBundleImages:@"assets"];
  NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
  @try {
    NSString *zipFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:DOCUMENTS] stringByAppendingPathComponent:fileName];
    NSString *unzipFileDir= [[NSHomeDirectory() stringByAppendingPathComponent:DOCUMENTS] stringByAppendingPathComponent:@"assets/App"];
    NSLog(@"____解压地址：%@",unzipFileDir);
    if( ! [[NSFileManager defaultManager] fileExistsAtPath:zipFilePath])
    {
      return;
    }
    CSIIMADPZipFile *unzipFile= [[CSIIMADPZipFile alloc] initWithFileName:zipFilePath mode:CSIIMADPZipFileModeUnzip];
    int num = (uInt)[unzipFile numFilesInZip];
    if (num < 1)
    {
      return;
    }
    [unzipFile goToFirstFileInZip];
    for (int i= 0; i < num; i++)
    {
      CSIIMADPZipReadStream *readStream= [unzipFile readCurrentFileInZipWithPassword:@"123456"];
      CSIIMADPFileInZipInfo *info= [unzipFile getCurrentFileInZipInfo];
      NSString *fileNamePath = info.name;
      NSString *fileFullPath = [unzipFileDir stringByAppendingPathComponent:fileNamePath];
      if(info.length > 0 || [info.name rangeOfString:@"."].location != NSNotFound)
      {
        NSData *data = [readStream readDataOfLength:info.length];
        NSString *fileFullDir = [fileFullPath stringByDeletingLastPathComponent];
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:fileFullDir withIntermediateDirectories:YES attributes:nil error:&error];
        [[NSFileManager defaultManager] createFileAtPath:fileFullPath contents:data attributes:nil];
      }
      else
      {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:fileFullPath withIntermediateDirectories:YES attributes:nil error:&error];
      }
      [readStream finishedReading];
      if ((i +1) < num)
      {
        [unzipFile goToNextFileInZip];
      }
    }
    [unzipFile close];
    [unzipFile release];
  } @catch (id e) {
    //NSLog(@"Exception caught: %@ - %@", [[e class] description], [e description]);
  }
  [pool drain];
}

+(void) zipWithPassword {
  [dirFileList removeAllObjects];
  dirFileList = nil;
    dirFileList = [[NSMutableArray alloc] init];

    NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
	@try {
        //需要加密文件的路径
        NSError *error = nil;
        NSString *documentDir = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:NATIVE_FOLDERNAME];
        //加密压缩,设置压保存压缩文件路径
        //NSLog(@"documentsDir = %@",documentsDir);
        NSMutableArray *dirFileListArray = [[self class] allFilesAtPath:documentDir];
        for (NSString *dirFileName in dirFileListArray) {
          NSInteger index = [dirFileName rangeOfString:NATIVE_FOLDERNAME].location;
          NSString *fileName = [dirFileName substringFromIndex:index+NATIVE_FOLDERNAME.length];
          fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@""];
          //fileName = [fileName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
          
          NSString *zipFilePath= [[NSHomeDirectory() stringByAppendingPathComponent:DOCUMENTS] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",fileName]];
          [[NSFileManager defaultManager] removeItemAtPath:zipFilePath error:nil];
          NSLog(@"___打包地址：%@",zipFilePath);
          CSIIMADPZipFile *zipFile = [[CSIIMADPZipFile alloc] initWithFileName:zipFilePath mode:CSIIMADPZipFileModeCreate];
            //.DS_Store文件无需加密
            if (![fileName isEqualToString:@".DS_Store"]) {
                // 获取文件创建日期
                NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:dirFileName error:&error];
                NSDate *date = [attributes objectForKey:NSFileCreationDate];
                //加密压缩文件
                CSIIMADPZipWriteStream *writeStream = [zipFile writeFileInZipWithName:fileName  fileDate:date compressionLevel:ZipCompressionLevelFastest password:@"123456" crc32:0];
              
                NSData *data = [NSData dataWithContentsOfFile:dirFileName];
                [writeStream writeData:data];
              [writeStream finishedWriting];
            }
          [zipFile close];
          [zipFile release];
        }
        // 关闭zip文件
    } @catch (id e) {
		//NSLog(@"Exception caught: %@ - %@", [[e class] description], [e description]);
	}
	
	[pool drain];
}

+(void) unZipFromBundleWithPassword:(NSString *)fileName{
    NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
	@try {
    NSString *zipFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",NATIVE_FOLDERNAME,fileName]];
        NSString *unzipFileDir = [NSHomeDirectory() stringByAppendingPathComponent:DOCUMENTS];
    NSLog(@"____解压地址：%@",unzipFileDir);
        if( ! [[NSFileManager defaultManager] fileExistsAtPath:zipFilePath])
        {
            return;
        }
        CSIIMADPZipFile *unzipFile= [[CSIIMADPZipFile alloc] initWithFileName:zipFilePath mode:CSIIMADPZipFileModeUnzip];
        int num = (uInt)[unzipFile numFilesInZip];
        if (num < 1)
        {
            return;
        }
        [unzipFile goToFirstFileInZip];
        for (int i= 0; i < num; i++)
        {
            CSIIMADPZipReadStream *readStream= [unzipFile readCurrentFileInZipWithPassword:@"123456"];
            CSIIMADPFileInZipInfo *info= [unzipFile getCurrentFileInZipInfo];
            NSString *fileNamePath = info.name;
            NSString *fileFullPath = [unzipFileDir stringByAppendingPathComponent:fileNamePath];
            if(info.length > 0 || [info.name rangeOfString:@"."].location != NSNotFound)
            {
                NSData *data = [readStream readDataOfLength:info.length];
                NSString *fileFullDir = [fileFullPath stringByDeletingLastPathComponent];
                NSError *error;
                [[NSFileManager defaultManager] createDirectoryAtPath:fileFullDir withIntermediateDirectories:YES attributes:nil error:&error];
                [[NSFileManager defaultManager] createFileAtPath:fileFullPath contents:data attributes:nil];
            }
            else
            {
                NSError *error;
                [[NSFileManager defaultManager] createDirectoryAtPath:fileFullPath withIntermediateDirectories:YES attributes:nil error:&error];
            }
            [readStream finishedReading];
            if ((i +1) < num)
            {
                [unzipFile goToNextFileInZip];
            }
        }
        [unzipFile close];
		[unzipFile release];
    } @catch (id e) {
		//NSLog(@"Exception caught: %@ - %@", [[e class] description], [e description]);
	}
	[pool drain];
}

+(void) unZipFromCachesWithPassword;
{
    [[NSFileManager defaultManager] removeItemAtPath:[[NSHomeDirectory() stringByAppendingPathComponent:DOCUMENTS] stringByAppendingPathComponent:NATIVE_FOLDERNAME] error:nil];
    NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
	@try {
        NSString *documentsDir= [NSHomeDirectory() stringByAppendingPathComponent:DOCUMENTS];
		NSString *zipFilePath =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",NATIVE_FOLDERNAME]];
        NSString *unzipFileDir = documentsDir;
        if( ! [[NSFileManager defaultManager] fileExistsAtPath:zipFilePath])
        {
            return;
        }
        CSIIMADPZipFile *unzipFile= [[CSIIMADPZipFile alloc] initWithFileName:zipFilePath mode:CSIIMADPZipFileModeUnzip];
        int num = (uInt)[unzipFile numFilesInZip];
        if (num < 1)
        {
            return;
        }
        [unzipFile goToFirstFileInZip];
        for (int i= 0; i < num; i++)
        {
            CSIIMADPZipReadStream *readStream= [unzipFile readCurrentFileInZipWithPassword:@"123456"];
            CSIIMADPFileInZipInfo *info= [unzipFile getCurrentFileInZipInfo];
            NSString *fileNamePath = info.name;
            NSString *fileFullPath = [unzipFileDir stringByAppendingPathComponent:fileNamePath];
            if(info.length > 0 || [info.name rangeOfString:@"."].location != NSNotFound)
            {
                NSData *data = [readStream readDataOfLength:info.length];
                NSString *fileFullDir = [fileFullPath stringByDeletingLastPathComponent];
                NSError *error;
                [[NSFileManager defaultManager] createDirectoryAtPath:fileFullDir withIntermediateDirectories:YES attributes:nil error:&error];
                [[NSFileManager defaultManager] createFileAtPath:fileFullPath contents:data attributes:nil];
            }
            else
            {
                NSError *error;
                [[NSFileManager defaultManager] createDirectoryAtPath:fileFullPath withIntermediateDirectories:YES attributes:nil error:&error];
            }
            [readStream finishedReading];
            if ((i +1) < num)
            {
                [unzipFile goToNextFileInZip];
            }
        }
        [unzipFile close];
		[unzipFile release];
    } @catch (id e) {
		//NSLog(@"Exception caught: %@ - %@", [[e class] description], [e description]);
	}
	[pool drain];
}
@end
