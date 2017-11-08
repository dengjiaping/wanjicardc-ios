//
//  APISynProductManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/7.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APISynProductManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSArray *proIDs;

@end
