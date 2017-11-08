//
//  APIUpdatePayPsdManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/24.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIUpdatePayPsdManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString      *passwordStr;
//@property (nonatomic, strong) NSString      *verifyStr;

@end
