//
//  APIChargeTotalManager.h
//  WanJiCard
//
//  Created by Lynn on 15/12/23.
//  Copyright © 2015年 zOne. All rights reserved.
//

//订单生成前的折扣，优惠券请求
#import "APIBaseManager.h"

@interface APIChargeTotalManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString * merID;             //分店的merchantid
@property (nonatomic, strong) NSString * merchantCardId;    //卡id
@property (nonatomic, strong) NSString * isLimitForSale;    //是否活动
@property (nonatomic, strong) NSString * activityId;        //活动id
@property (nonatomic, assign) FavorableTicketType   ticketType;

@end
