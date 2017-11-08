//
//  WJMerchantDetail.m
//  WanJiCard
//
//  Created by Angie on 15/9/12.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJMerchantDetailModel.h"

#import "WJStoreModel.h"
#import "WJMerchantImageModel.h"
#import "PayPrivilegeModel.h"
#import "WJMerchantCard.h"

@implementation WJMerchantDetailModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.shareDesc          = ToString(dic[@"Desc"]);
        self.shareTitle         = ToString(dic[@"Title"]);
        self.shareUrl           = ToString(dic[@"Url"]);
        self.activityNum        = ToString(dic[@"activityNum"]);
        self.merId              = ToString(dic[@"merchantId"]);
        self.merName            = ToString(dic[@"merchantName"]);
        self.address            = ToString(dic[@"merchantAddress"]);
        self.businessTime       = ToString(dic[@"merchantBusinesshours"]);
        self.phone              = ToString(dic[@"merchantPhone"]);
        self.branchNum          = [dic[@"branchNum"] integerValue];
        self.imageNum           = [dic[@"photoesNum"] integerValue];
        self.introduction       = ToString(dic[@"merchantIntroduce"]);
        self.lat                = [dic[@"merchantLatitude"] floatValue];
        self.lng                = [dic[@"merchantLongitude"] floatValue];
        self.mainMerId          = ToString(dic[@"mainMerchantId"]);
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in dic[@"branch"]) {
            WJStoreModel *model = [[WJStoreModel alloc] initWithDic:dict];
            [arr addObject:model];
        }
        self.branchArray = [NSArray arrayWithArray:arr];
        [arr removeAllObjects];
        
        for (NSDictionary *dict in dic[@"merchantCards"]) {
            WJMerchantCard *model = [[WJMerchantCard alloc] initWithDic:dict];
            [arr addObject:model];
        }
        self.productArray = [NSArray arrayWithArray:arr];
        [arr removeAllObjects];
        
        for (NSDictionary *dict  in dic[@"privilege"]) {
            PayPrivilegeModel *model = [[PayPrivilegeModel alloc] initWithDic:dict];
            [arr addObject:model];
        }
        self.privilegeArray = [NSArray arrayWithArray:arr];
        [arr removeAllObjects];
        
        self.activity = [NSArray arrayWithArray:dic[@"activity"]];

        for (NSDictionary *dict  in dic[@"photoes"]) {
            WJMerchantImageModel *model = [[WJMerchantImageModel alloc] initWithDic:dict];
            [arr addObject:model];
        }
        self.imageArray = [NSArray arrayWithArray:arr];
        [arr removeAllObjects];
        
    }
    return self;
}

@end
