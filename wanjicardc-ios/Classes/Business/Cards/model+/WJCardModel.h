//
//  WJCardModel.h
//  WanJiCard
//
//  Created by XT Xiong on 16/7/6.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJCardModel : NSObject

@property (nonatomic, strong) NSString    *activityId ;        //活动id new
@property (nonatomic, strong) NSString    *activityName;
@property (nonatomic, strong) NSString    *activityDescription;
@property (nonatomic, strong) NSString    *adString ;          //广告介绍
@property (nonatomic, assign) NSInteger   cType;              //卡图片类型
@property (nonatomic, strong) NSString    *cardId;             //卡id
@property (nonatomic, strong) NSString    *cardCoverUrl;       //商家pic，logo
@property (nonatomic, strong) NSString    *name;               //卡名称
@property (nonatomic, strong) NSString    *currentFlag;        //是否是请求卡 new
@property (nonatomic, strong) NSString    *faceValue;          //卡面额
@property (nonatomic, strong) NSString    *cardIntroduce;      //卡介绍
@property (nonatomic, strong) NSString    *isLimitForSale;     //是否限购 new
@property (nonatomic, strong) NSString    *merName;            //商家名称
@property (nonatomic, strong) NSString    *price;              //活动价格 new
@property (nonatomic, strong) NSArray     *privilegeArray;     //特权集合  
@property (nonatomic, assign) NSInteger    privilegeNum;       //特权数量
@property (nonatomic, strong) NSString    *salePrice;          //卡特价
@property (nonatomic, assign) NSInteger    saledNumber;        //售出数量
@property (nonatomic, strong) NSString    *useExplain;         //使用说明

- (id)initWithDic:(NSDictionary *)dic;

@end
