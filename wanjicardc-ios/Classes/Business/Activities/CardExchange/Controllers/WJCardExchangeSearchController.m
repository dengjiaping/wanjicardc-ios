//
//  WJCardExchangeSearchController.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCardExchangeSearchController.h"
#import "WJUtilityMethod.h"
#import "APICardExchangeListManager.h"
#import "WJEmptyView.h"
#import "WJRefreshTableView.h"
#import "WJCardExchangeListCell.h"

#import "WJCardExchangeModel.h"
#import "APICardExchangeCardFaceValueManager.h"
#import "WJFaceValueModel.h"
#import "WJInputCardViewController.h"
#import "WJChooseFaceValueView.h"

@interface WJCardExchangeSearchController ()<UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate,APIManagerCallBackDelegate,ChooseFaceValueDelegate>
{
    BOOL            isHeaderRefresh;
    BOOL            isFooterRefresh;
    BOOL            isShowMiddleLoadView;
    NSInteger       selectIndex;
}

@property(nonatomic,strong)UISearchBar                    * searchBar;
@property(nonatomic,strong)APICardExchangeListManager     * searchCardManager;
@property(nonatomic,strong)WJEmptyView                    * emptyView;
@property(nonatomic,strong)NSMutableArray                 * dataArray;
@property(nonatomic,strong)WJRefreshTableView             * mainTableView;

@property(nonatomic,strong) APICardExchangeCardFaceValueManager  * cardDetailValueManager;
@property(nonatomic,strong) WJChooseFaceValueView                * chooseValueView;

@property(nonatomic,strong) NSMutableArray                      * cardFacevalueArray;
@property(nonatomic,strong) NSString                            *activityURL;


@end

@implementation WJCardExchangeSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self navigationSetUp];
    self.navigationItem.titleView = self.searchBar;
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.chooseValueView];
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


#pragma mark - SearchBarDelegate
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    [self.searchBar becomeFirstResponder];
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    BOOL hasEmp = NO;
    
    if ([searchBar.text length] > 0) {
        for (int i =0; i<[searchBar.text length]; i++) {
            NSString *s = [searchBar.text substringWithRange:NSMakeRange(i, 1)];
            if ([s isEqualToString:@" "]) {
                hasEmp = YES;
                break;
            }
        }
        //如果有空格
        if (hasEmp) {
            NSString *searchStr = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([searchStr length] > 0) {
                [self.searchCardManager loadData];
            }else{
                ALERT(@"搜索内容不能为空");
            }
        }else{
            [self.searchCardManager loadData];
        }
    }else{
        ALERT(@"搜索内容不能为空");
    }
    [searchBar resignFirstResponder];
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

#pragma mark - Custion Function
- (void)navigationSetUp
{
    [self hiddenBackBarButtonItem];

    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:WJFont14];
    [cancelButton setFrame:CGRectMake(0, 0, ALD(40), ALD(30))];
    [cancelButton addTarget:self action:@selector(backToList) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.rightBarButtonItem = cancelItem;
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    if ([manager isKindOfClass:[APICardExchangeListManager class]]) {
        [self.dataArray removeAllObjects];
        NSDictionary *dataDic = [manager fetchDataWithReformer:nil];
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
                //                [self.cardFacevalueArray addObject:model];
                //                [self.cardFacevalueArray addObject:model];
                //                [self.cardFacevalueArray addObject:model];
                //                [self.cardFacevalueArray addObject:model];
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
    [self hiddenLoadingView];
    
}

#pragma mark - WJRefreshTableView Delegate

- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
{
    if ([self.searchBar.text isEqualToString:@""]) {
        return;
    }else{
        if (!isHeaderRefresh && !isFooterRefresh) {
            isHeaderRefresh = YES;
            self.searchCardManager.shouldCleanData = YES;
            isShowMiddleLoadView = NO;
            [self.searchCardManager loadData];
        }
    }
}

- (void)startFootRefreshToDo:(UITableView *)tableView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        isShowMiddleLoadView = NO;
        [self.searchCardManager loadData];
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

#pragma mark - Button Action
- (void)backToList
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

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

#pragma mark - Setter And Getter
- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        self.searchBar = [[UISearchBar alloc]init];
        _searchBar.delegate = self;
        _searchBar.barStyle = UIBarStyleDefault;
        _searchBar.backgroundImage = [[UIImage alloc]init];
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchBar.placeholder = @"请输入卡名称、拼音或首字母查询";
        _searchBar.keyboardType =  UIKeyboardTypeDefault;
        [_searchBar becomeFirstResponder];
    }
    return _searchBar;
}

-(APICardExchangeListManager *)searchCardManager
{
    if (!_searchCardManager) {
        _searchCardManager = [[APICardExchangeListManager alloc] init];
        _searchCardManager.delegate = self;
    }
    _searchCardManager.thirdCardName = self.searchBar.text;
    _searchCardManager.shouldParse = YES;
    _searchCardManager.shouldCleanData = YES;
    return _searchCardManager;
}

- (APICardExchangeCardFaceValueManager *)cardDetailValueManager
{
    if (!_cardDetailValueManager) {
        _cardDetailValueManager = [[APICardExchangeCardFaceValueManager alloc] init];
        _cardDetailValueManager.delegate = self;
    }
    return _cardDetailValueManager;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (WJEmptyView *)emptyView
{
    if (_emptyView == nil) {
        _emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(106), kScreenWidth, ALD(140))];
    }
    return _emptyView;
}

- (WJRefreshTableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[WJRefreshTableView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight - 10) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}


- (NSMutableArray  *)cardFacevalueArray
{
    if (!_cardFacevalueArray) {
        _cardFacevalueArray = [NSMutableArray array];
    }
    return _cardFacevalueArray;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
