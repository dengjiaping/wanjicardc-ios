//
//  APIOrderDetailsManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/6.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIOrderDetailsManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString  * ordersID;
@property (nonatomic, assign) OrderType orderType;

@end
