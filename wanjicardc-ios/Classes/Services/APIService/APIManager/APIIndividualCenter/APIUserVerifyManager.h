//
//  APIUserVerifyManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/24.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIUserVerifyManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString          *cardNumber;
@property (nonatomic, strong) NSString          *realName;

@end
