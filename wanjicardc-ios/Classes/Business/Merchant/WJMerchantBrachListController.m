//
//  WJMerchantBrachListController.m
//  WanJiCard
//
//  Created by Angie on 15/9/29.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJMerchantBrachListController.h"
#import "WJCardDetailFitStoreCell.h"

@interface WJMerchantBrachListController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation WJMerchantBrachListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *mTB = [[UITableView alloc] initForAutoLayout];
    mTB.delegate = self;
    mTB.dataSource = self;
    mTB.separatorInset = UIEdgeInsetsZero;
    mTB.tableFooterView = [UIView new];
    [self.view addSubview:mTB];
    
    [self.view addConstraints:[mTB constraintsFill]];
    
}


#pragma mark -UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(95);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.storeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WJCardDetailFitStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WJCardDetailFitStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.store = self.storeList[indexPath.row];
    
    return cell;
}

@end
