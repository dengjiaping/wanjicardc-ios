//
//  APIVerifyIdentityManager.h
//  WanJiCard
//
//  Created by XT Xiong on 16/7/11.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIVerifyIdentityManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property(nonatomic, strong) NSString *idNo;
@property(nonatomic, strong) NSString *trueName;
@property(nonatomic, strong) NSString *cardNo;
@property(nonatomic, strong) NSString *phone;

@end
