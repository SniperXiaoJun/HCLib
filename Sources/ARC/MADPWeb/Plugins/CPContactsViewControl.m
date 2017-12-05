//
//  CPContactsViewControl.m
//  CsiiMobileFinance
//
//  Created by 肖豪 on 17/4/6.
//  Copyright © 2017年 Shen Yu. All rights reserved.
//

#import "CPContactsViewControl.h"
#define Is_up_Ios_9             ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)

@interface CPContactsViewControl ()

@end

@implementation CPContactsViewControl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectZero;
    [self JudgeAddressBookPower];
    // Do any additional setup after loading the view.
}

- (void)JudgeAddressBookPower {
    ///获取通讯录权限，调用系统通讯录
    [self CheckAddressBookAuthorization:^(bool isAuthorized , bool isUp_ios_9) {
        if (isAuthorized) {
            [self callAddressBook:isUp_ios_9];
        }else {
            
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请到设置>隐私>通讯录打开本应用的权限设置!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }];
}


- (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized , bool isUp_ios_9))block {
    if (Is_up_Ios_9) {
        CNContactStore * contactStore = [[CNContactStore alloc]init];
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
                if (error)
                {
                    NSLog(@"Error: %@", error);
                }
                else if (!granted)
                {
                    
                    block(NO,YES);
                }
                else
                {
                    block(YES,YES);
                }
            }];
        }
        else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized){
            block(YES,YES);
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请到设置>隐私>通讯录打开本应用的权限设置!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
            
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }else {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        
        if (authStatus == kABAuthorizationStatusNotDetermined)
        {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error)
                    {
                        NSLog(@"Error: %@", (__bridge NSError *)error);
                    }
                    else if (!granted)
                    {
                        
                        block(NO,NO);
                    }
                    else
                    {
                        block(YES,NO);
                    }
                });
            });
        }else if (authStatus == kABAuthorizationStatusAuthorized)
        {
            block(YES,NO);
        }else {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请到设置>隐私>通讯录打开本应用的权限设置!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
            
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }
}


- (void)callAddressBook:(BOOL)isUp_ios_9 {
    if (isUp_ios_9) {
        CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
        contactPicker.delegate = self;
        contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        [self presentViewController:contactPicker animated:YES completion:nil];
    }else {
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        [self presentViewController:peoplePicker animated:YES completion:nil];
        
    }
}

#pragma mark -- CNContactPickerDelegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;
    [picker dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *text1 = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
        /// 电话
        NSString *text2 = phoneNumber.stringValue;
        //        text2 = [text2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSLog(@"联系人：%@, 电话：%@",text1,text2);
        NSDictionary *dic = @{@"UserName":text1,@"UserNumber":text2};
        _xhhsucessphoeBlock(dic,YES);
    }];
}
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    _xhhsucessphoeBlock(nil,NO);
}
- (BOOL)contactViewController:(CNContactViewController *)viewController shouldPerformDefaultActionForContactProperty:(CNContactProperty *)property
{
    return NO;
}



- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController*)peoplePicker
{
    
    DebugLog(@"peoplePickerNavigationControllerDidCancel");

    [peoplePicker dismissViewControllerAnimated:YES completion:NULL];
    _xhhsucessphoeBlock(nil,NO);

}

//- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0)
//{
//    //处理方法
//    DebugLog(@"didSelectPerson");
//    // Called after a value has been selected by the user.
//
//    
//    DebugLog(@"person:%@",person);
//
//}

// Called after a property has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_AVAILABLE_IOS(8_0)
{
    
    // Called after a value has been selected by the user.
    
    if (property != kABPersonPhoneProperty) //kABPersonPhoneProperty is 3
    {
//        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择手机号码!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择手机号码!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.delegate = self;
        [alert show];
        return;
    }
    
    //处理方法
    [self didSelectPerson:person property:property identifier:identifier];
}
#pragma mark helper methods
- (void)didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSString* aPhone = @"";
    NSString* aLabel = @"";
    
    ABRecordID recordID = ABRecordGetRecordID(person);
    ABRecordType recordType = ABRecordGetRecordType(person);
    CFStringRef anFullName = ABRecordCopyCompositeName(person);
    DebugLog(@"recordID:%d，recordType:%d", recordID, recordType);
    //NSString *strName = CFBridgingRelease(ABRecordCopyCompositeName(person));//联系人名字
    
    //iOS8，在联系人详情页ABPersonViewController上，会列出所有的号码item(包括重复的)，如果用户在这个页面选择重复的item的第2项，那么通过ABMultiValueGetIndexForIdentifier(phoneMulti, identifier)拿到的index会是-1，或者是别的号码的item的index，导致出现现象，点击选择的和返回来的不是同一个号码。尤其是通讯录上一个联系人有多个号码，删除一部分号码后，ABMultiValueGetIndexForIdentifier(phoneMulti, identifier)拿到的index更是错乱。
    
    //ios8上，标签相同且号码相同的item，在phoneMulti里是合并的。 ios7不会合并。
    ABMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
    
    if (phoneMulti) {
        CFIndex count = ABMultiValueGetCount(phoneMulti);
        // CFArrayRef arrayRef =  ABMultiValueCopyArrayOfAllValues( phoneMulti);
        if (count > 0) {
            CFIndex index = 0;
            
            //when the user selects an individual value in the Person view, identifier will be kABMultiValueInvalidIdentifier(-1) if a single value property was selected.
            
            if (identifier != kABMultiValueInvalidIdentifier) {
                //由于phoneMulti里有合并的项目，通过identifier拿到的index，有时会是-1。
                index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
            }
            
            if (count == 1 && index == -1)
                index = 0;
            
            if ((index >= 0) && (index <= count - 1)) {
                aPhone = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneMulti, index));
                aLabel = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phoneMulti, index));
            }
        }
        CFRelease(phoneMulti);
    }
    NSString *phoneName = (__bridge NSString *)(anFullName);
    NSString* phoneNumber = [self clearFormatOfPhoneNumber:aPhone];
    NSDictionary *dic = @{@"UserName":phoneName,@"UserNumber":phoneNumber};
    _xhhsucessphoeBlock(dic,YES);
}

/**
 * @method
 * @abstract 清除电话号码的格式
 * @result 返回电话号码
 */
- (NSString*)clearFormatOfPhoneNumber:(NSString*)aPhoneNumber
{
    aPhoneNumber = [aPhoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    aPhoneNumber = [aPhoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    aPhoneNumber = [aPhoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    aPhoneNumber = [aPhoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    aPhoneNumber = [aPhoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    aPhoneNumber = [aPhoneNumber stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    
    return aPhoneNumber;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // TODO: iOS8
    [self dismissViewControllerAnimated:NO completion:nil];

}
@end
