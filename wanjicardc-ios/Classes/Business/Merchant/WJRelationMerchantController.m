//
//  WJRelationMerchantController.m
//  WanJiCard
//
//  Created by Angie on 15/10/14.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJRelationMerchantController.h"
#import "WJMerchantDetailController.h"
#import "APIBranchsManager.h"
#import "WJRefreshTableView.h"
#import "WJCardDetailFitStoreCell.h"
#import "WJStoreModel.h"
#import "LocationManager.h"
#import "WJModelArea.h"

@interface WJRelationMerchantController ()<APIManagerCallBackDelegate, WJRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL isHeaderRefresh;
    BOOL isFooterRefresh;
    BOOL isShowMiddleLoadView;

}

@property (nonatomic, strong) WJRefreshTableView *mTb;
@property (nonatomic, strong) APIBranchsManager *branchsManager;
@property (nonatomic, strong) NSMutableArray *brachListArray;
@end

@implementation WJRelationMerchantController

- (void)viewDidLoad {
    [super viewDidLoad];

    isShowMiddleLoadView = YES;
    self.brachListArray = [NSMutableArray array];
    
    [self.view addSubview:self.mTb];
    [self.view addConstraints:[self.mTb constraintsFill]];

}


#pragma mark - Request

- (void)requestLoad{
    
//    [self showLoadingView];
    if (isShowMiddleLoadView) {
        [self showLoadingView];
        
    }
    [self.branchsManager loadData];
}


#pragma mark - APIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIBranchsManager class]]) {
        NSArray *branches = [manager fetchDataWithReformer:nil];
        
        if ([branches isKindOfClass:[NSArray class]]) {
            [self.brachListArray removeAllObjects];
            for (NSDictionary *dict in branches) {
                WJStoreModel *model = [[WJStoreModel alloc] initWithDic:dict];
                [self.brachListArray addObject:model];
            }
            
            [self refreshFooterStatus:self.branchsManager.hadGotAllData];
        }
        [self endGetData:YES];
    }
}


-(void)managerCallAPIDidFailed:(APIBaseManager *)manager{
    [self hiddenLoadingView];
    if (manager.errorType == APIManagerErrorTypeNoData) {
        [self refreshFooterStatus:YES];
    }else
        [self refreshFooterStatus:self.branchsManager.hadGotAllData];
    [self endGetData:NO];
}

#pragma mark - WJRefreshTableViewDelegate
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
    
    if (self.brachListArray.count > 0) {
        self.mTb.tableFooterView = [UIView new];
    }else{
        self.mTb.tableFooterView = nil;
    }
    
}


- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.branchsManager.shouldCleanData = YES;
        isShowMiddleLoadView = NO;
        [self requestLoad];
    }
}


- (void)startFootRefreshToDo:(UITableView *)tableView{
    if (!isFooterRefresh && !isFooterRefresh) {
        isFooterRefresh = YES;
        self.branchsManager.shouldCleanData = NO;
        isShowMiddleLoadView = NO;
        [self requestLoad];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.brachListArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(95);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WJCardDetailFitStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WJCardDetailFitStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.store = self.brachListArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WJMerchantDetailController *vc = [WJMerchantDetailController new];
    vc.merId = [self.brachListArray[indexPath.row] storeId];
    vc.intoCount = 1;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 属性方法

- (UITableView *)mTb{
    if (!_mTb) {
        _mTb = [[WJRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain refreshNow:YES refreshViewType:WJRefreshViewTypeBoth];
        _mTb.translatesAutoresizingMaskIntoConstraints = NO;
        _mTb.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTb.delegate = self;
        _mTb.dataSource = self;
        _mTb.separatorInset = UIEdgeInsetsZero;
        _mTb.backgroundColor = WJColorViewBg;
    }
    return _mTb;
}


- (APIBranchsManager *)branchsManager{
    if (!_branchsManager) {
        _branchsManager = [APIBranchsManager new];
        _branchsManager.delegate = self;
        _branchsManager.shouldParse = YES;
        _branchsManager.merID = self.merId;
        _branchsManager.merchantLatitude = [NSString stringWithFormat:@"%lf",[WJGlobalVariable sharedInstance].appLocation.latitude?:0];
        _branchsManager.merchantLongitude = [NSString stringWithFormat:@"%lf",[WJGlobalVariable sharedInstance].appLocation.longitude?:0];
    }
     _branchsManager.areaId  = [LocationManager sharedInstance].choosedArea.areaId;
    
    return _branchsManager;
}


@end
