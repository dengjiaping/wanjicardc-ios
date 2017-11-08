//
//  WJHotKeysReformer.m
//  WanJiCard
//
//  Created by Lynn on 15/9/23.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJHotKeysReformer.h"
#import "WJHotKeysModel.h"

@implementation WJHotKeysReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    if ([data[@"result"] isKindOfClass:[NSArray class]]) {
        for (id obj in data[@"result"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJHotKeysModel * hotKey = [[WJHotKeysModel alloc] initWithDic:obj];
                [result addObject:hotKey];
            }
        }
    }
    return result;
}
@end
