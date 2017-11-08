//
//  APIUpdateLocationManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/7.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIUpdateLocationManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, assign) double    latitude;
@property (nonatomic, assign) double    longitude;

@end
