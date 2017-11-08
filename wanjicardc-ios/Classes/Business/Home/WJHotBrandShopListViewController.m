//
//  WJHotBrandShopListViewController.m
//  WanJiCard
//
//  Created by silinman on 16/5/27.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJHotBrandShopListViewController.h"
#import "WJMerchantDetailController.h"
#import "WJEmptyView.h"
#import "WJRefreshTableView.h"

#import "WJMerchantListReformer.h"
#import "WJRecommendStoreModel.h"
#import "WJMerchantTableViewCell.h"
#import "WJSearchTapCell.h"
#import "APISearchOptionManager.h"
#import "WJCategateReformer.h"
#import "WJSearchConditionReformer.h"
#import "WJSearchConditionModel.h"
#import "WJFilterTableViewCell.h"
#import "APISearchManager.h"
#import "LocationManager.h"
#import "WJDBAreaManager.h"
#import "WJModelArea.h"
#import "WJSearchMerchantViewController.h"
#import "WJCityView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define kChooceTapHeight        44
#define kLocationTipHeight      32


@interface WJHotBrandShopListViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,APIManagerCallBackDelegate,SearchCellDelegate>
{
    BOOL                isHeaderRefresh;
    BOOL                isFooterRefresh;
    UILabel             *_positionLabel;
    BOOL                isCityViewShow;
    UIView              *backView;
    UIButton            *refreshBtn;
    UIImageView         *goSettingArrow;
    LocationManager     *locaManager;
    BOOL                positionSuccess;
    CGFloat             merchantTableHeight;
    BOOL                isShowMiddleLoadView;

}
@property (nonatomic, strong) WJRefreshTableView     *merchantTableView;
@property (nonatomic, strong) NSArray                *merchantArray;
@property (nonatomic, strong) WJEmptyView            *emptyView;

@property (nonatomic, strong) UITableView            *mainCityTableView;
@property (nonatomic, strong) UITableView            *minorCityTableView;
@property (nonatomic, strong) UITableView            *foodTableView;
@property (nonatomic, strong) UIView                 *businessBackView;

@property (nonatomic, strong) NSArray                *tabArray;
@property (nonatomic, strong) NSMutableArray         *mainCityArray;
@property (nonatomic, strong) NSMutableArray         *minorCityArray;
@property (nonatomic, strong) NSMutableArray         *searchConditionArray;

@property (nonatomic, strong) APISearchOptionManager *searchOptionManager;

@property (nonatomic, assign) int                    currentTap;
@property (nonatomic, strong) UIView                 *tabView;
@property (nonatomic, strong) NSString               *currentCategary;
@property (nonatomic, strong) NSString               *currentSort;
@property (nonatomic, strong) WJModelArea            *currentArea;
@property (nonatomic, strong) NSString               *currentMainCity;
@property (nonatomic, strong) NSString               *currentMinorCity;
@property (nonatomic, strong) NSString               *currentCity;
@property (nonatomic, strong) NSString               *currentCityID;
@property (nonatomic, assign) BOOL                   isRequesting;

@end

@implementation WJHotBrandShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isShowMiddleLoadView = YES;

    self.navigationController.navigationBar.translucent = NO;
    self.title = self.categoryTitle;
    self.currentTap = -1;
    self.view.backgroundColor = [UIColor whiteColor];
    isCityViewShow = NO;
    
    [self navigationSetup];
    [self UISetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshAddress:nil];
    self.searchManager.areaId = self.currentCityID;
    
    [self.searchOptionManager loadData];
    [self searchHeaderManager];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //城市恢复成默认状态
    WJSearchTapCell * tapCell = (WJSearchTapCell *)[self.tabView viewWithTag:30000];
    if (![tapCell.titleLabel.text isEqualToString:[self.tabArray objectAtIndex:0]]) {
        tapCell.moreImageView.highlighted = NO;
        tapCell.titleLabel.textColor = WJColorDarkGray;
        [tapCell setTapText:[self.tabArray objectAtIndex:0]];
        self.currentTap = 0;
    }
    
    self.minorCityArray = nil;
    self.currentMainCity = nil;
    self.currentMinorCity = nil;
    
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
}

- (void)tapShadowViewTakeBackWith:(UITapGestureRecognizer *)gesture
{
    WJSearchTapCell * cell = (WJSearchTapCell *)[self.tabView viewWithTag:30000+self.currentTap];
    if (cell.moreImageView.highlighted) {
        [self searchTap:cell didSelectWithindex:self.currentTap];
    }
}
- (void)navigationSetup
{
    
}

- (void)tap {
    self.mainCityTableView.hidden = YES;
    self.minorCityTableView.hidden = YES;
    self.foodTableView.hidden = YES;
    self.businessBackView.hidden = YES;
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
    
    if (!self.isRequesting) {
        
        if ([self.merchantTableView viewWithTag:20]) {
            self.emptyView.hidden = YES;
        }
        
        if (isShowMiddleLoadView) {
            [self showLoadingView];
            
        }
//        [self showLoadingView];
        
        self.isRequesting = YES;
        [self.searchManager loadData];
        [self tap];
    }
}

#pragma mark - SearchCellDelegate
- (void)searchTap:(WJSearchTapCell *)cell didSelectWithindex:(int)index
{
    
    for (int i =0; i<2; i++) {
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
            self.businessBackView.hidden = NO;
        }else{
            cell.titleLabel.textColor = WJColorDarkGray;
            self.businessBackView.hidden = YES;
        }
    }else{
        
        cell.moreImageView.highlighted = YES;
        cell.titleLabel.textColor = WJColorNavigationBar;
        self.businessBackView.hidden = NO;
    }
    
    switch (index) {
        case 0:
        {
            self.foodTableView.hidden = YES;
            if (index == self.currentTap) {
                self.mainCityTableView.hidden   = !self.mainCityTableView.hidden;
                self.minorCityTableView.hidden  = !self.minorCityTableView.hidden;
                
                if (!self.mainCityTableView.hidden) {
                    [self.mainCityTableView reloadData];
                    [self.minorCityTableView reloadData];
                }
                
                break;
            }
            self.currentTap = index;
            [self.mainCityTableView reloadData];
            [self.minorCityTableView reloadData];
            self.mainCityTableView.hidden = NO;
            self.minorCityTableView.hidden = NO;
            
        }
            break;
        case 1:
        {
            if ([WJUtilityMethod isNotReachable]) {
                
                self.mainCityTableView.hidden   = YES;
                self.minorCityTableView.hidden  = YES;
                if (index == self.currentTap) {
                    self.foodTableView.hidden = !self.foodTableView.hidden;
                    break;
                }
                self.foodTableView.hidden       = NO;
                self.currentTap                 = index;
                [self.foodTableView reloadData];
            }
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
        self.isRequesting = NO;
        [self hiddenLoadingView];
        
        self.merchantArray = [manager fetchDataWithReformer:[[WJMerchantListReformer alloc] init]];
        
        [self endGetData:YES];
        [self refreshFooterStatus:manager.hadGotAllData];
        
    }else if([manager isKindOfClass:[APISearchOptionManager class]])
    {
        self.searchConditionArray = [manager fetchDataWithReformer:[[WJSearchConditionReformer alloc] init]];
        [self.searchConditionArray insertObject:@"智能排序" atIndex:0];
        self.foodTableView.frame = CGRectMake(0, ALD(kChooceTapHeight), kScreenWidth, self.searchConditionArray.count *ALD(44));
        [self.foodTableView reloadData];
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self endGetData:NO];
    if([manager isKindOfClass:[APISearchManager class]])
    {
        self.isRequesting = NO;
        [self hiddenLoadingView];
        
        if (manager.errorType == APIManagerErrorTypeNoData) {
            self.merchantArray = nil;
            [self.merchantTableView reloadData];
        }
        
        if ([self.merchantArray count] == 0) {
            
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
        
    }else if(tableView == _foodTableView){
        return [self.searchConditionArray count];
        
    }else if (tableView == _mainCityTableView){
        return [self.mainCityArray count] + 1;
        
    }else if (tableView == _minorCityTableView){
        return [self.minorCityArray count];
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _merchantTableView) {
        return ALD(105);
    }else if(tableView == _foodTableView){
        return ALD(44);
    }else if(tableView == _mainCityTableView){
        return ALD(44);
    }else if(tableView == _minorCityTableView){
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
        
        WJSearchTapCell * cell = (WJSearchTapCell *)[self.tabView viewWithTag:30001];
        
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
        
        self.foodTableView.hidden = YES;
        [self.foodTableView reloadData];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self searchHeaderManager];
        
        //恢复筛选状态
        [self recoverState];
        
    }else if (tableView == _mainCityTableView)
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

- (void)recoverState
{
    self.currentTap = -1;
    
    for (int i =0; i<2; i++) {
        WJSearchTapCell * tapCell = (WJSearchTapCell *)[self.tabView viewWithTag:30000+i];
        tapCell.moreImageView.highlighted = NO;
        tapCell.titleLabel.textColor = WJColorDarkGray;
    }
}

- (void)refreshAddress:(UIButton *)btn{
    
    if ([btn isKindOfClass:[UIButton class]]) {
        if([btn.titleLabel.text isEqualToString:@"立即开启"]){
            NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingUrl];
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
                
                goSettingArrow.frame = CGRectMake(SCREEN_WIDTH - ALD(12) -ALD(10), ALD(kLocationTipHeight-10)/2, ALD(10), ALD(10));
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


#pragma mark- Getter and Setter

//商家列表
- (APISearchManager *)searchManager
{
    if (nil == _searchManager) {
        _searchManager = [[APISearchManager alloc] init];
        _searchManager.shouldParse = YES;
        _searchManager.delegate = self;
        _searchManager.categoryid = @"";
        _searchManager.areaId = self.currentCityID;
        _searchManager.sort = @"distance";
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
        
        
        _merchantTableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, ALD(kChooceTapHeight + kLocationTipHeight), kScreenWidth, SCREEN_HEIGHT -64 -ALD(kChooceTapHeight + kLocationTipHeight))
                                                                 style:UITableViewStylePlain
                                                            refreshNow:NO
                                                       refreshViewType:WJRefreshViewTypeBoth];
        merchantTableHeight = _merchantTableView.height;
        
        _merchantTableView.delegate = self;
        _merchantTableView.dataSource = self;
        _merchantTableView.backgroundColor = [UIColor whiteColor];
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
        //        _mainCityTableView.bounces = NO;
        //        _mainCityTableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    
    return _mainCityTableView;
}


- (UITableView *)minorCityTableView
{
    if (nil == _minorCityTableView) {
        
        _minorCityTableView =  [[UITableView alloc] initWithFrame:CGRectMake((kScreenWidth / 3) , ALD(kChooceTapHeight), kScreenWidth *2/3, ALD(396)) style:UITableViewStylePlain];
        
        _minorCityTableView.delegate = self;
        _minorCityTableView.dataSource = self;
        _minorCityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _minorCityTableView.tableFooterView = [[UIView alloc] init];
        //        _minorCityTableView.bounces = NO;
        //        _minorCityTableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _minorCityTableView;
}

- (UITableView *)foodTableView
{
    if (nil == _foodTableView) {

        _foodTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ALD(kChooceTapHeight), kScreenWidth, kScreenHeight - 64 - ALD(kChooceTapHeight)) style:UITableViewStylePlain];
        _foodTableView.delegate = self;
        _foodTableView.dataSource = self;
        _foodTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _foodTableView.bounces = NO;
        _foodTableView.tableFooterView = [[UIView alloc] init];
        _foodTableView.backgroundColor = [UIColor clearColor];
        
    }
    return _foodTableView;
}

- (UIView *)tabView
{
    if (nil == _tabView) {
        _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(kChooceTapHeight))];
        for(int i = 0; i < 2; i++)
        {
            WJSearchTapCell * cell = [[WJSearchTapCell alloc] initWithFrame:CGRectMake( (kScreenWidth / 2) * i, 0, kScreenWidth / 2, ALD(kChooceTapHeight))];
            cell.tag = 30000 + i;
            [cell setTapText:[self.tabArray objectAtIndex:i]];
            cell.delegate = self;
            [_tabView addSubview:cell];
            
        }
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, ALD(kChooceTapHeight-15)/2, 0.5, ALD(15))];
        line.backgroundColor = WJColorSeparatorLine;
        [_tabView addSubview:line];
        
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(kChooceTapHeight) - 1, kScreenWidth, 1)];
        bottomLine.backgroundColor = WJColorDarkGrayLine;
        [_tabView addSubview:bottomLine];
    }
    return _tabView;
}

- (UIView *)businessBackView
{
    if (nil == _businessBackView) {
        
        _businessBackView = [[UIView alloc] init];
        _businessBackView.frame = CGRectMake(0 , ALD(kChooceTapHeight), kScreenWidth, kScreenHeight - 64 - ALD(kChooceTapHeight));
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

- (NSArray *)tabArray
{
    _tabArray = @[@"全部商圈", @"智能排序"];
    
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
