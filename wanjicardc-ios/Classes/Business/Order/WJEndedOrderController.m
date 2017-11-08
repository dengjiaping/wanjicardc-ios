//
//  WJEndedOrderController.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/15.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJEndedOrderController.h"
#import "WJOrderDetailController.h"

#import "WJRefreshTableView.h"
#import "APIOrdersManager.h"
#import "WJOrderCell.h"
#import "WJEmptyView.h"

@interface WJEndedOrderController ()<WJRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>{
    BOOL isHeaderRefresh;
    BOOL isFooterRefresh;
    UIView *noDataView;
    BOOL isShowMiddleLoadView;
}

@property (nonatomic, strong) APIOrdersManager *ordersManager;
@property (nonatomic, strong) NSMutableArray   *orderArray;

@end

@implementation WJEndedOrderController

- (void)dealloc
{
    [kDefaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isShowMiddleLoadView = YES;

    //删除订单后刷新
    [kDefaultCenter addObserver:self selector:@selector(reloadOrder) name:kDeleteOrderSuccess object:nil];

    [self.view addSubview:self.mTb];
    [self.view VFLToConstraints:@"H:|[_mTb]|" views:NSDictionaryOfVariableBindings(_mTb)];
    [self.view VFLToConstraints:@"V:|[_mTb]|" views:NSDictionaryOfVariableBindings(_mTb)];

 
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WJEmptyView *emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(86), kScreenWidth, ALD(140))];
    emptyView.tipLabel.text = @"暂无数据";
    emptyView.imageView.image = [UIImage imageNamed:@"common_nodata_image"];
    [noDataView addSubview:emptyView];
    
//    [self.mTb startHeadRefresh];
}


- (void)reloadOrder
{
    isHeaderRefresh = YES;
    self.ordersManager.shouldCleanData = YES;
    if (self.orderArray.count > 0) {
        [self.orderArray removeAllObjects];
    }
    
    [self requestLoad];
}


#pragma mark - Request

- (void)requestLoad{
    
    self.mTb.tableFooterView = [UIView new];
    if (isShowMiddleLoadView) {
        [self showLoadingView];
        
    }
    [self.ordersManager loadData];
}

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    if ([manager isKindOfClass:[APIOrdersManager class]]) {
        NSArray *dic = [manager fetchDataWithReformer:nil];
        if ([dic isKindOfClass:[NSArray class]]) {
            [self.orderArray removeAllObjects];
            for (NSDictionary *dict in dic) {
                WJOrderModel *model = [[WJOrderModel alloc] initWithDic:dict];
                [self.orderArray addObject:model];
            }
            
            [self refreshFooterStatus:self.ordersManager.hadGotAllData];
        }
        [self endGetData:YES];
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    if (manager.errorType == APIManagerErrorTypeNoData) {
        [self refreshFooterStatus:YES];
        
        if (isHeaderRefresh) {
            if (self.orderArray.count > 0) {
                [self.orderArray removeAllObjects];
                
            }
            [self endGetData:YES];
            return;
        }
        [self endGetData:NO];
        
    }else {
        
        [self refreshFooterStatus:self.ordersManager.hadGotAllData];
        [self endGetData:NO];
    }

}


#pragma mark - model

- (void)endGetData:(BOOL)needReloadData{
    
    if (isHeaderRefresh) {
        isHeaderRefresh = NO;
        [self.mTb endHeadRefresh];
    }
    
    if (isFooterRefresh){
        isFooterRefresh = NO;
        [self.mTb endFootFefresh];
    }
    
    if (needReloadData) {
        [self.mTb reloadData];
    }
}

- (void)refreshFooterStatus:(BOOL)status{
    
    if (status) {
        [self.mTb hiddenFooter];
    }else {
        [self.mTb showFooter];
    }
    
    if (self.orderArray.count > 0) {
        self.mTb.tableFooterView = [UIView new];
    }else{
        self.mTb.tableFooterView = noDataView;
        self.mTb.showsVerticalScrollIndicator = NO;

    }
    
}


- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.ordersManager.shouldCleanData = YES;
        isShowMiddleLoadView = NO;
        [self requestLoad];
    }
}


- (void)startFootRefreshToDo:(UITableView *)tableView{
    if (!isFooterRefresh && !isFooterRefresh) {
        isFooterRefresh = YES;
        self.ordersManager.shouldCleanData = NO;
        isShowMiddleLoadView = NO;
        [self requestLoad];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(140);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];

    WJOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[WJOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorViewBg;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));

    }

    cell.isOrder = YES;
    [cell configCellWithOrder:self.orderArray[indexPath.row] isDetail:NO];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WJOrderDetailController *vc = [[WJOrderDetailController alloc] init];
    vc.orderSummary = self.orderArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 属性方法

- (UITableView *)mTb{
    if (!_mTb) {
        _mTb = [[WJRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        _mTb.translatesAutoresizingMaskIntoConstraints = NO;
        _mTb.delegate = self;
        _mTb.dataSource = self;
        _mTb.separatorInset = UIEdgeInsetsZero;
        _mTb.backgroundColor = WJColorViewBg;
        _mTb.separatorColor = WJColorSeparatorLine;

    }
    return _mTb;
}

- (APIOrdersManager *)ordersManager{
    if (!_ordersManager) {
        _ordersManager = [[APIOrdersManager alloc] init];
        _ordersManager.delegate = self;
        _ordersManager.orderStatus = OrderStatusClose;
        _ordersManager.orderType = OrderTypeAll;
        _ordersManager.shouldParse = YES;
    }
    return _ordersManager;
}


- (NSMutableArray *)orderArray{
    if (!_orderArray) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}


@end
