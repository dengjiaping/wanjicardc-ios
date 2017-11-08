//
//  WJFairDetailModel.m
//  WanJiCard
//
//  Created by silinman on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJFairDetailModel.h"
#import "WJECardModel.h"
#import "WJFairActivityModel.h"

@implementation WJFairDetailModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.balance                = ToString([dic[@"user"] objectForKey:@"balance"]);
        self.cardsHasmore           = YES;
        self.activityHasmore        = YES;
//        self.recharge               = [dic[@"ifRecharge"] boolValue];
        self.recharge               = [[dic[@"user"] objectForKey:@"ifRecharge"] boolValue];
        self.total                  = [dic[@"total"] integerValue];


        NSMutableArray *results = [NSMutableArray array];
        for (NSDictionary *cardsDic in [dic[@"thirdCard"] objectForKey:@"result"]) {
            WJECardModel *cards = [[WJECardModel alloc] initWithDictionary:cardsDic];
            [results addObject:cards];
        }
        self.cardsArray = [NSArray arrayWithArray:results];
        [results removeAllObjects];
        
//        NSMutableArray *acts = [NSMutableArray array];
//        for (NSDictionary *dics in [dic[@"activity"] objectForKey:@"result"]) {
//            WJFairActivityModel *cards = [[WJFairActivityModel alloc] initWithDictionary:dics];
//            [acts addObject:cards];
//        }
//        self.activityArray = [NSArray arrayWithArray:acts];
//        [acts removeAllObjects];
    }
    return self;
}


@end
