//
//  JRPLugin.m
//  JRPLugin
//
//  Created by 何崇 on 2017/10/26.
//  Copyright © 2017年 HeChong. All rights reserved.
//

#import "JRPLugin.h"
#import "JRGlobalVariable.h"
#import "JRSYPDFViewController.h"

#import "NickMBProgressHUD+MJ.h"
#import "PowerEnterUITextField.h"
#import "JRMyWalletViewController.h"
#import "JRStagePayAuthorizeController.h"
#import "JRStagePayAdsController.h"
#import "JRStagePayMenuController.h"
#import "JRPayTableViewController.h"
#import "CPCacheUtility.h"
#import "JRJumpClientToVx.h"
#import "JRScanViewController.h"
#import "JRConsumeQRViewController.h"
#import "CPMajorManager.h"
#import "JRSYHttpTool.h"
#import "JRPublisherH5Vc.h"



@interface JRPLugin ()

@property(nonatomic,strong) UIViewController *loginVC;

@end

@implementation JRPLugin

/*居然插件初始化入口
 *录入参数：info 输入字段为以下参数
 *custId    客户编号    NOT NULL    32    设计家用户ID
 *phone     手机号     NOT NULL    32
 *prodId    产品编号    NOT NULL    20    默认值：3000
 *tokenId   会话标识    NOT NULL    32    设计家Xtoken
 *status    贷款状态    NOT NULL    10    由查询交易返回
 *entrance  插件入口    NOT NULL    20    点击钱包跳转：QBTZ  点击额度跳转：EDTZ
 *
 *返回参数：checkXTokenBlock 初始化验证XToken回调 根据返回状态码判断是验证成功活着失败
 */
+ (instancetype)shareInstance {
    static JRPLugin *instances = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instances = [[JRPLugin alloc] init];
        [self initRoutable];
    });
    return instances;

}

//- (id)initPluginWithUserInfo:(NSDictionary *)info checkXTokenBlock:(void(^)(NSDictionary *dict))loginBlock{
//    self = [super init];
//    if (self) {
//        [self initRoutable];
//    }
//
//    Singleton.SJJUserInfo = [NSDictionary dictionaryWithDictionary:info];
//    if (loginBlock) {
//        Singleton.SJJLoginBlock = loginBlock;
//    }
//
//    return self;
//
//}

//初始化Routa
+ (void)initRoutable{

    [[CPUIActivityIndicator sharedInstance]
     addToShowView:[UIApplication sharedApplication].keyWindow];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    Singleton.rootViewController = (UINavigationController *)window.rootViewController;

    if ([Singleton.rootViewController.viewControllers lastObject]) {
        Singleton.SJJOPenVC = (UIViewController *)[Singleton.rootViewController.viewControllers lastObject];
    }else{
        Singleton.SJJOPenVC = Singleton.rootViewController;
    }

    
    DebugLog(@"initRoutableWithNav viewControllers:%@",Singleton.rootViewController.viewControllers);
    DebugLog(@"initRoutableWithNav Singleton.SJJOPenVC:%@",Singleton.SJJOPenVC);

    
    //设置发送接口的公共参数
    [CSIIBusinessContext sharedInstance].PublicArgument=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"zh_CN",@"_locale",@"99999",@"BankId",nil];
    [[CPMajorManager sharedInstance] setServerIP:SERVER_IP  withServerPath:@"mpweb"];
    
    
    //配置路由进行页面跳转
    [[Routable sharedRouter] setNavigationController:Singleton.rootViewController];
    [[Routable sharedRouter] map:@"vxWeb" toController:[JRVXWebViewController class]];
    [[Routable sharedRouter] map:@"h5app" toController:[JRH5AppViewController class]];
    //    [[Routable sharedRouter] map:@"publisher" toController:[SecondaryVc class]];
    [[Routable sharedRouter] map:@"publisherH5" toController:[JRPublisherH5Vc class]];
    [[Routable sharedRouter] map:@"consumeqr" toController:[JRConsumeQRViewController class]];
    [[Routable sharedRouter] map:@"scan" toController:[JRScanViewController class]];
    [[Routable sharedRouter] map:@"switchseverurl/:id" toCallback:^(NSDictionary *params) {
        NSString *url = [[params objectForKey:@"id"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        DebugLog(@"map--id===%@",url);
        [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"navUrl"];
    }];
    
    [[CPCacheUtility sharedInstance] openSqlite];
    [CPCacheUtility sharedInstance].isCacheProtocol  = YES;
    
}

/*根据贷款状态进入居然插件页面
 *PS：居然金融根据 entrance（插件入口）和status（贷款状态判断跳转页面）
 *录入参数info： 输入字段为以下参数
 *custId    客户编号    NOT NULL    32    设计家用户ID
 *phone     手机号     NOT NULL    32
 *prodId    产品编号    NOT NULL    20    默认值：3000
 *tokenId   会话标识    NOT NULL    32    设计家Xtoken
 *status    贷款状态    NOT NULL    10    由查询交易返回
 *entrance  插件入口    NOT NULL    20    点击钱包跳转/账户余额：QBTZ   点击额度跳转：EDTZ
 *
 */

- (void)ToJRPluginWithEntranceInfo:(NSDictionary *)info loginBlock:(void(^)(NSDictionary *dict))loginBlock{
    //1.进行X-Token验证
    //2.验证成功则继续跳页
    //3.验证失败则走回调函数 Singleton.SJJLoginBlock(nil);

    Singleton.SJJInfo = [NSMutableDictionary dictionaryWithDictionary:info];

    if (loginBlock) {
        Singleton.SJJLoginBlock = loginBlock;
    }

    //直接进入我的钱包
    JRMyWalletViewController *wallet = [[JRMyWalletViewController alloc] init];
    Singleton.myWalletVC = wallet;
    [Singleton.rootViewController pushViewController:wallet animated:YES];
    return;


    //验证通过
    if ([self checkXToken]) {

        //是否已同意授权协议
        BOOL isAuthorized = YES;

        if ([info[@"isAuthorized"] isEqualToString:@"Y"]) {
            isAuthorized = YES;
        }else{
            isAuthorized = NO;
        }

        //点击钱包／余额跳转
        if ([[info objectForKey:@"entrance"] isEqualToString:@"QBTZ"]){

            if (isAuthorized == YES) {
                //已授权 直接进入我的钱包
                JRMyWalletViewController *wallet = [[JRMyWalletViewController alloc] init];
                Singleton.myWalletVC = wallet;
                [Singleton.rootViewController pushViewController:wallet animated:YES];
            }else{
                //进入授权页面，同意之后才可进入钱包
                JRStagePayAuthorizeController *authorizeVC = [[JRStagePayAuthorizeController alloc] init];
                authorizeVC.nextpageVCName = @"JRMyWalletViewController";
                [Singleton.rootViewController pushViewController:authorizeVC animated:YES];
            }
        }
        
        //点击额度跳转
        else if ([[info objectForKey:@"entrance"] isEqualToString:@"EDTZ"]) {
            //无申请状态
            if ([info[@"status"] isEqualToString:@""] ||
                [info[@"status"] isEqualToString:@"SQZT_NULL"] ||
                [info[@"status"] isEqualToString:@"SQZT_YGD"] ||
                info[@"status"] == nil ) {

                if (isAuthorized == YES) {

                    //已授权未阅读过引导页 直接进入消费贷引导页
                    JRStagePayAdsController *payAds = [[JRStagePayAdsController alloc] init];
                    [Singleton.rootViewController pushViewController:payAds animated:YES];
                }else{
                    //进入授权页面，同意之后进入引导页
                    JRStagePayAuthorizeController *authorizeVC = [[JRStagePayAuthorizeController alloc] init];
                    [Singleton.rootViewController pushViewController:authorizeVC animated:YES];
                }

            }
            //待审核
            else if ([info[@"status"] isEqualToString:@"SQZT_SQ"]) {
                DebugLog(@"待审核");
                //直接进入我的钱包
                JRMyWalletViewController *wallet = [[JRMyWalletViewController alloc] init];
                Singleton.myWalletVC = wallet;
                [Singleton.rootViewController pushViewController:wallet animated:YES];
            }
            //审批中
            else if ([info[@"status"] isEqualToString:@"SQZT_SPZ"]) {
                //进入补录页面
                DebugLog(@"补充资料");
                [JRJumpClientToVx jumpWithZipID:Consume_upload controller:Singleton.rootViewController];
            }
            //审核通过待激活
            else if ([info[@"status"] isEqualToString:@"SQZT_TG"]) {
                DebugLog(@"去激活");
                [JRJumpClientToVx jumpWithZipID:Consume_active controller:Singleton.rootViewController];
            }
            //已激活
            else if ([info[@"status"] isEqualToString:@"SQZT_JH"]) {
                DebugLog(@"已激活 进入还款页面");
                [JRJumpClientToVx jumpWithZipID:Consume_repay controller:Singleton.rootViewController];
            }
            //被拒绝
            else if ([info[@"status"] isEqualToString:@"SQZT_XTJJ"] ||
                     [info[@"status"] isEqualToString:@"SQZT_JJ"] ||
                     [info[@"status"] isEqualToString:@"SQZT_TH"]) {
                DebugLog(@"被拒绝");
                //直接进入我的钱包
                JRMyWalletViewController *wallet = [[JRMyWalletViewController alloc] init];
                Singleton.myWalletVC = wallet;
                [Singleton.rootViewController pushViewController:wallet animated:YES];
            }
        }
    }else{
    //验证失败 回调设计家回调函数
        Singleton.SJJLoginBlock(nil);
    }

}

//X-Token校验入口
- (BOOL)checkXToken{

    return YES;

    /*
     @何崇 @张佳男安卓开发 xtoken校验
     交易：TokenLogin.do
     上送字段 XToken
     返回
     OpenFinance true/false(是否已开通居然金融分期付)
     */

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];

    [params setObject:@"76fc7040-bd2d-4112-a7d6-69655403535c" forKey:@"XToken"];

    [JRSYHttpTool post:@"TokenLogin.do" parameters:params success:^(id json) {

        if ([json[@"_RejCode"] isEqualToString:@"000000"])
        {
            NSArray *arr = json[@"List"];
            if (arr.count != 0)
            {
                alertView(json);
            }
            else
            {
                alertView(@"获取银行列表失败");
            }
        }

    } failure:^(NSError *error) {

    }];

    return YES;
}

/*分期支付入口
 *支付页面点击开通走 ToJRPluginWithEntranceInfo 接口
 *录入参数：orderInfo  订单信息为以下字段
 *custId        客户编号    NOT NULL    32    设计家用户ID
 *prodId        产品编号    NOT NULL    32    默认值：3000
 *tokenId       token     NOT NULL    32    设计家Xtoken
 *Amount        交易金额    NOT NULL    20
 *Term          分期期数    NOT NULL    10
 *MerNo         商户号    NOT NULL    32
 *StoreNo       门店号    NOT NULL    32
 *BloothNo      摊位号    NOT NULL    20
 *OrderNo       交易单号    NOT NULL    50
 *TranDate      交易日期    NOT NULL    30
 *MerchantRate  商户费率    NOT NULL    10
 *Memo          备注信息        100
 *
 *返回参数：orderBlock 订单回调函数
 */

- (NSDictionary *)ToJRStagePayOrderInfo:(NSDictionary *)orderInfo orderBlock:(void(^)(NSDictionary *dict))orderBlock{

    if (Singleton.SJJInfo != nil) {
        [Singleton.SJJInfo setValue:@"SJJPAY" forKey:@"entrance"];
    }else{
        Singleton.SJJInfo = [NSMutableDictionary dictionary];
        [Singleton.SJJInfo setValue:@"SJJPAY" forKey:@"entrance"];
    }



    JRPayTableViewController *jrPay = [[JRPayTableViewController alloc] init];
    [Singleton.rootViewController pushViewController:jrPay animated:YES];

    return nil;

//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂未开通" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alert show];
//
//    //跳转支付页面
//    return nil;
}



/*
 * 废弃代码
 */
- (void)gotoMyWallet{
    NSLog(@"plugin_______gotoMyWallet");
    
    JRMyWalletViewController *wallet = [[JRMyWalletViewController alloc] init];
    Singleton.myWalletVC = wallet;
    [Singleton.rootViewController pushViewController:wallet animated:YES];
}


- (void)testSYHttpRequest{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
    
    [JRSYHttpTool post:@"BankMsgListQry.do" parameters:params success:^(id json) {
        
        if ([json[@"_RejCode"] isEqualToString:@"000000"])
        {
            NSArray *arr = json[@"List"];
            if (arr.count != 0)
            {
                alertView(json);
            }
            else
            {
                alertView(@"获取银行列表失败");
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)testSqlite3{
    CPCacheUtility *cache = [CPCacheUtility sharedInstance];
    NSArray *cacheArr = [cache readSqlInfo];
    DebugLog(@"=====%@",cacheArr);
    //清理数据库  +  清理CPMenu下zip包
    if (cacheArr) {
        for (NSDictionary *dict in cacheArr) {
            DebugLog(@"可以删除了");
            NSString* filePath =
            [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
             stringByAppendingPathComponent:@"CPMenu"];
            
            //删除zip包
            NSString* deletePath = [NSString stringWithFormat:@"%@/%@", filePath, dict[@"name"]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:deletePath]) {
                [[NSFileManager defaultManager] removeItemAtPath:deletePath error:nil];
                [cache execSql:[NSString stringWithFormat:@"DELETE FROM %@ WHERE name = '%@'",@"infoTable", dict[@"name"]] withOperationName:@"删除操作失败"];
            }
        }
    }
    
    
    //如果清理出错或者清理不完全则重新清理全部
    NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"CPMenu"];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSArray *files = [fileManage subpathsOfDirectoryAtPath: filePath error:nil];
    
    if (files.count>0) {
        for (NSString * p in files) {
            
            NSError * error = nil ;
            NSString * fileAbsolutePath = [filePath stringByAppendingPathComponent :p];
            if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
                [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
            }
        }
    }
    
    UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"缓存清除成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alt show];
    
}


- (void)testDownLoadZip {
    [JRJumpClientToVx jumpWithZipID:@"StaffLoan" controller:Singleton.rootViewController];
    
}

- (void)testUploadImage {
    
}

- (UITextField *)getPwdTextField{
    PowerEnterUITextField *pwdField = [[PowerEnterUITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    pwdField.backgroundColor = [UIColor clearColor];
    //输入的文字颜色为白色
    pwdField.textColor = [UIColor blackColor];
    //输入框光标的颜色为白色
    pwdField.tintColor = [UIColor clearColor];
    pwdField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    pwdField.isSound = NO;
    pwdField.isRoundam = NO;
    pwdField.borderStyle = UITextBorderStyleNone;
    pwdField.placeholder = @"";
    pwdField.timestamp = @"1234567890";
    pwdField.passwordKeyboardType = Full;
    pwdField.isHighlightKeybutton = YES;
    
    return pwdField;
    
}


- (void)loginAction:(UITextField *)passwordTextField mobilePhone:(NSString *)phone loginBlock:(void(^)(NSDictionary *dict))loginBlock{
    
    NSMutableDictionary *params_1 = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
    [JRSYHttpTool post:@"TimestampJson.do" parameters:params_1 success:^(id json) {
        ((PowerEnterUITextField *)passwordTextField).timestamp = json[@"Timestamp"];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];

        if (phone.length<=0) {
            alertView(@"手机号码不能为空！");
            return;
        }
        [params setObject:phone forKey:@"UserId"];//18810472840 15645210112
        
        if (passwordTextField) {
            [params setObject:((PowerEnterUITextField *)passwordTextField).value forKey:@"Password"];
        }
        
        
        [params setObject:@"" forKey:@"_vTokenName"];
        [params setObject:@"D" forKey:@"LoginType"];
        [params setObject:@"IOS" forKey:@"ChannelId"];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"MachineCode"]) {
            [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"MachineCode"] forKey:@"InfoFlag"];
        }

        [JRSYHttpTool post:Login_do parameters:params success:^(id json) {
            MaskHide
            if (![json[@"_RejCode"] isEqualToString:@"000000"]) {
                alertView(json[@"jsonError"]);
                return;
            }else{
                Singleton.isLogin = YES;
                Singleton.userInfo = json;
                DebugLog(@"userInfo: %@:",Singleton.userInfo);
                if (json[@"UserId"]>0) {
                    [[NSUserDefaults standardUserDefaults] setObject:json[@"UserId"] forKey:kUserId];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUserId];

                }

            }
            
            if (loginBlock) {
                loginBlock((NSDictionary *)json);
            }
            
        } failure:^(NSError *error) {
            alertView(@"交易失败，请重试");
            
            return ;
        }];
    } failure:^(NSError *error) {
        alertView(@"交易失败，请重试");
        return ;
    }];
    
}

- (void)gotoQRCode {
    JRConsumeQRViewController *p = [[JRConsumeQRViewController alloc] init];
    [Singleton.rootViewController pushViewController:p animated:YES];
}

- (void)downLoadPdfFile:(NSString *)urlStr isSign:(NSInteger)issign
{
    if ([NickMBProgressHUD respondsToSelector:@selector(showMessage:)]) {
        [NickMBProgressHUD showMessage:@"请稍后"];
    }else{
        DebugLog(@"未找到方法：[NickMBProgressHUD showMessage]");
    }
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/contract.pdf"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    
    //创建 Request
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    //下载进行中的事件
    SYAFURLConnectionOperation *operation = [[SYAFURLConnectionOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
    
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float progress =  (float)totalBytesRead / totalBytesExpectedToRead;
        //下载完成
        //该方法会在下载完成后立即执行
        if (progress == 1.0) {
            NSLog(@"下载成功");
            
            if ([NickMBProgressHUD respondsToSelector:@selector(hideHUD)]) {
                [NickMBProgressHUD hideHUD];
            }else{
                DebugLog(@"未找到方法：[NickMBProgressHUD hideHUD]");
            }
            
            JRSYPDFViewController *vc = [[JRSYPDFViewController alloc] initWithFilePath:filePath fileName:@"" pdfBlock:^(NSString *isBack) {
                
            } isSign:issign];
            
            [Singleton.rootViewController pushViewController:vc animated:YES];
        }
    }];
    
    
    [operation start];
}

@end
