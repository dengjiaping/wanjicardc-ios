//
//  WJNewsCenterReformer.m
//  WanJiCard
//
//  Created by XT Xiong on 16/7/5.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJNewsCenterReformer.h"
#import "WJNewsCenterModel.h"

@implementation WJNewsCenterReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * newsArray  = [NSMutableArray array];
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary * result = [NSDictionary dictionary];
        result = [data objectForKey:@"news"];
        for (id obj in result) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJNewsCenterModel * newsCenterModel = [[WJNewsCenterModel alloc] initWithDictionary:obj];
                [newsArray addObject:newsCenterModel];
            }
        }
    }
    return newsArray;
}

@end
