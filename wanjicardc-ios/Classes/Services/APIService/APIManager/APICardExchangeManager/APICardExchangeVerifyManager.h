//
//  APICardExchangeVerifyManager.h
//  WanJiCard
//
//  Created by reborn on 16/11/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APICardExchangeVerifyManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property(nonatomic, strong) NSString *cardNumber;
@property(nonatomic, strong) NSString *cardPassword;
@property(nonatomic, assign) NSInteger exchangeActivityCardId;

@end
