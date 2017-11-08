//
//  WJBankCardModel.m
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJBankCardModel.h"

@implementation WJBankCardModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self) {
        self.bankLogol        = ToString(dic[@"bankLogo"]);
        self.bankName         = ToString(dic[@"bankName"]);
        self.bankCardType     = ToString(dic[@"cardType"]);
        
        self.bankCardNumber   = ToString(dic[@"cardNo"]);
        self.isReceiveCard    = [dic[@"default"] boolValue];
        self.bankId           = ToString(dic[@"id"]);
        
    }
    return self;
}
@end
