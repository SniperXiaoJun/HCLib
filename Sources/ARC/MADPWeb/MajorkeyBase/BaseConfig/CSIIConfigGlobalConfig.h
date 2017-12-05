//
//  CSIIConfigGlobalConfig.h
//  BankofYingkou
//  开发：
//  维护：
//  Created by 刘旺 on 13-4-22.
//  Copyright (c) 2013年 北京科蓝软件系统股份有限公司. All rights reserved.
//
#import <UIKit/UIKit.h>
#pragma mark - 环境配置

//
///************************************************************************
// *
// *内部挡板    MODEL_LOCAL
// *开发环境    MODEL_DEBUG
// *发布环境    MODEL_RELEASE
// *测试环境    MODEL_TEST
// *准生产环境   MODEL_QUASIPRODUCTION
// *
// ***********************************************************************/
//#ifdef DEBUG
////#define MODEL_LOCAL
//#define MODEL_DEBUG
////#define MODEL_TEST
////#define MODEL_RELEASE
////#define MODEL_QUASIPRODUCTION
////#define MODEL_EDIT
//#else
//#define MODEL_RELEASE
//#endif
//
//
//#pragma mark - 配置服务端IP
///************************************************************************
// *
// *配置服务端IP
// *
// ***********************************************************************/
//#if defined(MODEL_DEBUG)
////#define SERVER_IP @"http://10.1.240.132:7005"
////#define SERVER_IP @"http://10.1.1.114:8080"
////#define SERVER_IP   @"http://10.1.1.139:9082"
//#define SERVER_IP \
//@"http://124.207.86.58:9082" // 10.1.1.136:8088 //172.16.64.136:9104""
//// //192.168.0.113:9104" //172.16.0.19:9104
//// 收益//@"172.16.64.229:9104" //登录
//// //172.16.64.229:9104 //测试环境
//#elif defined(MODEL_LOCAL)
//#define SERVER_IP @"http://124.207.86.58:9082"
//#elif defined(MODEL_RELEASE)
//#define SERVER_IP @"http://124.207.86.58:9082"
////#define SERVER_IP @"http://www.tmfcncs.com"
//#elif defined(MODEL_TEST)
//#define SERVER_IP \
//@"http://124.207.86.58:9082" //@"172.16.0.168:9104"//@"172.16.64.229:9104"
//////@"172.16.0.19:9104" //聚利宝
////@"172.16.0.18:9104" //贷款
//#elif defined(MODEL_QUASIPRODUCTION)
//#define SERVER_IP @"http://124.207.86.58:9082" //资金转出
////#elif defined (MODEL_EDIT)
////#define SERVER_IP [[NSUserDefaults
//// standardUserDefaults]stringForKey:@"SERVER_IP"]
//#endif
///***********************************************************************/
//
//#pragma mark - 内部挡板服务器
///************************************************************************
// *
// *内部挡板服务器的宏
// *同时设定内部挡板的端口
// *
// ***********************************************************************/
//#ifdef DEBUG
//#ifdef MODEL_LOCAL
//#define INNERSERVER_PORT 8888
//#endif
//#endif
///***********************************************************************/


#define WRITE_LOCAL_WEB
#pragma mark - 日志开关
/************************************************************************
 *
 *日志开关
 *
 ***********************************************************************/

#define LOG_BASICMESSAGE
#define LOG_TRANSACTION
#define LOG_PAGE
/***********************************************************************/



//捕获.do交易数据，写到文件里
//#define TRANS_DATA_WRITE_TO_FILE

// TODO VXWEB
/************************************************************************
 *
 *vx首页从本地还是服务器读取的开关
 *
 ***********************************************************************/
//#define GET_DATA_FROM_LOCAL_FILE YES
//#define DO_FROM_LOCAL
//#define HTML_FROM_LOCAL

//#define GET_DATA_FROM_LOCAL_FILE NO
/***********************************************************************/

/************************************************************************
 *
 *vx首页从本地还是服务器读取的开关
 *
 ***********************************************************************/
//#define LOAD_INDEX_HTML_FROMSERVER  /*vx首页从本地还是服务器读取的开关*/
//#define LOAD_HTML_FROM_DEBUGSERVER
//#define DEBUGSERVER_IP @"http://172.16.64.129:8080"
/***********************************************************************/

//#define DO_DATA_FROM_LOCAL  //从本地读取.do交易数据

//#define USE_TEST_SERVER

#ifdef USE_TEST_SERVER
#define GET_DATA_FROM_LOCAL_FILE NO
#define LOAD_HTML_FROM_DEBUGSERVER
#define DEBUGSERVER_IP @"http://172.16.64.127:8080"
//    #define DEBUGSERVER_IP @"http://172.16.64.123:8080"
#else
#define GET_DATA_FROM_LOCAL_FILE YES
#define DO_FROM_LOCAL
#define HTML_FROM_LOCAL
#endif

/************************************************************************
 *
 *vx拦截采用protocol还是webview的切换开关
 *
 ***********************************************************************/
//#define USE_NSURLPROTOCOL
#define READ_ZIP
/***********************************************************************/

/************************************************************************
 *
 *配置服务端前缀
 *
 ***********************************************************************/
#define LOCAL_WEB @"pweb"
#define SERVER_PATH @"portal"
#define SERVER_BACKEND_PATH @"Product_pweb"
/***********************************************************************/

//#if defined(MODEL_EDIT)
//#define SERVER_URL \
//    [[NSUserDefaults standardUserDefaults] stringForKey:@"SERVER_URL"]
//#else
//#define SERVER_URL \
//    [NSString stringWithFormat:@"%@/%@", [CSIIBusinessContext sharedInstance].serverUrl, [CSIIBusinessContext sharedInstance].serverPath]
//#endif

/************************************************************************
 *
 *是否信任不加证书的SSL
 *
 ***********************************************************************/
#define SERVER_CHECKSSL YES
//#define SERVER_CHECKSSL NO
/***********************************************************************/

#define POST @"POST"
#define GET @"GET"

/************************************************************************
 *
 *请求头
 *
 ***********************************************************************/
#define SERVER_HEADER                           \
    @{                                          \
       @"Accept-Language" : @"zh-CN,zh;q=0.8",  \
       @"Content-Type" : @"application/json",   \
       @"Connection" : @"Keep-Alive",           \
       @"Accept" : @"text/xml,application/json" \
    }
//@"Accept":@"text/xml,application/xhtml+xml,application/xhtml+xml,application/xml;q=0.9,*/*"   \
\
//@"Content-Type":@"application/x-www-form-urlencoded",

/***********************************************************************/
/************************************************************************
 *
 *配置提交页面显示信息和显示数据
 *
 ***********************************************************************/
#define submitTransactionName @"submitTransactionName"
#define submitTransactionArg @"submitTransactionArg"
#define submitTransactionShowInfo @"submitTransactionShowInfo"
#define kShowInfoTextLabel @"kShowInfoTextLabel"
#define kShowInfoText @"kShowInfoText"
#define kShowInfoTextColor @"kShowInfoTextColor"
#define kShowInfoOnResultFlag @"kShowInfoOnResultFlag"
#define kShowInfoIsShowOTPFlag @"kShowInfoIsShowOTPFlag"
#define kShowInfoTextAlignment @"kShowInfoTextAlignment"
/************************************************************************
 *
 *配置服务端通信超时时间
 *
 ***********************************************************************/
#define SERVER_TIMEOUT 90
/***********************************************************************/

// iPhone
#define IPHONE \
    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
// iPad
#define IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/************************************************************************
 *
 *网络异常给出的提示信息的时间间隔
 *
 ***********************************************************************/
#define NETWORKERROR_TIME 5
/***********************************************************************/

/************************************************************************
 *
 *字典配置文件名
 *
 ***********************************************************************/
#define DICTFILENAME @"dictionary.json"
/***********************************************************************/

/************************************************************************
 *
 *转场动画配置
 *
 ***********************************************************************/
#define ANIMATE_DURATION 0.8
#define ANIMATIONFILENAME @"animation.json"
#define ANIMATIONFILENAMEHD @"animationHD.json"
#define PAGENETWORKPOWER @"pagenetworkpower.json"
/***********************************************************************/

#pragma mark - 启动动画结束时间配置
/************************************************************************
 *
 *启动动画结束时间配置
 *
 ***********************************************************************/
#define SPLASHSCREEN_ENDPLAYBACKTIME 4
/***********************************************************************/

/************************************************************************
 *
 *我的银行定制菜单配置配置
 *
 ***********************************************************************/
#define kMenuList @"MenuList"
#define kMenuField @"menu.json"
#define kMenuFieldHD @"menuHD.json"
/***********************************************************************/

#pragma mark - 接口返回信息返回标志
/************************************************************************
 *
 *加密公钥配置
 *
 ***********************************************************************/
#define PUBLICKEY @"fkasdfasjflasjflkasjflasjfljasfj"
/***********************************************************************/

/************************************************************************
 *
 *接口返回信息返回标志
 *
 ***********************************************************************/
#define RETURNCODE @"_RejCode"
#define RETURNMESSAGE @"jsonError"
#define SUCCESS_CODE @"000000"
#define ERROR_LOGIC @"999999"
#define ERROR_LINK @"999990"
#define ERROR_PASSWORD @"000009"
#define SESSION_FAILED @"888888"
/***********************************************************************/

#pragma mark - 公共配置

#define ChannelId @"PMBS"
#define BankId @"9999" //银行id
#define ExistCheckFlag @"false" //短信验证码时需要上传字段
#define TokenIndex @"1" //短信验证码时需要上传字段
#define TokenMessage_Card @"sms.ChangeBindCard.P" //变更绑卡
#define TokenMessage_TransferOut @"sms.TransferOut.P" //资金转出
#define TokenMessage_UserInfo @"sms.UpdateInfo.U" //变更个人信息
#define TokenMessage_LoginPw @"sms.updatepassword.msg" //登录密码修改
#define TokenMessage_TradePw @"sms.modtrspassword.msg" //交易密码修改
#define TokenMessage_PhoneNo @"sms.UpdatePhone.U" //修改手机号
#define ChangePhoneNo @"sms.ChangePhoneNo.P" //登录前变更手机号
#define TokenMessage_RPhoneNo @"sms.RegisterPre.P" // 重置手机号
#define TokenMessage_Register @"sms.RegisterPre.P" //变更手机号
#define TokenMessage_Retieve @"sms.findPassword.P" //变更手机号
#define Resettrs_Password @"sms.resettrspassword.msg"

/***********************************************************************/

#pragma mark - 配置服务接口
/************************************************************************
 *
 *配置服务接口
 *
 ***********************************************************************/
#define GenTokenImg @"GenTokenImg.do" //图形校验码
#define TransferOutPre @"TransferOutPre.do" //资金转出预备
#define TransferOutConfirm @"TransferOutConfirm.do" //资金转出校验
#define TransferOut @"TransferOut.do" //资金转出交易
#define AvailBalQry @"AvailBalQry.do" //资金转出余额查询
#define GenToken @"GenToken.do" //获得token码，防重复
#define Timestamp @"Timestamp.do" //获取时间戳
#define AutoGenPhoneToken @"AutoGenPhoneToken.do" //获取验证码

#define logout @"logout.do"
#define login @"login.do"

#pragma mark - 通知指令名
#define NTF_Global_LOGIN  @"Global|login" //登陆通知指令
#define NTF_APP_LOGOUT  @"Global|Logout" //登出通知指令
#define NTF_LOADING_FINISH  @"Loading|Finish" //关闭通知指令

#pragma mark - 异步加载图片超时时间
/************************************************************************
 *
 *异步加载图片超时时间
 *
 ***********************************************************************/
#define kAsyncLoadImageTimeOut 30
/***********************************************************************/

@interface CSIIConfigGlobalConfig : NSObject
+ (void)initDictConfig;
+ (void)initMenuConfig;
+ (void)initAnimationConfig;
//+(void)initAnimationConfigHD;
//+(void)initPageNetworkPowerConfig;
@end
