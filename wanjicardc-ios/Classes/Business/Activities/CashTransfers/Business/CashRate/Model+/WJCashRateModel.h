//
//  WJCashRateModel.h
//  WanJiCard
//
//  Created by reborn on 16/11/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJCashRateModel : NSObject

@property(nonatomic, strong) NSString *rateFast;  // 费率
@property(nonatomic, strong) NSString *rateNormal;

@property(nonatomic, strong) NSString *settleFast;  //结算
@property(nonatomic, strong) NSString *settleNormal;

@property(nonatomic, strong) NSString *quotaFast;   //额度
@property(nonatomic, strong) NSString *quotaNormal;

@property(nonatomic, strong) NSString *idFast;      //id
@property(nonatomic, strong) NSString *idNormal;

@property(nonatomic, strong) NSString *channelName;
@property(nonatomic, strong) NSString *tipCopy;     //提示
@property(nonatomic, strong) NSString *imageUrl;    //icon图片



- (id)initWithDic:(NSDictionary *)dic;

@end

