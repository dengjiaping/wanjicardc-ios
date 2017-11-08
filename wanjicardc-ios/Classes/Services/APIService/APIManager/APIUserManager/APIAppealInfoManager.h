//
//  APIAppealInfoManager.h
//  WanJiCard
//
//  Created by Lynn on 15/12/7.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIAppealInfoManager : APIBaseManager <APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * identityNumber;
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSString * year;
@property (nonatomic, strong) NSString * month;
@property (nonatomic, strong) NSString * imageName;
@end
