//
//  WJCardShopViewController.m
//  WanJiCard
//
//  Created by reborn on 16/11/3.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCardShopViewController.h"
#import "WJFairECardListTableViewCell.h"
#import "WJEleCardDeteilViewController.h"
#import "APIFairDetailManager.h"
#import "WJFairDetailModel.h"
#import "WJFairDetailReformer.h"
#import "WJBaoziCountTableViewCell.h"
#import "WJFairHotActivityTableViewCell.h"
#import "WJLoginViewController.h"
#import "WJMyBaoziViewController.h"
#import "WJWebViewController.h"
#import "WJElectronicCardListViewController.h"
#import "WJBaoziOrderConfirmController.h"
#import "WJECardModel.h"
//#import "WanJiCard-Swift.h"
#import "WJSystemAlertView.h"
#import "WJEmptyView.h"
#import "WJModelPerson.h"
#import "WJRefreshTableView.h"
#import "WJECardModel.h"
#import "UINavigationBar+Awesome.h"

@interface WJCardShopViewController ()<APIManagerCallBackDelegate,UITableViewDelegate,UITableViewDataSource,WJSystemAlertViewDelegate,WJRefreshTableViewDelegate>
{
    BOOL            isHeaderRefresh;
    BOOL            isFooterRefresh;
    BOOL            isShowMiddleLoadView;
}
@property (nonatomic, strong) WJRefreshTableView        *tableView;
@property (nonatomic, strong) APIFairDetailManager      *detailManager;
@property (nonatomic, strong) WJFairDetailModel         *fairDetailModel;
@property (nonatomic, strong) WJEmptyView               *emptyView;
@property (nonatomic, strong) NSMutableArray            *eCardArray;
@end

@implementation WJCardShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self UISetup];
    [self reloadView];
    
    [kDefaultCenter addObserver:self selector:@selector(logOutForCardShop) name:@"LogOutForCardShop" object:nil];
    [kDefaultCenter addObserver:self selector:@selector(reloadView) name:@"ReloadCardShop" object:nil];
}

- (void)logOutForCardShop{
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarView.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)dealloc
{
    [kDefaultCenter removeObserver:self];
}

- (void)reloadView
{
    isShowMiddleLoadView = YES;
    
    self.detailManager.shouldCleanData = YES;
    [self requestData];
}

#pragma mark - UI
- (void)UISetup{
    self.title = @"卡商城";
    self.view.backgroundColor = WJColorViewBg;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.emptyView];
    self.emptyView.hidden = YES;
}

#pragma mark - RequestData
- (void)requestData
{
    if (isShowMiddleLoadView) {
        [self showLoadingView];
    }
    [self.detailManager loadData];
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WJRefreshTableView Delegate

- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.detailManager.shouldCleanData = YES;
        isShowMiddleLoadView = NO;
        [self requestData];
    }
    
}

- (void)startFootRefreshToDo:(UITableView *)tableView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        self.detailManager.shouldCleanData = NO;
        isShowMiddleLoadView = NO;
        [self requestData];
    }
}

- (void)endGetData:(BOOL)needReloadData{
    
    if (isHeaderRefresh) {
        isHeaderRefresh = NO;
        [self.tableView endHeadRefresh];
    }
    
    if (isFooterRefresh){
        isFooterRefresh = NO;
        [self.tableView endFootFefresh];
    }
    
    if (needReloadData) {
        [self.tableView reloadData];
    }
}

- (void)refreshFooterStatus:(BOOL)status{
    
    if (status) {
        [self.tableView hiddenFooter];
    }else {
        [self.tableView showFooter];
    }
    
    if (self.eCardArray.count > 0) {
        self.tableView.tableFooterView = [UIView new];
    }else{
        
        self.tableView.tableFooterView = nil;
    }
    
}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"成功");
    
    if ([manager isKindOfClass:[APIFairDetailManager class]]) {
        [self hiddenLoadingView];
        
        self.fairDetailModel = [manager fetchDataWithReformer:[[WJFairDetailReformer alloc] init]];
        
        if ([self.fairDetailModel.cardsArray isKindOfClass:[NSArray class]]) {
            
            if (self.detailManager.shouldCleanData) {
                
                [self.eCardArray removeAllObjects];
                for (WJECardModel *model in self.fairDetailModel.cardsArray) {
                    [self.eCardArray addObject:model];
                }
                
            } else {
                for (WJECardModel *model in self.fairDetailModel.cardsArray) {
                    [self.eCardArray addObject:model];
                }
            }
            if (self.eCardArray.count < self.fairDetailModel.total ) {
                manager.hadGotAllData = NO;
                
            }else{
                manager.hadGotAllData = YES;
                
            }
            [self refreshFooterStatus:manager.hadGotAllData];
        }
        [self endGetData:YES];
        
        [WJGlobalVariable sharedInstance].defaultPerson.baoziNumber = self.fairDetailModel.balance;
        
        if (self.eCardArray.count == 0) {
            self.emptyView.hidden = NO;
        }else{
            self.emptyView.hidden = YES;
        }
        
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if (manager.errorType == APIManagerErrorTypeNoData) {
        [self refreshFooterStatus:YES];
        
        if (isHeaderRefresh) {
            if (self.eCardArray.count > 0) {
                [self.eCardArray removeAllObjects];
                
            }
            [self endGetData:YES];
            return;
        }
        [self endGetData:NO];
        
    }else{
        
        [self refreshFooterStatus:self.detailManager.hadGotAllData];
        [self endGetData:NO];
        
    }
    
    if (self.eCardArray.count == 0) {
        self.emptyView.hidden = NO;
    }else{
        self.emptyView.hidden = YES;
    }
    NSLog(@"失败");
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.eCardArray.count == 0) {
        return 0;
        
    } else {
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight;
    
    if (self.eCardArray.count == 0) {
        
        cellHeight = 0;
        
    } else {
        
        if (self.eCardArray.count > 2) {
            cellHeight = ALD(185) + ALD((self.eCardArray.count/2 + self.eCardArray.count%2 - 1) * 170);
        }else{
            cellHeight = ALD(185);
        }
    }

    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJFairECardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WJFairECardListTableViewCell"];
    if (!cell) {
        cell = [[WJFairECardListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJFairECardListTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    __weak typeof(self)weakSelf = self;
    cell.selectECardBlock = ^(WJECardModel *model){
        [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_Ecardclick"];
        WJEleCardDeteilViewController * eCardVC = [[WJEleCardDeteilViewController alloc] init];
        eCardVC.eCardModel = model;
        eCardVC.isEntityCard = YES;
        eCardVC.electronicCardComeFrom = ComeFromCardShop;
        [weakSelf.navigationController pushViewController:eCardVC animated:YES ];
        weakSelf.tabBarView.hidden = YES;
    };
    cell.isCardShop = YES;
    [cell configData:self.eCardArray];
    return cell;
    
}

#pragma mark- Getter and Setter
- (UITableView *)tableView
{
    if (nil == _tableView) {
        
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SCREEN_HEIGHT -64 -kTabbarHeight)
                                                         style:UITableViewStylePlain
                                                    refreshNow:NO
                                               refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (APIFairDetailManager *)detailManager
{
    if (!_detailManager) {
        _detailManager = [[APIFairDetailManager alloc] init];
        _detailManager.shouldParse = NO;
        _detailManager.delegate = self;
        
    }
    return _detailManager;
}
- (WJEmptyView *)emptyView
{
    if (nil == _emptyView) {
        _emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(210), kScreenWidth, ALD(140))];
    }
    return _emptyView;
}

- (NSMutableArray *)eCardArray{
    if (!_eCardArray) {
        _eCardArray = [NSMutableArray array];
    }
    return _eCardArray;
}


@end
