//
//  WJHomePageActivitiesModel.h
//  WanJiCard
//
//  Created by silinman on 16/6/3.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJHomePageActivitiesModel : NSObject

@property(nonatomic,strong) NSString        * activityName;
@property(nonatomic,strong) NSString        * activityType;
@property(nonatomic,strong) NSString        * imagePosition;
@property(nonatomic,strong) NSString        * img;
@property(nonatomic,strong) NSString        * url;
@property(nonatomic,strong) NSString        * merchantName;
@property(nonatomic,strong) NSString        * brandName;
@property(nonatomic,strong) NSString        * merchantAccountId;
@property(nonatomic,strong) NSString        * merchantId;
@property(nonatomic,strong) NSString        *isLogin;


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
