//
//  WJSupportBankCardViewController.m
//  WanJiCard
//
//  Created by reborn on 16/7/14.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJSupportBankCardViewController.h"
#import "APISupportBankCardListManager.h"
#import "WJSupportBankModel.h"
#import "WJSupportBankReformer.h"

@interface WJSupportBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,APIManagerCallBackDelegate>

@property(nonatomic, strong)UITableView                   *supportBankTableView;
@property(nonatomic, strong)APISupportBankCardListManager *supportBankCardListManager;
@property(nonatomic, strong)NSMutableArray                *bankListdataArray;

@end

@implementation WJSupportBankCardViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"支持的银行卡";
    
    [self.view addSubview:self.supportBankTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestLoad];
}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APISupportBankCardListManager class]]) {
        
        self.bankListdataArray = [manager fetchDataWithReformer:[[WJSupportBankReformer alloc] init]];

        [self.supportBankTableView reloadData];

        
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
}

#pragma mark - Request
- (void)requestLoad{
    [self showLoadingView];
    [self.supportBankCardListManager loadData];
}


#pragma mark- UITableViewDelegate & UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"supportCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = WJFont15;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
        [cell.textLabel setTextColor:WJColorDardGray3];
        
        UIImageView *bankIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(15), (ALD(44) - ALD(30))/2, ALD(30), ALD(30))];
        bankIconImageView.layer.cornerRadius = 15;
        bankIconImageView.tag = 2001;
        bankIconImageView.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:bankIconImageView];
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(bankIconImageView.right + ALD(10), 0, kScreenWidth, ALD(44))];
        nameL.textColor = WJColorDardGray3;
        nameL.font = WJFont15;
        nameL.tag = 2002;
        
        [cell.contentView addSubview:nameL];
    }
    
    UIImageView *bankIconImageView = (UIImageView *)[cell.contentView viewWithTag:2001];
    
    WJSupportBankModel *supportBankModel = [_bankListdataArray objectAtIndex:indexPath.row];
    [bankIconImageView sd_setImageWithURL:[NSURL URLWithString:supportBankModel.logoImage] placeholderImage:[UIImage imageNamed:@"supportBankDefaultImage"]];
    
    UILabel *nameL = (UILabel *)[cell.contentView viewWithTag:2002];
    nameL.text = supportBankModel.name;
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_bankListdataArray.count == 0 || _bankListdataArray == nil) {
        
        return 0;
    }
    return _bankListdataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJSupportBankModel *supportBankModel = [_bankListdataArray objectAtIndex:indexPath.row];
    
    if(_selectSupportBankBlock)
    {
        self.selectSupportBankBlock(supportBankModel.name);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Getter and Setter
-(UITableView* )supportBankTableView
{
    if(nil == _supportBankTableView)
    {
        _supportBankTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _supportBankTableView.delegate = self;
        _supportBankTableView.dataSource = self;
        _supportBankTableView.separatorInset = UIEdgeInsetsZero;
        _supportBankTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _supportBankTableView.backgroundColor = WJColorViewBg;
        _supportBankTableView.tableFooterView = [UIView new];
        
    }
    return _supportBankTableView;
}

-(APISupportBankCardListManager *)supportBankCardListManager
{
    if (nil == _supportBankCardListManager) {
        _supportBankCardListManager = [[APISupportBankCardListManager alloc] init];
        _supportBankCardListManager.delegate = self;
        
    }
    return _supportBankCardListManager;
}

-(NSMutableArray *)bankListdataArray
{
    if (nil==_bankListdataArray) {
        _bankListdataArray = [[NSMutableArray alloc]init];
    }
    return _bankListdataArray;
}
@end
