//
//  WJContactHelper.h
//  WanJiCard
//
//  Created by wangzhangjie on 15/9/20.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface WJContactHelper : NSObject<ABPeoplePickerNavigationControllerDelegate,APIManagerCallBackDelegate>

@property(strong,nonatomic) ABPeoplePickerNavigationController * pickView;

@property (nonatomic, strong)NSMutableArray         *dataArray;

-(NSString *) readAllPeoples;
//-(void) uploadAllProles:(NSString *) allPeopleString;

@end
