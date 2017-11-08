//
//  WJHomePageTopModel.h
//  WanJiCard
//
//  Created by XT Xiong on 16/6/2.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIBaseManager.h"

@interface WJHomePageTopModel : NSObject

@property(nonatomic,strong) NSString     * merchantBusinesshours;
@property(nonatomic,strong) NSString     * merchantPhone;
@property(nonatomic,strong) NSString     * merchantLinkman;
@property(nonatomic,strong) NSString     * merchantName;
@property(nonatomic,strong) NSString     * merchantIntroduce;
@property(nonatomic,strong) NSString     * merchantLatitude;
@property(nonatomic,strong) NSString     * merchantLongitude;
@property(nonatomic,strong) NSString     * merchantAddress;
@property(nonatomic,strong) NSString     * merchantId;
@property(nonatomic,strong) NSString     * merchantStatus;

- (instancetype)initWithDictionary:(NSDictionary *)dic;


@end
