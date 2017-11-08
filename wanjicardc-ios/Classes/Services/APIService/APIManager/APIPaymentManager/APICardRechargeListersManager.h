//
//  APICardRechargeListersManager.h
//  WanJiCard
//
//  Created by XT Xiong on 16/7/13.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APICardRechargeListersManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString      *merchantAccountId;

@end
