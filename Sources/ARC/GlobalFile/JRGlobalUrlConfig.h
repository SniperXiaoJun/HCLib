//
//  JRGlobalUrlConfig.h
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/2/14.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#ifndef JRGlobalUrlConfig_h
#define JRGlobalUrlConfig_h

//#define CSIIEncrypt //如果定义了该参数则走参数加密流程  否则参数不加密

//#define SERVER_IP   @"https://www.juranjinkong.com"      //  生产
//#define GO_SERVER_IP @"http://115.182.212.188"           //  居然生产-ip访问


//#define GO_SERVER_IP @"http://115.182.212.146:8088"      //  SIT
//#define SERVER_IP    @"http://115.182.212.146:8080"      //  SIT
//#define GO_SERVER_IP @"http://115.182.212.135:8088"        //  SIT
//#define SERVER_IP    @"http://115.182.212.135:8080"        //  SIT外网地址


#define GO_SERVER_IP @"http://115.182.212.135:8088"        //  设计家连调地址
#define SERVER_IP    @"http://115.182.212.161:8080"        //  设计家连调地址




//#define SERVER_IP    @"http://172.16.251.171:8080"  //SIT 内网地址

//#define GO_SERVER_IP @"http://172.16.251.183:8088"         //UAT
//#define SERVER_IP    @"http://172.16.251.183:8080"         //UAT

//#define GO_SERVER_IP @"http://115.182.212.162:8088"        //UAT外网
//#define SERVER_IP @"http://115.182.212.162:8080"        //UAT外网

/**********************  交易服务器 配置  *************************/


//#define SERVER_IP   @"http://115.182.212.158:8080"       //  UAT
//#define SERVER_IP   @"http://10.99.5.11:9090"            //  开发
//#define SERVER_IP   @"http://115.182.212.146:8080"       //  SIT
//#define SERVER_IP   @"https://www.juranjinkong.com"      //  生产
//#define SERVER_IP   @"http://172.16.251.121:9001"        //  和大师专用




/* 配置服务端前缀  */
#define SERVER_PREFIX @"mpweb/"
/* 配置服务端URL */
#define SERVER_URL [NSString stringWithFormat:@"%@/%@",SERVER_IP,SERVER_PREFIX]



/**********************  GO 配置  *************************/

//#define GO_SERVER_IP @"https://mbank.bankofyk.com:9443"  //  生产
//#define GO_SERVER_IP @"https://www.juranjinkong.com"       //  生产
//#define GO_SERVER_IP @"http://115.182.212.188"       //  居然生产-ip访问


//#define GO_SERVER_IP @"http://115.182.212.146:8088"        //  SIT
//#define GO_SERVER_IP @"http://10.99.5.11:9999"           //  内网测试
//#define GO_SERVER_IP @"http://115.182.212.158:18086"     //  UAT




/** 版本校验 */
#define CheckVersionUrl [NSString stringWithFormat:@"%@/clients/versionupdate",GO_SERVER_IP]
/** Tab信息 */
#define ServerUrl [NSString stringWithFormat:@"%@/clients/nav",GO_SERVER_IP]
/** zip信息查询 */
#define ZipInfo [NSString stringWithFormat:@"%@/clients/app",GO_SERVER_IP]
/** 版本号 */
#define appVerisonId @"22"


/**********************  GO 配置完成  *************************/


// 二维码
#define QRServer @"https://mob.csii.com.cn/iapadmin/qrcode.html"
// app store地址
#define AppStoreUrl @"itms-apps://itunes.apple.com/us/app/ke-lan-yi-dong-jin-rong/id1238107093?l=zh&ls=1&mt=8"

#endif
