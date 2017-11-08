//
//  WJFinishBillViewController.m
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJFinishBillViewController.h"
#import "WJRefreshTableView.h"
#import "WJEmptyView.h"
#import "APIBillsManager.h"
#import "WJBillModel.h"
#import "WJBillListCell.h"
@interface WJFinishBillViewController ()<WJRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL          isHeaderRefresh;
    BOOL          isFooterRefresh;
    BOOL          isShowMiddleLoadView;
    UIView        *noDataView;
    WJBillModel   *billModel;
}
@property (nonatomic, strong) NSMutableArray    *billArray;
@property (nonatomic, strong) APIBillsManager   *billsManager;

@end

@implementation WJFinishBillViewController

- (void)dealloc
{
    [kDefaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isShowMiddleLoadView = YES;
    
    //删除订单后，刷新
    //    [kDefaultCenter addObserver:self selector:@selector(reloadOrder) name:kDeleteOrderSuccess object:nil];
    //    //订单支付成功
    //    [kDefaultCenter addObserver:self selector:@selector(reloadOrder) name:kPayOrderSuccess object:nil];
    
    [self.view addSubview:self.mTb];
    [self.view VFLToConstraints:@"H:|[_mTb]|" views:NSDictionaryOfVariableBindings(_mTb)];
    [self.view VFLToConstraints:@"V:|[_mTb]|" views:NSDictionaryOfVariableBindings(_mTb)];
    
    self.mTb.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1f)];
    
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
    self.billsManager.shouldCleanData = YES;
    if (self.billArray.count > 0) {
        [self.billArray removeAllObjects];
    }
    
    [self requestLoad];
}


#pragma mark - Request

- (void)requestLoad{
    
    self.mTb.tableFooterView = [UIView new];
    
    if (isShowMiddleLoadView) {
        [self showLoadingView];
        
    }
    [self.billsManager loadData];
}


- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIBillsManager class]]) {
        NSArray *orderArr = [manager fetchDataWithReformer:nil];
        if ([orderArr isKindOfClass:[NSArray class]]) {
            [self.billArray removeAllObjects];
            for (NSDictionary *dict in orderArr) {
                WJBillModel *model = [[WJBillModel alloc] initWithDic:dict];
                [self.billArray addObject:model];
            }
            
            [self refreshFooterStatus:self.billsManager.hadGotAllData];
        }
        [self endGetData:YES];
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIBillsManager class]]) {
        if (manager.errorType == APIManagerErrorTypeNoData) {
            [self refreshFooterStatus:YES];
            
            if (isHeaderRefresh) {
                if (self.billArray.count > 0) {
                    [self.billArray removeAllObjects];
                    
                }
                [self endGetData:YES];
                return;
            }
            [self endGetData:NO];
            
        }else{
            
            [self refreshFooterStatus:self.billsManager.hadGotAllData];
            [self endGetData:NO];
        }
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
    
    if (self.billArray.count > 0) {
        self.mTb.tableFooterView = [UIView new];
    }else{
        self.mTb.tableFooterView = noDataView;
        self.mTb.showsVerticalScrollIndicator = NO;
        
    }
    
}


- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.billsManager.shouldCleanData = YES;
        isShowMiddleLoadView = NO;
        [self requestLoad];
    }
}


- (void)startFootRefreshToDo:(UITableView *)tableView{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        self.billsManager.shouldCleanData = NO;
        isShowMiddleLoadView = NO;
        [self requestLoad];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (0 == self.billArray.count || nil == self.billArray) {
        return 0;
    } else {
        return self.billArray.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(136);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section) {
        return 0.01f;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    
    WJBillListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[WJBillListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = WJColorViewBg;
        
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
        
    }
    
    [cell configDataWithModel:self.billArray[indexPath.row]];
    return cell;
}

#pragma mark - 属性方法

- (UITableView *)mTb{
    if (!_mTb) {
        _mTb = [[WJRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        _mTb.translatesAutoresizingMaskIntoConstraints = NO;
        _mTb.sectionFooterHeight = 0.01f;
        _mTb.delegate = self;
        _mTb.dataSource = self;
        
        _mTb.separatorInset = UIEdgeInsetsZero;
        _mTb.backgroundColor = WJColorViewBg;
        _mTb.separatorColor = WJColorSeparatorLine;
        _mTb.tableFooterView = [UIView new];
        
    }
    return _mTb;
}

- (APIBillsManager *)billsManager{
    if (!_billsManager) {
        _billsManager = [[APIBillsManager alloc] init];
        _billsManager.delegate = self;
        _billsManager.billStatus = BillStatusSuccess;
        _billsManager.shouldParse = YES;
    }
    return _billsManager;
}


- (NSMutableArray *)billArray{
    if (!_billArray) {
        _billArray = [NSMutableArray array];
    }
    return _billArray;
}

@end
