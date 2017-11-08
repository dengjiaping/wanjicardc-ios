//
//  WJOrderModel.h
//  WanJiCard
//
//  Created by Harry Hu on 15/9/19.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJOrderModel : NSObject

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, assign) OrderStatus orderStatus;
@property (nonatomic, strong) NSString *statusName;
@property (nonatomic, assign) OrderType orderType;
@property (nonatomic, strong) NSString *cardCover;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pcid;               //产品卡id
@property (nonatomic, strong) NSString *merId;              //产品卡id
@property (nonatomic, strong) NSString *salePrice;          //售价
@property (nonatomic, strong) NSString *faceValue;          //面值
@property (nonatomic, assign) NSInteger count;              //数量
@property (nonatomic, strong) NSString *amount;             //应付总金额
@property (nonatomic, strong) NSString *SpecialAmount;      //优惠金额
@property (nonatomic, strong) NSString *PayAmount;          //实付款
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *merName;
@property (nonatomic, strong) NSString *merAddress;
//@property (nonatomic, assign) ChargeType payType;
@property (nonatomic, assign) ColorType ctype;
@property (nonatomic, strong) NSString *charge;
@property (nonatomic, strong) NSString *paychannel;
@property (nonatomic, strong) NSString *userCouponCode;
@property (nonatomic ,assign) NSInteger countDown;
@property (nonatomic ,assign) BOOL isLimitForSale;

@property (nonatomic, strong) NSString *arrivalAmount;     //到账包子
@property (nonatomic, strong) NSString *baoZiCount;        //我的包子数量
@property (nonatomic, assign) NSInteger isBuyAgain;        //再次购买
@property (nonatomic, strong) NSString *rechargeMoney;     //可以充值金额
@property (nonatomic, strong) NSString *cardColor;        
@property (nonatomic, strong) NSString *successdescribe;   //包子充值描述

- (id)initWithDic:(NSDictionary *)dic;

@end
