//
//  WJCityListReformer.m
//  WanJiCard
//
//  Created by Lynn on 15/9/18.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJCityListReformer.h"
#import "WJCityModel.h"
@implementation WJCityListReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    if ([data isKindOfClass:[NSArray class]]) {
        for (id obj in data) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJCityModel * city = [[WJCityModel alloc] initWithDic:obj];
                [result addObject:city];
            }
        }
    }
    return result;
}
@end
