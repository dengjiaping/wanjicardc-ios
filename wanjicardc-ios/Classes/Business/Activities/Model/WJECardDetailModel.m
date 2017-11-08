//
//  WJECardDetailModel.m
//  WanJiCard
//
//  Created by 林有亮 on 16/8/31.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJECardDetailModel.h"
//@property (nonatomic, strong) NSString      * desString;
//@property (nonatomic, strong) NSString      * titleStrings;
//@property (nonatomic, assign) NSInteger      cardColor;
//@property (nonatomic, strong) NSString      * url;
//@property (nonatomic, strong) NSString      * ad;
//@property (nonatomic, strong) NSString      * expiryDate;
//@property (nonatomic, strong) NSString      * cardDes;
//@property (nonatomic, strong) NSString      * faceValue;
//@property (nonatomic, strong) NSString      * cardID;
//@property (nonatomic, strong) NSString      * logoUrl;
//@property (nonatomic, strong) NSString      * salePrice;
//@property (nonatomic, strong) NSString      * commodityName;
//@property (nonatomic, strong) NSString      * soldCount;
//@property (nonatomic, strong) NSString      * stock;
//@property (nonatomic, strong) NSString      * useRule;
@implementation WJECardDetailModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self) {
        self.titleString        = ToString(dic[@"Title"]);
        self.faceValue          = ToString(dic[@"faceUrl"]);
        self.desString          = ToString(dic[@"Desc"]);
    
        self.url                = ToString(dic[@"Url"]);
        self.useRule            = ToString(dic[@"useRule"]);
    
    }
    return self;
}

@end
