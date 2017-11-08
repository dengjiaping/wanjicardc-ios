//
//  WJHomePageBottomModel.m
//  WanJiCard
//
//  Created by XT Xiong on 16/6/2.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJHomePageBottomModel.h"
#import "WJHomePageCardsModel.h"
#import "WJCardActsModel.h"

@implementation WJHomePageBottomModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.areaId             = kTrueString(dic[@"areaId"]);
        self.merchantCategory   = kTrueString(dic[@"merchantCategory"]);
        self.merchantPhone      = kTrueString(dic[@"merchantPhone"]);
        self.merchantName       = kTrueString(dic[@"merchantName"]);
        self.distance           = kTrueString(dic[@"distance"]);
        self.merchantLatitude   = kTrueString(dic[@"merchantLatitude"]);
        self.merchantLongitude  = kTrueString(dic[@"merchantLongitude"]);
        self.merchantAddress    = kTrueString(dic[@"merchantAddress"]);
        self.merchantId         = kTrueString(dic[@"merchantId"]);
        self.merchantPic        = kTrueString(dic[@"merchantPic"]);
        self.tags               = kTrueString(dic[@"tags"]);
        self.totalSale          = kTrueString(dic[@"totalSale"]);
        
        NSMutableArray *results = [NSMutableArray array];
        for (NSDictionary *cardsDic in dic[@"cards"]) {
            WJHomePageCardsModel *cards = [[WJHomePageCardsModel alloc] initWithDictionary:cardsDic];
            [results addObject:cards];
        }
        self.cardsArray = [NSArray arrayWithArray:results];
        [results removeAllObjects];
        
        NSMutableArray *acts = [NSMutableArray array];
        for (NSDictionary *dics in dic[@"cardActs"]) {
            WJCardActsModel *cards = [[WJCardActsModel alloc] initWithDictionary:dics];
            [acts addObject:cards];
        }
        self.cardActs = [NSArray arrayWithArray:acts];
        [acts removeAllObjects];
    }
    return self;
}

@end
