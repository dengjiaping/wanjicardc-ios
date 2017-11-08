//
//  WJHomePageCardsModel.h
//  WanJiCard
//
//  Created by silinman on 16/6/3.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJHomePageCardsModel : NSObject

@property(nonatomic,strong) NSArray      * actsArray;
@property(nonatomic,strong) NSString     * ad;
@property(nonatomic,strong) NSString     * balance;
@property(nonatomic,strong) NSString     * cardColor;
@property(nonatomic,strong) NSString     * cardId;
@property(nonatomic,strong) NSString     * cardLogo;
@property(nonatomic,strong) NSString     * cardName;
@property(nonatomic,strong) NSString     * faceValue;
@property(nonatomic,strong) NSString     * introduce;
@property(nonatomic,strong) NSString     * isLimitForSale;
@property(nonatomic,strong) NSString     * merchantCardStatus;
@property(nonatomic,strong) NSString     * merchantId;
@property(nonatomic,strong) NSString     * merchantName;
@property(nonatomic,strong) NSString     * price;
@property(nonatomic,strong) NSString     * privailegeNum;
@property(nonatomic,strong) NSString     * salePercent;
@property(nonatomic,strong) NSString     * saleValue;
@property(nonatomic,strong) NSString     * totalSale;
@property(nonatomic,strong) NSString     * useExplain;

- (instancetype)initWithDictionary:(NSDictionary *)dic;


@end
