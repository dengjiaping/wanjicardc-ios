//
//  WJAvailableCouponViewController.h
//  WanJiCard
//
//  Created by 孙琦 on 16/5/27.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJViewController.h"

typedef void (^SelectCouponTypeBlock)(id object);

@interface WJAvailableCouponViewController : WJViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *mTb;
@property (nonatomic,strong)SelectCouponTypeBlock selectCouponTypeBlock;
@end

