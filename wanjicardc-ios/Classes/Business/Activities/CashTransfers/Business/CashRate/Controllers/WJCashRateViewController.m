//
//  WJCashRateViewController.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/22.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCashRateViewController.h"
#import "WJCashRateCell.h"
#import "APICashRateManager.h"
#import "WJCashRateModel.h"
#import "WJCashRateReformer.h"
@interface WJCashRateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView      *mTb;
@property(nonatomic,strong)NSMutableArray   *dataArray;
@property(nonatomic,strong)APICashRateManager *cashRateManager;
@end

@implementation WJCashRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"费率";
    // Do any additional setup after loading the view.ww6
    [self.view addSubview:self.mTb];
    
    [self requestData];
}

- (void)requestData
{
    [self showLoadingView];
    [self.cashRateManager loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APICashRateManager class]]) {
        
        self.dataArray =  [manager fetchDataWithReformer:[[WJCashRateReformer alloc] init]];
        
        [self.mTb reloadData];
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
}


#pragma mark - UITableViewDelagate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (0 == self.dataArray.count || nil == self.dataArray) {
        return 0;
    } else {
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(150);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJCashRateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CashRateCell"];
    
    if (cell == nil) {
        cell = [[WJCashRateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CashRate"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell configDataWithModel:self.dataArray[indexPath.row]];
    
    return cell;
}

#pragma mark - 属性方法
- (UITableView *)mTb{
    if (_mTb == nil) {
        _mTb = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 115) style:UITableViewStylePlain];
        
        _mTb.delegate = self;
        _mTb.dataSource = self;
        _mTb.separatorInset = UIEdgeInsetsZero;
        _mTb.backgroundColor = WJColorViewBg2;
        _mTb.scrollEnabled = NO;
        _mTb.separatorColor = WJColorSeparatorLine;
        _mTb.tableFooterView = [UIView new];
    }
    return _mTb;
}

- (APICashRateManager *)cashRateManager
{
    if (!_cashRateManager) {
        _cashRateManager = [[APICashRateManager alloc] init];
        _cashRateManager.delegate = self;
    }
    return _cashRateManager;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
