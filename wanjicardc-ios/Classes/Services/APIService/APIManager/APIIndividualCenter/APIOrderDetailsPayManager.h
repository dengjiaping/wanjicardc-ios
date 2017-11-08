//
//  APIOrderDetailsPayManager.h
//  WanJiCard
//
//  Created by reborn on 16/8/26.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIOrderDetailsPayManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString  * ordersID;
@property (nonatomic, assign) OrderType orderType;

@end
