//
//  WJCardPackageDetailModel.h
//  WanJiCard
//
//  Created by Angie on 15/10/13.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJCardPackageDetailModel : NSObject

@property (nonatomic, strong) NSString *merId;              //发卡商家id
@property (nonatomic, strong) NSString *mainMerId;          //发卡商家主店id
@property (nonatomic, strong) NSString *cardCoverUrl;       //
@property (nonatomic, assign) CGFloat faceValue;               //商家卡面值
@property (nonatomic, assign) CGFloat balance;               //商家卡余额
@property (nonatomic, strong) NSString *name;               //卡名称
@property (nonatomic, strong) NSString *useExplain;         //使用说明
@property (nonatomic, strong) NSString *introduce;         //卡介绍
@property (nonatomic, assign) NSInteger supportStoreNum;    //分店数量
@property (nonatomic, strong) NSArray *supportStoreArray;   //分店集合  WJStoreModel
@property (nonatomic, assign) NSInteger consumeCount;       //顾客数
@property (nonatomic, strong) NSArray *consumeArray;        //顾客集合  WJConsumeModel
@property (nonatomic, strong) NSArray *privilegeArray;      //特权集合  WJPrivilegeModel
@property (nonatomic, assign) CardBgType cType;             //卡图片类型
@property (nonatomic, strong) NSString *adString;           //广告语
@property (nonatomic, strong) NSDictionary  *shareInfoDic;  //分享相关
@property (nonatomic, strong) NSString *merName;            //商家名称

@property (nonatomic, strong) NSString *cardId;
@property (nonatomic, assign) BOOL     isLimitForSale;
@property (nonatomic, assign) CGFloat  price;


- (id)initWithDic:(NSDictionary *)dic;


@end
