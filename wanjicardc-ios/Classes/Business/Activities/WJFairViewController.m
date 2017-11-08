//
//  WJFairViewController.m
//  WanJiCard
//
//  Created by silinman on 16/8/18.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJFairViewController.h"
#import "WJFairECardListTableViewCell.h"
#import "WJEleCardDeteilViewController.h"
#import "APIFairDetailManager.h"
#import "WJFairDetailModel.h"
#import "WJFairDetailReformer.h"
#import "WJBaoziCountTableViewCell.h"
#import "WJFairHotActivityTableViewCell.h"
#import "WJLoginViewController.h"
#import "WJMyBaoziViewController.h"
#import "WJWebViewController.h"
#import "WJElectronicCardListViewController.h"
#import "WJBaoziOrderConfirmController.h"
#import "WJECardModel.h"
#import "WJSystemAlertView.h"
#import "WJEmptyView.h"
#import "WJModelPerson.h"
#import "WJRefreshTableView.h"
#import "WJECardModel.h"
#import "UINavigationBar+Awesome.h"

//WJPsdVerifyAlert
@interface WJFairViewController ()<APIManagerCallBackDelegate,UITableViewDelegate,UITableViewDataSource,WJSystemAlertViewDelegate,WJRefreshTableViewDelegate>
{
    BOOL            isHeaderRefresh;
    BOOL            isFooterRefresh;
    BOOL            isShowMiddleLoadView;
}
@property (nonatomic, strong) WJRefreshTableView        *tableView;
@property (nonatomic, strong) APIFairDetailManager      *detailManager;
@property (nonatomic, strong) WJFairDetailModel         *fairDetailModel;
@property (nonatomic, strong) WJEmptyView               *emptyView;
@property (nonatomic, strong) NSMutableArray            *eCardArray;

@end

@implementation WJFairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self UISetup];
    [self reloadView];
    
    [kDefaultCenter addObserver:self selector:@selector(logOutForFair) name:@"LogOutForFair" object:nil];
    [kDefaultCenter addObserver:self selector:@selector(reloadView) name:@"ReloadFair" object:nil];
}

- (void)logOutForFair{
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarView.hidden = NO;
    self.eventID = @"iOS_vie_Market";
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)dealloc
{
    [kDefaultCenter removeObserver:self];
}

- (void)reloadView
{
    isShowMiddleLoadView = YES;

//    if ([WJGlobalVariable sharedInstance].defaultPerson) {
//        self.detailManager.shouldCleanData = YES;
//        [self requestData];
//    }else{
//        [self.tableView reloadData];
//    }
    self.detailManager.shouldCleanData = YES;
    [self requestData];
}

#pragma mark - UI
- (void)UISetup{
    self.title = @"包子商城";
    self.view.backgroundColor = WJColorViewBg;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.emptyView];
    self.emptyView.hidden = YES;
}

#pragma mark - RequestData
- (void)requestData
{
    if (isShowMiddleLoadView) {
        [self showLoadingView];
    }
    [self.detailManager loadData];
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WJRefreshTableView Delegate

- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.detailManager.shouldCleanData = YES;
        isShowMiddleLoadView = NO;
        [self requestData];
    }
    
}

- (void)startFootRefreshToDo:(UITableView *)tableView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        self.detailManager.shouldCleanData = NO;
        isShowMiddleLoadView = NO;
        [self requestData];
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
    
    if (self.eCardArray.count > 0) {
        self.tableView.tableFooterView = [UIView new];
    }else{
        
        self.tableView.tableFooterView = nil;
    }
    
}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"成功");
    
    if ([manager isKindOfClass:[APIFairDetailManager class]]) {
        [self hiddenLoadingView];
        
        self.fairDetailModel = [manager fetchDataWithReformer:[[WJFairDetailReformer alloc] init]];
        
        if ([self.fairDetailModel.cardsArray isKindOfClass:[NSArray class]]) {
            
            if (self.detailManager.shouldCleanData) {
                
                [self.eCardArray removeAllObjects];
                for (WJECardModel *model in self.fairDetailModel.cardsArray) {
                    [self.eCardArray addObject:model];
                }

            } else {
                for (WJECardModel *model in self.fairDetailModel.cardsArray) {
                    [self.eCardArray addObject:model];
                }
            }
            if (self.eCardArray.count < self.fairDetailModel.total ) {
                manager.hadGotAllData = NO;

            }else{
                manager.hadGotAllData = YES;

            }
            [self refreshFooterStatus:manager.hadGotAllData];
        }
        [self endGetData:YES];
        
        [WJGlobalVariable sharedInstance].defaultPerson.baoziNumber = self.fairDetailModel.balance;
        
        if (self.eCardArray.count == 0 && self.fairDetailModel.activityArray.count == 0 && (self.fairDetailModel.balance == nil || [self.fairDetailModel.balance isEqualToString:@""] || [self.fairDetailModel.balance isEqualToString:@"0"] || [self.fairDetailModel.balance isEqualToString:@"0.00"])) {
            self.emptyView.hidden = NO;
        }else{
            self.emptyView.hidden = YES;
        }
        
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if (manager.errorType == APIManagerErrorTypeNoData) {
        [self refreshFooterStatus:YES];
        
        if (isHeaderRefresh) {
            if (self.eCardArray.count > 0) {
                [self.eCardArray removeAllObjects];
                
            }
            [self endGetData:YES];
            return;
        }
        [self endGetData:NO];
        
    }else{
        
        [self refreshFooterStatus:self.detailManager.hadGotAllData];
        [self endGetData:NO];
        
    }

    if (self.eCardArray.count == 0 && self.fairDetailModel.activityArray.count == 0 && (self.fairDetailModel.balance == nil || [self.fairDetailModel.balance isEqualToString:@""] || [self.fairDetailModel.balance isEqualToString:@"0"] || [self.fairDetailModel.balance isEqualToString:@"0.00"])) {
        self.emptyView.hidden = NO;
    }else{
        self.emptyView.hidden = YES;
    }
    NSLog(@"失败");
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    switch (section) {
        case 0:
        {
            if (self.eCardArray.count == 0 && self.fairDetailModel.activityArray.count == 0 && (self.fairDetailModel.balance == nil || [self.fairDetailModel.balance isEqualToString:@""] || [self.fairDetailModel.balance isEqualToString:@"0"] || [self.fairDetailModel.balance isEqualToString:@"0.00"])) {
                count = 0;
            }else{
                count = 1;
            }
        }
            break;
        case 1:
        {
            if (self.eCardArray.count == 0) {
                if (self.fairDetailModel.balance == nil || [self.fairDetailModel.balance isEqualToString:@""] || [self.fairDetailModel.balance isEqualToString:@"0"] || [self.fairDetailModel.balance isEqualToString:@"0.00"]) {
                    count = 0;
                }else{
                    count = 1;
                }
            }else{
                count = 2;
            }
        }
            break;
//        case 2:
//        {
//            if (self.fairDetailModel.activityArray.count == 0) {
//                count = 1;
//            }else{
//                count = 2;
//            }
//        }
            break;
            
        default:
            break;
    }
    return count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight;
    switch (indexPath.section) {
        case 0:
            if (self.eCardArray.count == 0 && (self.fairDetailModel.balance == nil || [self.fairDetailModel.balance isEqualToString:@""] || [self.fairDetailModel.balance isEqualToString:@"0"] || [self.fairDetailModel.balance isEqualToString:@"0.00"])) {
                cellHeight = 0;
            }else{
                cellHeight = ALD(64);
            }
            break;
        case 1:{
            if (indexPath.row == 0) {
                if (self.eCardArray.count == 0 && (self.fairDetailModel.balance == nil || [self.fairDetailModel.balance isEqualToString:@""] || [self.fairDetailModel.balance isEqualToString:@"0"] || [self.fairDetailModel.balance isEqualToString:@"0.00"])) {
                    cellHeight = 0;
                }else{
                    cellHeight = ALD(55);
                }
            }else{
                if (self.eCardArray.count == 0) {
                    cellHeight = 0;
                }else{
//                    if (self.eCardArray.count > 20) {
//                        cellHeight = ALD(185) + ALD(9 * 170);
//                    }else{
                        if (self.eCardArray.count > 2) {
                            cellHeight = ALD(185) + ALD((self.eCardArray.count/2 + self.eCardArray.count%2 - 1) * 170);
                        }else{
                            cellHeight = ALD(185);
                        }
//                        cellHeight = ALD(350);
//                    }
                }
            }
        }
            break;
//        case 2:{
//            if (indexPath.row == 0) {
//                
//                cellHeight = ALD(55);
//                
//            }else{
//                if (self.fairDetailModel.activityArray.count == 0) {
//                    cellHeight = 0;
//                }else{
//                    if (self.fairDetailModel.activityArray.count < 2) {
//                        cellHeight = ALD(155);
//                    }else{
//                        cellHeight = ALD(300);
//                    }
//                }
//            }
//        }
//            break;
        default:
            break;
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (self.eCardArray.count == 0 && self.fairDetailModel.activityArray.count == 0 && (self.fairDetailModel.balance == nil || [self.fairDetailModel.balance isEqualToString:@""] || [self.fairDetailModel.balance isEqualToString:@"0"] || [self.fairDetailModel.balance isEqualToString:@"0.00"])) {
            return nil;
        }
        
        WJBaoziCountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WJBaoziCountTableViewCell"];
        if (nil == cell) {
            cell = [[WJBaoziCountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJBaoziCountTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        __weak typeof(self)weakSelf = self;
        cell.myBuns = ^{
            [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_MyBun"];
            WJMyBaoziViewController *baoziVC = [[WJMyBaoziViewController alloc] initWithNibName:nil bundle:nil];
            [weakSelf.navigationController pushViewController:baoziVC animated:YES];
            weakSelf.tabBarView.hidden = YES;
        };
        cell.payBuns = ^{
            [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_instantRecharge"];
            if (weakSelf.fairDetailModel.recharge) {
                [WJGlobalVariable sharedInstance].payfromController = weakSelf;
                WJBaoziOrderConfirmController *baoziVC = [[WJBaoziOrderConfirmController alloc] init];
                [weakSelf.navigationController pushViewController:baoziVC animated:YES];
                weakSelf.tabBarView.hidden = YES;
            }else{
                WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil message:@"土豪！您充太多钱了，明天再来好不好！" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
                [alert showIn];
            }
        };
        cell.userLogin = ^{
            WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
            loginVC.from = LoginFromFair;
            WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
            [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
        };
        
        if ([WJGlobalVariable sharedInstance].defaultPerson) {
            [cell configData:self.fairDetailModel.balance  isLogin:YES];
        }else{
            [cell configData:@"" isLogin:NO];
        }
        
        return cell;
    }else if (indexPath.section == 1) {
        //电子卡
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fairECardList"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fairECardList"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *titleBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(10))];
                titleBg.backgroundColor = WJColorViewBg;
                [cell.contentView addSubview:titleBg];
                
                UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(9.5), kScreenWidth, ALD(0.5))];
                bottomLine.backgroundColor = WJColorSeparatorLine;
                [cell.contentView addSubview:bottomLine];
                
                UIView *topLine_1 = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(54.5), kScreenWidth, ALD(0.5))];
                topLine_1.backgroundColor = WJColorSeparatorLine;
                [cell.contentView addSubview:topLine_1];
                
                UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(23), ALD(150), ALD(16))];
                infoL.text = @"电子卡";
                infoL.font = WJFont14;
                infoL.textColor = WJColorDarkGray;
                [cell.contentView addSubview:infoL];
                
//                UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(18), ALD(28),ALD(6), ALD(11))];
//                arrowImageView.image =[UIImage imageNamed:@"details_rightArrowIcon"];
//                [cell.contentView addSubview:arrowImageView];
//                
//                UILabel *infosL = [[UILabel alloc] initWithFrame:CGRectMake(arrowImageView.x - ALD(10) - ALD(200), ALD(25), ALD(200), ALD(16))];
//                infosL.text = @"更多";
//                infosL.font = WJFont12;
//                infosL.textAlignment = NSTextAlignmentRight;
//                infosL.textColor = WJColorLightGray;
//                [cell.contentView addSubview:infosL];
            }
            return cell;
            
        }else{
            if (self.eCardArray.count == 0) {
                return nil;
            }
            WJFairECardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WJFairECardListTableViewCell"];
            if (!cell) {
                cell = [[WJFairECardListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJFairECardListTableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            __weak typeof(self)weakSelf = self;
            cell.selectECardBlock = ^(WJECardModel *model){
                [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_Ecardclick"];
                WJEleCardDeteilViewController * eCardVC = [[WJEleCardDeteilViewController alloc] init];
                model.isEntitycard = NO;
                eCardVC.eCardModel = model;
                eCardVC.electronicCardComeFrom = ComeFromFair;
                [weakSelf.navigationController pushViewController:eCardVC animated:YES ];
                weakSelf.tabBarView.hidden = YES;
            };
            cell.isCardShop = NO;
            [cell configData:self.eCardArray];
            return cell;
            
        }
    }else if (indexPath.section == 2) {
        //热门活动
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fairActivityList"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fairActivityList"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *titleBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(10))];
                titleBg.backgroundColor = WJColorViewBg;
                [cell.contentView addSubview:titleBg];
                
                UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(9.5), kScreenWidth, ALD(0.5))];
                bottomLine.backgroundColor = WJColorSeparatorLine;
                [cell.contentView addSubview:bottomLine];
                
                UIView *topLine_1 = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(54.5), kScreenWidth, ALD(0.5))];
                topLine_1.backgroundColor = WJColorSeparatorLine;
                [cell.contentView addSubview:topLine_1];
                
                UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(23), ALD(150), ALD(16))];
                infoL.text = @"编辑推荐";
                infoL.font = WJFont14;
                infoL.textColor = WJColorDarkGray;
                [cell.contentView addSubview:infoL];
                
                UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(18), ALD(28),ALD(6), ALD(11))];
                arrowImageView.image =[UIImage imageNamed:@"details_rightArrowIcon"];
                [cell.contentView addSubview:arrowImageView];
                
                UILabel *infosL = [[UILabel alloc] initWithFrame:CGRectMake(arrowImageView.x - ALD(10) - ALD(200), ALD(25), ALD(200), ALD(16))];
                infosL.text = @"更多";
                infosL.font = WJFont12;
                infosL.textAlignment = NSTextAlignmentRight;
                infosL.textColor = WJColorLightGray;
                [cell.contentView addSubview:infosL];
            }
            return cell;
            
        }else{
            if (self.fairDetailModel.activityArray.count == 0) {
                return nil;
            }
            WJFairHotActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WJFairHotActivityTableViewCell"];
            if (!cell) {
                cell = [[WJFairHotActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJFairHotActivityTableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            __weak typeof(self)weakSelf = self;
            cell.selectActivityBlock = ^(NSString *url,NSString *name){
                WJWebViewController *webVC = [[WJWebViewController alloc] init];
                [webVC loadWeb:url];
                webVC.titleStr = name;
                [weakSelf.navigationController pushViewController:webVC animated:YES];
                weakSelf.tabBarView.hidden = YES;
            };
            [cell configData:[NSMutableArray arrayWithArray:self.fairDetailModel.activityArray]];
            return cell;
            
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
//            if (indexPath.row == 0) {
//                [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_Ecardmore"];
//                WJElectronicCardListViewController *eCardListVC = [[WJElectronicCardListViewController alloc] initWithNibName:nil bundle:nil];
//                [self.navigationController pushViewController:eCardListVC animated:YES];
//                self.tabBarView.hidden = YES;
//            }
        }
            break;
        case 2:
        {
//            if (indexPath.row == 0) {
//                WJActivityThemeController *activityVC = [[WJActivityThemeController alloc] init];
//                [self.navigationController pushViewController:activityVC animated:YES];
//                self.tabBarView.hidden = YES;
//            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark- Getter and Setter
- (UITableView *)tableView
{
    if (nil == _tableView) {
        
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, SCREEN_HEIGHT -64 -kTabbarHeight)
                                                                 style:UITableViewStylePlain
                                                            refreshNow:NO
                                                       refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (APIFairDetailManager *)detailManager
{
    if (!_detailManager) {
        _detailManager = [[APIFairDetailManager alloc] init];
        _detailManager.shouldParse = NO;
        _detailManager.delegate = self;

    }
    return _detailManager;
}
- (WJEmptyView *)emptyView
{
    if (nil == _emptyView) {
        _emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(210), kScreenWidth, ALD(140))];
    }
    return _emptyView;
}

- (NSMutableArray *)eCardArray{
    if (!_eCardArray) {
        _eCardArray = [NSMutableArray array];
    }
    return _eCardArray;
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
