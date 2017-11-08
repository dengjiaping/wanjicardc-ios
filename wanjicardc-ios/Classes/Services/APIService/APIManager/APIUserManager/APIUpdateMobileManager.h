//
//  APIUpdateMobileManager.h
//  WanJiCard
//
//  Created by Lynn on 15/12/16.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIUpdateMobileManager : APIBaseManager <APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * code;

@end
