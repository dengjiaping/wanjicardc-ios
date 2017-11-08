//
//  WJCategory.m
//  WanJiCard
//
//  Created by Lynn on 15/9/18.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJCategoryModel.h"

@implementation WJCategoryModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.categoryID = [NSString stringWithFormat:@"%@",dic[@"categoryId"]];
        self.name       = dic[@"description"];
        self.pid        = [NSString stringWithFormat:@"%@",dic[@"parentid"]];
    }
    return self;
}

@end
