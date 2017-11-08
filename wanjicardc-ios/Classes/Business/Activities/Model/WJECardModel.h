//
//  WJECardModel.h
//  WanJiCard
//
//  Created by silinman on 16/8/18.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJECardModel : NSObject


@property (nonatomic, strong) NSString     * cardId;
@property (nonatomic, assign) NSInteger      cardColor;
@property (nonatomic, strong) NSString     * faceValue;//弃用
@property (nonatomic, strong) NSString     * facePrice;
@property (nonatomic, strong) NSString     * stock;
@property (nonatomic, strong) NSString     * expiryDate;
@property (nonatomic, strong) NSString     * cardDes;
@property (nonatomic, strong) NSString     * logoUrl;
@property (nonatomic, strong) NSString     * salePrice;
@property (nonatomic, strong) NSString     * commodityName;
@property (nonatomic, strong) NSString     * soldCount;
@property (nonatomic, strong) NSArray      * goodsDetailArray;
@property (nonatomic, assign) NSInteger    activityType; //活动类型（不为0是活动,活动类型1,2,3.....）
@property (nonatomic, assign) NSInteger    limitCount;   //限购数量
@property (nonatomic, assign) NSInteger    allowBuyCount;   //用户可以购买数量
@property (nonatomic, strong) NSString     * cardColorValue;
@property (nonatomic, strong) NSString     * salePriceRmb;
@property (nonatomic, assign) BOOL         isEntitycard;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
