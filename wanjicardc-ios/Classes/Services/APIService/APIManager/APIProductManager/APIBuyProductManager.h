//
//  APIBuyProductManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/6.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"
#import "WJEnumType.h"

@interface APIBuyProductManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString    *activityId;             //活动id
@property (nonatomic, strong) NSString    *proID;                  //商品id
@property (nonatomic, assign) CGFloat      cardOrderAmount;        //金额
@property (nonatomic, strong) NSString    *channelType;            //渠道
@property (nonatomic, strong) NSString    *specialCode;              //优惠券
@property (nonatomic, strong) NSString    *merId;                  //商家id
@property (nonatomic, assign) OrderType    orderType;              //购卡还是充值
@property (nonatomic, strong) NSString    *isLimitForSale;         //是否有活动

//@property (nonatomic, assign) int proNum;                          //商品数量，默认1
//@property (nonatomic, assign) ChargeType   channelType;            //渠道
//@property (nonatomic, strong) NSString    *cashier;                //推荐店员ID


@end
 