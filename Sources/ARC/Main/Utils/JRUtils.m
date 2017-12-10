//
//  JRUtils.m
//  ProductInfoFlow
//
//  Created by Shen Yu on 16/5/17.
//  Copyright © 2016年 Shen Yu. All rights reserved.
//

#import "JRUtils.h"


@implementation JRUtils



+ (NSDictionary *)dictWithJsonFile:(NSString *)fileName{
    
    NSString *navPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    
    NSString *home_json = [NSString stringWithContentsOfFile:navPath encoding:NSUTF8StringEncoding error:nil];
    
    NSData *jsonData = [home_json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return dict;
}


+ (BOOL)dictWithNoUrl:(NSDictionary *)dict{
    if (dict[@"Url"] || dict[@"FeedUrl"] ||  dict[@"AppUrl"]) {
        return NO;
    }
    return YES;
}
+ (BOOL)dictWithUrl:(NSDictionary *)dict{
    if (dict[@"Url"] || dict[@"FeedUrl"] ||  dict[@"AppUrl"]) {
        return YES;
    }
    return NO;
}


+ (BOOL)urlNeedsLogin:(NSDictionary *)dict
{
    if ([dict[@"Url"] hasSuffix:authStr]||
        [dict[@"FeedUrl"] hasSuffix:authStr] ||
        [dict[@"AppUrl"] hasSuffix:authStr] ||
        [dict[@"IsLogin"] isEqualToString:@"1"] ||
        [dict[@"Url"] isEqualToString:@"login"] ||
        [dict[@"Url"] isEqualToString:@"company"] ||
        [dict[@"Url"] isEqualToString:@"employee"])
    {
        return YES;
    }
    return NO;
}

+ (NSString *)nowTimeStr{
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    form.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate date];
    
    return [form stringFromDate:date];

}
    
+ (id)objectWithStr:(NSString *)str{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}


+ (NSInteger)maxValueWitValue:(float)originValue{
    /*
     NSArray *arr = @[@8.3,@93.2,@345.4,@2342.3,@12344.5,@992343.5];
     for (NSInteger i; i < arr.count; ++i) {
     NSLog(@"%f     --->%ld",[arr[i] floatValue], [self maxValueWitValue:[arr[i] floatValue]]);
     }
     
     2017-02-09 14:39:01.547 jjj[37928:1216044] 8.300000     --->12
     2017-02-09 14:39:01.548 jjj[37928:1216044] 93.199997     --->96
     2017-02-09 14:39:01.548 jjj[37928:1216044] 345.399994     --->360
     2017-02-09 14:39:01.548 jjj[37928:1216044] 2342.300049     --->2400
     2017-02-09 14:39:01.548 jjj[37928:1216044] 12344.500000     --->18000
     2017-02-09 14:39:01.548 jjj[37928:1216044] 992343.500000     --->1020000
     */
    NSInteger b = [NSString stringWithFormat:@"%d",(int)originValue].length;
    NSInteger y;
    if (b > 1) {
        y = (int)pow(10, b-2);
    }else{
        y = (int)pow(10, 0);
    }
    
    return ((int)originValue/6/y +1)*y*6;
}


// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}
//  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取gif图片的大小
+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}
+ (CGRect)returnBntFrame:(NSDictionary *)dataDic andImageDic:(NSDictionary *)imageDic{
    NSString *imageWidth = imageDic[@"Width"];
    CGFloat scale = ScreenWidth/[imageWidth floatValue];
    
    NSString *imageMap = dataDic[@"Frame"];
    NSArray *arr = [imageMap componentsSeparatedByString:@","];
    CGRect frame = CGRectMake([arr[0] floatValue]*scale, [arr[1] floatValue]*scale, [arr[2] floatValue]*scale, [arr[3] floatValue]*scale);
    return frame;
}
+ (CGRect)returnBntFrame:(NSDictionary *)dataDic andImageDic:(NSDictionary *)imageDic andMargin:(CGFloat)margin{
    
    NSString *imageWidth = imageDic[@"Width"];
    CGFloat scale = ScreenWidth/[imageWidth floatValue];
    
    NSString *imageMap = dataDic[@"Frame"];
    NSArray *arr = [imageMap componentsSeparatedByString:@","];
    CGRect frame = CGRectMake([arr[0] floatValue]*scale, [arr[1] floatValue]*scale + margin, [arr[2] floatValue]*scale, [arr[3] floatValue]*scale);
    return frame;
}
+ (NSString *)nowDate{
    NSDateFormatter * form=[[NSDateFormatter alloc]init];
    [form setDateFormat:@"yyyyMMddHHmmss"];
    return  [form stringFromDate:[NSDate date]];
}

/*
 
 DebugLog(@"AppUrl----%@",dataDict[@"AppUrl"]);
 
 if (dataDict[@"AppUrl"]) {
 DebugLog(@"appurl 存在");
 }else{
 DebugLog(@"appurl 不存在");
 }
 
 
 DebugLog(@"FeedUrl---%@",dataDict[@"FeedUrl"]);
 if (dataDict[@"FeedUrl"] == nil) {
 DebugLog(@"appurl 不存在");
 }else{
 DebugLog(@"appurl 存在");
 }
 
 
 DebugLog(@"FeedUrl---%@",dataDict[@"FeedUrl"]);
 if (dataDict[@"FeedUrl"] == NULL) {
 DebugLog(@"appurl 不存在");
 }else{
 DebugLog(@"appurl 存在");
 }
 
 
 
 */
/*
- (id)handleNullObjectForKey:(NSString *)key {
 
    id object = [self objectForKey:key];
 
    if ([object isKindOfClass:[NSNull class]]) {
 
        return nil;
    }
    
    return object;
}
*/




/*******  以下  为无服务时，本地数据测试 **********/
/*
 NSDictionary *json = [JRUtils dictWithJsonFile:@"home"];
 
 
 menuArray = [json[@"Contents"] mutableCopy];
 nextPageUrl = json[@"NextPageUrl"];
 Singleton.baseUrl = json[@"BaseUrl"];
 
 DebugLog(@"Singleton.baseUrl----%@",Singleton.baseUrl);
 [self.tableView reloadData];
 [self.tableView headerEndRefreshing];
 
 return;
 */
/*******  以上  为无服务时，本地数据测试 **********/

@end
