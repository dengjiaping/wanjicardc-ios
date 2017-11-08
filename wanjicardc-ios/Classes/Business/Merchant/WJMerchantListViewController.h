//
//  WJMerchantListViewController.h
//  WanJiCard
//
//  Created by Lynn on 15/9/10.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJViewController.h"
#import "APISearchManager.h"

typedef enum
{
    EnterFromNone = 0,
    EnterFromTab = 1,
    EnterFromSearch = 2,
    EnterFromCategory = 3,
    EnterFromHome
} EnterFrom;

@interface WJMerchantListViewController : WJViewController

@property (nonatomic, strong)UIImageView *tabBarView;
@property (nonatomic, strong)APISearchManager *searchManager;
@property (nonatomic, assign)EnterFrom from;
@property (nonatomic, strong)NSString *categoryTitle;
@end
