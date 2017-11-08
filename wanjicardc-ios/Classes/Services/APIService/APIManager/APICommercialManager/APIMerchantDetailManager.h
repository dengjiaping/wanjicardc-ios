//
//  APIMerchantDetailManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/15.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIMerchantDetailManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString      *merID;
@property (nonatomic, strong) NSString      *merchantLatitude;
@property (nonatomic, strong) NSString      *merchantLongitude;

@end
