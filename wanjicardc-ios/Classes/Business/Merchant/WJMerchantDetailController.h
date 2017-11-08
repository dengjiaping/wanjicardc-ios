//
//  WJMerchantDetailController.h
//  WanJiCard
//
//  Created by Angie on 15/9/12.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJViewController.h"

@class WJRecommendStoreModel;

@interface WJMerchantDetailController : WJViewController

@property (nonatomic, strong) NSString  *merId;
@property (nonatomic, strong) NSString  *merLatitude;
@property (nonatomic, strong) NSString  *merLongitude;
@property (nonatomic, assign) BOOL      isMaxCode;  //扫二维码进入？
@property (nonatomic, assign) NSInteger intoCount;

@end
