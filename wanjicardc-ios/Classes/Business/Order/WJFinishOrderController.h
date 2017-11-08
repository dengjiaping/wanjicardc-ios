//
//  WJFinishOrderController.h
//  WanJiCard
//
//  Created by reborn on 16/8/27.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJViewController.h"
#import "WJMyOrderControllerDelegate.h"
#import "WJRefreshTableView.h"
@interface WJFinishOrderController : WJViewController
@property (nonatomic, assign) id<WJMyOrderControllerDelegate> delegate;
@property (nonatomic, strong) WJRefreshTableView *mTb;
@end
