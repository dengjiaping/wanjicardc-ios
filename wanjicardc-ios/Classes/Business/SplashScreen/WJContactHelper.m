//
//  WJContactHelper.m
//  WanJiCard
//
//  Created by wangzhangjie on 15/9/20.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJContactHelper.h"

#import "WJContactReformer.h"
@implementation WJContactHelper 


#pragma mark -  ABPeoplePickerNavigationControllerDelegate
// after 8.0
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName==nil) {
        firstName = @" ";
    }
    NSString *lastName=(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName==nil) {
        lastName = @" ";
    }
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        [phones addObject:aPhone];
    }
    NSString *phone = @"";
    if (phones.count > 0) {
        phone = [phones objectAtIndex:0];
    }
//    NSDictionary *dic = @{@"fullname": [NSString stringWithFormat:@"%@%@", firstName, lastName]
//                          ,@"phone" : phone};
    
   //  _completionBlock(dic);
    [self.pickView dismissViewControllerAnimated:YES completion:nil];
}

// Called after the user has pressed cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    // _completionBlock(nil);
    [self.pickView dismissViewControllerAnimated:YES completion:nil];
}

// 8.0之前才会调用
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
}

// 8。0之前才会调用
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier {
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName==nil) {
        firstName = @" ";
    }
    NSString *lastName=(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName==nil) {
        lastName = @" ";
    }
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        [phones addObject:aPhone];
    }
    NSString *phone = @"";
    if (phones.count > 0) {
        phone = [phones objectAtIndex:0];
    }
//    NSDictionary *dic = @{@"fullname": [NSString stringWithFormat:@"%@%@", firstName, lastName]
//                          ,@"phone" : phone};
    
    // _completionBlock(dic);
    [self.pickView dismissViewControllerAnimated:YES completion:nil];
    
    // 不执行默认的操作，如，打电话  
    return NO;  
}
#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    // [self.tableView endHeadRefresh];
    // [self.tableView endFootFefresh];
    
    NSLog(@"success:--func:%s",__func__);
    NSLog(@"success:---manager%@",manager);
    // xxxxxxxx
    
    self.dataArray = [manager fetchDataWithReformer:[[WJContactReformer alloc] init]];
    NSLog(@"--->>>通讯录；dataArray = %@",self.dataArray);
    NSLog(@"--->>>通讯录；dataArray的大小： %lu",(unsigned long)[self.dataArray count]);
    // xxxxxx
    
    if ([self.dataArray count]>0) {
        //        [self.view addSubview:self.tableView]; //原先在viewdidload
        //        [self.tableView reloadData];
    }else
    {
        
        //        [self.view addSubview:self.imageView];
        //        [self.view addSubview:self.hintLabelTop];
        //        [self.view addSubview:self.hintLabelBottom];
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"fail:%s",__func__);
    NSLog(@"fail:%@",manager);
}


#pragma mark- public method
-(NSString *) readAllPeoples{
    
    NSString *formatProples = [[NSString alloc] init];
    
    formatProples = [formatProples stringByAppendingString:@""];
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
      //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        //        AddressBook *addressBook = [[AddressBook alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
                
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            
            if (valuesRef != nil)
                valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email，k < valuesCount。只取1个值
            for (NSInteger k = 0; k < 1; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        NSString * stringTel = (__bridge NSString*)value;
                        if(stringTel.length>0){
                          
                            NSArray * array = [stringTel componentsSeparatedByString:@" "];
                            stringTel = array[0];
                        }else{
                            stringTel=@"none";
                        }
                      
                        formatProples = [formatProples stringByAppendingString:[NSString stringWithFormat:@"%@_",value]];
                        
                        break;
                    }
                    case 1: {// Email
                        //        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        
        //当为最后1个的时候，不加逗号
        if (i == nPeople-1) {
            formatProples = [formatProples stringByAppendingString:[NSString stringWithFormat:@"%@",nameString]];
        }else
        {
            // 否则以逗号分割
            formatProples = [formatProples stringByAppendingString:[NSString stringWithFormat:@"%@%@",nameString,@","]];
        }
       // NSLog(@"本次循环得到的名字：%@",nameString);
        // addressBook.name = nameString;
        
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        //        [self.allLinkerInfo  addObject:addressBook];
        // [self.addressBookTemp addObject:addressBook];
     
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }

    return formatProples;
}



#pragma mark- setter & getter 
-(ABPeoplePickerNavigationController *)pickView
{
    if (nil==_pickView) {
        _pickView = [[ABPeoplePickerNavigationController alloc] init];
        _pickView.peoplePickerDelegate = self;
        _pickView.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
       
    }
    return  _pickView;
}


- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
