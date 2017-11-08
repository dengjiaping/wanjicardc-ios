//
//  WJMyBankCardViewController.m
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMyBankCardViewController.h"
#import "WJAddBankCardViewController.h"
#import "WJMyBankCardCell.h"
#import "WJBankCardModel.h"
#import "WJSystemAlertView.h"
#import "APIMyBankCardManager.h"
#import "WJRefreshTableView.h"
#import "APIDeleteBankCardManager.h"
#import "APISetDefaultReceiveCardManager.h"
@interface WJMyBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,WJRefreshTableViewDelegate,WJSystemAlertViewDelegate>
{
    BOOL          isHeaderRefresh;
    BOOL          isFooterRefresh;
    BOOL          isShowMiddleLoadView;
    UIButton      *addCardButton;
}
@property(nonatomic,strong)APIMyBankCardManager            *myBankCardManager;
@property(nonatomic,strong)APIDeleteBankCardManager        *deleteBankCardManager;
@property(nonatomic,strong)APISetDefaultReceiveCardManager *setReceiveBankCardManager;
@property(nonatomic,strong)NSMutableArray                  *bankListArray;
@property(nonatomic,strong)WJBankCardModel                 *bankCardModel;
@property(nonatomic,strong)WJBankCardModel                 *deletebankCardModel;
@property(nonatomic,assign)NSInteger                       index;
@property(nonatomic,assign)NSInteger                       deleteIndex;

@property(nonatomic,strong)WJRefreshTableView              *mTb;

@end

@implementation WJMyBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的银行卡";
    
    isShowMiddleLoadView = YES;

    [self.view addSubview:self.mTb];
    
//    [self.mTb startHeadRefresh];
//    [self requestLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.bankListArray.count != 0 && self.bankListArray != nil) {
        
        NSDictionary *personDic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:KCashUser];
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:personDic];
        
        [dic setValue:[NSString stringWithFormat:@"%lu",(unsigned long)self.bankListArray.count] forKey:@"bankAmount"];
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:KCashUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    self.mTb.tableFooterView = bottomView;
    
    addCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addCardButton.frame = CGRectMake(ALD(15), ALD(40), kScreenWidth - ALD(30), ALD(50));
    [addCardButton setTitle:@"添加银行卡" forState:UIControlStateNormal];
    [addCardButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
    [addCardButton setImage:[UIImage imageNamed:@"bankCardAdd"] forState:UIControlStateNormal];
    
    [addCardButton setImageEdgeInsets:UIEdgeInsetsMake(0, ALD(40), 0, ALD(60))];
    
    addCardButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    
    CAShapeLayer *buttonShapeLayer = [CAShapeLayer layer];
    buttonShapeLayer.strokeColor = WJColorDardGray9.CGColor;
    buttonShapeLayer.fillColor = nil;
    buttonShapeLayer.path = [UIBezierPath bezierPathWithRect:addCardButton.bounds].CGPath;
    buttonShapeLayer.frame = addCardButton.bounds;
    buttonShapeLayer.lineWidth = 1.f;
    buttonShapeLayer.lineCap = @"square";
    buttonShapeLayer.lineDashPattern = @[@4, @2];
    
    [addCardButton.layer addSublayer:buttonShapeLayer];

    [addCardButton addTarget:self action:@selector(addCardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addCardButton];
}

#pragma mark - Request

- (void)requestLoad
{
    if (isShowMiddleLoadView) {
        [self showLoadingView];
        
    }
    [self.myBankCardManager loadData];
}

- (void)cardDeleteRequest
{
    [self showLoadingView];
    [self.deleteBankCardManager loadData];
}

- (void)setDefaultBankCardRequest
{
    [self showLoadingView];
    [self.setReceiveBankCardManager loadData];
}

#pragma mark - model

//- (void)endGetData:(BOOL)needReloadData{
//    
//    if (isHeaderRefresh) {
//        isHeaderRefresh = NO;
//        [self.mTb endHeadRefresh];
//    }
//    
//    if (isFooterRefresh){
//        isFooterRefresh = NO;
//        [self.mTb endFootFefresh];
//    }
//    
//    if (needReloadData) {
//        [self.mTb reloadData];
//    }
//}
//
//- (void)refreshFooterStatus:(BOOL)status{
//    
//    if (status) {
//        [self.mTb hiddenFooter];
//    }else {
//        [self.mTb showFooter];
//    }
//    
//    if (self.bankListArray.count > 0) {
//        self.mTb.tableFooterView = [UIView new];
//    }else{
////        self.mTb.tableFooterView = noDataView;
//        self.mTb.showsVerticalScrollIndicator = NO;
//        
//    }
//    
//}
//
//
//- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView{
//    if (!isHeaderRefresh && !isFooterRefresh) {
//        isHeaderRefresh = YES;
//        self.myBankCardManager.shouldCleanData = YES;
//        isShowMiddleLoadView = NO;
//        [self requestLoad];
//    }
//}
//
//
//- (void)startFootRefreshToDo:(UITableView *)tableView{
//    if (!isFooterRefresh && !isHeaderRefresh) {
//        isFooterRefresh = YES;
//        self.myBankCardManager.shouldCleanData = NO;
//        isShowMiddleLoadView = NO;
//        [self requestLoad];
//    }
//}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIMyBankCardManager class]]) {
        NSArray *cardArray = [manager fetchDataWithReformer:nil];
        if ([cardArray isKindOfClass:[NSArray class]]) {
            [self.bankListArray removeAllObjects];
            for (NSDictionary *dict in cardArray) {
                WJBankCardModel *model = [[WJBankCardModel alloc] initWithDictionary:dict];
                
                [self.bankListArray addObject:model];
            }
            
            [self initBottomView];

            [self.mTb reloadData];

//            [self refreshFooterStatus:self.myBankCardManager.hadGotAllData];

        }
//        [self endGetData:YES];
    } else if ([manager isKindOfClass:[APIDeleteBankCardManager class]]) {
        
        if (self.bankListArray.count != 0) {
            
            [self.bankListArray removeObjectAtIndex:_deleteIndex];
        }
        
        [self.mTb reloadData];
        
    } else if ([manager isKindOfClass:[APISetDefaultReceiveCardManager class]]) {
        
        WJBankCardModel *bankCardModel = self.bankListArray[_index];

        for (WJBankCardModel *CardModel in self.bankListArray) {
            CardModel.isReceiveCard  = NO;
            if (CardModel != bankCardModel) {
                CardModel.isReceiveCard = NO;
            } else {
                CardModel.isReceiveCard = YES;
            }
        }
        [self.mTb reloadData];
        
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];

    
//    [self hiddenLoadingView];
//    
//    if ([manager isKindOfClass:[APIMyBankCardManager class]]) {
//        if (manager.errorType == APIManagerErrorTypeNoData) {
//            [self refreshFooterStatus:YES];
//            
//            if (isHeaderRefresh) {
//                if (self.bankListArray.count > 0) {
//                    [self.bankListArray removeAllObjects];
//                    
//                }
//                [self endGetData:YES];
//                return;
//            }
//            [self endGetData:NO];
//            
//        }else{
//            
//            [self refreshFooterStatus:self.myBankCardManager.hadGotAllData];
//            [self endGetData:NO];
//        }
//    }
    
}


#pragma mark - Action

- (void)addCardButtonAction:(id)sender
{
    WJAddBankCardViewController *addBankCardVC = [[WJAddBankCardViewController alloc] init];
    [self.navigationController pushViewController:addBankCardVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (0 == self.bankListArray.count || nil == self.bankListArray) {
        return 0;
    } else {
        return self.bankListArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(150);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJMyBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myBankCardCell"];
    
    if (cell == nil) {
        cell = [[WJMyBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myBankCardCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
        
    }
    cell.bankCardSetting = ^{
        
        WJBankCardModel *model = self.bankListArray[indexPath.row];
        
        _bankCardModel = model;

        _index = indexPath.row;
        
        [self setDefaultBankCardRequest];
        
    };
    
    cell.deleteCardBinding = ^{
        
        WJBankCardModel *model = self.bankListArray[indexPath.row];
        
        _deletebankCardModel = model;
        
        _deleteIndex = indexPath.row;
        
        WJSystemAlertView *sysAlert = [[WJSystemAlertView alloc] initWithTitle:@"是否删除该绑定银行卡" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消" textAlignment:NSTextAlignmentCenter];
        [sysAlert showIn];
        
    };
    
    [cell configDataWithModel:self.bankListArray[indexPath.row]];
    
    return cell;
}

#pragma mark - WJSystemAlertViewDelegate

- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        NSLog(@"确定");
        [self cardDeleteRequest];
        
    } else {
        
        NSLog(@"取消");
        
    }
}

#pragma mark - 属性方法
- (UITableView *)mTb{
    if (_mTb == nil) {
        _mTb = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 115) style:UITableViewStylePlain];
//        _mTb = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        
        _mTb.delegate = self;
        _mTb.dataSource = self;
        _mTb.separatorInset = UIEdgeInsetsZero;
        _mTb.backgroundColor = WJColorViewBg2;
        _mTb.separatorColor = WJColorSeparatorLine;
        _mTb.tableFooterView = [UIView new];
        
    }
    return _mTb;
}

- (NSMutableArray *)bankListArray{
    if (!_bankListArray) {
        _bankListArray = [NSMutableArray array];
    }
    return _bankListArray;
}

- (APIMyBankCardManager *)myBankCardManager
{
    if (!_myBankCardManager) {
        
        _myBankCardManager = [[APIMyBankCardManager alloc] init];
        _myBankCardManager.delegate = self;
//        _myBankCardManager.shouldParse = YES;

    }
    return _myBankCardManager;
}

- (APIDeleteBankCardManager *)deleteBankCardManager
{
    if (!_deleteBankCardManager) {
        _deleteBankCardManager = [[APIDeleteBankCardManager alloc] init];
        _deleteBankCardManager.delegate = self;
    }
    _deleteBankCardManager.bankCardId = _deletebankCardModel.bankId;
    return _deleteBankCardManager;
}

- (APISetDefaultReceiveCardManager *)setReceiveBankCardManager
{
    if (!_setReceiveBankCardManager) {
        _setReceiveBankCardManager  = [[APISetDefaultReceiveCardManager alloc] init];
        _setReceiveBankCardManager.delegate = self;
    }
    _setReceiveBankCardManager.bankCardId = _bankCardModel.bankId;
    return _setReceiveBankCardManager;
}

@end
