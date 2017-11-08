//
//  WJNewsListReformer.m
//  WanJiCard
//
//  Created by XT Xiong on 16/7/5.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJNewsListReformer.h"
#import "WJSystemNewsModel.h"
#import "WJConsumeNewsModel.h"

@implementation WJNewsListReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    if ([data isKindOfClass:[NSArray class]]) {
        for (id obj in data) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                if ([[obj objectForKey:@"type"]isEqualToString:@"1"]||[[obj objectForKey:@"type"]isEqualToString:@"2"]) {
                    WJSystemNewsModel * systemNewsModel = [[WJSystemNewsModel alloc] initWithDictionary:obj];
                    [result addObject:systemNewsModel];
                }else{
                    WJConsumeNewsModel * consumeNewsModel = [[WJConsumeNewsModel alloc] initWithDictionary:obj];
                    [result addObject:consumeNewsModel];
                }
            }
        }
    }
    return result;
}

@end
