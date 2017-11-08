//
//  APIUserUpdateManager.h
//  WanJiCard
//
//  Created by Lynn on 15/9/7.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIUserUpdateManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString  *name;
//@property (nonatomic, strong) NSString  *country;
//@property (nonatomic, strong) NSString  *province;
//@property (nonatomic, strong) NSString  *city;
//@property (nonatomic, assign) NSInteger year;
//@property (nonatomic, assign) NSInteger month;
//@property (nonatomic, assign) NSInteger day;

@property (nonatomic, assign) NSInteger isMale;
@property (nonatomic, strong) NSString  *address;
@property (nonatomic, strong) NSString  *userBirthday;






@end
