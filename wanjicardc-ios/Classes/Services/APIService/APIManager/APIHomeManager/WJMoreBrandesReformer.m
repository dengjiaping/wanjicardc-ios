//
//  WJMoreBrandesReformer.m
//  WanJiCard
//
//  Created by XT Xiong on 16/6/2.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMoreBrandesReformer.h"
#import "WJMoreBrandesModel.h"

@implementation WJMoreBrandesReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * brandesArray  = [NSMutableArray array];
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary * result = [NSDictionary dictionary];
        result = [data objectForKey:@"brands"];
        for (id obj in result) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJMoreBrandesModel * brandesModel = [[WJMoreBrandesModel alloc] initWithDictionary:obj];
                [brandesArray addObject:brandesModel];
            }
        }
    }
    return brandesArray;
}

@end
