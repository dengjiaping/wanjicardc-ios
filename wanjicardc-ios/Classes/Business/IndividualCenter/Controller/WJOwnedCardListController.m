//
//  WJOwnedCardListController.m
//  WanJiCard
//
//  Created by Angie on 15/9/30.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJOwnedCardListController.h"
#import "WJOrderConfirmController.h"
#import "WJRealNameAuthenticationViewController.h"

#import "WJOwnedCardCell.h"

#import "WJDBCardManager.h"
#import "AppDelegate.h"
#import "WJPayCompleteModel.h"
#import "APICardPackageManager.h"
#import "WJEmptyView.h"
#import "WJStatisticsManager.h"
#import "WJRefreshTableView.h"
#import "WJVerificationReceiptMoneyController.h"
@interface WJOwnedCardListController ()<UITableViewDataSource, UITableViewDelegate>
{
   __block NSInteger chargeIndex;
    WJRefreshTableView      *mTb;
    UIView           *noDataView;
    BOOL             isHeaderRefresh;
    BOOL             isFooterRefresh;
    BOOL             isShowMiddleLoadView;
}
@property (nonatomic, strong)APICardPackageManager *cardPackageManager;
@property (nonatomic, strong)NSMutableArray        *cardList;


@end

@implementation WJOwnedCardListController


- (void)dealloc
{
    [kDefaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"卡包充值";
    self.eventID = @"iOS_act_CardRecharge";
    isShowMiddleLoadView = YES;

    [kDefaultCenter addObserver:self selector:@selector(updateText:) name:kChargeSuccess object:nil];
    
    mTb = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
    mTb.delegate = self;
    mTb.dataSource = self;
    mTb.separatorInset = UIEdgeInsetsZero;
    mTb.tableFooterView = [UIView new];
    mTb.backgroundColor = [UIColor clearColor];
    mTb.separatorColor = WJColorSeparatorLine;
    [self.view addSubview:mTb];
    
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WJEmptyView *emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(86), kScreenWidth, ALD(140))];
    emptyView.tipLabel.text = @"没有卡可以充值";
    emptyView.imageView.image = [UIImage imageNamed:@"mycards_recharge_nodata"];
    [noDataView addSubview:emptyView];
    
    [self requestLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - Request

- (void)requestLoad{
    
    mTb.tableFooterView = [UIView new];
    
    if (isShowMiddleLoadView) {
        [self showLoadingView];
        
    }
    [self.cardPackageManager loadData];
}

- (void)updateText:(NSNotification *)notification
{

    WJPayCompleteModel *info = [notification object];
    WJModelCard *card = self.cardList[chargeIndex];
    card.balance = [info.amount floatValue] + card.balance;

    [self.cardList replaceObjectAtIndex:chargeIndex withObject:card];
    
    [mTb reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:chargeIndex inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark - WJRefreshTableView Delegate

- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        isShowMiddleLoadView = NO;
        self.cardPackageManager.shouldCleanData = YES;
        [self.cardPackageManager loadData];

    }
    
}

- (void)startFootRefreshToDo:(UITableView *)tableView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        isShowMiddleLoadView = NO;
        self.cardPackageManager.shouldCleanData = NO;
        [self.cardPackageManager loadData];
    }
    
}

- (void)endGetData:(BOOL)needReloadData{
    
    if (isHeaderRefresh) {
        isHeaderRefresh = NO;
        [mTb endHeadRefresh];
    }
    
    if (isFooterRefresh){
        isFooterRefresh = NO;
        [mTb endFootFefresh];
    }
    
    if (needReloadData) {
        [mTb reloadData];
    }
}

- (void)refreshFooterStatus:(BOOL)status{
    
    if (status) {
        [mTb hiddenFooter];
    }else {
        [mTb showFooter];
    }
    
    if (self.cardList.count > 0) {
        mTb.tableFooterView = [UIView new];
        
    }else{
        mTb.tableFooterView = noDataView;

    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(95);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WJOwnedCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WJOwnedCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));

    }
    
    __weak typeof(self)weakSelf = self;
    __weak WJModelCard *card = self.cardList[indexPath.row];
   
    cell.chargeRightNow = ^{
        
        WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
        
        if (defaultPerson.authentication == AuthenticationNo) {
            
            chargeIndex = indexPath.row;

            NSString *record = [[NSUserDefaults standardUserDefaults] valueForKey:@"RealNameReciveMoneyRecord"];
            
            if (!record) {
                
                WJRealNameAuthenticationViewController *realNameAuthenticationVC = [[WJRealNameAuthenticationViewController alloc] init];
                realNameAuthenticationVC.comefrom = ComeFromOwnedCardList;
                realNameAuthenticationVC.isjumpOrderConfirmController = YES;
                [WJGlobalVariable sharedInstance].realAuthenfromController = weakSelf;
                [weakSelf.navigationController pushViewController:realNameAuthenticationVC animated:YES];
                
                
                [realNameAuthenticationVC setRealNameAuthenticationSuc:^(void){
                    
                    __strong typeof(self) strongSelf = weakSelf;
                    [strongSelf fromChargeToOrderConfirmController:card];
                }];
                
            } else {
                
                //收款金额验证
                WJVerificationReceiptMoneyController *verificationReceiptMoneyController = [[WJVerificationReceiptMoneyController alloc] init];
                [WJGlobalVariable sharedInstance].realAuthenfromController = self;
                verificationReceiptMoneyController.comefrom = ComeFromOwnedCardList;
                verificationReceiptMoneyController.isjumpOrderConfirmController = YES;
                verificationReceiptMoneyController.BankCard = record;
                [weakSelf.navigationController pushViewController:verificationReceiptMoneyController animated:YES];
                
                __weak typeof(self) weakSelf = self;
                [verificationReceiptMoneyController setAuthenticationSuc:^(void){
                    
                    __strong typeof(self) strongSelf = weakSelf;
                    [strongSelf fromChargeToOrderConfirmController:card];
                    
                }];
                
            }
    
        } else {

            chargeIndex = indexPath.row;
    
            [weakSelf fromChargeToOrderConfirmController:card];
        }

    };

    [cell configWithModel:self.cardList[indexPath.row]];
    
    return cell;
}


- (void)fromChargeToOrderConfirmController:(WJModelCard *)card
{
    [WJGlobalVariable sharedInstance].payfromController = self;
    
    WJOrderConfirmController *vc = [[WJOrderConfirmController alloc] initWithCardId:nil
                                                                           cardName:card.name
                                                                              merID:card.merId
                                                                            merName:card.merName
                                                                            buyType:BuyTypeCharge];
    

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showNoDataView
{
    if (self.cardList.count > 0) {
        
        mTb.tableFooterView = [UIView new];

    } else {
        mTb.tableFooterView = noDataView;
        mTb.showsVerticalScrollIndicator = NO;

    }
}

#pragma nark - Request

- (APICardPackageManager *)cardPackageManager
{
    if (nil == _cardPackageManager) {
        _cardPackageManager = [[APICardPackageManager alloc] init];
        _cardPackageManager.delegate = self;
        _cardPackageManager.shouldParse = YES;
        _cardPackageManager.firstPageNo = 0;
    }
    return _cardPackageManager;
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[self.cardPackageManager class]]) {
        
        [self hiddenLoadingView];
        
        NSDictionary * dic = [manager fetchDataWithReformer:nil];
        [self.cardList removeAllObjects];

        for (NSDictionary *dict in dic) {
            WJModelCard *card = [[WJModelCard alloc] initWithDic:dict];
            [self.cardList addObject:card];
        }
        

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            WJDBCardManager *cardM = [[WJDBCardManager alloc] initWithOwnedUserId:[WJGlobalVariable sharedInstance].defaultPerson.userID];
            
            [cardM removeCards];
            
            if (self.cardList.count > 0) {
                [cardM insertCards:self.cardList];
            }
        });
        
        [self refreshFooterStatus:self.cardPackageManager.hadGotAllData];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self showNoDataView];
            [self endGetData:YES];

        });
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APICardPackageManager class]] ){
        
        [self hiddenLoadingView];
        if (manager.errorType == APIManagerErrorTypeNoData) {
            [self refreshFooterStatus:YES];

            if (isHeaderRefresh) {
                if (self.cardList.count > 0) {
                    [self.cardList removeAllObjects];
                    
                }
                [self endGetData:YES];
                return;
            }
            [self endGetData:NO];

        }else{
            ALERT(@"请求失败");
            [self refreshFooterStatus:self.cardPackageManager.hadGotAllData];
            [self endGetData:NO];
        }

    }
}

#pragma mark - 属性方法

- (NSMutableArray *)cardList{
    if (!_cardList) {
        _cardList = [NSMutableArray array];
    }
    return _cardList;
}


@end
