//
//  APIFindPasswordVerifysmsManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/15.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIFindPasswordVerifysmsManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * code;

@end
