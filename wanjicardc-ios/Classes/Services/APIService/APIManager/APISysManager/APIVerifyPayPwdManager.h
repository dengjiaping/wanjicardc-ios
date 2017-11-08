//
//  APIVerifyPayPwdManager.h
//  WanJiCard
//
//  Created by Lynn on 15/11/2.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIVerifyPayPwdManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString *identity;

@end
