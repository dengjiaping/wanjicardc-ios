//
//  WJMerchantCard.m
//  WanJiCard
//
//  Created by 孙明月 on 16/3/10.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJMerchantCard.h"

@implementation WJMerchantCard
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.cardId                 = ToString(dic[@"cardId"]) ;
        self.colorType              = [dic[@"cardColor"] intValue];
        self.salePrice              = [dic[@"saleValue"] floatValue];
        self.faceValue              = [dic[@"faceValue"] integerValue];
        self.name                   = dic[@"cardName"];
        self.coverURL               = dic[@"cardLogo"];
        self.saledNumber            = [dic[@"totalSale"] integerValue];
        self.merName                = dic[@"merchantName"];
        self.merchantCardStatus     = ToString(dic[@"merchantCardStatus"]) ;
        self.merchantId             = ToString(dic[@"merchantId"]) ;
        self.status                 = [dic[@"Status"] intValue];
        self.isLimitForSale         = [dic[@"isLimitForSale"] boolValue];
        self.salePercent            = [dic[@"salePercent"] floatValue];
        self.price                  = [dic[@"price"]floatValue];
        
        self.isLimitForSale = [dic[@"isLimitForSale"] boolValue];
        self.salePercent    = [dic[@"salePercent"] floatValue];
//        self.originalPrice  = [dic[@"originalPrice"]floatValue];
        self.price          = [dic[@"price"]floatValue];
        
    }
    return self;
}

@end
