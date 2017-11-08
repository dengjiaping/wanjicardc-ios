//
//  APICouponAddManager.h
//  WanJiCard
//
//  Created by XT Xiong on 16/6/21.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APICouponAddManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString      *code;

@end
