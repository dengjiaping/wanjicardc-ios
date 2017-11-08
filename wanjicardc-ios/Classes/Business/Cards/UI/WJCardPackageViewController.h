//
//  WJCardPackageViewController.h
//  WanJiCard
//
//  Created by 孙明月 on 16/5/17.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJViewController.h"

@interface WJCardPackageViewController : WJViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *tabBarView;
@property (nonatomic,strong)UITableView *mTb;

- (void)monitorPayCodeView;
@end
