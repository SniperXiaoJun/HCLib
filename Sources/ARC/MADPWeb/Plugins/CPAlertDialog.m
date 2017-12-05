//
//  CPAlertDialog.m
//  CsiiMobileFinance
//
//  Created by  高鹏飞 on 2017/3/6.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "CPAlertDialog.h"
#import "JRCSIISpaceTextView.h"
#import "JRCSIISpaceRemindTextView.h"
#import "JRCSIIGeneralPwdConfirmView.h"
#import "JRCSIIGeneralConfirmView.h"
#import "JRCSIIAddAccountView.h"
#import "JRCSIINoCardDrawView.h"
#import "JRCSIITextandTextView.h"

@implementation CPAlertDialog


-(void)showSpaceTextAndTextDialog{
    JRCSIISpaceTextView *submitView = [JRCSIISpaceTextView shareInstance];
    [submitView show:^{
        
        //        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //        [dict setObject:@"UC" forKey:@"_TokenType"];
        //        [dict setObject:submitView.TrsPassword forKey:@"TrsPassword"];
        //        [dict setObject:submitView.CSIISignature forKey:@"CSIISignature"];
        //        [dict setObject:submitView._AuthenticateType forKey:@"_AuthenticateType"];
        //        [dict setObject:submitView.UserCert forKey:@"UserCert"];
        //        [dict setObject:submitView._ChooseAuthMode forKey:@"_ChooseAuthMode"];
        //        [dict addEntriesFromDictionary:submitView.formDic];
        //
        //        self.pluginResponseCallback(dict);
    }];

}

-(void)showSpaceRemindTextAndTextDialog{
    JRCSIISpaceRemindTextView *submitView = [JRCSIISpaceRemindTextView shareInstance];
    [submitView show:^{
        
        //        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //        [dict setObject:@"UC" forKey:@"_TokenType"];
        //        [dict setObject:submitView.TrsPassword forKey:@"TrsPassword"];
        //        [dict setObject:submitView.CSIISignature forKey:@"CSIISignature"];
        //        [dict setObject:submitView._AuthenticateType forKey:@"_AuthenticateType"];
        //        [dict setObject:submitView.UserCert forKey:@"UserCert"];
        //        [dict setObject:submitView._ChooseAuthMode forKey:@"_ChooseAuthMode"];
        //        [dict addEntriesFromDictionary:submitView.formDic];
        //
        //        self.pluginResponseCallback(dict);
    }];

}

-(void)showGenernalPwdConfirmDialog{
    JRCSIIGeneralPwdConfirmView *submitView = [JRCSIIGeneralPwdConfirmView shareInstance];
    [submitView show:^{
        
        //        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //        [dict setObject:@"UC" forKey:@"_TokenType"];
        //        [dict setObject:submitView.TrsPassword forKey:@"TrsPassword"];
        //        [dict setObject:submitView.CSIISignature forKey:@"CSIISignature"];
        //        [dict setObject:submitView._AuthenticateType forKey:@"_AuthenticateType"];
        //        [dict setObject:submitView.UserCert forKey:@"UserCert"];
        //        [dict setObject:submitView._ChooseAuthMode forKey:@"_ChooseAuthMode"];
        //        [dict addEntriesFromDictionary:submitView.formDic];
        //
        //        self.pluginResponseCallback(dict);
    }];

}

-(void)showGenernalConfirmDialog{
    JRCSIIGeneralConfirmView *submitView = [JRCSIIGeneralConfirmView shareInstance];
    [submitView show:^{
        
        //        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //        [dict setObject:@"UC" forKey:@"_TokenType"];
        //        [dict setObject:submitView.TrsPassword forKey:@"TrsPassword"];
        //        [dict setObject:submitView.CSIISignature forKey:@"CSIISignature"];
        //        [dict setObject:submitView._AuthenticateType forKey:@"_AuthenticateType"];
        //        [dict setObject:submitView.UserCert forKey:@"UserCert"];
        //        [dict setObject:submitView._ChooseAuthMode forKey:@"_ChooseAuthMode"];
        //        [dict addEntriesFromDictionary:submitView.formDic];
        //
        //        self.pluginResponseCallback(dict);
    }];

}

-(void)showAddAcountDialog{
    JRCSIIAddAccountView *submitView = [JRCSIIAddAccountView shareInstance];
    [submitView show:^{
        
        //        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //        [dict setObject:@"UC" forKey:@"_TokenType"];
        //        [dict setObject:submitView.TrsPassword forKey:@"TrsPassword"];
        //        [dict setObject:submitView.CSIISignature forKey:@"CSIISignature"];
        //        [dict setObject:submitView._AuthenticateType forKey:@"_AuthenticateType"];
        //        [dict setObject:submitView.UserCert forKey:@"UserCert"];
        //        [dict setObject:submitView._ChooseAuthMode forKey:@"_ChooseAuthMode"];
        //        [dict addEntriesFromDictionary:submitView.formDic];
        //
        //        self.pluginResponseCallback(dict);
    }];

}

-(void)showNOCardDrawDialog{
    JRCSIINoCardDrawView *submitView = [JRCSIINoCardDrawView shareInstance];
    [submitView show:^{
        
        //        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //        [dict setObject:@"UC" forKey:@"_TokenType"];
        //        [dict setObject:submitView.TrsPassword forKey:@"TrsPassword"];
        //        [dict setObject:submitView.CSIISignature forKey:@"CSIISignature"];
        //        [dict setObject:submitView._AuthenticateType forKey:@"_AuthenticateType"];
        //        [dict setObject:submitView.UserCert forKey:@"UserCert"];
        //        [dict setObject:submitView._ChooseAuthMode forKey:@"_ChooseAuthMode"];
        //        [dict addEntriesFromDictionary:submitView.formDic];
        //
        //        self.pluginResponseCallback(dict);
    }];

}

-(void)showTextAndTextDialog{
    JRCSIITextandTextView *submitView = [JRCSIITextandTextView shareInstance];
    [submitView show:^{
        
        //        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //        [dict setObject:@"UC" forKey:@"_TokenType"];
        //        [dict setObject:submitView.TrsPassword forKey:@"TrsPassword"];
        //        [dict setObject:submitView.CSIISignature forKey:@"CSIISignature"];
        //        [dict setObject:submitView._AuthenticateType forKey:@"_AuthenticateType"];
        //        [dict setObject:submitView.UserCert forKey:@"UserCert"];
        //        [dict setObject:submitView._ChooseAuthMode forKey:@"_ChooseAuthMode"];
        //        [dict addEntriesFromDictionary:submitView.formDic];
        //
        //        self.pluginResponseCallback(dict);
    }];

}

@end
