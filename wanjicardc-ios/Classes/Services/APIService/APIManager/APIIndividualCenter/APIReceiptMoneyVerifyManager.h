//
//  APIReceiptMoneyVerifyManager.h
//  WanJiCard
//
//  Created by reborn on 16/9/20.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIReceiptMoneyVerifyManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong)NSString  *money;

@end
