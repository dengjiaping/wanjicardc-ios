//
//  APIHomePageTopManager.h
//  WanJiCard
//
//  Created by XT Xiong on 16/5/23.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIHomePageTopManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString      *areaId;                   //默认0

@end
