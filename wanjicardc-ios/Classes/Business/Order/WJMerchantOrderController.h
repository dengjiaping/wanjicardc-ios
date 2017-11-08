//
//  WJMerchantOrderController.h
//  WanJiCard
//
//  Created by reborn on 16/8/12.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJViewController.h"
#import "WJMyOrderControllerDelegate.h"
#import "WJRefreshTableView.h"
@interface WJMerchantOrderController : WJViewController

@property (nonatomic, assign) id<WJMyOrderControllerDelegate> delegate;
@property (nonatomic, strong) WJRefreshTableView *mTb;
@end
