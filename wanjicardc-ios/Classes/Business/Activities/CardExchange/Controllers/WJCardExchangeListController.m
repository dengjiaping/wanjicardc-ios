//
//  WJCardExchangeListController.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCardExchangeListController.h"
#import "WJCEListTopView.h"
#import "DZNSegmentedControl.h"
#import "WJRefreshTableView.h"
#import "WJCardExchangeListCell.h"
#import "WJChooseFaceValueView.h"
#import "WJEmptyView.h"
#import "APICardExchangeListManager.h"
#import "APICardExchangeCardFaceValueManager.h"

#import "WJCardExchangeSearchController.h"
#import "WJWebViewController.h"
#import "WJCardExchangeModel.h"
#import "APICardExchangeCardFaceValueManager.h"
#import "WJFaceValueModel.h"
#import "WJInputCardViewController.h"
#import "UINavigationBar+Awesome.h"


@interface WJCardExchangeListController ()<UITableViewDataSource, UITableViewDelegate,APIManagerCallBackDelegate,ChooseFaceValueDelegate>
{
    BOOL            isHeaderRefresh;
    BOOL            isFooterRefresh;
    BOOL            isShowMiddleLoadView;
    NSInteger       selectIndex;
}

@property(nonatomic,strong) WJCEListTopView                      * topView;
@property(nonatomic,strong) DZNSegmentedControl                  * segmentControl;
@property(nonatomic,strong) WJRefreshTableView                   * mainTableView;
@property(nonatomic,strong) WJEmptyView                          * emptyView;

@property(nonatomic,assign) CardExchangeType                       currentType;
@property(nonatomic,assign) NSInteger                              currentSelect;
@property(nonatomic,strong) NSMutableArray                       * dataArray;

@property(nonatomic,strong) APICardExchangeListManager           * cardExchangeListManager;
@property(nonatomic,strong) APICardExchangeCardFaceValueManager  * cardDetailValueManager;
@property(nonatomic,strong) WJChooseFaceValueView                * chooseValueView;

@property(nonatomic,strong) NSMutableArray                      * cardFacevalueArray;
@property(nonatomic,strong) NSString                            *activityURL;



@end

@implementation WJCardExchangeListController

#pragma maek - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"可兑换的卡";
    self.view.backgroundColor = WJColorViewBg;
    selectIndex = -1;
    
    [self navigationSetUp];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView addSubview:self.emptyView];
    self.emptyView.hidden = YES;
    
    [self.view addSubview:self.chooseValueView];
    [self.cardExchangeListManager loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    if ([manager isKindOfClass:[APICardExchangeListManager class]]) {
        
        NSDictionary *dataDic = [manager fetchDataWithReformer:nil];
        [self.topView configDataWithDictionary:dataDic];
        self.activityURL = [dataDic objectForKey:@"activityURL"];
        [self.dataArray removeAllObjects];
        for (NSDictionary *dic in [dataDic objectForKey:@"list"]) {
            WJCardExchangeModel *model = [[WJCardExchangeModel alloc] initWithDic:dic];
            [self.dataArray addObject:model];
        }
        if (self.dataArray.count != 0) {
            self.emptyView.hidden = YES;
        }else{
            self.emptyView.hidden = NO;
        }
        [self.mainTableView reloadData];
    } else if ([manager isKindOfClass:[APICardExchangeCardFaceValueManager class]]) {

        NSDictionary * dic = [manager fetchDataWithReformer:nil];
        NSLog(@"dic = %@",dic);
        NSArray *listArr = dic[@"result"];
        if ([listArr isKindOfClass:[NSArray class]]) {
            [self.cardFacevalueArray removeAllObjects];
            for (NSDictionary *dict in listArr) {
                WJFaceValueModel * model = [[WJFaceValueModel alloc] initWithDic:dict];
                [self.cardFacevalueArray addObject:model];
            }
        }
        
        WJCardExchangeModel *model = [self.dataArray objectAtIndex:selectIndex];
        [self.chooseValueView refreshWithDictionary:model listFaceValue:self.cardFacevalueArray];
        self.chooseValueView.hidden = NO;
    }
    [self endGetData:YES];
    [self refreshFooterStatus:manager.hadGotAllData];
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    ALERT(manager.errorMessage);
    [self endGetData:NO];
    [self hiddenLoadingView];
    if (manager.errorType == APIManagerErrorTypeNoData) {
        self.dataArray = nil;
        [self.mainTableView reloadData];
    }
    if (self.dataArray.count != 0) {
        self.emptyView.hidden = YES;
    }else{
        self.emptyView.hidden = NO;
    }
}


- (void)selectModel:(WJFaceValueModel *)model
{
    NSLog(@"%@",model);
    self.chooseValueView.hidden = YES;

    WJCardExchangeModel *changeModel = [self.dataArray objectAtIndex:selectIndex];
    WJInputCardViewController * vc = [[WJInputCardViewController alloc] init];
    vc.faceCard = model;
    vc.cardModel = changeModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Button Action
- (void)sureButton:(UIButton *)button
{
    if([self.dataArray count] > button.tag - 20000)
    {
        WJCardExchangeModel *model = [self.dataArray objectAtIndex:button.tag - 20000];
        
        self.cardDetailValueManager.cardId = model.cardId;
        [self.cardDetailValueManager loadData];
        NSLog(@" model = %@",model);
        selectIndex = button.tag - 20000;
    } else
    {
            selectIndex = -1;
    }
}

- (void)selectedSegment:(DZNSegmentedControl *)control
{
    self.currentSelect = control.selectedSegmentIndex;
    [self.dataArray removeAllObjects];
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            self.currentType = CardExchangeTypeAll;
        }
            break;
        case 1:
        {
            self.currentType = CardExchangeTypeTelephoneCharge;
        }
            break;
        case 2:
        {
            self.currentType = CardExchangeTypeGame;
        }
            break;
            
        default:
            break;
    }
    [self.cardExchangeListManager loadData];
}

#pragma mark - WJRefreshTableView Delegate

- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.cardExchangeListManager.shouldCleanData = YES;
        isShowMiddleLoadView = NO;
        [self.cardExchangeListManager loadData];
    }
}

- (void)startFootRefreshToDo:(UITableView *)tableView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        isShowMiddleLoadView = NO;
        [self.cardExchangeListManager loadData];
    }
}

- (void)endGetData:(BOOL)needReloadData{
    
    if (isHeaderRefresh) {
        isHeaderRefresh = NO;
        [self.mainTableView endHeadRefresh];
    }
    
    if (isFooterRefresh){
        isFooterRefresh = NO;
        [self.mainTableView endFootFefresh];
    }
    
    if (needReloadData) {
        [self.mainTableView reloadData];
    }
}

- (void)refreshFooterStatus:(BOOL)status{
    
    if (status) {
        [self.mainTableView hiddenFooter];
    }else {
        [self.mainTableView showFooter];
    }
    
    if (self.dataArray.count > 0) {
        self.mainTableView.tableFooterView = [UIView new];
    }else{
        self.mainTableView.tableFooterView = nil;
    }
}

#pragma mark - UITableViewDelagate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJCardExchangeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardExchangeList"];
    if (cell == nil) {
        cell = [[WJCardExchangeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CardExchangeList"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.sureButton addTarget:self action:@selector(sureButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.sureButton.tag = indexPath.row + 20000;
    [cell configDataWithModel:self.dataArray[indexPath.row]];
    
    return cell;
}


#pragma mark - NavButton Action

- (void)helpButton:(UIButton *)button
{
    WJWebViewController *webVC = [[WJWebViewController alloc] init];
    webVC.titleStr = @"活动说明";
    [webVC loadWeb:self.activityURL];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)searchButton:(UIButton *)button
{
    WJCardExchangeSearchController *searchVC = [[WJCardExchangeSearchController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - Cusitom Function

- (void)navigationSetUp{
    UIButton *helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    helpBtn.frame = CGRectMake(0, 0, 25, 25);
    [helpBtn setImage:[UIImage imageNamed:@"nav_btn_help_nor"] forState:UIControlStateNormal];
    [helpBtn addTarget:self action:@selector(helpButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *helpBarBtn = [[UIBarButtonItem alloc] initWithCustomView:helpBtn];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 25, 25);
    [searchBtn setImage:[UIImage imageNamed:@"nav_btn_search_nor"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchBarBtn = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:helpBarBtn,searchBarBtn, nil];
}

#pragma mark - Setter And Getter

- (DZNSegmentedControl *)segmentControl
{
    if (_segmentControl == nil ) {
        _segmentControl = [[DZNSegmentedControl alloc] initWithItems:@[@"全部",@"话费",@"游戏"]];
        _segmentControl.frame = CGRectMake(0, 100, kScreenWidth, 44);
        _segmentControl.selectedSegmentIndex = 0;
        _segmentControl.hairlineColor = [UIColor clearColor];
        _segmentControl.tintColor = WJColorNavigationBar;
        _segmentControl.backgroundColor = WJColorWhite;
        _segmentControl.showsGroupingSeparators = NO;
        _segmentControl.showsCount = NO;
        _segmentControl.autoAdjustSelectionIndicatorWidth = NO;
        _segmentControl.font = WJFont15;
        [[DZNSegmentedControl appearance] setSelectionIndicatorHeight:1.5];
        
        [_segmentControl addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (WJCEListTopView *)topView
{
    if (_topView == nil) {
        _topView = [[WJCEListTopView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    }
    return _topView;
}

- (WJRefreshTableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[WJRefreshTableView alloc]initWithFrame:CGRectMake(0, 149, kScreenWidth, kScreenHeight - 215) style:UITableViewStylePlain refreshNow:YES refreshViewType:WJRefreshViewTypeBoth];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

- (APICardExchangeListManager *)cardExchangeListManager
{
    if (_cardExchangeListManager == nil) {
        _cardExchangeListManager = [[APICardExchangeListManager alloc]init];
        _cardExchangeListManager.delegate = self;
    }
    _cardExchangeListManager.thirdCardSortId = self.currentType;
    _cardExchangeListManager.shouldParse = YES;
    _cardExchangeListManager.shouldCleanData = YES;

    return _cardExchangeListManager;
}

- (APICardExchangeCardFaceValueManager *)cardDetailValueManager
{
    if (!_cardDetailValueManager) {
        _cardDetailValueManager = [[APICardExchangeCardFaceValueManager alloc] init];
        _cardDetailValueManager.delegate = self;
    }
    return _cardDetailValueManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (WJChooseFaceValueView *)chooseValueView
{
    if (!_chooseValueView) {
        _chooseValueView = [[WJChooseFaceValueView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        _chooseValueView.hidden = YES;
        _chooseValueView.delegate = self;
        
    }
    return _chooseValueView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray  *)cardFacevalueArray
{
    if (!_cardFacevalueArray) {
        _cardFacevalueArray = [NSMutableArray array];
    }
    return _cardFacevalueArray;
}

- (WJEmptyView *)emptyView
{
    if (_emptyView == nil) {
        _emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(106), kScreenWidth, ALD(140))];
    }
    return _emptyView;
}

@end
