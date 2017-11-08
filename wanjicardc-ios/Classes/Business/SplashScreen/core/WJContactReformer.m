//
//  WJContactReformer.m
//  WanJiCard
//
//  Created by wangzhangjie on 15/9/27.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJContactReformer.h"
#import "WJContactModel.h"
@implementation WJContactReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray * dataArray = (NSArray *)data;
        
        //        if ([data[@"result"] isKindOfClass:[NSArray class]]) {
        //            NSArray * dataArray = (NSArray *)data[@"result"];
        for (int i = 0; i< [dataArray count]; i++) {
            NSDictionary * dic = [dataArray objectAtIndex:i];
            WJContactModel * model = [[WJContactModel alloc] initWithDictionary:dic];
            
            [result addObject:model];
        }
    }
    return result;
}

@end
