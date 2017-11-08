//
//  APIUserLocalLoginManager.h
//  WanJiCard
//
//  Created by Lynn on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIUserLocalLoginManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, copy) NSString *loginname;    //  用户名
@property (nonatomic, copy) NSString *password;     //  密码
@end
