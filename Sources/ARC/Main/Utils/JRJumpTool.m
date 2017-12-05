
//
//  JRJumpTool.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2016/12/5.
//  Copyright © 2016年 Shen Yu. All rights reserved.
//

#pragma mark -  URL路由规则
/*
 信息流数据报文中会提供URL作为点击后的响应目标，包含如下字段：
 
 Url 网页/H5应用URL
 AppUrl 应用包URL
 FeedUrl 信息流数据URL（原nav.json中的ContentUrl，已改名）
 ExtUrl 外部应用URL （拨打电话，打开safari，打开微信）
 处理URL时的规则如下：
 
 判断是否存在FeedUrl字段，如有，则使用信息流视图打开。
 判断是否存在ExtUrl字段，如有，则使用URL路由器的openExternal方法打开。
 判断是否同时存在AppUrl和Url字段，如有，则使用轻应用引擎(原VX Web模块)下载并打开。
 判断Url字段是否包含"://"字串，如有，则为网页或H5应用，使用H5应用引擎（原网页浏览器）打开。
 如果Url字段不包含"://"字串，则为相对路径，注册了原生视图，使用URL路由器打开。
 以上任何条件都不符合，则不执行任何打开动作，日志输出错误信息，并在行为信息系统上报。
 */


#import "JRJumpTool.h"
#import "CPCacheUtility.h"
#import "CSIIDownLoadUtility.h"
#import "JRUtils.h"
//#import "JRUploadIdCardViewController.h"
#import "CPImage.h"
//#import "JRSYImagePickerViewController.h"
//#import "Register2ViewController.h"
//#import "JRBindCardViewController.h"
#import "JRConsumeResultViewController.h"
#import "CPOpenPdf.h"
#import "JRConsumeQRViewController.h"
//#import "JRBindCardViewController.h"
//#import "ChangeLoginPasswordViewController.h"
//#import "JRChangeTransactionPasswordViewController.h"
//#import "JRForgetTransactionPassword2ViewController.h"
//#import "ForgetLoginPassword2ViewController.h"
//#import "JRBindCardViewController.h"

@implementation JRJumpTool

+ (void)jumpWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller{

    
//    CPOpenPdf *pp = [[CPOpenPdf alloc] init];
//    [pp openPdf];
//    return;
    
//    JRBindCardViewController *cus = [[JRBindCardViewController alloc] init];
//    [Singleton.rootViewController pushViewController:cus animated:YES];
//    return;
    
    DebugLog(@"跳转事件处理\n%@",infoDict);
    if (![JRUtils dictWithUrl:infoDict]) return ;
    
    if ([JRUtils urlNeedsLogin:infoDict])
    {
        if (Singleton.isLogin == NO)
        {
            DebugLog(@"未登录");
            NSString *tmpUrl;
            if ([infoDict[@"Url"] hasSuffix:authStr]) {
                NSRange range = [infoDict[@"Url"] rangeOfString:authStr];
                tmpUrl = [infoDict[@"Url"] substringToIndex:range.location];
            }else{
                tmpUrl = infoDict[@"Url"];
            }
            tmpUrl = [tmpUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            // 首页---我要贷款--跳VX
            if ([tmpUrl hasSuffix:jAppLoan])
            {
                Singleton.jumpVC = XiaoFeiDaiKuan;
            }
            
            // 首页---扫码支付--跳原生
            if ([tmpUrl hasSuffix:jConsumeQr])
            {
                Singleton.jumpVC = SaoMaZhiFu;
            }
            
            // 首页---企业专区--跳原生
            if ([tmpUrl hasSuffix:jCompany])
            {
                Singleton.jumpVC = ShangHuDaiKuan;
            }
            
            // 首页---员工专区--跳原生
            if ([tmpUrl hasSuffix:YuanGong])
            {
                Singleton.jumpVC = YuanGongDaiAll;
            }
            
            
            if ([tmpUrl hasSuffix:jSetting])
            {
                Singleton.jumpVC = SetVC;
            }

            [JRPluginUtil needReLogin];;

            
//            [[Routable sharedRouter] open:@"login" animated:YES extraParams:nil];
            return ;
        }
    }
    
    if (infoDict == nil) return;
    
    
    /************** 路由拦截 *********有时间重构****************/
    NSString *tmpUrl;
    if ([infoDict[@"Url"] hasSuffix:authStr]) {
        NSRange range = [infoDict[@"Url"] rangeOfString:authStr];
        tmpUrl = [infoDict[@"Url"] substringToIndex:range.location];
    }else{
        tmpUrl = infoDict[@"Url"];
    }
    tmpUrl = [tmpUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // 我的---设置--跳原生
    if ([tmpUrl hasSuffix:jSetting]) {
        [JRJumpIntercept settingWithDictionary:infoDict baseUrl:baseUrl controller:controller];
        return;
    }
    
    // 我的---帮助中心--跳原生
    if ([tmpUrl hasSuffix:jHelpCenter]) {
        [JRJumpIntercept helpCenterWithDictionary:infoDict baseUrl:baseUrl controller:controller];
        return;
    }
    
    // 我的---电子发票--跳原生
    if ([tmpUrl hasSuffix:Invoice]) {
        [JRJumpIntercept InvoiceWithDictionary:infoDict baseUrl:baseUrl controller:controller];
        return;
    }
    
    
    // 首页---扫码支付--跳原生
    if ([tmpUrl hasSuffix:jConsumeQr]) {
        [JRJumpIntercept consumeQrWithDictionary:infoDict baseUrl:baseUrl controller:controller];
        return;
    }
    
    // 首页---我要贷款--跳VX
    if ([tmpUrl hasSuffix:jAppLoan]) {
        [JRJumpIntercept appLoanWithDictionary:infoDict baseUrl:baseUrl controller:controller success:^{
            [self specificJumpWithDictionary:infoDict baseUrl:baseUrl controller:controller];
        }];
        return;
    }
    
    // 首页---个人贷款--跳原生
    if ([tmpUrl hasSuffix:jHomePersonalLoan]) {
        [JRJumpIntercept homeLoanWithDictionary:infoDict baseUrl:baseUrl controller:controller];
        return;
    }
    
    
    
    // 首页---企业专区--跳原生
    if ([tmpUrl hasSuffix:jCompany])
    {
        if (Singleton.isLogin == NO)
        {
            DebugLog(@"未登录");
            [JRPluginUtil needReLogin];;

//            [[Routable sharedRouter] open:@"login" animated:YES extraParams:nil];
            return ;
        }
        
        if (Singleton.userInfo[@"E_CifNo"])
        {
            [[Routable sharedRouter] open:jCompany animated:YES extraParams:nil];
        }else{
            alertView(@"您还不是企业用户，请前往PC端进行企业注册。");
        }
        return;
    }
    
    // 首页---员工专区--跳原生
    if ([tmpUrl hasSuffix:YuanGong])
    {
        
        
        if ([Singleton.userInfo[@"EmployeeFlag"] isEqualToString:@"true"])
        {
            
            if (!Singleton.userInfo[@"CifName"] ||[Singleton.userInfo[@"CifName"] length] == 0)
            {
                alertView(@"您尚未进行实名认证");
            }
            else
            {
                if (!Singleton.userInfo[@"Entitycard"] ||[Singleton.userInfo[@"Entitycard"] length] == 0)
                {
                    alertView(@"您个人账户尚未绑卡");
                }
            }
            
            [JRJumpClientToVx jumpWithZipID:kStaffLoan controller:Singleton.rootViewController];
        }
        else
        {
            alertView(@"您不是居然集团内部员工或暂无员工贷申请资格，无法申请员工贷款");
        }
        
        return;
    }
    
    /*
     {
     "AppClass": "H",
     "Background": "#EEEFF3",
     "BgImageUrl": "/clients/useruploads/iap/home/enterprisezone3.png",
     "ContentList": "[{}]",
     "Id": "floor_enterprise_center",
     "ImageSize": {
     "Height": "140",
     "Width": "750"
     },
     "LayoutId": "lyHome",
     "Title": "企业专区",
     "Type": "RichText",
     "Url": "company"
     },
     
     {
     "AppClass": "H",
     "Background": "#EDEDED",
     "BgImageUrl": "/clients/useruploads/iap/home/img_loan_title_yuangong.png",
     "ContentList": "[{}]",
     "Id": "index_loan_title_yuangong",
     "ImageSize": {
     "Height": "222",
     "Width": "1125"
     },
     "LayoutId": "lyHome",
     "Title": "员工贷标题",
     "Type": "RichText",
     "Url": "employee"
     },
     */
    
    
    [self specificJumpWithDictionary:infoDict baseUrl:baseUrl controller:controller];
}

+ (void)specificJumpWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller
{

    if (infoDict[@"FeedUrl"])
    {
        DebugLog(@"公众号存在feedUrl---\n%@",infoDict[@"FeedUrl"]);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if ([infoDict[@"FeedUrl"] hasPrefix:@"http"])
        {
            [dict setObject:infoDict[@"FeedUrl"] forKey:@"Url"];
        }
        else
        {
            [dict setObject:[NSString stringWithFormat:@"%@%@",baseUrl,infoDict[@"FeedUrl"]] forKey:@"Url"];
        }
        if (infoDict[@"Title"])
        {
            [dict setObject:infoDict[@"Title"] forKey:@"Title"];
        }
        else
        {
            [dict setObject:@"" forKey:@"Title"];
        }
        [[Routable sharedRouter] open:@"publisher" animated:YES extraParams:dict];
        
    }
    else if (infoDict[@"AppUrl"])
    {
        CPCacheUtility *cache = [CPCacheUtility sharedInstance];
        
        NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"CPMenu"];
        NSFileManager *fileManage = [NSFileManager defaultManager];
        NSArray *files = [fileManage subpathsOfDirectoryAtPath: filePath error:nil];
        
        NSArray *array = [infoDict[@"AppUrl"] componentsSeparatedByString:@"/"]; //从字符A中分隔成2个元素的数组
        NSArray *arr = [array.lastObject componentsSeparatedByString:@"."];
        NSString *fileName = arr[0];
        
        
        NSString *sevUrl;
        BOOL hasSuffix = NO;
        //有后缀#allauth
        if ([infoDict[@"Url"] hasSuffix:authStr]) {
            hasSuffix = YES;
        }
        
        if (hasSuffix == YES) {
            NSRange range = [infoDict[@"Url"] rangeOfString:authStr];
            sevUrl = [infoDict[@"Url"] substringToIndex:range.location];
        }else{
            sevUrl = infoDict[@"Url"];
        }
        sevUrl = [sevUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        BOOL hasZip = NO;
        
        
        for (NSString *str in files)
        {
            if ([str isEqualToString:fileName])
            {
                //已经有包
                NSString *sql12 = [NSString
                                   stringWithFormat:
                                   @"INSERT INTO infoTable ('%@','%@') VALUES ('%@','%@')",
                                   @"name",@"UpdateTime",fileName,[JRUtils nowTimeStr]];
                [cache insertToTable:@"infoTable" withNameStr:fileName withSqlTtr:sql12];
                
                hasZip = YES;
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:sevUrl forKey:@"Url"];
                
                // 设置一个字段表示是要跳转vx的
                [dict setObject:@"Vx" forKey:@"VxUrl"];
                
                if (infoDict[PartCellInfo])
                {
                    [dict setObject:infoDict[PartCellInfo]  forKey:PartCellInfo];
                }
                
                if ([infoDict[@"AppUrl"] hasPrefix:@"http"])
                {
                    [dict setObject:infoDict[@"AppUrl"] forKey:@"AppUrl"];
                }
                else
                {
                    [dict setObject:[NSString stringWithFormat:@"%@%@",baseUrl,infoDict[@"AppUrl"]] forKey:@"AppUrl"];
                }

                if ([Singleton.consumeInfoDict[@"applyNo"] length]>0) {
                    [dict setObject:Singleton.consumeInfoDict[@"applyNo"] forKey:@"applyNo"];
                }

                
                [[Routable sharedRouter] open:@"vxWeb" animated:YES extraParams:dict];
            }
        }
        if (hasZip == NO)
        {
            //下载 AppUrl
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:sevUrl forKey:@"Url"];
            // 设置一个字段表示是要跳转vx的
            [dict setObject:@"Vx" forKey:@"VxUrl"];
            
            if (infoDict[PartCellInfo]) {
                [dict setObject:infoDict[PartCellInfo]  forKey:PartCellInfo];
            }
            
            if ([Singleton.consumeInfoDict[@"applyNo"] length]>0) {
                [dict setObject:Singleton.consumeInfoDict[@"applyNo"] forKey:@"applyNo"];
            }

            
            CSIIDownLoadUtility *down = [[CSIIDownLoadUtility alloc] initWithFrame:controller.view.bounds];
            
            NSString *mAppUrl;
            if ([infoDict[@"AppUrl"] hasPrefix:@"http"]) {
                mAppUrl = infoDict[@"AppUrl"];
            }else{
                mAppUrl = [NSString stringWithFormat:@"%@%@",baseUrl,infoDict[@"AppUrl"]];
            }
            [down downLoadWithUrl:mAppUrl downLoadFinish:^(id responsdata, BOOL success) {
                if (success) {
                    NSLog(@"下载成功---走 Router");
                    [[Routable sharedRouter] open:@"vxWeb" animated:YES extraParams:dict];
                }else{
                    alertView(@"功能包不存在");
                }
            }];
            [controller.view addSubview:down];
        }
    }
    else
    { // 其余的都是url
        DebugLog(@"Url -- %@",infoDict[@"Url"]);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSString *commond;
        
        if (infoDict[@"Url"]) {
            
            if ([infoDict[@"Url"] hasSuffix:authStr]) {
                DebugLog(@"注册原生页面需要登录");
                NSRange range = [infoDict[@"Url"] rangeOfString:authStr];
                commond = [infoDict[@"Url"] substringToIndex:range.location];
                DebugLog(@"截取后缀后的common===%@",commond);
                [dict setObject:commond forKey:@"urlDes"];
                
            }else{
                [dict setObject:infoDict[@"Url"] forKey:@"urlDes"];
                
            }
        }
        if ([dict[@"urlDes"] rangeOfString:@"://"].length > 0 || [dict[@"urlDes"] rangeOfString:@"/"].length > 0)  {
            [[Routable sharedRouter] open:@"h5app" animated:YES extraParams:dict];
        }else{
            if ([[[Routable sharedRouter] routes].allKeys containsObject:dict[@"urlDes"]]) {
                [[Routable sharedRouter] open:dict[@"urlDes"] animated:YES extraParams:nil];
            }else{
                alertView(@"请正确配置Url链接:https://或http://")
            }        }
    }
}
@end
