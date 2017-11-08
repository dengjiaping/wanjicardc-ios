//
//  APIBaoziRechargeOrderManager.h
//  WanJiCard
//
//  Created by 孙明月 on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIBaoziRechargeOrderManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString *rechargeMoneyID;    //  充值id
@property (nonatomic, strong) NSString    *channelType;     //  渠道

@end
