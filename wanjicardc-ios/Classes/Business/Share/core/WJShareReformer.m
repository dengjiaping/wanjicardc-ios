//
//  WJShareReformer.m
//  WanJiCard
//
//  Created by wangzhangjie on 15/9/24.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJShareReformer.h"
#import "WJShareModel.h"
@implementation WJShareReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    
//    if ([data isKindOfClass:[NSArray class]]) {
//        NSArray * dataArray = (NSArray *)data;
//        
//        //        if ([data[@"result"] isKindOfClass:[NSArray class]]) {
//        //            NSArray * dataArray = (NSArray *)data[@"result"];
//        for (int i = 0; i< [dataArray count]; i++) {
//            NSDictionary * dic = [dataArray objectAtIndex:i];
//            WJShareModel * model = [[WJShareModel alloc] initWithDictionary:dic];
//            
//            [result addObject:model];
//        }
//    }
    if ([data[@"result"] isKindOfClass:[NSArray class]]) {
        NSArray * dataArray = (NSArray *)data[@"result"];
        
        for (int i = 0; i< [dataArray count]; i++) {
            NSDictionary * dic = [dataArray objectAtIndex:i];
            WJShareModel * model = [[WJShareModel alloc] initWithDictionary:dic];
            
            [result addObject:model];
        }
    }
    
    return result;
}

@end
