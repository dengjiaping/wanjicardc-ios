//
//  APIRecommandMerchantManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/14.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIRecommendMerchantManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString      *cityId;
@property (nonatomic, assign) double        longitude;
@property (nonatomic, assign) double        latitude;

@end
