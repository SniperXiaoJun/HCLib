//
//  CPContacts.m
//  CSIIPlatformLib
//
//  Created by 任兴 on 15/6/30.
//  Copyright (c) 2015年 刘任朋. All rights reserved.
//

#import "CPContacts.h"
#import <UIKit/UIKit.h>
#define Is_up_Ios_9             ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
#import "CPContactsViewControl.h"
@interface CPContacts ()

@end

@implementation CPContacts

/**
 * @method
 * @abstract 调用系统通讯录页面，选择联系人信息并返回
 * @result 返回值通过pluginResponseCallback  类型 string
 */
- (void)SearchBySystem
{
    
    [self CheckAddressBookAuthorization:^(bool isAuthorized , bool isUp_ios_9) {
        if (isAuthorized) {
//            [self callAddressBook:isUp_ios_9];
            CPContactsViewControl *ccc = [[CPContactsViewControl alloc] init];
            
            ccc.xhhsucessphoeBlock = ^(NSDictionary *dic,BOOL isInfo)
            {
                if (isInfo) {
                    self.pluginResponseCallback(dic);
                    [self.curViewController dismissViewControllerAnimated:NO completion:nil];
                }else
                {
                    [self.curViewController dismissViewControllerAnimated:NO completion:nil];
                }
            };
            [self.curViewController presentViewController:ccc animated:NO completion:nil];
        }else {
            
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请到设置>隐私>通讯录打开本应用的权限设置!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }];
    
    
  //    [self JudgeAddressBookPower];

//    [self performSelectorOnMainThread:@selector(pushPickView) withObject:nil waitUntilDone:NO];
}



- (void)pushPickView
{

    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    DebugLog(@"ABAuthorizationStatus: %ld", status); //ios7上会询问用户授权。iOS8不会询问授权，所以ios8上授权status为0

    //显示通讯录
    ABPeoplePickerNavigationController* ABPeoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    ABPeoplePicker.peoplePickerDelegate = self;

    //    // The people picker will only display the person's name, image and phone properties in ABPersonViewController.
    //    //过滤用户在联系人详情页可以看到的属性
    ABPeoplePicker.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];

    //    //适配iOS8通讯录联系人选择
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //        //ABPeoplePicker.predicateForEnablingPerson = [NSPredicate predicateWithValue:TRUE];
        //
        //        //set FALSE, the selected person should be displayed in Person View.
        //        //set TRUE,a selected person should be returned to the app.
        ABPeoplePicker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:FALSE];
        //
        //        //set TRUE, the selected property should be returned to the app.
        //        ABPeoplePicker.predicateForSelectionOfProperty = [NSPredicate predicateWithValue:TRUE];
    }

    [self.curViewController presentViewController:ABPeoplePicker animated:YES completion:nil];
}

//当用户选择了通讯录中某一个联系人时调用这个方法，可以在这里获取联系人的信息。如果希望可以继续显示这个联系人更具体的信息，则return YES。否则取消整个通讯录页面的显示并return NO。
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    return NO;
}

//如果上一个方法返回的是YES，则会显示某一个联系人信息，如果选择了联系人的某一项纪录，就会调用这个方法，可以通过点击选择联系人的某一项信息。如果 希望可以对选择的某一项纪录进行进一步操作，比如直接拨打电话或调用邮箱发送邮件，则return YES。否则取消整个通讯录页面的显示并return NO。

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{

    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
    CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);

    NSString* aPhone = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneMulti, index));

    CFRelease(phoneMulti);
    NSString* phoneNumber = [self clearFormatOfPhoneNumber:aPhone];
    self.pluginResponseCallback(phoneNumber);
    [peoplePicker dismissViewControllerAnimated:YES completion:NULL];
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController*)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0)
{
    //处理方法
}

// Called after a property has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_AVAILABLE_IOS(8_0)
{

    // Called after a value has been selected by the user.

    if (property != kABPersonPhoneProperty) //kABPersonPhoneProperty is 3
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择手机号码!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
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
    self.pluginResponseCallback(dic);
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

#pragma - mark UIPickerViewDelegate

/**
 * @method
 * @abstract 调用自定义通讯录页面，选择联系人信息并返回
 * @result 返回值通过pluginResponseCallback  类型 string
 */

- (void)SearchByCustom
{

    [self performSelectorOnMainThread:@selector(pushPickView) withObject:nil waitUntilDone:NO];
}


#pragma mark ====适配iOS10


#pragma mark ---- 调用系统通讯录
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
        [self.curViewController presentViewController:contactPicker animated:YES completion:nil];
    }else {
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        [self.curViewController presentViewController:peoplePicker animated:YES completion:nil];
        
    }
}

#pragma mark -- CNContactPickerDelegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
    [picker dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *text1 = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
        /// 电话
        NSString *text2 = phoneNumber.stringValue;
        //        text2 = [text2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSLog(@"联系人：%@, 电话：%@",text1,text2);
        NSDictionary *dic = @{@"UserName":text1,@"UserNumber":text2};
        self.pluginResponseCallback(dic);
    }];
}
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)contactViewController:(CNContactViewController *)viewController shouldPerformDefaultActionForContactProperty:(CNContactProperty *)property
{
    return NO;
}
@end
