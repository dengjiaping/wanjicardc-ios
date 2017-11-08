//
//  WJBaoziRechargeModel.h
//  WanJiCard
//
//  Created by 孙明月 on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJBaoziRechargeModel : NSObject

@property (nonatomic, strong) NSString      *moneyID;             //充值money ID
@property (nonatomic, strong) NSString      *baoziAmount;         //包子数 num
@property (nonatomic, strong) NSString      *describe;            //描述
@property (nonatomic, assign) CGFloat      rechargeAmount;        //充值金额
@property (nonatomic, strong) NSString   *newdescribe;        //新用户充值送包子描述
@property (nonatomic, strong) NSString   *successdescribe;        //充值成功页描述

- (id)initWithDic:(NSDictionary *)dic;

@end
