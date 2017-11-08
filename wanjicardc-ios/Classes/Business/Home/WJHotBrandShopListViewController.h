//
//  WJHotBrandShopListViewController.h
//  WanJiCard
//
//  Created by silinman on 16/5/27.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJViewController.h"
#import "APISearchManager.h"

@interface WJHotBrandShopListViewController : WJViewController

@property (nonatomic, strong) UIImageView           *tabBarView;
@property (nonatomic, strong) NSString              *categoryTitle;
@property (nonatomic, strong) APISearchManager      *searchManager;

@end
