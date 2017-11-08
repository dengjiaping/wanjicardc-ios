//
//  WJBaoziRechargeListModel.h
//  WanJiCard
//
//  Created by 孙明月 on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJBaoziRechargeListModel : NSObject
@property (nonatomic, strong) NSArray    *bunList;              //充值金额集合  WJCouponModel
@property (nonatomic, strong) NSString   *rechargeAgreement;    //协议
@property (nonatomic, assign) BOOL       ecoEnable;             //是否支持易联

- (id)initWithDic:(NSDictionary *)dic;

@end
