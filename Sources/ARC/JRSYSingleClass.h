//
//  JRSYSingleClass.h
//  ProductInfoFlow
//
//  Created by Shen Yu on 16/4/6.
//  Copyright © 2016年 Shen Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RxWebViewNavigationViewController.h"
#import "CWStatusBarNotification.h"

typedef enum{
    
#pragma mark - 首页
    SystemMessage = 0,  //左上角系统消息
    PersonMessage,      //右上角个人信息
    XiaoFeiDaiKuan,
    SaoMaZhiFu,
    ShangHuDaiKuan,
    LiuShuiDaiVC,       //流水贷
    YuanGongDaiAll,
    YuanGongDaiZi,
    XiaoFeiDaiLiJiShenQing,
    
#pragma mark - 贷款
    TopLoginOrJiHuo,// 只是登录
    TiE,
    HuanKuan,
    YGD_LeHuo,
    
#pragma mark - 我的
    ToCompany,
    ZhangDan,
    BankZhangHu,
    SetVC
} JumpViewController;

@class SYTabBarViewController;
@interface JRSYSingleClass : NSObject
+ (instancetype)shareInstance;
/** tabbar 数组 */
@property (nonatomic,strong) NSArray *tabBarArray;

@property (nonatomic,strong) UIImage *tmpImg;

/** 根路径 */
@property (nonatomic,strong) NSString *baseUrl;

@property (nonatomic,strong) NSDictionary *leftDic;
@property (nonatomic,strong) NSDictionary *rightDic;
@property (nonatomic,strong) NSMutableDictionary *navigationDC;

@property (nonatomic,strong) UINavigationController  *rootViewController;
@property (nonatomic,strong) SYTabBarViewController  *tabBarController;


/****设计家插件新增字段开始*****/
typedef void(^SJJLoginBlock)(NSDictionary *dict);

@property (nonatomic,strong) UIViewController  *loginViewController;
@property (nonatomic,strong) UIViewController  *SJJOPenVC;           //设计家进入的插件的页面
@property (nonatomic,strong) UIViewController  *myWalletVC;          //进入我的钱包页面
@property (nonatomic,strong) NSDictionary      *SJJUserInfo;         //设计家初始化插件带入的客户信息
@property (nonatomic,strong) NSDictionary      *consumeInfoDict;     //消费贷申请信息
@property (nonatomic,strong) NSDictionary      *consumeRaiseInfoDict;//消费贷提额信息
@property (nonatomic, copy)  SJJLoginBlock      SJJLoginBlock;       //设计家登录回调
@property (nonatomic,strong) NSMutableDictionary      *SJJInfo;//设计家带入跳页信息
@property (nonatomic,strong) NSDictionary      *creditInfo;//预授信信息

/****设计家插件新增字段结束*****/

@property (nonatomic,strong) NSMutableDictionary *indexDic;
@property (nonatomic,assign) int nowTabIndex;
@property (nonatomic,strong) NSString *nowVcTitle;
@property (nonatomic,strong) NSMutableArray *indexUrlArr;


/** 登录标志位 */
@property (nonatomic,assign) BOOL isLogin;
/*短信验证码标志位*/
@property (assign, nonatomic) BOOL isOTPUserFlag;

@property (assign, nonatomic) BOOL isHaveSetGesture;

@property (assign, nonatomic) BOOL serverGestureSwitchStatus;

@property (nonatomic, strong) NSMutableDictionary *memoryCache;



@property (strong, nonatomic) CWStatusBarNotification *notification;
/** 登录页面大背景 */
@property (nonatomic,copy) NSString *loginBg;
/** 版本号 */
@property (nonatomic,assign) int versionId;
@property (nonatomic,strong) NSDictionary *publicParamsDict;


@property (nonatomic,strong) NSMutableArray *cellInfoArr;

/* 判断是否是从Qr dismiss过来的 */
@property (assign, nonatomic) BOOL isDismissFormQr;

@property (nonatomic,strong) NSDictionary *userInfo;
/** 手机号 */
@property (nonatomic,copy) NSString *userID;


@property (nonatomic,strong) UIButton *serverBtn;


@property (nonatomic,assign) BOOL isAppActive;


@property (nonatomic,assign) BOOL isConsumeLoanLogin;

@property (nonatomic, assign) JumpViewController jumpVC;
@property (nonatomic, strong) NSMutableArray *jumpArray;

-(void)removeAllPic;
@end
