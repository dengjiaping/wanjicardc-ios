//
//  WJRecommendStoreModel.h
//  WanJiCard
//
//  Created by Lynn on 15/9/16.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJRecommendStoreModel : NSObject

@property (nonatomic, strong) NSString      *address;
@property (nonatomic, strong) NSString      *businessTime;
@property (nonatomic, strong) NSString       *category;
@property (nonatomic, strong) NSString      *cover;
@property (nonatomic, strong) NSString      *distance;
@property (nonatomic, strong) NSString      *distanceStr;
@property (nonatomic, strong) NSString      *merID;
@property (nonatomic, strong) NSString      *latitude;
@property (nonatomic, strong) NSString      *longitude;
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, strong) NSString      *phone;
@property (nonatomic, strong) NSString      *totalSale;
@property (nonatomic, assign) BOOL          isLimitForSale;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end
