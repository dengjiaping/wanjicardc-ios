//
//  WJVerificationCodeManager.h
//  WanJiCard
//
//  Created by Lynn on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIVerificationCodeManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString * phoneNum;

@end
