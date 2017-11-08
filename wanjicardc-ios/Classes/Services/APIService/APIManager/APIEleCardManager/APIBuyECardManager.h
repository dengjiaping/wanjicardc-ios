//
//  APIBuyECardManager.h
//  WanJiCard
//
//  Created by 林有亮 on 16/8/29.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIBuyECardManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong)NSString * orderNo;

@end
