//
//  libaes.h
//  libaes
//
//  Created by luchunguang on 17/09/2017.
//  Copyright © 2017 luchunguangcsii. All rights reserved.
//
#ifndef __lib__aes__h__
#define __lib__aes__h__

#if defined (__cplusplus)
extern "C" {
#endif

/*
keyType：  0，密钥长度为128位；1，密钥长度为256位
isRandkey：true，一次一密，密钥是随机的，针对非异步调用；
           false，密钥初始化后不会改变，针对异步调用
*/
void initialize(int keyType, bool isRandKey);
    
    
/*
 text：上送报文原文
 key：1024位RSA公钥，使用公钥的模数，16进制字符串格式。
 返回值：加密后的报文密文
 */
char* getValue(char *text,char *key);
    
/*
解密方法
text：服务端返回的报文密文
返回值：服务端返回的报文原文
*/
char* decrypt_aes(char *text);

    
    
#if defined (__cplusplus)
}
#endif

#endif    // __lib__aes__h____lib__aes__h__
