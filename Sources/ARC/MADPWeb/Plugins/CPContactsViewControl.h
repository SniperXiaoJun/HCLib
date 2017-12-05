//
//  CPContactsViewControl.h
//  CsiiMobileFinance
//
//  Created by 肖豪 on 17/4/6.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <Contacts/Contacts.h>
#import <Contacts/ContactsDefines.h>
#import <ContactsUI/CNContactPickerViewController.h>
#import <ContactsUI/CNContactViewController.h>
#import <ContactsUI/ContactsUI.h>
typedef void(^XHHSucessBlockPhone)(NSDictionary* info,BOOL isInfo);

@interface CPContactsViewControl : UIViewController<ABPeoplePickerNavigationControllerDelegate,UINavigationControllerDelegate,CNContactPickerDelegate,CNContactViewControllerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) XHHSucessBlockPhone xhhsucessphoeBlock;
@end
