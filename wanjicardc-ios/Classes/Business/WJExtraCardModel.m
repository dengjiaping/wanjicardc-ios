//
//  WJExtraCardModel.m
//  WanJiCard
//
//  Created by maying on 2017/8/12.
//  Copyright © 2017年 WJIKA. All rights reserved.
//

#import "WJExtraCardModel.h"

@implementation WJExtraCardModel
- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {

        
        self.cardNumber = ToString(dic[@"cardNum"]);
        
        self.cardSecret =  ToString(dic[@"cardPassword"]);

        
        
    }
    return self;
}
@end
