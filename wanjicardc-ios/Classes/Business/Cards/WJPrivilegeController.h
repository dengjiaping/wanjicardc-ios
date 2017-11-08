//
//  WJCardDetailPrivilegeController.h
//  WanJiCard
//
//  Created by Harry Hu on 15/9/7.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJViewController.h"

@interface WJPrivilegeController : WJViewController

@property (nonatomic, strong) NSString *cardId;
@property (nonatomic, strong) NSArray *privilegeArray;
@property (nonatomic, assign) BOOL isMerchantPrivilege;

@end
