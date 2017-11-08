//
//  WJMerchantListViewController.m
//  WanJiCard
//
//  Created by Lynn on 15/9/10.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJMerchantListViewController.h"
#import "WJMerchantDetailController.h"

#import "WJRefreshTableView.h"
#import "WJMerchantListReformer.h"
#import "WJRecommendStoreModel.h"
#import "WJMerchantTableViewCell.h"
#import "WJSearchTapCell.h"

#import "APISearchOptionManager.h"
#import "WJCategateReformer.h"
#import "WJSearchConditionReformer.h"
#import "WJCategoryModel.h"
#import "WJSearchConditionModel.h"
#import "WJFilterTableViewCell.h"
#import "APISearchManager.h"
#import "LocationManager.h"
#import "WJDBAreaManager.h"
#import "WJModelArea.h"
#import "WJEmptyView.h"
#import "WJSearchMerchantViewController.h"
#import "WJCityView.h"
#import <CoreLocation/CoreLocation.h>
#import<MapKit/MapKit.h>

#define kChooceTapHeight        44
#define kLocationTipHeight      32
#define KSystomVersion   [[[UIDevice currentDevice] systemVersion] floatValue]

@interface WJMerchantListViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,APIManagerCallBackDelegate,SearchCellDelegate, WJCityViewDelegate>
{
    
    BOOL isHeaderRefresh;
    BOOL isFooterRefresh;
    UILabel *_positionLabel;
    UILabel *_addressLabel;
    UIImageView * chooseCityImageView;
    BOOL isCityViewShow;
    UIView *backView;
    UIButton *refreshBtn;
    UIImageView *goSettingArrow;
    LocationManager * locaManager;
    BOOL positionSuccess;
    CGFloat merchantTableHeight;
    
    BOOL isShowMiddleLoadView;
    
}

@property (nonatomic, strong) UIView                 *businessBackView;
@property (nonatomic, strong) WJRefreshTableView     *merchantTableView;
@property (nonatomic, strong) UITableView            *mainCityTableView;
@property (nonatomic, strong) UITableView            *minorCityTableView;
@property (nonatomic, strong) UITableView            *foodTableView;
@property (nonatomic, strong) UITableView            *sortTableView;

@property (nonatomic, strong) NSArray                *merchantArray;
@property (nonatomic, strong) NSMutableArray         *mainCityArray;
@property (nonatomic, strong) NSMutableArray         *minorCityArray;
@property (nonatomic, strong) NSMutableArray         *categaryArray;
@property (nonatomic, strong) NSArray                *tabArray;
@property (nonatomic, strong) NSMutableArray         *searchConditionArray;

@property (nonatomic, strong) APISearchOptionManager *searchOptionManager;

@property (nonatomic, assign) int                    currentTap;
@property (nonatomic, strong) UIView                 *tabView;
@property (nonatomic, strong) WJEmptyView            *emptyView;
@property (nonatomic, strong) NSString               *currentCategary;
@property (nonatomic, strong) NSString               *currentSort;
@property (nonatomic, strong) WJModelArea            *currentArea;
@property (nonatomic, strong) NSString               *currentMainCity;
@property (nonatomic, strong) NSString               *currentMinorCity;
@property (nonatomic, strong) NSString               *currentCity;
@property (nonatomic, strong) NSString               *currentCityID;
@property (nonatomic, assign) BOOL                   isRequesting;
@property (nonatomic, strong) WJCityView             *cityView;

@end

@implementation WJMerchantListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.eventID = @"iOS_vie_MerchantView";
    
    [kDefaultCenter addObserver:self selector:@selector(refreshAddress:) name:kLocationSettingChange object:nil];
    
    [kDefaultCenter addObserver:self selector:@selector(refreshMerchantData) name:@"ReloadMerchant" object:nil];
    
    if (self.from == EnterFromCategory) {
        self.title = self.categoryTitle;
    }else{
        self.title = @"商家";
    }
    
    self.currentTap = -1;
    self.view.backgroundColor = [UIColor whiteColor];
    isCityViewShow = NO;
    
    [self navigationSetup];
    [self UISetup];
    [self startLocation];
    
    isShowMiddleLoadView = YES;

    [self.searchOptionManager loadData];
    [self searchHeaderManager];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.from == EnterFromTab) {
        self.tabBarView.hidden = NO;
    }
    isShowMiddleLoadView = YES;
    self.navigationController.navigationBar.translucent = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.from == EnterFromTab) {
        if ([self.view viewWithTag:1000]) {
            //如果城市是展开状态，收回
            if (isCityViewShow) {
                //如果下拉筛选展开状态，收回
                if (self.currentTap >= 0) {
                    WJSearchTapCell * cell = (WJSearchTapCell *)[self.tabView viewWithTag:30000+self.currentTap];
                    if (cell.moreImageView.highlighted) {
                        [self searchTap:cell didSelectWithindex:self.currentTap];
                    }
                }
                
                isCityViewShow = NO;
                chooseCityImageView.highlighted = NO;
                self.cityView.hidden = YES;
            }
        }
        
        //恢复分类下拉状态
        WJSearchTapCell * tapCell = (WJSearchTapCell *)[self.tabView viewWithTag:30000+self.currentTap];
        if (tapCell && tapCell.moreImageView.highlighted) {

            [self searchTap:tapCell didSelectWithindex:self.currentTap];
        }

        //城市恢复成默认状态
        WJSearchTapCell * busCell = (WJSearchTapCell *)[self.tabView viewWithTag:30000];
        if (![busCell.titleLabel.text isEqualToString:[self.tabArray objectAtIndex:0]]) {
            busCell.moreImageView.highlighted = NO;
            busCell.titleLabel.textColor = WJColorDarkGray;
            [busCell setTapText:[self.tabArray objectAtIndex:0]];
            self.currentTap = 0;
        }
        
        self.minorCityArray = nil;
        self.currentMainCity = nil;
        self.currentMinorCity = nil;
       
    }
}


- (void)UISetup
{
    [self.view addSubview:self.tabView];
    
    //定位view
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabView.bottom, SCREEN_WIDTH, ALD(kLocationTipHeight))];
    backView.backgroundColor = WJColorViewBg;
    
    //叹号
    UIImageView *remindView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), ALD(8.5), ALD(15), ALD(15))];
    remindView.image = [UIImage imageNamed:@"LocationTips"];
    [backView addSubview:remindView];
    
    //位置
    _positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(37), 0, ALD(250), ALD(kLocationTipHeight))];
    _positionLabel.font = WJFont12;
    _positionLabel.text = @"定位中⋯";
    _positionLabel.textColor = WJColorLightGray;
    _positionLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:_positionLabel];
    
    //重试按钮
    refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn.titleLabel setFont:WJFont12];
    [refreshBtn setTitleColor:WJColorLightGray forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshAddress:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:refreshBtn];
    
    //去设置箭头
    goSettingArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Details_btn_more"]];
    [backView addSubview:goSettingArrow];
    
    [self.view addSubview:backView];
    
    
    UITapGestureRecognizer *takebackTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShadowViewTakeBackWith:)];
    [self.businessBackView addGestureRecognizer:takebackTap];

    [self.view addSubview:self.merchantTableView];
    
    [self.view addSubview:self.businessBackView];
    
    [self.view addSubview:self.mainCityTableView];
    [self.view addSubview:self.minorCityTableView];
    [self.view addSubview:self.foodTableView];
    [self.view addSubview:self.sortTableView];
    
}


- (void)navigationSetup
{
    if (self.from == EnterFromTab) {
        
        [self hiddenBackBarButtonItem];
        
        UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCityAction)];
        [leftView addGestureRecognizer:tap];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        _addressLabel.font = [UIFont systemFontOfSize:14.0];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.textColor = [UIColor whiteColor];
        
        
        chooseCityImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Home_btn_location_nor"]highlightedImage:[UIImage imageNamed:@"Home_btn_location_pressed"]];
        CGFloat addWith = [UILabel getWidthWithTitle:self.currentCity font:WJFont14];
        _addressLabel.frame = CGRectMake(0, 0, addWith, ALD(25));
        chooseCityImageView.frame = CGRectMake(_addressLabel.right + ALD(5), _addressLabel.y + ALD(9), ALD(8), ALD(8));
        [leftView addSubview:_addressLabel];
        [leftView addSubview:chooseCityImageView];
        
        
        UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
        self.navigationItem.leftBarButtonItem = leftBarItem;
    }
    
    if (self.from == EnterFromTab || self.from == EnterFromCategory || self.from == EnterFromHome) {
        
        UIButton * searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchButton setFrame:CGRectMake(0, 0, ALD(19), ALD(19))];
        [searchButton setImage:[UIImage imageNamed:@"nav_btn_search_nor"] forState:UIControlStateNormal];
        [searchButton setImage:[UIImage imageNamed:@"nav_btn_search_nor"] forState:UIControlStateHighlighted];
        [searchButton addTarget:self action:@selector(gotoSearchVC) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
}


- (void)startLocation{
    [self refreshAddress:nil];
    
    if (![_addressLabel.text isEqualToString:self.currentCity]) {
        _addressLabel.text = self.currentCity;
        [self.cityView.cityTableView reloadData];
        
        CGFloat addWith = [UILabel getWidthWithTitle:self.currentCity font:WJFont14];
        _addressLabel.frame = CGRectMake(0, 0, addWith, ALD(25));
        chooseCityImageView.frame = CGRectMake(_addressLabel.right + ALD(5), _addressLabel.y + ALD(9), ALD(8), ALD(8));
        
        self.searchManager.areaId = self.currentCityID;
    }
}


- (void)backBarButton:(UIButton *)btn
{
    if(self.from != EnterFromTab){
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)tap {
    self.mainCityTableView.hidden = YES;
    self.minorCityTableView.hidden = YES;
    self.foodTableView.hidden = YES;
    self.sortTableView.hidden = YES;
    self.businessBackView.hidden = YES;
}


#pragma mark - NSNotification

- (void)refreshMerchantData
{
    [self startLocation];
    if (self.categaryArray.count ==0) {
        [self.searchOptionManager loadData];
    }
    
    [self searchHeaderManager];
}


#pragma mark - request 

- (void)searchHeaderManager {
    self.searchManager.shouldCleanData = YES;
    [self requestData];
}


- (void)searchAppendManager {
    self.searchManager.shouldCleanData = NO;
    [self requestData];
}


- (void)requestData {
    
    if ([self.merchantTableView viewWithTag:20]) {
        self.emptyView.hidden = YES;
    }
    
    if (isShowMiddleLoadView) {

        if (self.merchantArray.count == 0) {

            [self showLoadingView];
        }
    }

    [self.searchManager loadData];
    [self tap];
}


#pragma mark - WJCityViewDelegate
- (void)updateCity:(WJCityView *)cityView
{
    if (isCityViewShow) {
        isCityViewShow = NO;
        chooseCityImageView.highlighted = NO;
        self.cityView.hidden = YES;
        
        if (![_addressLabel.text isEqualToString:self.currentCity]) {
            
            //修改城市名
            _addressLabel.text = self.currentCity;
            CGFloat addWith = [UILabel getWidthWithTitle:self.currentCity font:WJFont14];
            _addressLabel.frame = CGRectMake(0, 0, addWith, ALD(25));
            chooseCityImageView.frame = CGRectMake(_addressLabel.right + ALD(5), _addressLabel.y + ALD(9), ALD(8), ALD(8));
        }
        
        //恢复筛选条件状态
        self.currentTap = -1;
        
        for (int i =0; i<3; i++) {
            WJSearchTapCell * tapCell = (WJSearchTapCell *)[self.tabView viewWithTag:30000+i];
            tapCell.moreImageView.highlighted = NO;
            tapCell.titleLabel.textColor = WJColorDarkGray;
            [tapCell setTapText:[self.tabArray objectAtIndex:i]];
        }
        
        self.merchantArray = nil;
        self.minorCityArray = nil;
        self.currentMainCity = nil;
        self.currentMinorCity = nil;
        self.currentSort = nil;
        
        self.searchManager.areaId = self.currentCityID;
        self.searchManager.categoryid = @"0";
        self.searchManager.sort = @"distance";
        
        [self searchHeaderManager];
    }
}


- (void)takeBackView:(WJCityView *)cityView
{
    isCityViewShow = !isCityViewShow;
    chooseCityImageView.highlighted = !chooseCityImageView.highlighted;
    
    if (isCityViewShow) {
    
        self.cityView.hidden = NO;
        
    }else{
        self.cityView.hidden = YES;
    }

}


#pragma mark - SearchCellDelegate
- (void)searchTap:(WJSearchTapCell *)cell  didSelectWithindex:(int)index
{
    
    for (int i =0; i<3; i++) {
        WJSearchTapCell * tapCell = (WJSearchTapCell *)[self.tabView viewWithTag:30000+i];
        if (tapCell.tag != cell.tag) {
            tapCell.moreImageView.highlighted = NO;
            tapCell.titleLabel.textColor = WJColorDarkGray;
        }
    }
    
    if (index == self.currentTap) {
        
        cell.moreImageView.highlighted = !cell.moreImageView.highlighted;
        
        if (cell.moreImageView.highlighted) {
            cell.titleLabel.textColor = WJColorNavigationBar;
            
            if ((index == 1 && self.categaryArray.count ==0) || (index == 2 && self.searchConditionArray.count ==0)) {
                self.businessBackView.hidden = YES;
            }else{
                self.businessBackView.hidden = NO;
            }

//            self.businessBackView.hidden = NO;
            
        }else{
            
            cell.titleLabel.textColor = WJColorDarkGray;
            self.businessBackView.hidden = YES;
        }
    }else{
        
        cell.moreImageView.highlighted = YES;
        cell.titleLabel.textColor = WJColorNavigationBar;

        if ((index == 1 && self.categaryArray.count ==0) || (index == 2 && self.searchConditionArray.count ==0)) {
            self.businessBackView.hidden = YES;
        }else{
            self.businessBackView.hidden = NO;
        }
//        self.businessBackView.hidden = NO;
    }
    
    switch (index) {
        case 0:
        {
            self.foodTableView.hidden = YES;
            self.sortTableView.hidden = YES;
            
            if (index == self.currentTap) {
                self.mainCityTableView.hidden = !self.mainCityTableView.hidden;
                self.minorCityTableView.hidden = !self.minorCityTableView.hidden;
                
                if (!self.mainCityTableView.hidden) {
                    [self.mainCityTableView reloadData];
                    [self.minorCityTableView reloadData];
                }
                
                break;
            }
            [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_AreaFilter"];
            self.currentTap = index;
            [self.mainCityTableView reloadData];
            [self.minorCityTableView reloadData];
            self.mainCityTableView.hidden = NO;
            self.minorCityTableView.hidden = NO;
           
        }
            break;
        case 1:
        {
//            if ([WJUtilityMethod isNotReachable]) {
            
                self.mainCityTableView.hidden = YES;
                self.minorCityTableView.hidden = YES;
                self.sortTableView.hidden = YES;
                if (index == self.currentTap) {
                    self.foodTableView.hidden = !self.foodTableView.hidden;
                    break;
                }
                [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_ClassFilter"];
                self.foodTableView .hidden = NO;
                self.currentTap = index;
                [self.foodTableView reloadData];
//            }
        }
            break;
        case 2:
        {
//            if ([WJUtilityMethod isNotReachable]) {
            
                self.mainCityTableView.hidden = YES;
                self.minorCityTableView.hidden = YES;
                self.foodTableView.hidden = YES;
                if (index == self.currentTap) {
                    self.sortTableView.hidden = !self.sortTableView.hidden;
                    break;
                }
                [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_IntelFilter"];
                self.sortTableView.hidden = NO;
                self.currentTap = index;
                [self.sortTableView reloadData];
//            }
        }
            break;
        default:
            break;
    }
}


#pragma mark - APIManagerCallbackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"%@",manager);
    NSLog(@"%s",__func__);
    
    if ([manager isKindOfClass:[APISearchManager class]]) {
        
        [self hiddenLoadingView];
        
        self.merchantArray = [manager fetchDataWithReformer:[[WJMerchantListReformer alloc] init]];

        [self endGetData:YES];
        [self refreshFooterStatus:manager.hadGotAllData];
        
    }else if([manager isKindOfClass:[APISearchOptionManager class]])
    {
        self.categaryArray = [manager fetchDataWithReformer:[[WJCategateReformer alloc] init]];
        self.searchConditionArray = [manager fetchDataWithReformer:[[WJSearchConditionReformer alloc] init]];
        [self.searchConditionArray insertObject:@"智能排序" atIndex:0];
        
        self.foodTableView.frame = CGRectMake(0, ALD(kChooceTapHeight), kScreenWidth, self.categaryArray.count *ALD(44));
        self.sortTableView.frame = CGRectMake(0, ALD(kChooceTapHeight), kScreenWidth, self.searchConditionArray.count *ALD(44));
        
        [self.sortTableView reloadData];
        [self.foodTableView reloadData];
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self endGetData:NO];
    if([manager isKindOfClass:[APISearchManager class]])
    {
        [self hiddenLoadingView];
        
        if (manager.errorType == APIManagerErrorTypeNoData) {
            self.merchantArray = nil;
            [self.merchantTableView reloadData];
        }
        
        if ([self.merchantArray count] == 0) {

//            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"还没有发现您想要的商家哦~"];
            
            if (![self.merchantTableView viewWithTag:20]) {
                self.emptyView.tag = 20;
                [self.merchantTableView addSubview:self.emptyView];
            }else{
                self.emptyView.hidden = NO;
            }
  
        }
        
    }else if([manager isKindOfClass:[APISearchOptionManager class]])
    {
        
    }
   
    NSLog(@"%@",manager);
    NSLog(@"%s",__func__);
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _merchantTableView) {
        return [self.merchantArray count];

    }else if(tableView == _foodTableView)
    {
        return [self.categaryArray count];
        
    }else if (tableView == _sortTableView){
        
       return [self.searchConditionArray count];
    }
    else if (tableView == _mainCityTableView)
    {
        return [self.mainCityArray count] + 1;
        
    }else if (tableView == _minorCityTableView)
    {
        return [self.minorCityArray count];
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _merchantTableView) {
        return ALD(105);
    }else if(tableView == _foodTableView)
    {
        return ALD(44);
    }else if (tableView == _sortTableView){
        return ALD(44);
    }
    else if(tableView == _mainCityTableView)
    {
        return ALD(44);
    }else if(tableView == _minorCityTableView)
    {
        return ALD(44);
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _merchantTableView) {
        WJMerchantTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"merCellID"];
        if (nil == cell) {
            cell = [[WJMerchantTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"merCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
//            cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
            
        }
        [cell configData:[self.merchantArray  objectAtIndex:indexPath.row]];
        if (positionSuccess) {
            cell.locationMark.hidden = NO;
            cell.distanceLabel.hidden = NO;
        }else{
            cell.locationMark.hidden = YES;
            cell.distanceLabel.hidden = YES;
        }
        return cell;
        
    }else if (tableView == _foodTableView)
    {
        WJFilterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"footCellID"];
        if (nil == cell) {
            cell = [[WJFilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"footCellID"];
            cell.backgroundColor = WJColorViewBg;
            cell.markView.hidden = YES;
            cell.rightSideLine.hidden = YES;
            cell.bottomLine.hidden = YES;
        }
        
        [cell configData:[self.categaryArray objectAtIndex:indexPath.row]];

        if ([((WJCategoryModel *)[self.categaryArray objectAtIndex:indexPath.row]).categoryID isEqualToString:self.searchManager.categoryid]) {
            
            cell.titleLabel.textColor = WJColorNavigationBar;
        }else{
            
            cell.titleLabel.textColor = WJColorDarkGray;
        }
       
        
        return cell;
        
    }else if (tableView == _sortTableView){
        WJFilterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sortCellID"];
        if (nil == cell) {
            cell = [[WJFilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sortCellID"];
            cell.backgroundColor = WJColorViewBg;
            cell.markView.hidden = YES;
            cell.rightSideLine.hidden = YES;
            cell.bottomLine.hidden = YES;
        }

        [cell configData:[self.searchConditionArray objectAtIndex:indexPath.row]];
        
        if ([cell.titleLabel.text isEqualToString:self.currentSort]) {
            
            cell.titleLabel.textColor = WJColorNavigationBar;
        }else{
            
            cell.titleLabel.textColor = WJColorDarkGray;
        }

        return cell;
        
    }else if(tableView == _mainCityTableView)
    {
        WJFilterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mainCityCellID"];
        if (nil == cell) {
            cell = [[WJFilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCityCellID"];
            cell.backgroundColor = WJColorWhite;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.markView.hidden = YES;
            cell.rightSideLine.hidden = NO;
        }
        if (indexPath.row == 0) {
             cell.titleLabel.text = @"全部";
        }else{
       
            [cell configData: ((WJModelArea *)[self.mainCityArray  objectAtIndex:indexPath.row-1]).name];
        }

        if ([cell.titleLabel.text isEqualToString:self.currentMainCity]){
            cell.backgroundColor = WJColorViewBg;
            cell.titleLabel.textColor = WJColorNavigationBar;
            cell.rightSideLine.hidden = YES;
            cell.markView.hidden = NO;
            
        }else{
            cell.titleLabel.textColor = WJColorDarkGray;
            cell.backgroundColor = WJColorWhite;
            cell.rightSideLine.hidden = NO;
            cell.markView.hidden = YES;
        }
        
        return cell;
        
    }else if(tableView == _minorCityTableView)
    {
        WJFilterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"11minorCityCellID"];
        if (nil == cell) {
            cell = [[WJFilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"11minorCityCellID"];
            cell.backgroundColor = WJColorViewBg;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.markView.hidden = YES;
            cell.rightSideLine.hidden = YES;
            cell.bottomLine.hidden = YES;
        }
        if(indexPath.row == 0){
            cell.titleLabel.text = [self.minorCityArray objectAtIndex:indexPath.row];
        }else{
            
            [cell configData: ((WJModelArea *)[self.minorCityArray  objectAtIndex:indexPath.row]).name];
        }
 
        if([cell.titleLabel.text isEqualToString:self.currentMinorCity]){
            cell.titleLabel.textColor = WJColorNavigationBar;
        }else{
            cell.titleLabel.textColor = WJColorDarkGray;
        }
        
        return cell;
    
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _merchantTableView) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.tabBarView.hidden = YES;
        
        WJRecommendStoreModel *model = self.merchantArray[indexPath.row];
        WJMerchantDetailController *vcv = [[WJMerchantDetailController alloc] init];
        vcv.merId = model.merID;
        [self.navigationController pushViewController:vcv animated:NO];
        
    }else if(tableView == _foodTableView){
        
     
        self.searchManager.categoryid = [NSString stringWithFormat:@"%@",((WJCategoryModel *)[self.categaryArray objectAtIndex:indexPath.row]).categoryID];
        
        WJCategoryModel * categoryModel = nil;
        categoryModel = (WJCategoryModel *)[self.categaryArray objectAtIndex:indexPath.row];
        
        WJSearchTapCell * cell = (WJSearchTapCell *)[self.tabView viewWithTag:30001];
        if (indexPath.row == 0) {
    
            [cell setTapText:[self.tabArray objectAtIndex:1]];
            if(self.from == EnterFromCategory){
                self.title = [self.tabArray objectAtIndex:1];
            }
        }else{
            
            [cell setTapText:categoryModel.name];
            if(self.from == EnterFromCategory){
                self.title = categoryModel.name;
            }
        }
        
        self.currentCategary = categoryModel.name;
        
//        self.foodTableView.hidden = YES;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.foodTableView reloadData];

        self.searchManager.categoryid = categoryModel.categoryID;
        [self searchHeaderManager];
        
        
        //恢复筛选状态
        [self recoverState];
      

    }else if (tableView == _sortTableView){
    
        WJSearchTapCell * cell = (WJSearchTapCell *)[self.tabView viewWithTag:30002];
        
        if (indexPath.row == 0) {
            
            [cell setTapText:[self.searchConditionArray objectAtIndex:0]];
            self.currentSort = [self.searchConditionArray objectAtIndex:0];
            self.searchManager.sort = ((WJSearchConditionModel *)[self.searchConditionArray objectAtIndex:1]).keyStr;
            
        }else{
            
            WJSearchConditionModel * searchConditionModel = [self.searchConditionArray objectAtIndex:indexPath.row];
            [cell setTapText:searchConditionModel.name];
            self.currentSort = searchConditionModel.name;
            self.searchManager.sort = searchConditionModel.keyStr;
        }
        
//        self.sortTableView.hidden = YES;
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.sortTableView reloadData];
        
        [self searchHeaderManager];
        
        //恢复筛选状态
        [self recoverState];
    }
    
    else if (tableView == _mainCityTableView)
    {
        if (indexPath.row == 0) {
            self.currentMainCity = @"全部";
            WJSearchTapCell *cell = (WJSearchTapCell *)[self.tabView viewWithTag:30000];
            [cell setTapText:[self.tabArray objectAtIndex:0]];
            
            if(self.minorCityArray.count > 0){
                [self.minorCityArray removeAllObjects];
            }
            
            self.searchManager.areaId = self.currentCityID;
            [self searchHeaderManager];
            
            //恢复筛选状态
            [self recoverState];
            
        }else{
            
            WJModelArea * area = [self.mainCityArray objectAtIndex:indexPath.row - 1];
            self.minorCityArray = [[WJDBAreaManager new] getSubAreaByParentId:area.areaId];
            [self.minorCityArray insertObject:@"全部" atIndex:0];
            
            self.currentArea = area;
            self.currentMainCity = area.name;
        }

        [self.mainCityTableView reloadData];
        [self.minorCityTableView reloadData];
        
        
    }else if(tableView == _minorCityTableView)
    {
        WJSearchTapCell *cell = (WJSearchTapCell *)[self.tabView viewWithTag:30000];
        
        if(indexPath.row == 0)
        {
            [cell setTapText:self.currentMainCity];
    
            self.currentMinorCity = [self.minorCityArray objectAtIndex:0];
            self.searchManager.areaId = self.currentArea.areaId;
            
        }else{
            
            self.currentArea = ((WJModelArea *)[self.minorCityArray  objectAtIndex:indexPath.row]);
            self.currentMinorCity = self.currentArea.name;
            [cell setTapText:self.currentArea.name];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            self.searchManager.areaId = self.currentArea.areaId;
        }
        
        [self.minorCityTableView reloadData];
        [self searchHeaderManager];
        
        //恢复筛选状态
        [self recoverState];
    }
    
    NSLog(@"%@",indexPath);
    NSLog(@"%s",__func__);
}


#pragma mark - WJRefreshTableView Delegate

- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
{
    
    if (!isHeaderRefresh && !isFooterRefresh) {
        isHeaderRefresh = YES;
        self.searchManager.shouldCleanData = YES;
        isShowMiddleLoadView = NO;

        [self searchHeaderManager];
    }

}

- (void)startFootRefreshToDo:(UITableView *)tableView
{
    if (!isFooterRefresh && !isHeaderRefresh) {
        isFooterRefresh = YES;
        isShowMiddleLoadView = NO;
        [self searchAppendManager];
    }

}

- (void)endGetData:(BOOL)needReloadData{
    
    if (isHeaderRefresh) {
        isHeaderRefresh = NO;
        [self.merchantTableView endHeadRefresh];
    }
    
    if (isFooterRefresh){
        isFooterRefresh = NO;
        [self.merchantTableView endFootFefresh];
    }
    
    if (needReloadData) {
        [self.merchantTableView reloadData];
    }
}

- (void)refreshFooterStatus:(BOOL)status{
    
    if (status) {
        [self.merchantTableView hiddenFooter];
    }else {
        [self.merchantTableView showFooter];
    }
    
    if (self.merchantArray.count > 0) {
        self.merchantTableView.tableFooterView = [UIView new];
    }else{
        self.merchantTableView.tableFooterView = nil;
    }
    
}


#pragma mark- Event Response

//点击搜索
- (void)gotoSearchVC{
    
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_SearchButton"];
    
    self.tabBarView.hidden = YES;
    WJSearchMerchantViewController * searchVC = [[WJSearchMerchantViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}


- (void)recoverState
{
    WJSearchTapCell * cell = (WJSearchTapCell *)[self.tabView viewWithTag:30000+self.currentTap];
//    [self searchTap:cell didSelectWithindex:self.currentTap];

    cell.moreImageView.highlighted = NO;
    cell.titleLabel.textColor = WJColorDarkGray;
}


//选择城市
- (void)chooseCityAction
{
    if (![self.view viewWithTag:1000]) {
        
        [self.view addSubview:self.cityView];
    }
    
    isCityViewShow = !isCityViewShow;
    chooseCityImageView.highlighted = !chooseCityImageView.highlighted;
    
    if (isCityViewShow) {
        
        if (self.currentTap >= 0) {
            WJSearchTapCell * cell = (WJSearchTapCell *)[self.tabView viewWithTag:30000+self.currentTap];
            if (cell.moreImageView.highlighted) {
                [self searchTap:cell didSelectWithindex:self.currentTap];
            }
        }
        
        self.cityView.hidden = NO;
        
    }else{
        self.cityView.hidden = YES;
    }
}


- (void)refreshAddress:(UIButton *)btn{

    if ([btn isKindOfClass:[UIButton class]]) {
        if([btn.titleLabel.text isEqualToString:@"立即开启"]){
            if (KSystomVersion >= 8.0) {
                NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:settingUrl];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            }
        }else{
            _positionLabel.text = @"定位中⋯";
            goSettingArrow.hidden = YES;
            [refreshBtn setTitle:nil forState:UIControlStateNormal];
            [self performSelector:@selector(updateLocation) withObject:nil afterDelay:0.2];
        }

    }else{
        _positionLabel.text = @"定位中⋯";
        [refreshBtn setTitle:nil forState:UIControlStateNormal];
        goSettingArrow.hidden = YES;
        [self performSelector:@selector(updateLocation) withObject:nil afterDelay:0.2];
    }
   
}


- (void)updateLocation
{
    //定位成功
    if ([LocationManager gpsAddress]) {
        //_positionLabel.text = [LocationManager gpsAddress];
        positionSuccess = YES;
      
        CGRect frame = self.merchantTableView.frame;
        frame.origin.y = self.tabView.bottom;
        frame.size.height = merchantTableHeight + CGRectGetHeight(backView.frame);
        self.merchantTableView.frame = frame;

    }else{
        
        //定位
        if([LocationManager gpsError]){
            positionSuccess = NO;
            
            if ([[LocationManager gpsError] code] == kCLErrorDenied)
            {
                //访问权限未开启
                _positionLabel.text = @"定位未开启，无法推荐附近商户";
                refreshBtn.frame = CGRectMake(SCREEN_WIDTH - ALD(82), 0, ALD(60), ALD(kLocationTipHeight));
                [refreshBtn setTitle:@"立即开启" forState:UIControlStateNormal];
                
                
                goSettingArrow.frame = CGRectMake(SCREEN_WIDTH - ALD(12) -ALD(10), (ALD(kLocationTipHeight) - ALD(10))/2, ALD(10), ALD(10));
                goSettingArrow.hidden = NO;
            }
            //无法获取位置信息
//          if ([[LocationManager gpsError] code] == kCLErrorLocationUnknown)
            else{
                _positionLabel.text = @"定位失败";
                goSettingArrow.hidden = YES;
                refreshBtn.frame = CGRectMake(SCREEN_WIDTH - ALD(72), 0, ALD(60), ALD(kLocationTipHeight));
                [refreshBtn setTitle:@"点击重试" forState:UIControlStateNormal];
            }
            
            CGRect frame = self.merchantTableView.frame;
            frame.origin.y = CGRectGetMaxY(backView.frame);
            frame.size.height = merchantTableHeight;
            self.merchantTableView.frame = frame;

        }
    
    }
    
    [self.merchantTableView reloadData];

}


- (void)tapShadowViewTakeBackWith:(UITapGestureRecognizer *)gesture
{
    WJSearchTapCell * cell = (WJSearchTapCell *)[self.tabView viewWithTag:30000+self.currentTap];
    if (cell.moreImageView.highlighted) {
        [self searchTap:cell didSelectWithindex:self.currentTap];
    }
}


#pragma mark- Getter and Setter

//商家列表
- (APISearchManager *)searchManager
{
    if (nil == _searchManager) {
        _searchManager = [[APISearchManager alloc] init];
        _searchManager.shouldParse = YES;
        _searchManager.delegate = self;
        _searchManager.categoryid = @"0";
        _searchManager.sort = @"distance";
        _searchManager.areaId = self.currentCityID;
    }
    
    _searchManager.longitude = [WJGlobalVariable sharedInstance].appLocation.longitude;
    _searchManager.latitude = [WJGlobalVariable sharedInstance].appLocation.latitude;

    return _searchManager;
}


//商家类别
- (APISearchOptionManager *)searchOptionManager
{
    if (nil == _searchOptionManager) {
        _searchOptionManager = [[APISearchOptionManager alloc] init];
        _searchOptionManager.delegate = self;
    }
    _searchOptionManager.city = [self.currentCityID integerValue];

    return _searchOptionManager;
}

- (WJRefreshTableView *)merchantTableView
{
    if (nil == _merchantTableView) {
        if (self.from == EnterFromTab) {
            _merchantTableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, ALD(kChooceTapHeight + kLocationTipHeight), kScreenWidth, SCREEN_HEIGHT -64 -kTabbarHeight - ALD(kChooceTapHeight + kLocationTipHeight))
                                                                     style:UITableViewStylePlain
                                                                refreshNow:NO
                                                           refreshViewType:WJRefreshViewTypeBoth];
            merchantTableHeight = _merchantTableView.height;
        }else{
           
            _merchantTableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, ALD(kChooceTapHeight + kLocationTipHeight), kScreenWidth, SCREEN_HEIGHT -64 -ALD(kChooceTapHeight + kLocationTipHeight))
                                                                     style:UITableViewStylePlain
                                                                refreshNow:NO
                                                           refreshViewType:WJRefreshViewTypeBoth];
            merchantTableHeight = _merchantTableView.height;
        }
        
        _merchantTableView.delegate = self;
        _merchantTableView.dataSource = self;
        _merchantTableView.backgroundColor = [UIColor whiteColor];
        _merchantTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _merchantTableView.translatesAutoresizingMaskIntoConstraints = NO;
//        _merchantTableView.automaticallyRefresh = YES;
    
    }
    
    return _merchantTableView;
}


- (UITableView *)mainCityTableView
{
    if (nil == _mainCityTableView) {

        _mainCityTableView =  [[UITableView alloc] initWithFrame:CGRectMake(0, ALD(kChooceTapHeight), kScreenWidth / 3, ALD(396)) style:UITableViewStylePlain];
        _mainCityTableView.delegate = self;
        _mainCityTableView.dataSource = self;
//        _mainCityTableView.separatorInset = UIEdgeInsetsZero;
        _mainCityTableView.tableFooterView = [[UIView alloc] init];
        _mainCityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        _mainCityTableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    
    return _mainCityTableView;
}


- (UITableView *)minorCityTableView
{
    if (nil == _minorCityTableView) {

        _minorCityTableView =  [[UITableView alloc] initWithFrame:CGRectMake((kScreenWidth / 3) , ALD(kChooceTapHeight), kScreenWidth *2/3, ALD(396)) style:UITableViewStylePlain];
        _minorCityTableView.backgroundColor = WJColorViewBg;
        _minorCityTableView.delegate = self;
        _minorCityTableView.dataSource = self;
        _minorCityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _minorCityTableView.tableFooterView = [[UIView alloc] init];

    }
    return _minorCityTableView;
}


- (UITableView *)foodTableView
{
    if (nil == _foodTableView) {

        _foodTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _foodTableView.delegate = self;
        _foodTableView.dataSource = self;
        _foodTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _foodTableView.bounces = NO;
        _foodTableView.tableFooterView = [[UIView alloc] init];
        _foodTableView.backgroundColor = [UIColor clearColor];
        
        //        _foodTableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];

    }
    return _foodTableView;
}


- (UITableView *)sortTableView
{
    if (nil == _sortTableView) {
        
        _sortTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _sortTableView.delegate = self;
        _sortTableView.dataSource = self;
        _sortTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sortTableView.bounces = NO;
        _sortTableView.tableFooterView = [[UIView alloc] init];
        _sortTableView.backgroundColor = [UIColor clearColor];
        
//        _foodTableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
    }
    return _sortTableView;
}



- (UIView *)tabView
{
    if (nil == _tabView) {
        _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(kChooceTapHeight))];
        for(int i = 0; i< 3; i++)
        {
            WJSearchTapCell * cell = [[WJSearchTapCell alloc] initWithFrame:CGRectMake( (kScreenWidth / 3) * i, 0, kScreenWidth / 3, ALD(kChooceTapHeight))];
            cell.tag = 30000 + i;
            [cell setTapText:[self.tabArray objectAtIndex:i]];
            cell.delegate = self;
            [_tabView addSubview:cell];
            
        }
        
        for (int j=0; j<2; j++) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake((j+1)*SCREEN_WIDTH/3, ALD(kChooceTapHeight-15)/2, 0.5, ALD(15))];
            line.backgroundColor = WJColorSeparatorLine;
            [_tabView addSubview:line];
        }
        
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(kChooceTapHeight) - 0.5, kScreenWidth, 0.5)];
        bottomLine.backgroundColor = WJColorSeparatorLine;
        [_tabView addSubview:bottomLine];
    }
    return _tabView;
}


- (WJCityView  *)cityView
{
    if (nil == _cityView) {
        
        _cityView = [[WJCityView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTabbarHeight -64)];
        _cityView.delegate = self;
        _cityView.tag = 1000;
    }
    _cityView.currentCity = _addressLabel.text?:@"北京";
    
    return _cityView;
}

- (UIView *)businessBackView
{
    if (nil == _businessBackView) {
        
        _businessBackView = [[UIView alloc] init];
        if(self.from == EnterFromTab){
            
            _businessBackView.frame = CGRectMake(0 , ALD(kChooceTapHeight), kScreenWidth, kScreenHeight - 64 - ALD(kChooceTapHeight) - kTabbarHeight);
            
        }else{
            _businessBackView.frame = CGRectMake(0 , ALD(kChooceTapHeight), kScreenWidth, kScreenHeight - 64 - ALD(kChooceTapHeight));
            
        }
        
        _businessBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    
    return _businessBackView;
}


- (NSMutableArray *)searchConditionArray
{
    if (nil == _searchConditionArray) {
        _searchConditionArray = [NSMutableArray array];
    }
    return _searchConditionArray;
}


- (NSArray *)merchantArray
{
    if(nil == _merchantArray)
    {
        _merchantArray = [NSArray array];
    }
    return _merchantArray;
}


- (NSMutableArray *)mainCityArray
{
    _mainCityArray = [[[WJDBAreaManager alloc] init] getSubAreaByParentId:self.currentCityID];

    return _mainCityArray;
}


- (NSMutableArray *)minorCityArray
{
    if(nil == _minorCityArray)
    {
        _minorCityArray = [NSMutableArray array];
        
    }
    return _minorCityArray;
}


- (NSMutableArray *)categaryArray
{
    if(nil == _categaryArray)
    {
        _categaryArray = [NSMutableArray array];
    }
  
    return _categaryArray;
}


- (NSArray *)tabArray
{
//    _tabArray = @[@"全部商圈", ([[self titleDic] objectForKey:self.searchManager.categoryid]!=nil?[[self titleDic] objectForKey:self.searchManager.categoryid]:@"全部分类"), @"智能排序"];
    _tabArray = @[@"全部商圈", @"全部分类", @"智能排序"];
    
    return _tabArray;
}


- (NSString *)currentCity
{
    _currentCity = [WJUtilityMethod dealWithAreaName:[LocationManager sharedInstance].choosedArea.name];

    return _currentCity;
}


- (NSString *)currentCityID
{
    _currentCityID = [LocationManager sharedInstance].choosedArea.areaId;
    
    return _currentCityID;
}


- (NSString *)currentCategary
{
    if (nil == _currentCategary) {
        
        _currentCategary = [self.tabArray objectAtIndex:1];
    }
    return _currentCategary;
}

- (NSString *)currentSort
{
    if (nil == _currentSort) {

        _currentSort = [self.searchConditionArray firstObject];
    }
    return _currentSort;
}

- (NSString *)currentMainCity
{
    if (nil == _currentMainCity) {
        
         _currentMainCity = @"全部";
    }
    return _currentMainCity;
}

- (NSString *)currentMinorCity
{
    if (nil == _currentMinorCity) {
        _currentMinorCity = @"全部";
    }
    return _currentMinorCity;
}

//- (NSDictionary *)titleDic
//{
//    return @{@"1":@"美食",@"2":@"丽人",@"3":@"生活",@"4":@"购物"};
//}

- (WJEmptyView *)emptyView
{
    if (nil == _emptyView) {
        _emptyView = [[WJEmptyView alloc] initWithFrame:CGRectMake(0, ALD(106), kScreenWidth, ALD(140))];
    }
    return _emptyView;
}

- (WJModelArea *)currentArea
{
    if (_currentArea == nil) {
        _currentArea = [[WJModelArea alloc] init];
    }
    return _currentArea;
}


@end
