//
//  WJStoreModel.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//


#import "WJStoreModel.h"

@implementation WJStoreModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.areaId = ToString(dic[@"areaId"]);
        self.distanceStr = ToString(dic[@"distance"]);
        self.isLimitForSale = ToString(dic[@"isLimitForSale"]);
        self.storeAddress = ToString(dic[@"merchantAddress"]);
        self.storeCategory = ToString(dic[@"merchantCategory"]);
        self.storeId = ToString(dic[@"merchantId"]);
        self.latitude = [dic[@"merchantLatitude"] floatValue];
        self.longitude = [dic[@"merchantLongitude"] floatValue];
        self.storeName = ToString(dic[@"merchantName"]);
        self.telephone = ToString(dic[@"merchantPhone"]);
        self.storeCover = ToString(dic[@"merchantPic"]);
        self.storeTotalSale = [dic[@"totalSale"] integerValue];
    }
    return self;
}


@end
