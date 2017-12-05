//
//  LibAesSingle.m
//  CsiiMobileFinance
//
//  Created by 何崇 on 2017/10/18.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "LibAesSingle.h"
//#import "libaes.h"
@implementation LibAesSingle

+ (instancetype)shareInstance{
    static LibAesSingle *instances = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instances = [[LibAesSingle alloc] init];
    });
    return instances;
}


//字典转json格式字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


//json格式字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
}


#pragma mark - 获取加密字典（go服务、上传文件流不加密，其余加密）
- (NSDictionary *)getTransactionEncryptDict:(NSDictionary *)sendDict currentUrl:(NSString *)url{
    
#ifdef CSIIEncrypt
    DebugLog(@"\n##################\n##################\n##################加密原文:%@",sendDict);
    
    //如果是go服务直接返回 不做加密
    NSString *goServer = [NSString stringWithFormat:@"%@/clients/",GO_SERVER_IP];
    if ([url rangeOfString:goServer].location != NSNotFound) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:sendDict];
        [dict setObject:@"N" forKey:@"IsEncrypt"];
        return dict;
    }
    
    
    //上传文件/图片不进行加密
    if ([url rangeOfString:@"ImgUpload.do"].location != NSNotFound ||
        [url rangeOfString:@"PublicImgUpload.do"].location != NSNotFound||
        [url rangeOfString:@"ErrorFileUploading.do"].location != NSNotFound) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:sendDict];
        [dict setObject:@"N" forKey:@"IsEncrypt"];
        return dict;
    }
    
    //如果不是go服务判断字典是否为空，为空直接返回空的加密字典，否则进行加密
    if ([sendDict isEqualToDictionary:[NSDictionary dictionary]] ||
        sendDict == nil) {
        NSDictionary *transactionDcit = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"Attribute",@"N",@"IsEncrypt", nil];
        
        return transactionDcit;
    }
    
    //CSII客户端传输参数加密
    initialize(0, false);
    char mychar[512];
    strcpy(mychar,(char *)[RSAKEY UTF8String]);
    
    //将字典转换成json字符串
    NSString *transactionArgumentStr = [self dictionaryToJson:sendDict];
    //json字符串转换成加密后的char密文
    char *transactionArgumentChar = getValue((char *)[transactionArgumentStr UTF8String], mychar);
    //char密文转成字符串
    transactionArgumentStr = [NSString stringWithUTF8String:transactionArgumentChar];
    
    
    DebugLog(@"\n##################\n##################\n##################加密密文:%@",transactionArgumentStr);
    
    //字符串塞进字段
    //IsEncrypt:上传参数／文件是否加密  Y加密   N不加密  默认为加密
    
    NSMutableDictionary *transactionDcit = [NSMutableDictionary dictionary];
    [transactionDcit setObject:transactionArgumentStr forKey:@"Attribute"];
    [transactionDcit setObject:@"IOS" forKey:@"ChannelId"];
    [transactionDcit setObject:@"Y" forKey:@"IsEncrypt"];
    
    
    Log_TransactionInfo(
                        @"\nExecuteTransaction\nInterface     %@\nRequestData  ->->->->->\n%@",
                        url, transactionDcit);
    
    return transactionDcit;
    
#else
    NSMutableDictionary *unEncryoptdict = [NSMutableDictionary dictionaryWithDictionary:sendDict];
    
    [unEncryoptdict setObject:@"N" forKey:@"IsEncrypt"];
    
    Log_TransactionInfo(
                        @"\nExecuteTransaction\nInterface     %@\nRequestData  ->->->->->\n%@",
                        url, unEncryoptdict);
    return unEncryoptdict;
#endif
    
}

#pragma mark - 获取解密字典（go服务不解密，其余解密）
- (NSDictionary *)getTransactionDecipheringDict:(NSDictionary *)backDict currentUrl:(NSString *)url{
    DebugLog(@"\n##################\n##################\n##################解密原文:%@",backDict);
#ifdef CSIIEncrypt
    //如果是go服务直接返回 不做解密
    NSString *goServer = [NSString stringWithFormat:@"%@/clients/",GO_SERVER_IP];
    if ([url rangeOfString:goServer].location != NSNotFound) {
        return backDict;
    }
    
    
    //将字典转换成json字符串
    NSString *transactionBackStr = [self dictionaryToJson:backDict];
    //json字符串转换char
    char *transactionBackChar = (char *)[transactionBackStr UTF8String];
    //解析密文
    char *decrypt_aesChar = decrypt_aes(transactionBackChar);
    //密文转换为字符串
    NSString *jsonStr = [NSString stringWithUTF8String:decrypt_aesChar];
    //字符串转换为字典对象
    NSDictionary *decrypt_aesDict =  [NSDictionary dictionaryWithDictionary:[self dictionaryWithJsonString:jsonStr]];
    
    return decrypt_aesDict;

#else
    return backDict;
#endif
}
@end
