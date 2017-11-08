//
//  WJCardListOfMerchantViewController.m
//  WanJiCard
//
//  Created by Angie on 15/10/15.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJCardListOfMerchantViewController.h"
#import "WJRefreshTableView.h"
#import "WJCardListTableViewCell.h"
#import "APIProductsListManager.h"
#import "WJModelCard.h"
#import "WJHomeCardDetailsViewController.h"
#import "WJCardModel.h"
#import "WJMerchantCard.h"

@interface WJCardListOfMerchantViewController ()<APIManagerCallBackDelegate, WJRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL isHeaderRefresh;
    BOOL isFooterRefresh;
}

@property (nonatomic, strong) WJRefreshTableView *mTb;
@property (nonatomic, strong) APIProductsListManager *productsListManager;
@property (nonatomic, strong) NSMutableArray *cardListArray;
@end

@implementation WJCardListOfMerchantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家橱窗";
    
    self.cardListArray = [NSMutableArray array];
    
    //临时修改，商户卡片不多，不用再次请求，由上一个页面带过来数据
    [self.cardListArray addObjectsFromArray:self.cardList];

    
    [self.view addSubview:self.mTb];
    [self.view addConstraints:[self.mTb constraintsFill]];
    
}


#pragma mark - Request

- (void)requestLoad{
    
    [self showLoadingView];
    
    [self.productsListManager loadData];
    
}


#pragma mark - APIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIProductsListManager class]]) {
        NSArray *dic = [manager fetchDataWithReformer:nil];
        NSLog(@"%@", dic);
        if ([dic isKindOfClass:[NSArray class]]) {
            [self.cardListArray removeAllObjects];
            for (NSDictionary *dict in dic) {
                WJModelCard *model = [[WJModelCard alloc] initWithDic:dict];
                [self.cardListArray addObject:model];
            }
            
            [self refreshFooterStatus:self.productsListManager.hadGotAllData];
        }
        [self endGetData:YES];
    }
}


-(void)managerCallAPIDidFailed:(APIBaseManager *)manager{
    [self hiddenLoadingView];
    if (manager.errorType == APIManagerErrorTypeNoData) {
        [self refreshFooterStatus:YES];
    }else{
        [self refreshFooterStatus:self.productsListManager.hadGotAllData];
    }
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
    
    if (self.cardListArray.count > 0) {
        self.mTb.tableFooterView = [UIView new];
    }else{
        self.mTb.tableFooterView = nil;
    }
    
}


- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.productsListManager.shouldCleanData = YES;
        [self requestLoad];
    }
}


- (void)startFootRefreshToDo:(UITableView *)tableView{
    if (!isFooterRefresh && !isFooterRefresh) {
        isFooterRefresh = YES;
        self.productsListManager.shouldCleanData = NO;
        [self requestLoad];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cardListArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(95);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJCardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"store"];
    
    if (cell == nil) {
        cell = [[WJCardListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"card"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell configWithProduct:self.cardListArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJMerchantCard *model = self.cardList[indexPath.row];
    WJHomeCardDetailsViewController *vc = [WJHomeCardDetailsViewController new];
    vc.merchantID = self.merId;
    vc.cardID       = model.cardId;
    vc.cardIndex    = 0;
    vc.titleStr     = model.merName;
    [self.navigationController pushViewController:vc animated:YES];
    
//    WJProductDetailController *vc = [[WJProductDetailController alloc] init];
//    vc.card = self.cardList[indexPath.row];
//    vc.card.merId = self.merId;
//    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 属性方法

- (UITableView *)mTb{
    if (!_mTb) {
        _mTb = [[WJRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeNone];
        _mTb.translatesAutoresizingMaskIntoConstraints = NO;
        _mTb.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTb.delegate = self;
        _mTb.dataSource = self;
        _mTb.separatorInset = UIEdgeInsetsZero;
        _mTb.backgroundColor = WJColorViewBg;
    }
    return _mTb;
}


@end
