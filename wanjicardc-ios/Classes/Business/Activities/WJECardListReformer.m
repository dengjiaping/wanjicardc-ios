//
//  WJECardListReformer.m
//  WanJiCard
//
//  Created by silinman on 16/8/18.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJECardListReformer.h"
#import "WJECardModel.h"

@implementation WJECardListReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * cardsArray  = [NSMutableArray array];
    if ([data isKindOfClass:[NSArray class]]) {
        for (id obj in data) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJECardModel * cardModel = [[WJECardModel alloc] initWithDictionary:obj];
                [cardsArray addObject:cardModel];
            }
        }
    }
    return cardsArray;
}

@end
