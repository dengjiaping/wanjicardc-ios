//
//  WJHomePageBottomModel.h
//  WanJiCard
//
//  Created by XT Xiong on 16/6/2.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIBaseManager.h"

@interface WJHomePageBottomModel : NSObject

@property(nonatomic,strong) NSString                    * areaId;
@property(nonatomic,strong) NSArray                     * cardsArray;
@property(nonatomic,strong) NSString                    * distance;
@property(nonatomic,strong) NSString                    * merchantAddress;
@property(nonatomic,strong) NSString                    * merchantCategory;
@property(nonatomic,strong) NSString                    * merchantLatitude;
@property(nonatomic,strong) NSString                    * merchantLongitude;
@property(nonatomic,strong) NSString                    * merchantId;
@property(nonatomic,strong) NSString                    * merchantPhone;
@property(nonatomic,strong) NSString                    * merchantName;
@property(nonatomic,strong) NSString                    * merchantPic;
@property(nonatomic,strong) NSString                    * tags;
@property(nonatomic,strong) NSString                    * totalSale;
@property(nonatomic,strong) NSArray                     * cardActs;

- (instancetype)initWithDictionary:(NSDictionary *)dic;


@end
