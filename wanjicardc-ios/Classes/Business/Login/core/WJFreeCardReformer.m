//
//  WJFreeCardReformer.m
//  WanJiCard
//
//  Created by Lynn on 15/9/8.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJFreeCardReformer.h"
#import "WJModelCard.h"

@implementation WJFreeCardReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    
    if ([data[@"result"] isKindOfClass:[NSArray class]]) {
        NSArray * dataArray = (NSArray *)data[@"result"];
        
        for (int i = 0; i< [dataArray count]; i++) {
            NSDictionary * dic = [dataArray objectAtIndex:i];
            WJModelCard * model = [[WJModelCard alloc] initWithDic:dic];
            
            [result addObject:model];
        }
    }
    return result;
}
@end
