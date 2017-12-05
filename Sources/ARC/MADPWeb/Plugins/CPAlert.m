//
//  CPAlert.m
//  CSIIPlatformLib
//
//  Created by 任兴 on 15/6/18.
//  Copyright (c) 2015年 刘任朋. All rights reserved.
//

#import "CPAlert.h"
#import "JRMMAlertView.h"

#import "JRMMPopupItem.h"
@implementation CPAlert
{
//    PluginResponseCallback _pluginData1;
//    UIView * yyalert;
//    CSIICustomAlertView * passCustomAlert;

}
//- (void) leftBtnPressedWithinalertView:(CustomAlertView*)alert{
//
//    [passCustomAlert hideAlertView];
//
//}
//- (void) rightBtnPressedWithinalertView:(CustomAlertView*)alert{
//
//    [passCustomAlert hideAlertView];
//
//}


/*!
 @method
 @abstract 默认一个按钮的alert
 @discussion：弹出框样式为系统默认，切包含按键回调，弹出框按钮为确定按钮和取消按钮。
 @param js端传过来的data
 @result 返回值通过pluginResponseCallback  类型 string
 */

-(void)ShowHintMsgDefaultAlert{
    
    
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:self.curData[@"data"][@"Params"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
//

}
/*!
 @method
 @abstract 默认两个按钮的alert
 @discussion：弹出框样式为系统默认，切包含按键回调，弹出框按钮为确定按钮和取消按钮。
 @param js端传过来的data
 @result 返回值通过pluginResponseCallback  类型 string
 */
-(void)ShowHintMsgDefaultConfirm{
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:self.curData[@"data"][@"Params"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];

}

/*!
 * @method
 * @abstract 自定义一个按钮的alert
 * @discussion：弹出框样式为系统默认，切包含按键回调，弹出框按钮为确定按钮和取消按钮。
 * @param js端传过来的data
 * @result 返回值通过pluginResponseCallback  类型 string
 */
#pragma mark 要处理的一个按钮的
-(void)ShowHintMsgCustomAlert{
    
    
    JRMMPopupItemHandler block = ^(NSInteger index){
        NSLog(@"clickd %@ button",@(index));
        pluginResponseCallback(@"success");
    };
    
    NSArray *items =
    @[JRMMItemMake(@"确定", JRMMItemTypeHighlight, block)];
    
    JRMMAlertView *alertView = [[JRMMAlertView alloc] initWithTitle:@"温馨提示"
                                                         detail:self.curData[@"data"][@"Params"]
                                                          items:items];
//    alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleLight;
    
    [alertView show];
   
}


//-(void)DisappearAlert:(UIButton * )sender{
//    
//    [passCustomAlert hideAlertView];
//
//}


/*!
 * @method
 * @abstract 自定义两个按钮的alert
 * @discussion：弹出框样式为系统默认，切包含按键回调，弹出框按钮为确定按钮和取消按钮。
 * @param js端传过来的data
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(void)ShowHintMsgCustomConfirm{
    
    

    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:self.curData[@"data"][@"Params"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    
}


/*!
 * @method
 * @abstract 签约确认弹框（营口）
 * @discussion：弹出框样式为系统默认，切包含按键回调，弹出框按钮为签约按钮和取消按钮。
 * @param js端传过来的data
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(void)ShowSignConfirm{
    
//    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:self.curData[@"data"][@"Params"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"签约", nil];
//    [alert show];
    

    
    
    JRMMPopupItemHandler block = ^(NSInteger index){
        NSLog(@"clickd %@ button",@(index));
        if (index == 1) {
            pluginResponseCallback(@"ssss");
        }
    };
    
    NSArray *items =
    @[JRMMItemMake(@"取消", JRMMItemTypeHighlight, block),
      JRMMItemMake(@"签约", JRMMItemTypeHighlight, block)];
    
    JRMMAlertView *alertView = [[JRMMAlertView alloc] initWithTitle:@"温馨提示"
                                                    detail:self.curData[@"data"][@"Params"]
                                                          items:items];
    //            alertView.attachedView = self.view;
//    alertView.attachedView.mm_dimBackgroundBlurEnabled = YES;
//    alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleLight;
    
    [alertView show];
}


//-(void)ShowSignConfirm{
//    CSIICustomAlertView * alert=[[CSIICustomAlertView alloc] initTextFieldWithTitle:@"备注" msg:nil rightBtnTitle:@"确定" leftBtnTitle:@"取消" delegate:self];
//    alert.textField.text = self.curData[@"data"][@"Params"];
//    [alert show];
//    
//}

- (void)rightBtnPressedWithinalertView:(CSIICustomAlertView *)alert{
    [alert hideAlertView];
    pluginResponseCallback(alert.textField.text);
    
}

- (void)ShowHintMsgToast;
{
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:self.curData[@"data"][@"Params"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    DebugLog(@"clickedButtonAtIndex");
    if (buttonIndex==0) {
        pluginResponseCallback(@"返回确认结果");
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    DebugLog(@"didDismissWithButtonIndex");
    if (buttonIndex==0) {
        pluginResponseCallback(@"点击确认");
        
    }
}


//- (void)alertViewCancel:(UIAlertView *)alertView{
//
//    DebugLog(@"cancel");
//}

@end
