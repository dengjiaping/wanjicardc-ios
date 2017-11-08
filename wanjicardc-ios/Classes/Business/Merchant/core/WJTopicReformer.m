//
//  WJTopicReformer.m
//  WanJiCard
//
//  Created by Lynn on 15/9/12.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJTopicReformer.h"
#import "WJTopicModel.h"

@implementation WJTopicReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    if ([data[@"activities"] isKindOfClass:[NSArray class]]) {
        for (id obj in [data objectForKey:@"activities"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJTopicModel * topic = [[WJTopicModel alloc] initWithDic:obj];
                [result addObject:topic];
            }
        }
    }
    return result;
}

@end
