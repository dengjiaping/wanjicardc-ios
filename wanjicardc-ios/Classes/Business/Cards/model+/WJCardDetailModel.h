//
//  WJCardDetailModel.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJStoreModel.h"
#import "WJConsumeModel.h"
#import "WJPrivilegeModel.h"

@interface WJCardDetailModel : NSObject

@property (nonatomic, strong) NSString *cardId;             //卡id
@property (nonatomic, strong) NSString *name;               //卡名称
@property (nonatomic, strong) NSString *merId;              //发卡商家id
@property (nonatomic, strong) NSString *mainMerId;          //发卡商家主店id
@property (nonatomic, strong) NSString *merName;            //商家名称
@property (nonatomic, strong) NSString *cardIntroduce;      //卡介绍
@property (nonatomic, assign) CGFloat faceValue;            //卡面额
@property (nonatomic, strong) NSString *cardCoverUrl;       //商家pic
@property (nonatomic, assign) CGFloat salePrice;            //卡特价
@property (nonatomic, assign) NSInteger saledNumber;        //售出数量
@property (nonatomic, strong) NSString *useExplain;         //使用说明
@property (nonatomic, assign) NSInteger supportStoreNum;    //分店数量
@property (nonatomic, strong) NSArray *supportStoreArray;   //分店集合  WJStoreModel
@property (nonatomic, strong) NSString *promotion;          //促销口号
@property (nonatomic, strong) NSString *merRule;            //商家介绍
@property (nonatomic, strong) NSArray *privilegeArray;      //特权集合  WJPrivilegeModel
@property (nonatomic, assign) CardBgType cType;             //卡图片类型
@property (nonatomic, strong) NSString *adString ;          //广告介绍
@property (nonatomic, strong) NSDictionary  *shareInfoDic;  //分享相关
@property (nonatomic, assign) BOOL isLimitForSale;
@property (nonatomic, strong) NSString  *activityId;
@property (nonatomic, assign) CGFloat   price;                 //卡活动价



- (id)initWithDic:(NSDictionary *)dic;

@end
