//
//  WJElectronicCardListViewController.m
//  WanJiCard
//
//  Created by silinman on 16/8/16.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJElectronicCardListViewController.h"
#import "WJEleCardDeteilViewController.h"
#import "WJECardCollectionViewCell.h"
#import "APIECardsListManager.h"
#import "WJECardListReformer.h"
#import "WJECardModel.h"
#import "WJEmptyView.h"
#import "WJRefreshCollectionView.h"

@interface WJElectronicCardListViewController ()<APIManagerCallBackDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    BOOL            isHeaderRefresh;
    BOOL            isFooterRefresh;
    BOOL            isShowMiddleLoadView;
}

@property (nonatomic, strong) WJRefreshCollectionView   *collectionView;
@property (nonatomic, strong) APIECardsListManager      *cardsListManager;
@property (nonatomic, strong) NSArray                   *dataArray;
@property (nonatomic, strong) WJEmptyView               *emptyView;

@end

@implementation WJElectronicCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UISetup];
    [self requestData];
}

- (void)UISetup{
    self.title = @"电子卡";
    [self.view addSubview:self.collectionView];
}
#pragma mark - RequestData
- (void)requestData{
    if (isShowMiddleLoadView) {
        [self showLoadingView];
    }
    self.cardsListManager.shouldCleanData = YES;
    self.cardsListManager.firstPageNo = 1;
    [self.cardsListManager loadData];
}

- (void)reloadMoreData{
    
    if (isShowMiddleLoadView) {
        [self showLoadingView];
    }
    self.cardsListManager.shouldCleanData = NO;
    [self.cardsListManager loadData];
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WJRefreshTableView Delegate

- (void)startHeadRefreshToDo:(WJRefreshCollectionView *)collectionView
{
    
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.cardsListManager.shouldCleanData = YES;
        isShowMiddleLoadView = NO;
        [self requestData];
    }
    
}

- (void)startFootRefreshToDo:(WJRefreshCollectionView *)collectionView
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
        [self.collectionView endHeadRefresh];
    }
    
    if (isFooterRefresh){
        isFooterRefresh = NO;
        [self.collectionView endFootFefresh];
    }
    
    if (needReloadData) {
        [self.collectionView reloadData];
    }
}

- (void)refreshFooterStatus:(BOOL)status{
    
    if (status) {
        [self.collectionView hiddenFooter];
    }else {
        [self.collectionView showFooter];
    }
    
    if (self.dataArray.count > 0) {
        
    }else{
        
    }
    
}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"成功 === %@",manager);
    if([manager isKindOfClass:[APIECardsListManager class]])
    {
        self.dataArray = [[NSArray alloc]initWithArray: [manager fetchDataWithReformer:[[WJECardListReformer alloc] init]]];
        
    }
    
    if (self.dataArray.count != 0) {
        self.emptyView.hidden = YES;
    }else{
        self.emptyView.hidden = NO;
    }
    [self endGetData:YES];
    [self refreshFooterStatus:manager.hadGotAllData];
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"失败");
    [self endGetData:NO];
    [self hiddenLoadingView];
    if (manager.errorType == APIManagerErrorTypeNoData) {
        self.dataArray = nil;
        [self.collectionView reloadData];
    }
    if (self.dataArray.count != 0) {
        self.emptyView.hidden = YES;
    }else{
        self.emptyView.hidden = NO;
    }
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WJECardCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"WJECardCollectionViewListCell" forIndexPath:indexPath];
    WJECardModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell configData:model];
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(ALD(12), ALD(11), ALD(25), ALD(11));
}

#pragma mark ---- UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_Ecardclick"];
    WJECardModel *model = [self.dataArray objectAtIndex:indexPath.row];
    WJEleCardDeteilViewController * eCardVC = [[WJEleCardDeteilViewController alloc] init];
    eCardVC.eCardModel = model;
    [self.navigationController pushViewController:eCardVC animated:YES ];
}



#pragma mark - 懒加载collectionView
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(ALD(170), ALD(160));
        _collectionView = [[WJRefreshCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = WJColorWhite;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        [_collectionView registerClass:[WJECardCollectionViewCell class] forCellWithReuseIdentifier:@"WJECardCollectionViewListCell"];
    }
    return _collectionView;
}


- (APIECardsListManager *)cardsListManager{
    if (nil == _cardsListManager) {
        _cardsListManager = [[APIECardsListManager alloc] init];
        _cardsListManager.shouldParse = YES;
        _cardsListManager.delegate = self;
    }
    _cardsListManager.merchantBranchId = self.merchantBranchId;
    return _cardsListManager;
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
