//
//  WJCategateReformer.m
//  WanJiCard
//
//  Created by Lynn on 15/9/18.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJCategateReformer.h"
#import "WJCategoryModel.h"

@implementation WJCategateReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{

    NSMutableArray * result = [NSMutableArray array];
    if ([data[@"Category"] isKindOfClass:[NSArray class]]) {
        for (id obj in data[@"Category"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJCategoryModel * categoryModel = [[WJCategoryModel alloc] initWithDic:obj];
                [result addObject:categoryModel];
            }
        }
    }
    return result;
}
@end
