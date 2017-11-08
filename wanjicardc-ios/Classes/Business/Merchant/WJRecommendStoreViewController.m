//
//  WJRecommendStoreViewController.m
//  WanJiCard
//
//  Created by Lynn on 15/9/10.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJRecommendStoreViewController.h"
#import "WJChooseCityViewController.h"
#import "WJSearchMerchantViewController.h"
#import "WJMerchantListViewController.h"
#import "WJMerchantDetailController.h"

#import "WJSearchCellView.h"
#import "WJRefreshTableView.h"
#import "WJTopicReformer.h"
#import "WJTopicModel.h"
#import "WJTopicTableViewCell.h"

#import "APIRecommendMerchantManager.h"
#import "WJRecommendStoreReformer.h"
#import "WJMerchantTableViewCell.h"
#import "LocationManager.h"
#import "WJDBAreaManager.h"
#import "WJWebViewController.h"

#define kShowFootViewNumber     20

@interface WJRecommendStoreViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,APIManagerCallBackDelegate,TopicDelegate,SearchCellDelegate,WJRefreshTableViewDelegate>
{
    BOOL isHeaderRefresh;

}
@property (nonatomic, strong) UILabel               *addressLabel;
@property (nonatomic, strong) WJRefreshTableView    *tableView;
@property (nonatomic, strong) NSArray               *logosArray;
@property (nonatomic, strong) NSArray               *sectionTitleArray;
@property (nonatomic, strong) NSArray               *dataArray;
@property (nonatomic, strong) NSArray               *topicsArray;

@property (nonatomic, strong) NSArray               *merchantArray;
@property (nonatomic, strong) APIRecommendMerchantManager   *merchantManager;

@property (nonatomic, strong) NSArray               *mainCityArray;
@property (nonatomic, strong) NSString              *currentCity;

@end

@implementation WJRecommendStoreViewController

#pragma mark- ClassMethods
// TODO:这里实现类方法。
#pragma mark- Initialization
#pragma mark- Life cycle
- (void)dealloc
{
    [kDefaultCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (![self.addressLabel.text isEqualToString:self.currentCity]) {
        self.addressLabel.text = self.currentCity;
        
        [self.tableView startHeadRefresh];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [kDefaultCenter addObserver:self selector:@selector(shopsRefresh:) name:kCityUpdate object:nil];
    
    self.eventID = @"iOS_act_biztotal";
    [self UISetup];
    
    [self.tableView startHeadRefresh];

}

- (void)shopsRefresh:(NSNotification *)notification
{
    if (![self.addressLabel.text isEqualToString:self.currentCity]) {
     
        [self.tableView startHeadRefresh];
    }
}

#pragma mark - WJRefreshTableView Delegate
- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isHeaderRefresh) {
        
        isHeaderRefresh = YES;
        self.addressLabel.text = self.currentCity;
        [self.merchantManager loadData];
    }
}


- (void)endGetData:(BOOL)needReloadData{

    if (needReloadData) {
        [self.tableView reloadData];
    }
    
    if (isHeaderRefresh) {
        isHeaderRefresh = NO;
        [self.tableView endHeadRefresh];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Delegate

#pragma mark - SearchCellDelegate
- (void)searchCell:(WJSearchCellView *)searchCell didSelectWithIndex:(int)index
{
    WJMerchantListViewController * merchantListVC = [[WJMerchantListViewController alloc] init];
    merchantListVC.eventID = @"iOS_act_bizmore";
    merchantListVC.searchManager.categoryid = [[self.logosArray objectAtIndex:index] objectForKey:@"type"];
    [self.navigationController pushViewController:merchantListVC animated:YES];
}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"%@",manager);
    NSLog(@"%s",__func__);
    
   if([manager isKindOfClass:[APIRecommendMerchantManager class]])
    {
        self.topicsArray = [manager fetchDataWithReformer:[[WJTopicReformer alloc] init]];
        self.merchantArray = [manager fetchDataWithReformer:[[WJRecommendStoreReformer alloc] init]];
        
        [self endGetData:YES];
        self.tableView.tableFooterView = [UIView new];
    }
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"%@",manager);
    NSLog(@"%s",__func__);
    
    [self endGetData:NO];
}

#pragma mark - TopicDelegate
- (void)topicCell:(WJTopicTableViewCell *)cell didSelectedWithIndex:(int)index
{
    if (index < self.topicsArray.count){
        WJTopicModel * model = [self.topicsArray objectAtIndex:index];
        //进入WEBView
        if (model.topicType == TopicTypeWebViewAction) {
            WJWebViewController * webVC = [[WJWebViewController alloc] init];
            webVC.titleStr = model.name;
//#if DEBUG
//            model.link = @"http://localhost/test.html";
//#endif
            [webVC loadWeb:model.link];
            [self.navigationController pushViewController:webVC animated:YES];
        }
        NSLog(@"%@",model.name);
    }
 
}

#pragma mark - SearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    WJSearchMerchantViewController * searchVC = [[WJSearchMerchantViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
    return NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    switch (section) {
        case 0:
        case 2:
            rows = 1;
            break;
            
        case 1:
            rows = [self.merchantArray count];
            break;
            
        default:
            rows = 0;
            break;
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    switch (indexPath.section) {
        case 0:
            height = ALD(103);
            break;

        case 1:
            height = ALD(95);
            break;
            
        case 2:
            height = ALD(50);
            break;
            
        default:
            height = 0;
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            WJTopicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellTopicID"];
            if (nil == cell) {
                cell = [[WJTopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTopicID"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            [cell setImageWithArray:self.topicsArray];
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"moreCellID"];
            if (nil == cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreCellID"];
                cell.contentView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e5e5e5"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(10), kScreenWidth , ALD(40))];
                titleLabel.text = @"查看全部商家";
                titleLabel.backgroundColor = [UIColor whiteColor];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.font = [UIFont systemFontOfSize:12.0];
                titleLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"999999"];
                [cell.contentView addSubview:titleLabel];
                
                UIImageView * cellJumpIV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(30), ALD(19), ALD(22), ALD(22))];
                cellJumpIV.image = [UIImage imageNamed:@"cell_jump"];
                [cell.contentView addSubview:cellJumpIV];
            }
            return cell;
        }
            break;
        default:
        {
            NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
            
            WJMerchantTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (nil == cell) {
                cell = [[WJMerchantTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
                        
            [cell configData:[self.merchantArray  objectAtIndex:indexPath.row]];
            return cell;
        }
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 1:
            return ALD(30);
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(30))];
    aView.backgroundColor = [UIColor whiteColor];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, 200, 30)];
    titleLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.text = [self.sectionTitleArray objectAtIndex:section];

    UIView  * line = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(29), kScreenWidth, ALD(1))];
    line.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e5e5e5"];
    [aView addSubview:titleLabel];
    [aView addSubview:line];
    return aView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    NSLog(@"%s",__func__);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        WJMerchantDetailController *vc = [[WJMerchantDetailController alloc] init];
        vc.merId = [self.merchantArray[indexPath.row] merID];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section == 2)
    {
        WJMerchantListViewController * merchantListVC = [[WJMerchantListViewController alloc] init];
        merchantListVC.eventID = @"iOS_act_bizmore";
        merchantListVC.searchManager.categoryid = @"0";
        [self.navigationController pushViewController:merchantListVC animated:YES];
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 30;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
}

#pragma mark- Event Response
// TODO:所有 button、gestureRecognizer、notification 的事件相应方法，与跳转到其他 controller 的出口方法都写在这里。
- (void)chooseCityAction
{
    WJChooseCityViewController * chooseCityVC = [[WJChooseCityViewController alloc] init];
    chooseCityVC.currentCity = self.addressLabel.text?:@"北京";
    WJNavigationController * chooseCityNav = [[WJNavigationController alloc] initWithRootViewController:chooseCityVC];
//    [self.navigationController pushViewController:chooseCityVC animated:YES];
    [self presentViewController:chooseCityNav animated:YES completion:^{
        
    }];
}

#pragma mark- Rotation
// TODO:转屏处理写在这。

#pragma mark- Private Methods
// TODO:理论上来说，此处不应有私有方法存在，都应该在上面找到归类。这里应该放置拆分的中间方法。

- (void)UISetup
{
    [self navigationSetup];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
}

- (UIView *)getTableHeaderView
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(105))];
    headerView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e5e5e5"];

    for(int i = 0; i < 4; i++ ) //写死了
    {
        CGRect frame = CGRectMake(i * (kScreenWidth/4), 0, kScreenWidth/4, ALD(90));
        WJSearchCellView * cell = [[WJSearchCellView alloc] initWithFrame:frame dictionary:[self.logosArray objectAtIndex:i] tag:i];
        cell.delegate = self;
        [headerView addSubview:cell];
    }
    return headerView;
}

- (void)navigationSetup
{
    UIColor *color = self.navigationController.navigationBar.barTintColor;
    
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCityAction)];
    [rightView addGestureRecognizer:tap];
    UIImageView * chooseCityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.addressLabel.frame) + 4, CGRectGetMinY(self.addressLabel.frame) + 10 , 10, 10)];
    chooseCityImageView.image = [UIImage imageNamed:@"business_Down-arrow_icon"];
    self.addressLabel.text = self.currentCity;
    [rightView addSubview:self.addressLabel];
    [rightView addSubview:chooseCityImageView];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    CGFloat width = kScreenWidth - 120;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    [titleView setBackgroundColor:color];
    
    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    searchBar.delegate = self;
//        searchBar.barStyle = UIBarStyleDefault;
    searchBar.barTintColor = color;
    searchBar.searchBarStyle = UISearchBarStyleDefault;

    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.placeholder = @"请输入店铺名称";
    searchBar.keyboardType =  UIKeyboardTypeDefault;
    searchBar.layer.cornerRadius = 5;
    searchBar.layer.masksToBounds = YES;
    [titleView addSubview:searchBar];
    
    self.navigationItem.titleView = titleView;
    
    if ([searchBar respondsToSelector:@selector(barTintColor)]) {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.1) {
            //ios7.1
            [[[[searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [searchBar setBackgroundColor:[UIColor clearColor]];
        }else{
            //ios7.0
            [searchBar setBarTintColor:[UIColor clearColor]];
            [searchBar setBackgroundColor:[UIColor clearColor]];
        }
    }else{
        //iOS7.0 以下
        [[searchBar.subviews objectAtIndex:0] removeFromSuperview];
        [searchBar setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)lookforMore
{
    NSLog(@"%s",__func__);
}

#pragma mark- Getter and Setter

- (UILabel *)addressLabel
{
    if (nil == _addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        _addressLabel.font = [UIFont systemFontOfSize:14.0];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.textColor = [UIColor whiteColor];
    }
    return _addressLabel;
}

- (NSArray *)logosArray
{
    if (nil == _logosArray) {
        _logosArray = @[@{@"logo":@"business_food",@"name":@"美食",@"type":@"1"},
                        @{@"logo":@"business_beauty",@"name":@"丽人",@"type":@"10"},
                        @{@"logo":@"business_life",@"name":@"生活",@"type":@"4"},
                        @{@"logo":@"business_more",@"name":@"更多",@"type":@"0"}];
    }
    return _logosArray;
}

- (NSArray *)sectionTitleArray
{
    if (nil == _sectionTitleArray) {
        _sectionTitleArray = @[@"活动专区",@"推荐商家",@""];
    }
    return _sectionTitleArray;
}

- (WJRefreshTableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeHeader];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WJColorViewBg;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.automaticallyRefresh = YES;
        
        _tableView.tableHeaderView = [self getTableHeaderView];
        _tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _tableView;
}

- (UIView *)footView
{
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(40))];
//    r_icon
    UIImageView * nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(37), ALD(9), ALD(22), ALD(22))];
    nextImageView.image = [UIImage imageNamed:@"lump_icon"];
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(37), 0, kScreenWidth - ALD(74), ALD(40))];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"查看更多店铺";
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookforMore)];
    [footView addGestureRecognizer:tap];
    
    [footView addSubview:nextImageView];
    [footView addSubview:tipLabel];
    
    return footView;
}


- (NSString *)currentCity
{
    NSString * cityName = [WJUtilityMethod dealWithAreaName:[LocationManager sharedInstance].choosedArea.name];
    return cityName;
}


- (APIRecommendMerchantManager *)merchantManager
{
    if (nil == _merchantManager) {
        _merchantManager = [[APIRecommendMerchantManager  alloc] init];
        _merchantManager.delegate = self;
    }
//    _merchantManager.cityId = self.currentCity;
    _merchantManager.cityId  = [LocationManager sharedInstance].choosedArea.areaId;
    
    return _merchantManager;
}

- (NSArray *)topicsArray
{
    if (nil == _topicsArray) {
        _topicsArray = [NSArray array];
    }
    return _topicsArray;
}

- (NSArray *)merchantArray
{
    if (nil == _merchantArray) {
        _merchantArray = [NSArray array];
    }
    return _merchantArray;
}


- (NSArray *)mainCityArray
{
    if (nil == _mainCityArray) {
        _mainCityArray = [[WJDBAreaManager alloc] getAreaByLevel:2];
    }
    return _mainCityArray;
}


@end
