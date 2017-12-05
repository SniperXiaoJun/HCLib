//
//  CPWebControlUtiliy.h
//  CPPlugins
//
//  Created by liurenpeng on 8/12/15.
//  Copyright (c) 2015 刘任朋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^CPWebControlCheckCallBack)(id responseData);

/*!
 * @class
 * @abstract 缓存公共。
 */
@interface CPCacheUtility : NSObject

/*!
 * @property
 * @abstract 回调
 */
@property (nonatomic, assign) CPWebControlCheckCallBack checkZipIntegrity;

/*!
 * @property
 * @abstract 缓存机制开关
 */
@property (nonatomic, assign) BOOL isCacheProtocol;

/*!
 * @property
 * @abstract 跳过版本校验以及动态菜单获取
 */
@property (nonatomic, assign) BOOL isDebug;


+ (CPCacheUtility*)sharedInstance;

/*!
 * @method
 * @abstract 检查缓存目录完整性
 * @param checkZipBlock 返回错误结果
 */
- (void)checkWithZipIntegrity:(CPWebControlCheckCallBack)checkZipBlock;

/*!
 * @method
 * @abstract 将zip包保存到缓存目录
 * @param zipInfo zip信息（zipFilePath:文件路径 zipPassWord：zip包密码）
 */

- (void)saveZipToCacheFileWithZipPath:(NSDictionary*)zipInfo;

/*!
 * @method
 * @abstract 将zip包保存到缓存目录
 * @param zipFileArr zip文件路径数组
 */
- (void)saveZipToCacheFileWithZipPathArr:(NSArray*)zipFileArr;

/*!
 * @method
 * @abstract 查找zip包包名
 * @param fileUrl 文件路径
 */
- (NSString*)readZipName:(NSString*)filePath;

/*!
 *  @method 查询zip包信息
 *
 *  @param fileName zip包名
 *  @param typeName 查找类型
 *
 *  @return 返回查找结果
 */
- (NSString*)readInfoToSql:(NSString*)fileName withType:(NSString*)typeName;

/*!
 * @method
 * @abstract 获取有效的文件名
 */
- (NSArray*)getTamperFileArr;

/*!
 * @method
 * @abstract 读取数据库内容
 */
- (NSArray*)readSqlInfo;

/*!
 *  读取信息
 *
 *  @param zipfile 读取zip子目录的文件名
 *
 *  @return 返回读取数据流
 */
- (NSData*)readZipWithPath:(NSString*)zipfile;

/*!
 * @method
 * @abstract 将菜单保存到缓存目录
 * @param DisplayMenuStr json字符串
 */
- (void)saveDisplayMenuToSql:(NSString*)DisplayMenuStr;

/*!
 * @method
 * @abstract 从数据库读取菜单
 * @return json字符串
 */
- (NSString*)readDisplayMenuListForSql;
/*!
 * @method
 * @abstract 开启数据库
 */

-(void)openSqlite;

- (void)insertToTable:(NSString*)tableName
          withNameStr:(NSString*)nameStr
           withSqlTtr:(NSString*)sqlStr;

- (void)execSql:(NSString*)sql withOperationName:(NSString*)str;
@end
