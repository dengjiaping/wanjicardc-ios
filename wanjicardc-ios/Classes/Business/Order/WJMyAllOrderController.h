//
//  WJMyAllOrderController.h
//  WanJiCard
//
//  Created by Harry Hu on 15/9/15.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJViewController.h"
#import "WJMyOrderControllerDelegate.h"
#import "WJRefreshTableView.h"
@interface WJMyAllOrderController : WJViewController

@property (nonatomic, assign) id<WJMyOrderControllerDelegate> delegate;
@property (nonatomic, strong) WJRefreshTableView *mTb;

@end
