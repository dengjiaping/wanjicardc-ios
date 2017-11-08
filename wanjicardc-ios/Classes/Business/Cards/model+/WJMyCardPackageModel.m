//
//  WJMyCardPackageModel.m
//  WanJiCard
//
//  Created by XT Xiong on 16/7/9.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMyCardPackageModel.h"

@implementation WJMyCardPackageModel

- (id)initWithDic:(NSDictionary *)dic
{
    NSMutableArray * resultsArray  = [NSMutableArray array];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSDictionary * result = [NSDictionary dictionary];
        result = [dic objectForKey:@"result"];
        for (id obj in result) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJModelCard * modelCard = [[WJModelCard alloc]initWithDic:obj];
                [resultsArray addObject:modelCard];
            }
        }
        self.cardListArray = [NSArray arrayWithArray:resultsArray];
        self.totalAssets   = [dic[@"totalAssets"] floatValue];
        self.totalPage     = [dic[@"totalPage"] intValue];
        self.pages         = [dic[@"totalAssets"] intValue];

    }
    return self;
}
@end
