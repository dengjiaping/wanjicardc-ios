//
//  WJSystemMessageViewController.m
//  WanJiCard
//
//  Created by silinman on 16/6/17.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJSystemMessageViewController.h"
#import "WJSystemMessageTableViewCell.h"
#import "APINewsListManager.h"
#import "WJNewsListReformer.h"
#import "WJSystemNewsModel.h"
#import "WJEmptyView.h"
#import "WJRefreshTableView.h"

@interface WJSystemMessageViewController ()<APIManagerCallBackDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSString        *contentStr;
    BOOL            isHeaderRefresh;
    BOOL            isFooterRefresh;
    
    BOOL            isShowMiddleLoadView;

}

@property (nonatomic, strong)WJRefreshTableView             *tableView;
@property (nonatomic, strong)APINewsListManager             *newsListManager;
@property (nonatomic, strong)NSArray                        *newsListArray;
@property (nonatomic, strong)WJEmptyView                    *emptyView;

@end

@implementation WJSystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isShowMiddleLoadView = YES;
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"系统消息";
    [self UISetUp];
    [self requsetData];
}
- (void)UISetUp{
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.emptyView];
    self.emptyView.hidden = YES;
}
- (void)requsetData{
    
    if (isShowMiddleLoadView) {
        [self showLoadingView];
        
    }
    self.newsListManager.shouldCleanData = YES;
    self.newsListManager.type = @"1";
    [self.newsListManager loadData];
//    [self showLoadingView];
}
- (void)reloadMoreData{
    
    if (isShowMiddleLoadView) {
        [self showLoadingView];
        
    }
    self.newsListManager.shouldCleanData = NO;
    self.newsListManager.type = @"1";
    [self.newsListManager loadData];
//    [self showLoadingView];
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
    
    if (self.newsListArray.count > 0) {
        self.tableView.tableFooterView = [UIView new];
    }else{
        self.tableView.tableFooterView = nil;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"成功");
    [self hiddenLoadingView];
    self.newsListArray = [[NSArray alloc]initWithArray:[manager fetchDataWithReformer:[[WJNewsListReformer alloc] init]]];
    if (self.newsListArray.count != 0) {
        self.emptyView.hidden = YES;
    }else{
        self.emptyView.hidden = NO;
    }
    [self endGetData:YES];
    [self refreshFooterStatus:manager.hadGotAllData];
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self endGetData:NO];
    [self hiddenLoadingView];
    if (manager.errorType == APIManagerErrorTypeNoData) {
        self.newsListArray = nil;
        [self.tableView reloadData];
    }
    if (self.newsListArray.count != 0) {
        self.emptyView.hidden = YES;
    }else{
        self.emptyView.hidden = NO;
    }
    NSLog(@"失败");
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.newsListArray.count == 0) {
        return 0;
    }
    return self.newsListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJSystemNewsModel *model = [self.newsListArray objectAtIndex:indexPath.row];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:WJFont14,NSFontAttributeName,nil];
    CGSize sizeText = [model.content boundingRectWithSize:CGSizeMake(kScreenWidth - ALD(24), MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:dic context:nil].size;
    return sizeText.height + ALD(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    WJSystemMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WJSystemMessageTableViewCell"];
    if (!cell) {
        cell = [[WJSystemMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJSystemMessageTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.newsListArray.count == 0) {
        return cell;
    }
    WJSystemNewsModel *model = [self.newsListArray objectAtIndex:indexPath.row];
    [cell configData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight)
                                                         style:UITableViewStylePlain
                                                    refreshNow:NO
                                               refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (APINewsListManager *)newsListManager{
    if (nil == _newsListManager) {
        _newsListManager = [[APINewsListManager alloc] init];
        _newsListManager.shouldParse = YES;
        _newsListManager.delegate = self;
    }
    return _newsListManager;
}
- (WJEmptyView *)emptyView
{
    if (nil == _emptyView) {
        _emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(106), kScreenWidth, ALD(140))];
    }
    return _emptyView;
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
