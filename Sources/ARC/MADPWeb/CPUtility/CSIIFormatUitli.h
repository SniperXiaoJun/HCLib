//
//  CSIIFormatUitli.h
//  CPBaseManager
//
//  Created by 任兴 on 15/11/9.
//  Copyright © 2015年 刘认朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSIIFormatUitli : NSObject


/*!
 * @method
 * @abstract 字符串转换成NSDate
 * @param 字符串
 * @result NSDate
 */

- (NSDate *)formateStrToDate:(NSString *)str;
+ (NSDate *)formateStrToDate:(NSString *)str;
/*!
 * @method
 * @abstract 显示小数点 但是没有元
 * @param 金额字符串
 * @result 带小数点的金额
 */
-(NSString *)splitByRmb:(NSString *)moneyStr;
+(NSString *)splitByRmb:(NSString *)moneyStr;
/*!
 * @method
 * @abstract 逗号拆分金额
 * @param 金额字符串
 * @result 拆分开的字符串
 */

-(NSString *)splitMoneyStr:(NSString *)moneyStr;

+(NSString *)splitMoneyStr:(NSString *)moneyStr;
/*!
 * @method
 * @abstract 判断是否为整形
 * @param 字符串
 * @result 布尔值
 */
- (BOOL)isPureInt:(NSString*)string;
/*!
 * @method
 * @abstract 判断是否为浮点形
 * @param 字符串
 * @result 布尔值
 */
- (BOOL)isPureFloat:(NSString*)string;
/*!
 * @method
 * @abstract 银行卡号格式化
 * @param 卡号
 * @result 格式化够的卡号
 */
- (NSString *)splitCardNumberStr:(NSString *)cnStr;

/*!
 * @method
 * @abstract NSDate转NSString
 * @param NSDate
 * @result 字符串
 */
-(NSString *) formateDate:(NSDate *) date;
+(NSString *) formateDate:(NSDate *) date;


//获取字符串文字的长度
+(CGFloat)getWidthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height;

@end
