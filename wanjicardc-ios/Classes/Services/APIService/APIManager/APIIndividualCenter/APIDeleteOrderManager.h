//
//  APIDeleteOrderManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/24.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIDeleteOrderManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong)NSString   *orderNumber;
@property (nonatomic, assign)OrderType  orderType;

@end
