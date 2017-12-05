//
//  JRJumpIntercept.m
//  CsiiMobileFinance
//
//  Created by ShenYu on 2017/5/1.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "JRJumpIntercept.h"
//#import "PersonalSettingsViewController.h"
//#import "HelpListViewController.h"
//#import "JRConsumeQRViewController.h"
//#import "CustomerLoanApplyVC.h"
//#import "ElectronicInvoiceTableVC.h"

@implementation JRJumpIntercept


/** 首页 - 我要贷款 */
+ (void)appLoanWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller success:(void(^)())success{
    
//    if (![CheckAcNElectronicInvoiceTableVC.ho isCheckOk]) return;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
    [params setObject:@"3000" forKey:@"prodId"];
    
    
    new_transaction_caller
    caller.transactionId = @"PerConsumerLoanApplyQuery.do"; //交易名
    caller.webMethod = POST;                                   // POST  GET
    caller.responsType = ResponsTypeOfJson; //返回数据处理
    caller.transactionArgument = params;   //上传参数
    caller.isShowActivityIndicator = YES;
    execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
        if (TransactionIsSuccess) {
            DebugLog(@"PerConsumerLoanApplyQuery.do-%@",TransReturnInfo);
            
            //FSLX_00新发生（非提额） FSLX_01提额
            if ([TransReturnInfo[@"status1"] isEqualToString:@"SQZT_NULL"] ||
                [TransReturnInfo[@"status1"] isEqualToString:@""]||
                [TransReturnInfo[@"status1"] isEqualToString:@"SQZT_TG"]) {
                success();
            }else if ([TransReturnInfo[@"status1"] isEqualToString:@"SQZT_SQ"]) {
                alertView(@"乐享消费贷申请中,请等待审核");
                
            }else if ([TransReturnInfo[@"status1"] isEqualToString:@"SQZT_JJ"]||
                      [TransReturnInfo[@"status1"] isEqualToString:@"SQZT_XTJJ"]) {
                alertView(@"乐享消费贷被拒绝");
                
            }else if ([TransReturnInfo[@"status1"] isEqualToString:@"SQZT_SPZ"]) {
                alertView(@"乐享消费贷审批中");
                
            }else if ([TransReturnInfo[@"status1"] isEqualToString:@"SQZT_JH"]) {
                alertView(@"您已申请过乐享消费贷,无需再次申请");
                
            }else{
                NSString *str = [NSString stringWithFormat:@"您已申请贷款,当前贷款状态:%@",TransReturnInfo[@"status"]];
                alertView(str);
            }
            
        }else{
            alerErr
        }
    }));
    
}


+ (void)homeLoanWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller{
//    CustomerLoanApplyVC *vc = [[CustomerLoanApplyVC alloc] init];
//    [Singleton.rootViewController pushViewController:vc animated:YES];

}
+ (void)settingWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller{
    
//    PersonalSettingsViewController *p = [[PersonalSettingsViewController alloc] init];
//    [Singleton.rootViewController pushViewController:p animated:YES];
    
}

+ (void)helpCenterWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller{

//    HelpListViewController *p = [[HelpListViewController alloc] init];
//    [Singleton.rootViewController pushViewController:p animated:YES];
}


+ (void)InvoiceWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller{

//    if (![JRCheckAcNo isCheckOk]) return;
    
    //查询个人电子发票
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
    [params setObject:@"P" forKey:@"PWDType"];
    new_transaction_caller
    caller.transactionId = @"wkpshlQry.do"; //交易名
    caller.webMethod = POST;                                   // POST  GET
    caller.responsType = ResponsTypeOfJson; //返回数据处理
    caller.transactionArgument = params;   //上传参数
    caller.isShowActivityIndicator = YES;
    execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
        if (TransactionIsSuccess) {
            DebugLog(@"电子发票:%@",TransReturnInfo);
            
//            if ([TransReturnInfo[@"List"] count]>0) {
//                ElectronicInvoiceTableVC *p = [[ElectronicInvoiceTableVC alloc] init];
//                p.invoiceList = [NSArray arrayWithArray:TransReturnInfo[@"List"]];
//                p.isPersonalInvoice = YES;
//                [Singleton.rootViewController pushViewController:p animated:YES];
//            }else{
//                ElectronicInvoiceTableVC *p = [[ElectronicInvoiceTableVC alloc] init];
//                p.invoiceList = [NSArray array];
//                p.isPersonalInvoice = YES;
//                [Singleton.rootViewController pushViewController:p animated:YES];
//                return;
//            }
            
        }else{
            alerErr
        }
    }));

    
 
}


/** 扫码支付 */
+ (void)consumeQrWithDictionary:(NSDictionary *)infoDict baseUrl:(NSString *)baseUrl controller:(UIViewController *)controller{
    
    
//    if (![JRCheckAcNo isCheckOk]) return;

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:Singleton.publicParamsDict];
    [params setObject:@"3000" forKey:@"prodId"];
    new_transaction_caller
    caller.transactionId = @"PerConsumerLoanApplyQuery.do"; //交易名
    caller.webMethod = POST;                                   // POST  GET
    caller.responsType = ResponsTypeOfJson; //返回数据处理
    caller.transactionArgument = params;   //上传参数
    caller.isShowActivityIndicator = YES;
    execute_transaction_block_caller((^(CSIIBusinessCaller *returnCaller) {
        if (TransactionIsSuccess) {
            DebugLog(@"贷款顶部:%@",TransReturnInfo);
            
            //FSLX_01提额
            if ([TransReturnInfo[@"occurType"] isEqualToString:@"FSLX_01"]) {
                if ([TransReturnInfo[@"status1"] isEqualToString:@"SQZT_TG"]) {
                    alertView(@"您的可用额度已用完，无法进行消费");
                }else{
                    if([TransReturnInfo[@"validAmt"] isEqualToString:@"0"]||[TransReturnInfo[@"validAmt"] length] == 0){
                        alertView(@"您的可用额度已用完，无法进行消费");
                    }else{
//                        JRConsumeQRViewController *p = [[JRConsumeQRViewController alloc] init];
//                        [Singleton.rootViewController pushViewController:p animated:YES];
                    }
                }
                
                
            }else{
            //FSLX_00新发生（非提额）
                if([TransReturnInfo[@"validAmt"] isEqualToString:@"0"]||[TransReturnInfo[@"validAmt"] length] == 0){
                    alertView(@"您的可用额度已用完，无法进行消费");
                }else{
//                    JRConsumeQRViewController *p = [[JRConsumeQRViewController alloc] init];
//                    [Singleton.rootViewController pushViewController:p animated:YES];
                }
            
            }
            
//            if([TransReturnInfo[@"validAmt"] isEqualToString:@"0"]||[TransReturnInfo[@"validAmt"] length] == 0){
//                alertView(@"您尚未申请乐享消费贷或乐享消费贷申请中，暂时无法进行消费");
//            }else{
//                JRConsumeQRViewController *p = [[JRConsumeQRViewController alloc] init];
//                [Singleton.rootViewController pushViewController:p animated:YES];
//            }
        }else{
           alerErr
        }
    }));
}

@end

