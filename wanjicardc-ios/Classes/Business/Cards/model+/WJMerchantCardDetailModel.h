//
//  WJMerchantCardDetailModel.h
//  WanJiCard
//
//  Created by XT Xiong on 16/7/7.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJStoreModel.h"
#import "WJCardModel.h"

@interface WJMerchantCardDetailModel : NSObject

@property (nonatomic, strong) NSDictionary  *shareInfoDic;        //分享相关
@property (nonatomic, strong) NSArray       *supportStoreArray;   //分店集合  WJStoreModel
@property (nonatomic, assign) NSInteger      supportStoreNum;     //分店数量
@property (nonatomic, strong) NSArray       *cardArray;           //卡集合    WJCardModel
@property (nonatomic, strong) NSString      *mainMerId;           //发卡商家主店id
@property (nonatomic, strong) NSString      *merId;               //发卡商家id
@property (nonatomic, strong) NSString      *merName;             //商家名称
@property (nonatomic, assign) NSInteger     isMyCard;

- (id)initWithDic:(NSDictionary *)dic;

@end
