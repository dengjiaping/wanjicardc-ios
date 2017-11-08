//
//  WJMyBaoziViewController.m
//  WanJiCard
//
//  Created by silinman on 16/8/16.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMyBaoziViewController.h"
#import "WJMyBunsRecordsTableViewCell.h"
#import "APIBunsTransRecordManager.h"
#import "WJBunsTrandsRecordReformer.h"
#import "WJBunsTransRecordModel.h"
#import "WJMyBunsRecordModel.h"
#import "WJEmptyView.h"
#import "WJRefreshTableView.h"
#import "WJMyBunsTopView.h"
#import "AppDelegate.h"
#import "WJBaoziOrderConfirmController.h"
#import "WJSystemAlertView.h"
#import "WJOrderModel.h"
#import "WJOrderDetailController.h"
#import "UINavigationBar+Awesome.h"

@interface WJMyBaoziViewController ()<APIManagerCallBackDelegate,UITableViewDelegate,UITableViewDataSource,WJSystemAlertViewDelegate>{
    BOOL            isHeaderRefresh;
    BOOL            isFooterRefresh;
    BOOL            isShowMiddleLoadView;
    NSInteger       pageCount;
}
@property (nonatomic, strong)WJRefreshTableView             *tableView;
@property (nonatomic, strong)APIBunsTransRecordManager      *newsListManager;
@property (nonatomic, strong)NSMutableArray                 *newsListArray;
@property (nonatomic, strong)WJEmptyView                    *emptyView;
@property (nonatomic, strong)WJMyBunsTopView                *topView;
@property (nonatomic, strong)WJMyBunsRecordModel            *recordModel;
@property (nonatomic, assign)BOOL                            isSuccessRequestData;

@end

@implementation WJMyBaoziViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.newsListArray = [NSMutableArray arrayWithCapacity:1];
    self.isSuccessRequestData = NO;
    [self UISetup];
    [self requsetData];
}

- (void)UISetup{
    
    self.navigationItem.hidesBackButton = NO;
    [self.navigationController.navigationBar lt_setBackgroundColor:[WJColorNavigationBar colorWithAlphaComponent:0]];
    self.navigationController.navigationBar.translucent = YES;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, ALD(19), ALD(19));
    [rightButton setImage:[UIImage imageNamed:@"mybaozi_ic_help"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"mybaozi_ic_help_press"] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(helpAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    //mybaozi_image_bg
    [self.view addSubview:self.topView];
    __weak typeof(self)weakSelf = self;
    self.topView.useBunsPay = ^{
        if (weakSelf.isSuccessRequestData) {
            [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_spendBun"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if (appDelegate.myTab.selectedIndex != 3) {
                [appDelegate.myTab changeTabIndex:3];
            }
        }

    };
    self.topView.bunsRecharge = ^{
        if (weakSelf.isSuccessRequestData) {
            [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_MyBunRecharge"];
            if (weakSelf.recordModel.recharge) {
                [WJGlobalVariable sharedInstance].payfromController = weakSelf;
                WJBaoziOrderConfirmController *baoziVC = [[WJBaoziOrderConfirmController alloc] initWithNibName:nil bundle:nil];
                [weakSelf.navigationController pushViewController:baoziVC animated:YES];
            }else{
                WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil message:@"土豪！您充太多钱了，明天再来好不好！" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
                [alert showIn];
            }
        }
    };
    [self.tableView addSubview:self.emptyView];
    [self.view addSubview:self.tableView];
    self.emptyView.hidden = YES;
}

- (void)refershBunsTopView{
//    self.topView.bunsCountsL.text = [WJGlobalVariable changeMoneyString:self.recordModel.walletCount?:@"0"];
    self.topView.bunsCountsL.text = [WJGlobalVariable sharedInstance].defaultPerson.baoziNumber ? [WJUtilityMethod baoziNumberFormatter:[WJGlobalVariable sharedInstance].defaultPerson.baoziNumber] : @"0";
    
    CGFloat bunsCountsLwidth = [UILabel getWidthWithTitle:self.topView.bunsCountsL.text font:self.topView.bunsCountsL.font];
    self.topView.bunsCountsL.frame = CGRectMake(self.topView.bunsTitleL.right + ALD(5), ALD(89), bunsCountsLwidth, ALD(31));
    self.topView.bunsStrL.frame = CGRectMake(self.topView.bunsCountsL.right + ALD(5),self.topView.bunsCountsL.y +  ALD(11), ALD(30), ALD(15));
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.eventID = @"iOS_vie_MyBunDetail";
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar lt_setBackgroundColor:[WJColorNavigationBar colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];


}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar lt_reset];
}

//包子说明
- (void)helpAction{
    
//    WJBaoziDescriptionController *baoziVC = [[WJBaoziDescriptionController alloc] init];
//    [self.navigationController pushViewController:baoziVC animated:YES];
}

- (void)requsetData{
    
    if (isShowMiddleLoadView) {
        [self showLoadingView];
        
    }
    [self.newsListArray removeAllObjects];
    pageCount = 1;
    self.newsListManager.currentPage = pageCount;
    self.newsListManager.shouldCleanData = YES;
    [self.newsListManager loadData];
}
- (void)reloadMoreData{
    
    if (isShowMiddleLoadView) {
        [self showLoadingView];
        
    }
    pageCount ++;
    self.newsListManager.currentPage = pageCount;
    self.newsListManager.shouldCleanData = NO;
    [self.newsListManager loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WJRefreshTableView Delegate

- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
{
    
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.newsListManager.shouldCleanData = YES;
        isShowMiddleLoadView = NO;
        [self requsetData];
    }
    
}

- (void)startFootRefreshToDo:(UITableView *)tableView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        isShowMiddleLoadView = NO;
        [self reloadMoreData];
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
    
    if (self.recordModel.recordsArray.count > 0) {
        self.tableView.tableFooterView = [UIView new];
    }else{
        self.tableView.tableFooterView = nil;
    }
    
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"成功");
    [self hiddenLoadingView];
    self.recordModel = [manager fetchDataWithReformer:[[WJBunsTrandsRecordReformer alloc] init]];
    [self refershBunsTopView];
    if (self.recordModel.recordsArray.count == 0 && pageCount == 1) {
        self.emptyView.hidden = NO;
    }else{
        for (WJBunsTransRecordModel *model in self.recordModel.recordsArray) {
            [self.newsListArray addObject:model];
        }
        self.emptyView.hidden = YES;
    }
    
    if ([self.recordModel.total integerValue] <= [self.newsListArray count]) {
        manager.hadGotAllData = YES;
    }else{
        manager.hadGotAllData = NO;
    }
    
    
    [self endGetData:YES];
    [self refreshFooterStatus:manager.hadGotAllData];
    self.isSuccessRequestData = YES;
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"失败");
    [self endGetData:NO];
    [self hiddenLoadingView];
    if (manager.errorType == APIManagerErrorTypeNoData) {
        if (_recordModel == nil) {
            self.recordModel = [[WJMyBunsRecordModel alloc] initWithDictionary:nil];
        }
        self.recordModel.recordsArray = nil;
        self.recordModel.recharge = YES;
        [self refershBunsTopView];
        [self.tableView reloadData];
    }
    if (self.recordModel.recordsArray.count != 0) {
        self.emptyView.hidden = YES;
    }else{
        self.emptyView.hidden = NO;
    }
    self.isSuccessRequestData = YES;
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJMyBunsRecordsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WJMyBunsRecordsTableViewCell"];
    if (nil == cell) {
        cell = [[WJMyBunsRecordsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJMyBunsRecordsTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.newsListArray.count != 0) {
        WJBunsTransRecordModel *model = [self.newsListArray objectAtIndex:indexPath.row];
        [cell configWithModel:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_Records"];
    WJBunsTransRecordModel *model = [self.newsListArray objectAtIndex:indexPath.row];
    WJOrderModel *orderModel = [[WJOrderModel alloc] init];
    orderModel.orderNo = model.order_no;
    orderModel.orderType = (OrderType)[model.type integerValue];
    WJOrderDetailController *orderVC = [[WJOrderDetailController alloc] init];
    orderVC.orderSummary = orderModel;
    [self.navigationController pushViewController:orderVC animated:YES];
}


- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, ALD(244), kScreenWidth, kScreenHeight - ALD(244))
                                                         style:UITableViewStylePlain
                                                    refreshNow:NO
                                               refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (APIBunsTransRecordManager *)newsListManager{
    if (nil == _newsListManager) {
        _newsListManager = [[APIBunsTransRecordManager alloc] init];
        _newsListManager.shouldParse = NO;
        _newsListManager.delegate = self;
    }
    return _newsListManager;
}

- (WJEmptyView *)emptyView
{
    if (nil == _emptyView) {
        _emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(120), kScreenWidth, ALD(140))];
    }
    return _emptyView;
}

- (WJMyBunsTopView *)topView
{
    if (nil == _topView) {
        _topView = [[WJMyBunsTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(244))];
    }
    return _topView;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
