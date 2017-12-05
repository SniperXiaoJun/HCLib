//
//  JRUtils.h
//  ProductInfoFlow
//
//  Created by Shen Yu on 16/5/17.
//  Copyright © 2016年 Shen Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRUtils : NSObject
+ (NSDictionary *)dictWithJsonFile:(NSString *)fileName;
+ (BOOL)dictWithNoUrl:(NSDictionary *)dict;
+ (BOOL)dictWithUrl:(NSDictionary *)dict;
+ (BOOL)urlNeedsLogin:(NSDictionary *)dict;
+ (NSString *)nowTimeStr;
    
+ (id)objectWithStr:(NSString *)str;
+ (NSInteger)maxValueWitValue:(float)originValue;


+ (CGSize)getImageSizeWithURL:(id)imageURL;
+ (CGRect)returnBntFrame:(NSDictionary *)dataDic andImageDic:(NSDictionary *)imageDic;
+ (CGRect)returnBntFrame:(NSDictionary *)dataDic andImageDic:(NSDictionary *)imageDic andMargin:(CGFloat)margin;

+ (NSString *)nowDate;
@end
