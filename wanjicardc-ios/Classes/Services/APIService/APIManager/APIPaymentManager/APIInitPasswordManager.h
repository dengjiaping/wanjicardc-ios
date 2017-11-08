//
//  APIInitPasswordManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/15.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIInitPasswordManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *identity;

@end
