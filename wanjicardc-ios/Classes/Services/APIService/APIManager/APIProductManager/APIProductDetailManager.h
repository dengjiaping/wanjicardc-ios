//
//  APIProductDetailManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/6.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIProductDetailManager : APIBaseManager <APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString * proID;
@property (nonatomic, assign) double    latitude;
@property (nonatomic, assign) double    longitude;

@end
