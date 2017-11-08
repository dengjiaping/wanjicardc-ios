//
//  WJBillModel.h
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJBillModel : NSObject
@property (nonatomic, strong) NSString *billId;
@property (nonatomic, strong) NSString *billNo;
@property (nonatomic, assign) BillStatus billStatus;
@property (nonatomic, strong) NSString *statusName;

@property (nonatomic, strong) NSString *receiveAmount;      //收款
@property (nonatomic, strong) NSString *fee;                //手续费
@property (nonatomic, strong) NSString *deductedChannel;    //扣款通道 微信、支付宝

@property (nonatomic, strong) NSString *createTime;



- (id)initWithDic:(NSDictionary *)dic;
@end
