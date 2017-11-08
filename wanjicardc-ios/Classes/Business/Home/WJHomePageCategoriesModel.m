//
//  WJHomePageCategoriesModel.m
//  WanJiCard
//
//  Created by silinman on 16/6/3.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJHomePageCategoriesModel.h"

@implementation WJHomePageCategoriesModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.categoryId     = kTrueString(dic[@"categoryId"]);
        self.Id             = kTrueString(dic[@"id"]);
        self.name           = kTrueString(dic[@"name"]);
        self.img            = kTrueString(dic[@"img"]);
    }
    return self;
}

@end
