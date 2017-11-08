//
//  APIChangePayPsdManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/6.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIChangePayPsdManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * password;

@end
