//
//  WJRecommendStoreModel.m
//  WanJiCard
//
//  Created by Lynn on 15/9/16.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJRecommendStoreModel.h"


@implementation WJRecommendStoreModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
   
        self.distanceStr = dic[@"distance"];
        self.category = dic[@"merchantCategory"];
        self.merID = [NSString stringWithFormat:@"%@",dic[@"merchantId"]];
        self.name = dic[@"merchantName"];
        self.cover  = dic[@"merchantPic"];
        self.latitude = [NSString stringWithFormat:@"%@",dic[@"merchantLatitude"]];
        self.longitude = [NSString stringWithFormat:@"%@",dic[@"merchantLongitude"]];
        self.totalSale = [NSString stringWithFormat:@"%@",dic[@"totalSale"]];
        self.address = dic[@"merchantAddress"];
        self.phone = dic[@"merchantPhone"];
        self.isLimitForSale = [dic[@"isLimitForSale"] boolValue];

        self.businessTime = dic[@"BusinessTime"]; 

    }
    return self;
}


@end
