//
//  CPWebControlUtiliy.m
//  CPPlugins
//
//  Created by liurenpeng on 8/12/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import "CPCacheUtility.h"
#import "CSIIMADPZipFile.h"
#import "CSIIMADPZipException.h"
#import "CSIIMADPFileInZipInfo.h"
#import "CSIIMADPZipReadStream.h"
#import <sqlite3.h>
#import <CommonCrypto/CommonDigest.h>
#import "CPDebug.h"

#define CPLIBRARY_FOLDER(fileName)                                        \
    [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/CPMenu"] \
        stringByAppendingPathComponent:fileName]
#define CC_MD5_DIGEST_LENGTH 16 /* digest length in bytes */
#define CC_MD5_BLOCK_BYTES 64 /* block size in bytes */
#define CC_MD5_BLOCK_LONG (CC_MD5_BLOCK_BYTES / sizeof(CC_LONG))

static NSString* CSIICachingURLHeader = @"X-CSIICache";
static NSArray* fileInfos = nil;
static CSIIMADPZipFile* unzipFile;

@interface CPCacheUtility () {

    NSMutableDictionary* zipMenuDic;
    // ZipReadStream *readStream;
    sqlite3* menuSqlite;
    NSMutableArray* folderAllFileArr;
    NSMutableArray* TamperFileArr;
    NSString* curZipFilePath;
    NSString* curTableName;
    NSArray* zipInfoArr;
}

@end
@implementation CPCacheUtility
@synthesize isCacheProtocol;
@synthesize isDebug;
@synthesize checkZipIntegrity;
static CPCacheUtility* _sharedInstance;

+ (CPCacheUtility*)sharedInstance;
{
    @synchronized(self)
    {
        if (!_sharedInstance) {
            _sharedInstance = [[CPCacheUtility alloc] init];
        }
        return _sharedInstance;
    }
}
#pragma mark - 检测应用资源完整性
- (void)checkWithZipIntegrity:(CPWebControlCheckCallBack)checkZipBlock
{
    BOOL isLocality;

    self.checkZipIntegrity = checkZipBlock;
    folderAllFileArr = [[NSMutableArray alloc] init];
    TamperFileArr = [[NSMutableArray alloc] init];
    NSString* filePath =
        [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
            stringByAppendingPathComponent:@"CPMenu"];
    [self creatInformationSqlite];
    [self CreateTable];

    BOOL zipIntegrity = NO;
    NSFileManager* manager = [NSFileManager defaultManager];
    NSEnumerator* childFilesEnumerator =
        [[manager subpathsAtPath:filePath] objectEnumerator];
    NSString* fileName;

    if (!isLocality) {

        while ((fileName = [childFilesEnumerator nextObject]) != nil) {
            if ([fileName isEqualToString:@".DS_Store"]) {
                break;
            }
            CPDLog(@"[fileName pathExtension]====%@", [fileName pathExtension]);

            if ([[fileName pathExtension] isEqualToString:@""]) {
                NSString* fileAbsolutePath =
                    [filePath stringByAppendingPathComponent:fileName];
                if ([manager fileExistsAtPath:fileAbsolutePath]) {
                    NSMutableDictionary* zipInfoDict = [[NSMutableDictionary alloc] init];
                    NSString* nowfilemd5 = [self fileMD5:fileAbsolutePath];
                    [zipInfoDict setObject:[NSString stringWithFormat:@"%@.zip", fileName]
                                    forKey:@"ZipId"];
                    [zipInfoDict setObject:nowfilemd5 forKey:@"ZipSignature"];
                    [zipInfoDict
                        setObject:[self readInfoToSql:fileName withType:@"ZipVersionId"]
                           forKey:@"ZipVersionId"];
                    [TamperFileArr addObject:zipInfoDict];
                }
            }
        }
        zipIntegrity = NO;
    }
    else {

        if (![manager fileExistsAtPath:filePath]) {
            // 文件不存在
            zipIntegrity = NO;
        }
        else {

            /** 校验文件完整性*/
            while ((fileName = [childFilesEnumerator nextObject]) != nil) {
                if ([[fileName pathExtension] isEqualToString:@""]) {
                    NSString* fileAbsolutePath =
                        [filePath stringByAppendingPathComponent:fileName];

                    if ([manager fileExistsAtPath:fileAbsolutePath]) {

                        NSString* nowfileSize = [NSString
                            stringWithFormat:@"%llu",
                            [self fileSizeAtPath:fileAbsolutePath]];
                        NSString* oldfileSize =
                            [self readInfoToSql:fileName
                                       withType:@"length"];
                        //
                        if ([nowfileSize isEqualToString:oldfileSize]) {
                            //                    zipIntegrity = YES;
                            NSString* nowfilemd5 = [self fileMD5:fileAbsolutePath];
                            NSString* oldfilemd5 =
                                [self readInfoToSql:fileName
                                           withType:@"MD5"];
                            if ([nowfilemd5 isEqualToString:oldfilemd5]) {

                                zipIntegrity = YES;

                                NSMutableDictionary* zipInfoDict =
                                    [[NSMutableDictionary alloc] init];
                                [zipInfoDict setObject:fileName forKey:@"ZipId"];
                                [zipInfoDict setObject:[self readInfoToSql:fileName
                                                                  withType:@"ZipVersionId"]
                                                forKey:@"ZipVersionId"];

                                [TamperFileArr addObject:zipInfoDict];
                            }
                            else {
                                zipIntegrity = NO;
                            }
                        }
                        else {

                            zipIntegrity = NO;
                        }
                    }
                    else {
                        // 文件不存在
                        zipIntegrity = NO;
                    }
                }
            }
            //        zipIntegrity=YES;
        }
    }

    if (zipIntegrity) {

        if (self.checkZipIntegrity) {
            self.checkZipIntegrity(@"true");
        }
    }
    else {

        if (self.checkZipIntegrity) {
            self.checkZipIntegrity(@"true");
        }
    }
}

- (NSArray*)getTamperFileArr
{

    return TamperFileArr;
}
#pragma mark - 文件信息处理（大小，MD5）
//计算单个文件的大小  返回字节
- (long long)fileSizeAtPath:(NSString*)filePath
{
    NSString* cacheFile =
        [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
            stringByAppendingPathComponent:@"CPMenu"];
    NSString* file = [filePath lastPathComponent];
    cacheFile = [cacheFile stringByAppendingPathComponent:file];
    NSFileManager* manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:cacheFile]) {
        return [[manager attributesOfItemAtPath:cacheFile error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float)folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    NSEnumerator* childFilesEnumerator =
        [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {

        NSString* fileAbsolutePath =
            [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize / (1024.0 * 1024.0);
}
//计算文件的md5值
- (NSString*)fileMD5:(NSString*)path
{
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (handle == nil)
        return nil;

    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);

    BOOL done = NO;
    while (!done) {
        NSData* fileData = [handle readDataOfLength:1024];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if ([fileData length] == 0)
            done = YES;
    }

    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);

    [handle closeFile];

    NSString* s = [NSString
        stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
        digest[0], digest[1], digest[2], digest[3], digest[4], digest[5],
        digest[6], digest[7], digest[8], digest[9], digest[10], digest[11],
        digest[12], digest[13], digest[14], digest[15]];
    return s;
}

- (void)creatZipMenuJsonFile:(NSString*)cacheFile
{

    if (cacheFile != nil) {
        [self traversalUnZipFile:cacheFile];
    }
    else {

        NSString* filePath =
            [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
                stringByAppendingPathComponent:@"CPMenu"];
        NSArray* contentOfFolder =
            [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath
                                                                error:NULL];
        for (NSString* subFolder in contentOfFolder) {
            CPDLog(@"subFolder:%@", subFolder);
            if (![subFolder isEqualToString:@".DS_Store"] &&
                [[subFolder pathExtension] isEqualToString:@""]) {
                NSString* curCipFile =
                    [filePath stringByAppendingPathComponent:subFolder];
                [self traversalUnZipFile:curCipFile];
            }
        }
    }
}
- (NSDictionary*)traversalUnZipFile:(NSString*)zipFilePath;
{

    if ([[NSFileManager defaultManager] fileExistsAtPath:zipFilePath]) {
        if (![zipFilePath isEqualToString:curZipFilePath]) {
            curZipFilePath = zipFilePath;
            unzipFile =
                [[CSIIMADPZipFile alloc] initWithFileName:zipFilePath
                                             mode:CSIIMADPZipFileModeUnzip];
            fileInfos = [unzipFile listFileInZipInfos];
        }
        for (CSIIMADPFileInZipInfo * zipFileInfo in fileInfos) {
            if (zipFileInfo.length > 0) {
                //插入操作
                // TODO:注释打印
//                CPDLog(@"zipFileInfo.name===%@  zipFilePath ==%@", zipFileInfo.name,
//                    [zipFilePath lastPathComponent]);

                if ([self isDirectory:zipFileInfo.name]) {

                    NSString* sql12 = [NSString
                        stringWithFormat:
                            @"INSERT INTO menuListTable ('%@','%@') VALUES ('%@','%@')",
                        @"path", @"name", zipFileInfo.name,
                        [zipFilePath lastPathComponent]];

                    [self insertToTable:@"menuListTable"
                            withNameStr:zipFileInfo.name
                             withSqlTtr:sql12];
                }
            }
        }
        [unzipFile close];
        unzipFile = nil;
    }
    return nil;
}



-(void)openSqlite{
    [self creatInformationSqlite];
    [self CreateTable];
}

#pragma mark - 读取应用资源文件从数据库
////打开数据库没有创建
- (void)creatInformationSqlite
{

    NSString* fullPath =
        [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
            stringByAppendingPathComponent:@"Menu"];

    if (sqlite3_open([fullPath UTF8String], &menuSqlite) != SQLITE_OK) {

        CPDLog(@"数据库打开失败");
    }
}
//创建表
- (void)CreateTable
{

    NSString* sqlCreateTable = @"CREATE TABLE IF NOT EXISTS menuListTable (path TEXT PRIMARY KEY , name TEXT)";
    [self execSql:sqlCreateTable withOperationName:@"menuListTable创建表失败"];

    NSString* sqlCreateTable1 = @"CREATE TABLE IF NOT EXISTS infoTable (name TEXT PRIMARY KEY, UpdateTime TEXT)";
    [self execSql:sqlCreateTable1 withOperationName:@"infoTable创建表失败"];
}
//插入数据 tableName 表名

- (void)insertToTable:(NSString*)tableName
          withNameStr:(NSString*)nameStr
           withSqlTtr:(NSString*)sqlStr
{
    //查询数据

    if (![curTableName isEqualToString:tableName])
    {
        curTableName = tableName;

        zipInfoArr = [self readSqlMenuListInfo:tableName];
    }

    for (NSString* pathStr in zipInfoArr)
    {
        
        if ([nameStr isEqualToString:pathStr]) {
//            CPDLog(@"pathStr===%@", pathStr);

            if ([tableName isEqualToString:@"infoTable"])
            {
                [self execSql:[NSString
                                  stringWithFormat:@"DELETE FROM %@ WHERE name = '%@'",
                                  tableName, nameStr]
                    withOperationName:@"删除操作失败"];
            }
            else if ([tableName isEqualToString:@"menuTable"])
            {
                [self execSql:[NSString
                                  stringWithFormat:@"DELETE FROM %@ WHERE name = '%@'",
                                  tableName, nameStr]
                    withOperationName:@"删除操作失败"];
            }
            else
            {

                [self execSql:[NSString
                                  stringWithFormat:@"DELETE FROM %@ WHERE path = '%@'",
                                  tableName, nameStr]
                    withOperationName:@"删除操作失败"];
            }
        }
    }

    [self execSql:sqlStr withOperationName:@"插入操作失败"];
}

- (void)execSql:(NSString*)sql withOperationName:(NSString*)str
{
    char* err;
    //操作数据库
    if (sqlite3_exec(menuSqlite, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
    }
}
- (NSArray*)readSqlInfo
{
    NSMutableArray* AllArray = [[NSMutableArray alloc] init];
    NSString* sqlQuery =
        [NSString stringWithFormat:@"SELECT * FROM '%@'", @"infoTable"];
    sqlite3_stmt* statement;

    if (sqlite3_prepare_v2(menuSqlite, [sqlQuery UTF8String], -1, &statement,
            nil) == SQLITE_OK) {

        while (sqlite3_step(statement) == SQLITE_ROW) {

            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];

            char* name = (char*)sqlite3_column_text(statement, 0);
            char* updateTimeC = (char*)sqlite3_column_text(statement, 1);

            NSString* nameStr = [[NSString alloc] initWithUTF8String:name];
            NSString* updateTime = [[NSString alloc] initWithUTF8String:updateTimeC];
            
            [dic setObject:nameStr forKey:@"name"];
            [dic setObject:updateTime forKey:@"UpdateTime"];
            [AllArray addObject:dic];
        }
    }

    return AllArray;
}

- (NSArray*)readSqlMenuListInfo:(NSString*)tableName
{
    NSMutableArray* AllArray = [[NSMutableArray alloc] init];
    NSString* sqlQuery =
        [NSString stringWithFormat:@"SELECT * FROM '%@'", tableName];
    sqlite3_stmt* statement;

    if (sqlite3_prepare_v2(menuSqlite, [sqlQuery UTF8String], -1, &statement,
            nil) == SQLITE_OK) {

        while (sqlite3_step(statement) == SQLITE_ROW) {

            char* name = (char*)sqlite3_column_text(statement, 0);
            NSString* pathStr = [[NSString alloc] initWithUTF8String:name];
            [AllArray addObject:pathStr];
        }
    }

    return AllArray;
}
//读取包名
- (NSString*)readZipName:(NSString*)filePath
{

    NSString* sqlQuery = [NSString
        stringWithFormat:@"SELECT name  FROM menuListTable WHERE path = '%@'",
        filePath];
    sqlite3_stmt* statement;
    NSString* nsNameStr;
    if (sqlite3_prepare_v2(menuSqlite, [sqlQuery UTF8String], -1, &statement,
            nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {

            char* name = (char*)sqlite3_column_text(statement, 0);
            nsNameStr = [[NSString alloc] initWithUTF8String:name];
            //     TODO: 去掉注释
//            CPDLog(@"nsNameStr===%@", nsNameStr);
        }
    }else{
        
        CPDLog(@"数据库未开启或开启失败");
        
    }

    return nsNameStr;
}
//数据库读取字段
- (NSString*)readInfoToSql:(NSString*)fileName withType:(NSString*)typeName
{

    NSString* sqlQuery =
        [NSString stringWithFormat:@"SELECT %@ FROM infoTable WHERE name = '%@'",
                  typeName, fileName];
    //TODO:注释打印
//    CPDLog(@"sqlQuery===%@", sqlQuery);
    sqlite3_stmt* statement;
    NSString* nsNameStr;

    int dbrc;
    dbrc = sqlite3_prepare_v2(menuSqlite, [sqlQuery UTF8String], -1, &statement,
        NULL);
    // TODO:注释打印
//    CPDLog(@"prepared statement=%d", dbrc);

    if (sqlite3_prepare_v2(menuSqlite, [sqlQuery UTF8String], -1, &statement,
            nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int typeIndex;
            if ([typeName isEqualToString:@"UpdateTime"]) {
                typeIndex = 1;
            }
            char* str = (char*)sqlite3_column_text(statement, 0);
            nsNameStr = [[NSString alloc] initWithUTF8String:str];
            //     TODO: 去掉注释
//            CPDLog(@"nsNameStr====%@", nsNameStr);
        }
    }else{
        
        CPDLog(@"数据库未开启或开启失败");
        
    }

    return nsNameStr;
}

#pragma mark 保存zip到缓存目录并存如数据库
- (void)saveZipToCacheFileWithZipPath:(NSDictionary*)zipInfo;
{
    NSString* zipFile = [zipInfo objectForKey:@"zipFilePath"];
    NSArray* rslt =
        [[zipFile lastPathComponent] componentsSeparatedByString:@"."];

    NSString* fileTitle = rslt[0];

    [self creatInformationSqlite];
    [self CreateTable];

    NSString *timeDDD = [JRUtils nowTimeStr];
    
    //校验值存在sql里
//    NSString* sql12 = [NSString
//                       stringWithFormat:
//                       @"INSERT INTO infoTable ('%@','%@','%@','%@','%@','%@') VALUES ('%@','%@','%@','%@','%@','%@')",
//                       @"name", @"length", @"MD5", @"passcode", @"ZipVersionId",@"UpdateTime",
//                       fileTitle,
//                       [NSString stringWithFormat:@"%llu",[self fileSizeAtPath:zipFile]],
//                       [self fileMD5:zipFile],
//                       zipPassWord,
//                       ZipVersionId,timeDDD];
    NSString* sql12 = [NSString
        stringWithFormat:
            @"INSERT INTO infoTable ('%@','%@') VALUES ('%@','%@')",
        @"name",@"UpdateTime",fileTitle,timeDDD];
    [self insertToTable:@"infoTable" withNameStr:fileTitle withSqlTtr:sql12];

    if (![[NSFileManager defaultManager] fileExistsAtPath:zipFile]) {
        [[[UIAlertView alloc]
                initWithTitle:@"温馨提示"
                      message:[NSString
                                  stringWithFormat:@"安装包中不存在%@文件",
                                  zipFile]
                     delegate:nil
            cancelButtonTitle:@"确定"
            otherButtonTitles:nil, nil] show];
    }
    NSString* filePath =
        [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
            stringByAppendingPathComponent:@"CPMenu"];

    NSString* copyFath =
        [NSString stringWithFormat:@"%@/%@", filePath, fileTitle];

    //  NSString *copyFath =
    //      [filePath stringByAppendingPathComponent:[zipFile lastPathComponent]];

    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    else {

        [[NSFileManager defaultManager] removeItemAtPath:copyFath error:nil];
    }

    NSError* error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:zipFile
                                            toPath:copyFath
                                             error:&error];
    // TODO:注释打印
//    CPDLog(@"copyFath===%@", copyFath);
    if (error) {
        DebugLog(@"copy zipFile faild in CPWebControlUtiliy saveZipToCacheFile:%@",error);
        return;
//        NSAssert(!error,
//            @"copy zipFile faild in CPWebControlUtiliy saveZipToCacheFile:%@",
//            error);
    }
    [self creatZipMenuJsonFile:copyFath];
}
- (void)saveZipToCacheFileWithZipPathArr:(NSArray*)zipFileArr;
{
    for (NSDictionary* zipfile in zipFileArr) {
        [self saveZipToCacheFileWithZipPath:zipfile];
    }
}
- (NSData*)readZipWithPath:(NSString*)zipfile;
{
    NSData* data = nil;
    if (![curZipFilePath isEqualToString:zipfile]) {
        curZipFilePath = zipfile;
        NSString* zipFileName = [self readZipName:zipfile];
        NSString* zipPasscode =
            [self readInfoToSql:zipFileName
                       withType:@"passcode"];
        NSString* zipFilePath = CPLIBRARY_FOLDER(zipFileName);

        CPDLog(@"path_zipurl:%@", zipFilePath);

        if ([zipFileName hasSuffix:@""]) {
            unzipFile =
                [[CSIIMADPZipFile alloc] initWithFileName:zipFilePath
                                             mode:CSIIMADPZipFileModeUnzip];
            if (unzipFile) {
                fileInfos = [unzipFile listFileInZipInfos];
            }
        }
        CSIIMADPZipReadStream* readStream = nil;
        for (CSIIMADPFileInZipInfo* info in fileInfos) {

            if ([info.name isEqualToString:zipfile]) {
                [unzipFile locateFileInZip:info.name];
                CPDLog(@"info.name:---%@", info.name);
                if ([zipPasscode isEqualToString:@""] || zipPasscode == nil ||
                    [zipPasscode isEqualToString:@"<null>"]) {
                    readStream = [unzipFile readCurrentFileInZip];
                }
                else {
                    readStream = [unzipFile readCurrentFileInZipWithPassword:zipPasscode];
                }
                data = [readStream readDataOfLength:info.length];
            }
        }
    }
    return data;
}

#pragma mark -menuTable保存读取数据项
- (void)saveDisplayMenuToSql:(NSString*)DisplayMenuStr
{
    [self creatInformationSqlite];
    [self CreateMenuTable];
    [self execSql:[NSString stringWithFormat:@"DELETE FROM %@ WHERE name = '%@'",
                            @"menuTable", @"menulist"]
        withOperationName:@"删除操作失败"];
    NSString* sql12 = [NSString
        stringWithFormat:@"INSERT INTO menuTable ('%@','%@') VALUES ('%@','%@')",
        @"name", @"menulistStr", @"menulist", DisplayMenuStr];

    [self execSql:sql12 withOperationName:@"插入操作失败"];
}
- (NSString*)readDisplayMenuListForSql
{
    [self creatInformationSqlite];

    NSString* sqlQuery = [NSString
        stringWithFormat:@"SELECT menulistStr  FROM menuTable WHERE name = '%@'",
        @"menulist"];
    sqlite3_stmt* statement;
    NSString* menulistStr;
    if (sqlite3_prepare_v2(menuSqlite, [sqlQuery UTF8String], -1, &statement,
            nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {

            char* menulist = (char*)sqlite3_column_text(statement, 0);
            menulistStr = [[NSString alloc] initWithUTF8String:menulist];
            CPDLog(@"menulistStr===%@", menulistStr);
        }
    }else{
        
        CPDLog(@"数据库未开启或开启失败");
        
    }

    return menulistStr;
}

- (void)CreateMenuTable
{
    NSString* sqlCreateTable = @"CREATE TABLE IF NOT EXISTS menuTable (name TEXT PRIMARY KEY , menulistStr TEXT)";
    [self execSql:sqlCreateTable withOperationName:@"menuTable创建表失败"];
}

- (BOOL)isDirectory:(NSString*)filePath
{

    NSString* pathExtension = [filePath pathExtension];
    // TODO:注释MADP打印
//    NSLog(@"pathExtension===%@", [filePath pathExtension]);
    
    if ([pathExtension isEqualToString:@"DS_Store"] ||
        [pathExtension isEqualToString:@"exe"] ||
        [pathExtension isEqualToString:@"jar"] ||
        [pathExtension isEqualToString:@"conf"] ||
        [pathExtension isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

@end
