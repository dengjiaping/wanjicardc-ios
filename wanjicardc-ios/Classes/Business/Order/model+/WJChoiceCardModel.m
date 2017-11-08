//
//  WJChoiceCardModel.m
//  WanJiCard
//
//  Created by XT Xiong on 16/7/13.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJChoiceCardModel.h"
#import "PayPrivilegeModel.h"

@implementation WJChoiceCardModel

- (id)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        self.cardId = ToString(dic[@"cardId"]);
        self.merchantCardName = ToString(dic[@"merchantCardName"]);
        self.cardFacePrice = [dic[@"cardFacePrice"] floatValue];
        
        NSMutableArray *results = [NSMutableArray array];
        
        for (NSDictionary *preivilegeDic in dic[@"merchantCardPrivilege"]) {
            PayPrivilegeModel *preivilege = [[PayPrivilegeModel alloc] initWithDic:preivilegeDic];
            [results addObject:preivilege];
        }
        self.privilegeArray = [NSArray arrayWithArray:results];

    }    
    return self;
}

@end
