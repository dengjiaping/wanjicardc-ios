//
//  WJGenECardOrderManager.h
//  WanJiCard
//
//  Created by 林有亮 on 16/8/29.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIGenECardOrderManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic , assign) NSInteger        buyNumber;
@property (nonatomic , strong) NSString         * eCardID;
@property (nonatomic , assign) NSString         * channelId;  //三种支付方式传参：wjkbun、pingapp、payeco
@property (nonatomic , strong) NSString         * orderNo;    //第一次生成订单传空，第二次修改传入订单号

@end
