//
//  WJMessageCenterViewController.m
//  WanJiCard
//
//  Created by silinman on 16/6/17.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMessageCenterViewController.h"
#import "WJMessageCenterTableViewCell.h"
#import "WJMyAssetMessageViewController.h"
#import "WJConsumeMessageViewController.h"
#import "WJSystemMessageViewController.h"
#import "WJActivityMessageViewController.h"
#import "WJPayCompleteController.h"

#import "APINewsCenterManager.h"
#import "WJNewsCenterReformer.h"
#import "WJNewsCenterModel.h"

@interface WJMessageCenterViewController ()<APIManagerCallBackDelegate,UITableViewDelegate,UITableViewDataSource>{
    BOOL            isLogin;
}

@property (nonatomic, strong)UITableView            *tableView;
@property (nonatomic, strong)APINewsCenterManager   *newsCenterManager;
@property (nonatomic, strong)NSArray                *newsArray;

@end

@implementation WJMessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNav];
    [self loadUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    [self requestData];
}
- (void)loadNav{
    self.title = @"消息中心";
}

- (void)loadUI{
    [self.view addSubview:self.tableView];
}
- (void)requestData{
    [self.newsCenterManager loadData];
    [self showLoadingView];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"成功");
    [self hiddenLoadingView];
    self.newsArray = [[NSArray alloc]initWithArray:[manager fetchDataWithReformer:[[WJNewsCenterReformer alloc] init]]];
    [self.tableView reloadData];
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    [self loadUI];
    NSLog(@"失败");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(73);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJMessageCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WJMessageCenterTableViewCell"];
    if (!cell) {
        cell = [[WJMessageCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJMessageCenterTableViewCell"];
    }
    if (_newsArray.count == 0 || _newsArray == nil) {
        cell.noticeIV.hidden = YES;
        cell.contentL.text = @"暂无消息";
    }else{
        WJNewsCenterModel *model = [_newsArray objectAtIndex:indexPath.row];
        NSInteger msgType = [model.type integerValue];
        switch (msgType) {
            case 1:
                cell.listIV.image = [UIImage imageNamed:@"Notice_System"];
                cell.titleL.text  = @"系统消息";
                break;
            case 2:
                cell.listIV.image = [UIImage imageNamed:@"Notice_Active"];
                cell.titleL.text  = @"活动消息";
                break;
            case 3:
                cell.listIV.image = [UIImage imageNamed:@"Notice_Assets"];
                cell.titleL.text  = @"我的资产";
                break;
            case 4:
                cell.listIV.image = [UIImage imageNamed:@"Notice_Consume"];
                cell.titleL.text  = @"消费信息";
                cell.moneyL.hidden = NO;
                break;
                
            default:
                break;
        }
        
        if ([model.isRead isEqualToString:@"1"]) {
            cell.noticeIV.hidden = YES;
        }else{
            cell.noticeIV.hidden = NO;
        }
        if (model.reqParam == nil || [model.reqParam isEqualToString:@""]) {
            cell.contentL.text = @"暂无消息";
        }else{
            cell.contentL.text = model.reqParam;
        }
        if (model.money == nil || [model.money isEqualToString:@""]) {
            cell.moneyL.text = @"";
            cell.contentL.frame = CGRectMake(cell.listIV.right + ALD(10),cell.titleL.bottom + ALD(5), kScreenWidth - cell.listIV.right - ALD(22), ALD(16));
            
        }else{
            cell.moneyL.text = [NSString stringWithFormat:@"￥%@",model.money];
            cell.contentL.frame = CGRectMake(cell.listIV.right + ALD(10),cell.titleL.bottom + ALD(5), kScreenWidth - cell.listIV.right - ALD(140), ALD(16));
        }
    }


//    [cell configData:[self.newsArray objectAtIndex:indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WJNewsCenterModel *model = [_newsArray objectAtIndex:indexPath.row];
    NSInteger msgType = [model.type integerValue];
    switch (msgType) {
        case 1:{
            WJSystemMessageViewController *systemVC = [[WJSystemMessageViewController alloc]init];
            [self.navigationController pushViewController: systemVC animated:YES whetherJump:NO];
        }
            break;
        case 2:{
            WJActivityMessageViewController *activityVC = [[WJActivityMessageViewController alloc]init];
            [self.navigationController pushViewController: activityVC animated:YES whetherJump:NO];
        }
            break;
        case 3:{
            WJMyAssetMessageViewController *assetVC = [[WJMyAssetMessageViewController alloc]init];
            [self.navigationController pushViewController: assetVC animated:YES whetherJump:NO];
        }
            break;
        case 4:{
            WJConsumeMessageViewController *consumeVC = [[WJConsumeMessageViewController alloc]init];
            [self.navigationController pushViewController: consumeVC animated:YES whetherJump:NO];
        }
            break;
            
        default:
            break;
    }

}


- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (APINewsCenterManager *)newsCenterManager{
    if (nil == _newsCenterManager) {
        _newsCenterManager = [[APINewsCenterManager alloc] init];
        _newsCenterManager.delegate = self;
    }
    return _newsCenterManager;
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
