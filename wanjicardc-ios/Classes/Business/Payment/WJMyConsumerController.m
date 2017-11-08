//
//  WJMyConsumerController.m
//  WanJiCard
//
//  Created by reborn on 16/5/18.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJMyConsumerController.h"
#import "WJRefreshTableView.h"
#import "WJPurchaseHistoryCell.h"
#import "WJPurchaseHistoryModel.h"
#import "APIConsumeRecordsManager.h"
#import "WJEmptyView.h"
#import "WJStatisticsManager.h"
@interface WJMyConsumerController ()<UITableViewDelegate, UITableViewDataSource, WJRefreshTableViewDelegate, APIManagerCallBackDelegate>
{
    WJRefreshTableView *mTableView;
    UIView             *noDataView;
    
    BOOL               isHeaderRefresh;
    BOOL               isFooterRefresh;
    
    BOOL               isShowMiddleLoadView;

}
@property (nonatomic, strong)APIConsumeRecordsManager *consumeRecordsManager;
@property (nonatomic, strong)NSMutableArray           *dataArray;
@end

@implementation WJMyConsumerController
-  (void)viewDidLoad {
    [super viewDidLoad];
    
    isShowMiddleLoadView = YES;
    
    self.title = @"我的消费";
    self.eventID = @"iOS_act_Consumption";
    
    mTableView = [[WJRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain refreshNow:YES refreshViewType:WJRefreshViewTypeBoth];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.translatesAutoresizingMaskIntoConstraints = NO;
    mTableView.backgroundColor = WJColorViewBg;
    mTableView.separatorColor = WJColorSeparatorLine;
    mTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:mTableView];
    [self.view VFLToConstraints:@"H:|[mTableView]|" views:NSDictionaryOfVariableBindings(mTableView)];
    [self.view VFLToConstraints:@"V:|[mTableView]|" views:NSDictionaryOfVariableBindings(mTableView)];
    
    [self initNoDataView];

    [mTableView startHeadRefresh];
}

- (void)initNoDataView
{
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WJEmptyView *emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(86), kScreenWidth, ALD(140))];
    emptyView.tipLabel.text = @"暂无数据";
    emptyView.imageView.image = [UIImage imageNamed:@"common_nodata_image"];
    [noDataView addSubview:emptyView];
}

#pragma mark - Refresh Event

- (void)endGetData:(BOOL)needReloadData{
    
    if (isHeaderRefresh) {
        isHeaderRefresh = NO;
        [mTableView endHeadRefresh];
    }
    
    if (isFooterRefresh){
        isFooterRefresh = NO;
        [mTableView endFootFefresh];
    }
    
    if (needReloadData) {
        [mTableView reloadData];
    }
}

- (void)refreshFooterStatus:(BOOL)status{
    
    if (status) {
        [mTableView hiddenFooter];
    }else {
        [mTableView showFooter];
    }
    
    if (self.dataArray.count > 0) {
        mTableView.tableFooterView = [UIView new];
    }else{
        mTableView.tableFooterView = noDataView;
        mTableView.showsVerticalScrollIndicator = NO;

    }
    
}

#pragma mark - APIManagerCallBackDelegate

- (void)requestLoad
{
//    [self showLoadingView];
    if (isShowMiddleLoadView) {
        [self showLoadingView];
    } 
    [self.consumeRecordsManager loadData];
}

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    NSArray *array = [manager fetchDataWithReformer:nil];
    
    if ([array isKindOfClass:[NSArray class]]) {
        [self.dataArray removeAllObjects];
        for (NSDictionary *dic in array) {
            
            WJPurchaseHistoryModel *model = [[WJPurchaseHistoryModel alloc] initWithDic:dic];
            [self.dataArray addObject:model];
        }
        [self refreshFooterStatus:self.consumeRecordsManager.hadGotAllData];
        
    }
    [self endGetData:YES];

}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];

    if (manager.errorType == APIManagerErrorTypeNoData) {
        [self refreshFooterStatus:YES];
    }else{
        [self refreshFooterStatus:self.consumeRecordsManager.hadGotAllData];
    }
    [self endGetData:NO];

}

#pragma mark - WJRefreshTableViewDelegate

- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView{
    if (!isHeaderRefresh) {
        isHeaderRefresh = YES;
        self.consumeRecordsManager.shouldCleanData = YES;
        isShowMiddleLoadView = NO;
        [self requestLoad];
    }
}

- (void)startFootRefreshToDo:(UITableView *)tableView{
    if (!isFooterRefresh) {
        isFooterRefresh = YES;
        self.consumeRecordsManager.shouldCleanData = NO;
        isShowMiddleLoadView = NO;
        [self requestLoad];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.dataArray == nil && self.dataArray.count == 0) {
        return 0;
    }
    return self.dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(97);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WJPurchaseHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WJPurchaseHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));

    }
    [cell configWithHistory:self.dataArray[indexPath.section]];
    return cell;
}

#pragma mark - 属性访问

- (APIConsumeRecordsManager *)consumeRecordsManager
{
    if (!_consumeRecordsManager) {
        _consumeRecordsManager = [APIConsumeRecordsManager new];
        _consumeRecordsManager.delegate = self;
        _consumeRecordsManager.shouldParse = YES;
        if (self.fromType == FromCardDetail) {
            _consumeRecordsManager.merchantId = self.merchantId;
        }
    }
    return _consumeRecordsManager;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
