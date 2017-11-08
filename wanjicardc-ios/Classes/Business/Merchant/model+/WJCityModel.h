//
//  WJCityModel.h
//  WanJiCard
//
//  Created by Lynn on 15/9/18.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJCityModel : NSObject

@property (nonatomic, strong) NSString * cityId;
@property (nonatomic, strong) NSString * cityName;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
