//
//  APIHotKeysManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/23.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIHotKeysManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, assign) NSInteger      keyCount;

@end
