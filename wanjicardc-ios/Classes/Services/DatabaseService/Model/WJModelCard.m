//
//  WJModelCard.m
//  WanJiCard
//
//  Created by Lynn on 15/9/8.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJModelCard.h"

@implementation WJModelCard

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.freeCardID     = ToString(dic[@"cardId"]) ;
        self.colorType      = [dic[@"cardColor"] intValue];
        self.name           = dic[@"cardName"];
        self.coverURL       = dic[@"cardLogo"];
        self.balance      = [dic[@"balance"] floatValue];
        self.faceValue      = [dic[@"faceValue"] floatValue];
        self.saledNumber    = [dic[@"totalSale"] integerValue];
        self.merName        = dic[@"merchantName"];
        self.merId        = dic[@"merchantId"];

        self.status         = [dic[@"Status"] intValue];
    }
    return self;
}

-(id)initWithCursor:(FMResultSet *)cursor{
    
    if (self = [super init]) {
        self.freeCardID =   [cursor stringForColumn:COL_CARD_ID];
        self.name =         [cursor stringForColumn:COL_CARD_NAME]?:@"";
        self.faceValue =    [cursor doubleForColumn:COL_CARD_FaceValue];
        self.coverURL =     [cursor stringForColumn:COL_CARD_COVER]?:@"";
        self.saledNumber =  [cursor intForColumn:COL_CARD_SaleNumber];
        self.balance =    [cursor doubleForColumn:COL_CARD_SalePrice];
        self.status =       (OrderStatus)[cursor intForColumn:COL_CARD_CardStatus];
        self.colorType =    [cursor intForColumn:COL_CARD_ColorType];
        self.merName =      [cursor stringForColumn:COL_CARD_MerName]?:@"";
    }

    return self;
}

@end
