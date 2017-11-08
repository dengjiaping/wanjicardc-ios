//
//  WJOrderModel.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/19.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJOrderModel.h"

@implementation WJOrderModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {

        self.orderId = ToString(dic[@"orderId"]);
        self.orderNo = ToString(dic[@"cardOrderNo"]);
        self.orderStatus = (OrderStatus)[dic[@"cardOrderStatus"] intValue];
        self.statusName = ToString(dic[@"StatusName"]);
        self.orderType = (OrderType)[dic[@"orderType"] intValue];
        self.cardCover = ToString(dic[@"cardOrderPic"]);
        self.name = ToString(dic[@"merchantCardName"]);
        self.pcid = ToString(dic[@"merchantCardId"]);
        self.merId = ToString(dic[@"merchantId"]);
        self.salePrice = ToString(dic[@"cardSalePrice"]);
        self.faceValue = ToString(dic[@"cardFacePrice"]);
        self.count = [dic[@"cardOrderAmount"] integerValue];
        self.amount = ToString(dic[@"cardOrignal"]);
        self.SpecialAmount = ToString(dic[@"reduceMoney"]);
        self.PayAmount = ToString(dic[@"cardOrderValue"]);
//        self.userName = ToString(dic[@"Username"]);
        self.createTime = ToString(dic[@"cardOrderCreatedate"]);
        self.merName = ToString(dic[@"merchantName"]);
        self.merAddress = ToString(dic[@"merchantAddress"]);
//        self.payType = (ChargeType)[dic[@"payType"] integerValue];
        self.ctype = (ColorType)[dic[@"merchantCardColor"] integerValue];
        self.charge = dic[@"charge"];
        self.paychannel = dic[@"paychannel"];
        self.userCouponCode = dic[@"userCouponCode"];
        self.countDown = [dic[@"countDown"] integerValue];
        self.isLimitForSale = [dic[@"isLimitForSale"] boolValue];
        
        self.countDown = [dic[@"countDown"] integerValue];
        self.isLimitForSale = [dic[@"isLimitForSale"] boolValue];
        
        self.arrivalAmount = ToString(dic[@"arrival"]);
        
        self.baoZiCount =  ToString(dic[@"walletCount"]);
        self.isBuyAgain = [dic[@"ifBuy"] integerValue];
        
        self.rechargeMoney = ToString(dic[@"rechargeMoney"]);
        self.cardColor = ToString(dic[@"cardColorValue"]);
        self.successdescribe = ToString(dic[@"successdescribe"]);
        
        
    }
    return self;
}
@end
