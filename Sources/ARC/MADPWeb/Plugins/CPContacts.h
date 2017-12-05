//
//  CPContacts.h
//  CSIIPlatformLib
//
//  Created by 任兴 on 15/6/30.
//  Copyright (c) 2015年 刘任朋. All rights reserved.
//

#import "CPPlugin.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
/// iOS 9的新框架
#import <ContactsUI/ContactsUI.h>


/*!
 * @class
 * @abstract CPContacts联系人插件，提供js获取通讯录联系人信息功能。
 */

@interface CPContacts : CPPlugin<ABPeoplePickerNavigationControllerDelegate,UINavigationControllerDelegate,CNContactPickerDelegate,CNContactViewControllerDelegate>
/*!
 * @method
 * @abstract 调用系统通讯录页面，选择联系人信息并返回
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(void)SearchBySystem;
/*!
 * @method
 * @abstract 调用自定义通讯录页面，选择联系人信息并返回
 * @result 返回值通过pluginResponseCallback  类型 string
 */
-(void)SearchByCustom;


//  打电话   发短信
@end

