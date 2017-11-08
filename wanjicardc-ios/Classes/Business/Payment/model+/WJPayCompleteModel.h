//
//  WJPayCompleteModel.h
//  WanJiCard
//
//  Created by Angie on 15/11/18.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJEnumType.h"

typedef NS_ENUM(NSInteger, PaymentType){
    PaymentTypeBuy,
    PaymentTypeCharge,
    PaymentTypeConsume
};

FOUNDATION_EXPORT NSString * const kOrderNumber;
FOUNDATION_EXPORT NSString * const kOrderAmount;
FOUNDATION_EXPORT NSString * const kMerId;
FOUNDATION_EXPORT NSString * const kMerName;

@class WJECardDetailModel;
@interface WJPayCompleteModel : NSObject

@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *merId;
@property (nonatomic, strong) NSString *merName;


@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *payTime;

@property (nonatomic, strong) NSString *paymentChannel;
@property (nonatomic, assign) PaymentType paymentType;

@property (nonatomic, strong) NSString *cardName;           //卡名
@property (nonatomic, strong) NSString *cardFaceValue;      //面值
@property (nonatomic, strong) NSString *salePrice;          //售价
@property (nonatomic, strong) NSString *realPay;            //实付款
@property (nonatomic, strong) NSArray  *privilegeArray;     //新加特权集合

@property (nonatomic, strong) NSString *rechargeDescribe;   //  描述
@property (nonatomic, strong) NSString *promptStr;          //  提示语
@property (nonatomic, strong) NSString *ecardsNum;          //电子卡数量
@property (nonatomic, strong) WJECardDetailModel   *ecard;    //电子卡

@property (nonatomic, assign) ElectronicCardPayType electronicCardPayType;


- (id)initWithDic:(NSDictionary *)dic;

@end
