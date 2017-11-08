//
//  APIPayOrderManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/6.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"
#import "WJEnumType.h"

extern NSString *const kChargeTypeAlipay;
extern NSString *const kChargeTypeYiLianPayWap;

@interface APIPayOrderManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString      *orderNum;
@property (nonatomic, strong) NSString      *proID;
@property (nonatomic, strong) NSString      *chargeType;

@end
