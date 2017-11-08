//
//  WJHomeViewController.m
//  WanJiCard
//
//  Created by 孙明月 on 16/5/11.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJHomeViewController.h"
#import "WJMerchantMapViewController.h"
#import "WJShopAndCardsTableViewCell.h"
#import "UINavigationBar+Awesome.h"

#import "WJRefreshTableView.h"
#import "WJAdScrollingView.h"
#import "WJAdScrollingCell.h"
#import "WJCategoryTableViewCell.h"
#import "WJActivityTableViewCell.h"
#import "WJHotBrandTableViewCell.h"
#import "WJCommendTableViewCell.h"
#import "WJCheckAllShopTableViewCell.h"
#import "Reachability.h"
#import "WJHotBrandListViewController.h"
#import "WJHotBrandShopListViewController.h"
#import "WJCityView.h"
#import "APIHomePageTopManager.h"
#import "WJHomePageTopReformer.h"
#import "APIHomePageBottomManager.h"
#import "APIMoreBrandesManager.h"
#import "LocationManager.h"
#import "WJDBAreaManager.h"
#import "WJHomePageBottomReformer.h"
#import "WJMessageCenterViewController.h"
#import "WJMerchantListViewController.h"
#import "WJHomeCardDetailsViewController.h"
#import "APIUnReadMessagesManger.h"
#import "WJUnReadMessagesReformer.h"
#import "WJUnReadMessagesModel.h"
#import "WJHomePageBottomModel.h"
#import "WJHomePageCardsModel.h"
#import "WJMerchantDetailController.h"
#import "WJLoginViewController.h"
#import "WJSystemAlertView.h"
#import "WJWebViewController.h"
#import "WJHomePageCityActivityModel.h"
#import "WJHomePageCityActivityModel.h"
#import "WJHomePageCategoriesModel.h"
#import "WJMoreBrandesModel.h"
#import "WJHomePageActivitiesModel.h"
#import "WJStatisticsManager.h"
#import "WJFairECardListTableViewCell.h"
#import "WJEleCardDeteilViewController.h"
#import "WJCardPackageViewController.h"
#import "WJMyBaoziViewController.h"
#import "WJECardModel.h"
#import "WJElectronicCardListViewController.h"
#import "WJReceiptViewController.h"
#import "WJCardExchangeListController.h"

static CGFloat ImageHight = 225.0f;
#define NavigationBarHight 64.0f

@interface WJHomeViewController ()<WJRefreshTableViewDelegate,UITableViewDataSource, UITableViewDelegate,WJCityViewDelegate,APIManagerCallBackDelegate,CLLocationManagerDelegate,WJSystemAlertViewDelegate>{
    BOOL            isHeaderRefresh;
    BOOL            isCityViewShow;
    BOOL            positionSuccess;
    CGFloat         alpha;
    UIColor         *color;
    UILabel         *_addressLabel;
    UIImageView     *chooseCityImageView;
    UIView          *backView;
    UIView          *messagePoint;
    
    BOOL            isShowMiddleLoadView;
}
@property (nonatomic, strong) WJRefreshTableView        *tableView;
@property (nonatomic, strong) UIImageView               *imageView;
@property (nonatomic, strong) WJAdScrollingView         *adScrollingView;
@property (nonatomic, strong) WJCityView                *cityView;
@property (nonatomic, strong) NSString                  *currentMainCity;
@property (nonatomic, strong) NSString                  *currentMinorCity;
@property (nonatomic, strong) NSString                  *currentCity;
@property (nonatomic, strong) NSString                  *currentCityID;
@property (nonatomic, strong) APIHomePageTopManager     *homePageTopManager;
@property (nonatomic, strong) APIHomePageBottomManager  *homePageBottomManager;
@property (nonatomic, strong) APIMoreBrandesManager     *moreBrandesManager;
@property (nonatomic, strong) APIUnReadMessagesManger   *unReadMessagesManger;
@property (nonatomic, strong) WJHomePageBottomReformer  *bottomResormer;
@property (nonatomic, strong) WJHomePageTopReformer     *topResormer;
@property (nonatomic, strong) NSMutableArray            *bottomDataArray;
@property (nonatomic, strong) NSMutableDictionary       *topDataDic;
@property (nonatomic, strong) NSMutableArray            *activitiesArray;
@property (nonatomic, strong) NSMutableArray            *brandsArray;
@property (nonatomic, strong) NSMutableArray            *categoriesArray;
@property (nonatomic, strong) NSMutableArray            *cityActivityArray;
@property (nonatomic, strong) WJUnReadMessagesModel     *unReadMessagesModel;
@property (nonatomic, strong) WJHomePageCityActivityModel *model;

@end

@implementation WJHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    color = WJColorNavigationBar;
    alpha = 0;
    [self readCacheData];
    [self registerHomeDataNotification];
    [self UISetup];
    
    isShowMiddleLoadView = YES;

    [self requestData];
    self.eventID = @"iOS_vie_HomeView";
    
}
- (void)refershMsgData{
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
    if (defaultPerson) {
        [self.unReadMessagesManger loadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self changeNetworkConnections];
    //注册通知
    [self registerNotification];
    [self refershMsgData];

    self.tabBarView.hidden = NO;

    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
//    if (![_addressLabel.text isEqualToString:self.currentCity]) {
//        _addressLabel.text = self.currentCity;
//        [self.cityView.cityTableView reloadData];
//        CGFloat addWith = [UILabel getWidthWithTitle:self.currentCity font:WJFont14];
//        _addressLabel.frame = CGRectMake(0, 0, addWith, ALD(25));
//        chooseCityImageView.frame = CGRectMake(_addressLabel.right + ALD(5), _addressLabel.y + ALD(9), ALD(8), ALD(8));
//        
//        isShowMiddleLoadView = YES;
//
//        [self requestData];
//    }
    [self requestData];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar lt_reset];
    //移除通知
    [self removeNotifications];
    
//    if ([self.view viewWithTag:1000]) {
//        //如果城市是展开状态，收回
//        if (isCityViewShow) {
//            
//            isCityViewShow = NO;
//            chooseCityImageView.highlighted = NO;
//            self.cityView.hidden = YES;
//        }
//    }
}
//检查网络连接
- (void)changeNetworkConnections{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
            
        case NotReachable:{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请检查网络连接"];
        }
            break;
        case ReachableViaWWAN:
            
            break;
        case ReachableViaWiFi:
            
            break;
            
    }
}

- (void)readCacheData{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *topFilePath = [path stringByAppendingPathComponent:@"homeTopData.txt"];
    NSString *bottomFilePath = [path stringByAppendingPathComponent:@"homeBottomData.txt"];
    //首部
    NSData *topData = [NSData dataWithContentsOfFile:topFilePath
                                             options:0
                                               error:NULL];
    NSString *topJsonStr = [[NSString alloc]initWithData:topData encoding:NSUTF8StringEncoding];
    NSDictionary *topDic = [self.class dictionaryWithJsonString:topJsonStr];
    //底部
    NSData *bottomData = [NSData dataWithContentsOfFile:bottomFilePath
                                             options:0
                                               error:NULL];
    NSString *bottomJsonStr = [[NSString alloc]initWithData:bottomData encoding:NSUTF8StringEncoding];
//    NSDictionary *bottomDic = [self.class dictionaryWithJsonString:bottomJsonStr];
    
    NSArray *bottomArr = [self.class arrayWithJsonString:bottomJsonStr];

    
    if (topDic != nil) {
        NSMutableArray * activitiesArray    = [NSMutableArray array];
        NSMutableArray * brandsArray        = [NSMutableArray array];
        NSMutableArray * categoriesArray    = [NSMutableArray array];
        NSMutableArray * cityActivityArray  = [NSMutableArray array];
        if ([topDic isKindOfClass:[NSDictionary class]]) {
            
            for (id obj in [topDic objectForKey:@"activities"]) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    WJHomePageActivitiesModel * activities = [[WJHomePageActivitiesModel alloc] initWithDictionary:obj];
                    [activitiesArray addObject:activities];
                }
            }
            for (id obj in [topDic objectForKey:@"brands"]) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    WJMoreBrandesModel * brands = [[WJMoreBrandesModel alloc] initWithDictionary:obj];
                    [brandsArray addObject:brands];
                }
            }
            for (id obj in [topDic objectForKey:@"categories"]) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    WJHomePageCategoriesModel * categories = [[WJHomePageCategoriesModel alloc] initWithDictionary:obj];
                    [categoriesArray addObject:categories];
                }
            }
            for (id obj in [topDic objectForKey:@"cityActivity"]) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    WJHomePageCityActivityModel * cityActivity = [[WJHomePageCityActivityModel alloc] initWithDictionary:obj];
                    [cityActivityArray addObject:cityActivity];
                }
            }
            
        }
        NSMutableDictionary * resultDic  = [NSMutableDictionary dictionaryWithObjectsAndKeys:activitiesArray,@"activities",brandsArray,@"brands",categoriesArray,@"categories",cityActivityArray,@"cityActivity", nil];
        
        self.activitiesArray    = [resultDic objectForKey:@"activities"];
        self.brandsArray        = [resultDic objectForKey:@"brands"];
        self.categoriesArray    = [resultDic objectForKey:@"categories"];
        self.cityActivityArray  = [resultDic objectForKey:@"cityActivity"];

    }
    if (bottomArr != nil) {
        
//        if ([bottomDic isKindOfClass:[NSDictionary class]]) {
//            for (id obj in [bottomDic objectForKey:@"branch"]) {
//                if ([obj isKindOfClass:[NSDictionary class]]) {
////                    WJHomePageBottomModel * branch = [[WJHomePageBottomModel alloc] initWithDictionary:obj];
//                    WJECardModel *branch = [[WJECardModel alloc] initWithDictionary:obj];
//                    [self.bottomDataArray addObject:branch];
//                }
//            }
//        }
        
//        if ([bottomDic isKindOfClass:[NSDictionary class]]) {
//            
//            for (id object in bottomDic) {
//                if ([object isKindOfClass:[NSArray class]]) {
//                    
//                    for (id obj in object) {
//                        
//                        if ([obj isKindOfClass:[NSDictionary class]]) {
//                            
//                            WJECardModel *model = [[WJECardModel alloc] initWithDictionary:obj];
//                            [self.bottomDataArray addObject:model];
//                        }
//                    }
//                    
//                }
//            }
//        }
        if ([bottomArr isKindOfClass:[NSArray class]]) {
            for (id object in bottomArr) {
                if ([object isKindOfClass:[NSDictionary class]]) {
                    WJECardModel *model = [[WJECardModel alloc] initWithDictionary:object];
                    [self.bottomDataArray addObject:model];
                }
            }
        }
    }
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSArray *)arrayWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}

#pragma mark - 请求数据
- (void)requestData{
    
    if (isShowMiddleLoadView) {
        [self showLoadingView];
        
    } 
    //请求顶部数据
    [self.homePageTopManager loadData];
}

#pragma mark - 通知相关
- (void)registerHomeDataNotification{
    __weak typeof(self) weakSelf = self;
    
    //定位成功后刷新首页数据
    [kDefaultCenter addObserverForName:@"RefershLocationData" object:nil queue:nil usingBlock:^(NSNotification *note) {
        __strong typeof(self) strongSelf = weakSelf;
//        [strongSelf judgeOpenCity];
        [strongSelf requestData];

    }];
    

    //从后台进入app刷新首页数据
    [kDefaultCenter addObserverForName:@"HomePageRefershData" object:nil queue:nil usingBlock:^(NSNotification *note) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf changeNetworkConnections];
        [strongSelf requestData];
    }];
    
    //从登陆页登陆后跳转到消息
    [kDefaultCenter addObserver:self selector:@selector(pushForHomeMessage:) name:@"LoginForHomeMessage" object:nil];

    //从登陆页登陆后跳转到webView
    [kDefaultCenter addObserver:self selector:@selector(pushForWebView:) name:@"LoginFromWebView" object:nil];
    //从登录页登陆后跳转到卡包
    [kDefaultCenter addObserver:self selector:@selector(pushForPayCode:) name:@"LoginForHomePayCode" object:nil];
    //从登录页登陆后跳转到我的包子
    [kDefaultCenter addObserver:self selector:@selector(pushForMyBaoziView:) name:@"LoginFromHomeMyBaoziView" object:nil];

    //从登陆页登陆后跳转到卡兑换
    [kDefaultCenter addObserver:self selector:@selector(pushForCarExchange:) name:@"LoginFromCardExchange" object:nil];
}

- (void)pushForWebView:(NSNotification *)note
{
    WJWebViewController *webVC = [[WJWebViewController alloc] init];
    
    if ([self.model.isLogin boolValue]) {
        WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
        NSString * sysVersionStr = [@"&sysVersion="stringByAppendingString:kSystemVersion];
        NSString * appVersionStr = [@"&appVersion="stringByAppendingString:AppVersion];
        NSString * urlStr = [self.model.url stringByAppendingFormat:@"%@,%@,%@",person.token?:@"",sysVersionStr,appVersionStr];
        [webVC loadWeb:urlStr];
    }else{
        NSString * appVersionStr = [@"?appVersion="stringByAppendingString:AppVersion];
        [webVC loadWeb:[self.model.url stringByAppendingString:appVersionStr]];
    }
    webVC.titleStr = self.model.category;
    self.tabBarView.hidden = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)pushForCarExchange:(NSNotification *)note
{
    WJCardExchangeListController   *cardExchangeVC = [[WJCardExchangeListController alloc] init];
    [self.navigationController pushViewController:cardExchangeVC animated:YES];
    self.tabBarView.hidden = YES;
}


- (void)pushForHomeMessage:(NSNotification *)note
{
    WJMessageCenterViewController *messageVC = [[WJMessageCenterViewController alloc]init];
    [self.navigationController pushViewController: messageVC animated:YES whetherJump:NO];
    self.tabBarView.hidden = YES;
}

- (void)pushForPayCode:(NSNotification *)note
{
    WJCardPackageViewController * cardPackageVC = [[WJCardPackageViewController alloc] init];
    [self.navigationController pushViewController: cardPackageVC animated:YES whetherJump:NO];
    self.tabBarView.hidden = YES;
}

- (void)pushForMyBaoziView:(NSNotification *)note
{
    WJMyBaoziViewController *baoziVC = [[WJMyBaoziViewController alloc] init];
    [self.navigationController pushViewController:baoziVC animated:YES whetherJump:NO];
    self.tabBarView.hidden = YES;

}

//
//- (void)judgeOpenCity{
//    //判断定位是否成功
//    if ([LocationManager sharedInstance].currentArea.name) {
//        NSArray *openCityArray = [NSArray arrayWithArray:[[WJDBAreaManager new] getAreaByLevel:2]];
//        
//        BOOL openCity = NO;
//        for (WJModelArea *cityStr in openCityArray) {
//            if ([cityStr.name isEqualToString:[LocationManager sharedInstance].currentArea.name]) {
//                openCity = YES;
//                break;
//            }
//        }
//        //判断定位城市有没有开通万集卡服务
//        if (openCity) {
//            //如果开通,则判断选择的城市和定位城市是否相同
//            if (![[LocationManager sharedInstance].currentArea.name isEqualToString:[LocationManager sharedInstance].choosedArea.name]) {
//                WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"系统定位到您在%@，需要切换至%@吗？",[LocationManager sharedInstance].currentArea.name,[LocationManager sharedInstance].currentArea.name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" textAlignment:NSTextAlignmentCenter];
//                alert.delegate = self;
//                alert.alertTag = 111;
//                [alert showIn];
//            }else{
//                [self requestData];
//            }
//        }else{
//            //未开通则提示，显示北京数据
//            WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"系统定位到您在%@,我们还未开通该地区的服务哦,点击确定按钮进入北京抢先体验",[LocationManager sharedInstance].currentArea.name] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定" textAlignment:NSTextAlignmentCenter];
//            alert.delegate = self;
//            alert.alertTag = 222;
//            [alert showIn];
//        }
//        
//    }else{
//        //定位失败,判断是否有定位权限
//        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
//        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
//            //未开启定位提示开启
//            WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:@"未开启定位服务" message:@"请进入系统设置中开启定位服务：设置>隐私>位置>定位服务>万集卡>开启定位服务”中打开" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即开启" textAlignment:NSTextAlignmentCenter];
//            alert.delegate = self;
//            alert.alertTag = 333;
//            [alert showIn];
//            
//        }else{
//            //已开启定位，定位失败
//            //            [self requestData];
//        }
//    }
//}

//- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    if (buttonIndex == 1) {
//        switch (alertView.tag) {
//            case 111:{
//                [LocationManager sharedInstance].choosedArea = [LocationManager sharedInstance].currentArea;
//                self.currentCity = [WJUtilityMethod dealWithAreaName:[LocationManager sharedInstance].currentArea.name];
//                _addressLabel.text = self.currentCity;
//                CGFloat addWith = [UILabel getWidthWithTitle:self.currentCity font:WJFont14];
//                _addressLabel.frame = CGRectMake(0, 0, addWith, ALD(25));
//                chooseCityImageView.frame = CGRectMake(_addressLabel.right + ALD(5), _addressLabel.y + ALD(9), ALD(8), ALD(8));
//                [self.cityView.cityTableView reloadData];
//                [self requestData];
//            }
//                break;
//            case 222:
//                
//                break;
//            case 333:{
//                
//                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                if([[UIApplication sharedApplication] canOpenURL:url]) {
//                    NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                    [[UIApplication sharedApplication] openURL:url];
//                }
//            }
//                break;
//                
//            default:
//                break;
//        }
//    }
//    
//    
//}

//注册通知
- (void)registerNotification{
    //分类列表
    [kDefaultCenter addObserver:self selector:@selector(pushForCategoryVC:) name:@"PushForCategoryVC" object:nil];
    //热门品牌更多列表页
    [kDefaultCenter addObserver:self selector:@selector(pushForHotBrandVC:) name:@"PushForHotBrandVC" object:nil];
    //品牌商家列表页
    [kDefaultCenter addObserver:self selector:@selector(pushForHotBrandShopVC:) name:@"PushForHotBrandShopVC" object:nil];
    //商家卡详情页
    [kDefaultCenter addObserver:self selector:@selector(pushForShopDetails:) name:@"PushForShopDetails" object:nil];
    //活动点击事件
    [kDefaultCenter addObserver:self selector:@selector(pushForWebVC:) name:@"PushForWebVC" object:nil];

}
//移除通知
- (void)removeNotifications{
    [kDefaultCenter removeObserver:self name:@"PushForCategoryVC" object:nil];
    [kDefaultCenter removeObserver:self name:@"PushForHotBrandVC" object:nil];
    [kDefaultCenter removeObserver:self name:@"PushForHotBrandShopVC" object:nil];
    [kDefaultCenter removeObserver:self name:@"PushForShopDetails" object:nil];
    [kDefaultCenter removeObserver:self name:@"PushForWebVC" object:nil];
}

#pragma mark - 通知相应方法
//分类列表
- (void)pushForCategoryVC:(NSNotification *)note
{
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_Classification"];
    NSInteger type = [[note.userInfo objectForKey:@"key"] integerValue];
    NSString  *name = [note.userInfo objectForKey:@"name"];
    WJMerchantListViewController * merchantListVC = [[WJMerchantListViewController alloc] init];
    merchantListVC.categoryTitle = name;
    merchantListVC.searchManager.categoryid = [NSString stringWithFormat:@"%ld",(long)type];
    merchantListVC.from = EnterFromCategory;
    [self.navigationController pushViewController:merchantListVC animated:YES];
    self.tabBarView.hidden = YES;
}

//热门品牌 更多列表页
- (void)pushForHotBrandVC:(NSNotification *)note
{
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_Brand"];
    WJHotBrandListViewController *hotVC = [[WJHotBrandListViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:hotVC animated:YES];
    self.tabBarView.hidden = YES;
}

//品牌商家列表页
- (void)pushForHotBrandShopVC:(NSNotification *)note
{
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_HotBrand"];
    NSString *name                      = [note.userInfo objectForKey:@"name"];
    NSString *merchantAccountId         = [note.userInfo objectForKey:@"merchantAccountId"];
    NSString *merchantBranchId          = [note.userInfo objectForKey:@"merchantBranchId"];
    BrandType     brandType             = [[note.userInfo objectForKey:@"type"] integerValue];
    
    if (brandType == BrandTypeElectronicCard ) {
        //电子卡列表
        WJElectronicCardListViewController *eCardListVC = [[WJElectronicCardListViewController alloc] init];
        eCardListVC.title = name;
        eCardListVC.merchantBranchId = merchantBranchId;
        [self.navigationController pushViewController:eCardListVC animated:YES];
        self.tabBarView.hidden = YES;
        
    } else {
        //商家卡列表
        WJHotBrandShopListViewController *hotVC = [[WJHotBrandShopListViewController alloc] init];
        hotVC.categoryTitle = name;
        hotVC.searchManager.merchantAccountId = merchantAccountId;
        [self.navigationController pushViewController:hotVC animated:YES];
        self.tabBarView.hidden = YES;
    }
}
//商家详情
- (void)pushForShopDetails:(NSNotification *)note
{
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_RecommendMerchant"];
    WJMerchantDetailController *hotVC = [[WJMerchantDetailController alloc] initWithNibName:nil bundle:nil];
    hotVC.merId = [note.userInfo objectForKey:@"key"];
    [self.navigationController pushViewController:hotVC animated:YES];
    self.tabBarView.hidden = YES;
}

//活动点击事件
- (void)pushForWebVC:(NSNotification *)note
{
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_Special"];
    NSString *url                       = [note.userInfo objectForKey:@"url"] ;
    NSString *name                      = [note.userInfo objectForKey:@"name"];
    NSInteger activityType              = [[note.userInfo objectForKey:@"type"] integerValue];
    NSString *merchantName              = [note.userInfo objectForKey:@"merchantName"];
    NSString *brandName                 = [note.userInfo objectForKey:@"brandName"];
    NSString *merchantAccountId         = [note.userInfo objectForKey:@"merchantAccountId"];
    NSString *merchantId                = [note.userInfo objectForKey:@"merchantId"];
    NSString *merchantBranchId          = [note.userInfo objectForKey:@"merchantBranchId"];
    NSString *isLogin                   = [note.userInfo objectForKey:@"isLogin"];

    switch (activityType) {
        case 1://H5
        {
            self.model.category = name;
            self.model.url = url;
            self.model.isLogin = isLogin;
            if ([isLogin boolValue]) {
                if ([WJGlobalVariable sharedInstance].defaultPerson) {
                    [self pushForWebView:nil];
                }else{
                    WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
                    loginVC.from = LoginFromWebView;
                    WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
                    [self.navigationController presentViewController:nav animated:YES completion:nil];
                }
            }else{
                [self pushForWebView:nil];
            }
        }
            break;
        case 2://商家卡品牌列表
        {
            WJHotBrandShopListViewController *hotVC = [[WJHotBrandShopListViewController alloc] initWithNibName:nil bundle:nil];
            hotVC.categoryTitle = brandName;
            hotVC.searchManager.merchantAccountId = merchantAccountId;
            [self.navigationController pushViewController:hotVC animated:YES];
            self.tabBarView.hidden = YES;
            
        }
            break;
        case 3://商家卡详情
        {
            WJHomeCardDetailsViewController *cardVC = [[WJHomeCardDetailsViewController alloc] initWithNibName:nil bundle:nil];
            cardVC.cardID       = url;
            cardVC.cardIndex    = 0;
            cardVC.titleStr     = merchantName;
            cardVC.merchantID   = merchantId;
            [self.navigationController pushViewController:cardVC animated:YES whetherJump:NO];
            self.tabBarView.hidden = YES;
        }
            break;
        
        case 4://电子卡品牌列表
        {
            WJElectronicCardListViewController *eCardListVC = [[WJElectronicCardListViewController alloc]
                                                               initWithNibName:nil bundle:nil];
            eCardListVC.title = brandName;
            eCardListVC.merchantBranchId = merchantBranchId;
            [self.navigationController pushViewController:eCardListVC animated:YES];
            self.tabBarView.hidden = YES;
            
        }
            break;
        case 5://现金转账
        {
            WJReceiptViewController   *cashVC = [[WJReceiptViewController alloc] init];
            cashVC.select = 0;
            [self.navigationController pushViewController:cashVC animated:YES];
            self.tabBarView.hidden = YES;
        }
            break;
        case 6 :
        {
            if ([isLogin boolValue]) {
                if ([WJGlobalVariable sharedInstance].defaultPerson) {
                    [self pushForCarExchange:nil];
                }else{
                    WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
                    loginVC.from = LoginFromCardExchange;
                    WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
                    [self.navigationController presentViewController:nav animated:YES completion:nil];
                }
            }else{
                [self pushForCarExchange:nil];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LocationManager Delegate

//- (void)gpsUpdate:(id)locateResult
//{
//    //定位成功
//    if ([locateResult isKindOfClass:[NSString class]]) {
////        _addressLabel.text = [LocationManager gpsAddress];
////        CGFloat addWith = [UILabel getWidthWithTitle:self.currentCity font:WJFont14];
////        _addressLabel.frame = CGRectMake(0, 0, addWith, ALD(25));
////        chooseCityImageView.frame = CGRectMake(_addressLabel.right + ALD(5), _addressLabel.y + ALD(9), ALD(8), ALD(8));
//        positionSuccess = YES;
//    }
//    
//    if ([locateResult isKindOfClass:[NSError class]]) {
//        
//        positionSuccess = NO;
//        
//        if ([locateResult code] == kCLErrorDenied)
//        {
//            //访问权限未开启
//            
//        }
//        if ([locateResult code] == kCLErrorLocationUnknown) {
//            //无法获取位置信息
//        }
//        
//    }
//    [self.tableView reloadData];
//}
#pragma mark - WJRefreshTableView Delegate
- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isHeaderRefresh) {
        isHeaderRefresh = YES;
        self.homePageBottomManager.shouldCleanData = YES;
        self.homePageTopManager.shouldCleanData = YES;
        isShowMiddleLoadView = NO;
        [self searchHomeManager];
    }
    
}
- (void)searchHomeManager{
    [self requestData];
}

- (void)endGetData:(BOOL)needReloadData{
    
    if (isHeaderRefresh) {
        isHeaderRefresh = NO;
        [self.tableView endHeadRefresh];
    }
    
    if (needReloadData) {
        [self.tableView reloadData];
    }
}
#pragma mark - UITableViewDelegate&DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
//    if (self.bottomDataArray.count != 0) {
//        if (self.bottomDataArray.count > 10) {
//            return 12;
//        }
//        return self.bottomDataArray.count + 2;
//    }
    
    if (self.bottomDataArray.count != 0) {
        return 2;
        
    } else {
        return 1;
    }
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        if (indexPath.row == 0) {
            return ALD(40);
        }
//        if (self.bottomDataArray.count != 0) {
//            if (indexPath.row == self.bottomDataArray.count + 1) {
//                return ALD(65);
//            }
//            return ALD(155);
//        }else{
//            return ALD(65);
//        }
        
        if (self.bottomDataArray.count == 0) {
            return 0;
        }else{

            if (self.bottomDataArray.count > 2) {
                return  ALD(185) + ALD((self.bottomDataArray.count/2 + self.bottomDataArray.count%2 - 1) * 170);
            }else{
                return  ALD(185);
            }
        }

    }else{
        CGFloat height;
        switch (indexPath.row) {
            case 0:
                
                height = ALD(225);
                
                break;
            case 1:
                height = 0;
                break;
            case 2:
            
                if (self.brandsArray.count < 1 || self.brandsArray == nil) {
                    height = 0;
                }else{
                    height = ALD(130);
                }
                break;
            case 3:

                if ([self.activitiesArray count] == 0) {
                    height = 0;
                } else {
                    height = ALD(100);
                }
                break;
            default:
                return ALD(225);
                break;
        }
        return height;
    }
    return ALD(225);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cardDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                static NSString *cellNames = @"cardDetails";
                UITableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:cellNames];
                if(!cells){
                    cells = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNames];
                    cells.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                CGRect frame = CGRectMake(0, 0, kScreenWidth, ALD(225));
                if (self.cityActivityArray.count > 1) {
                    __weak typeof(self) weakSelf = self;
                    _adScrollingView = [[WJAdScrollingView alloc]initWithFrame:frame imageArray:self.cityActivityArray selectImageHandle:^(NSInteger index) {
                        __strong typeof(self) strongSelf = weakSelf;
                        NSLog(@"点击的是第%zd图片",index);
                        if (index < strongSelf.cityActivityArray.count) {
                            [strongSelf selectForActivity:index];
                            
                        }else{
                            
                        }

                    }];
                    [cells addSubview:self.adScrollingView];
                }else{
                    UIImageView *backIV = [[UIImageView alloc] initWithFrame:frame];
                    backIV.backgroundColor = [UIColor redColor];
                    if (self.cityActivityArray.count == 1) {
                        WJHomePageCityActivityModel *model = [self.cityActivityArray objectAtIndex:0];
                        [backIV sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"home_banner_default"]];
                    }else{
                        backIV.image = [UIImage imageNamed:@"home_banner_default"];
                    }
                    [cells addSubview:backIV];
                }

                return cells;

            }
                break;
            case 1:{
//                if (self.categoriesArray.count == 0) {
                    return cell;
//                }
//                WJCategoryTableViewCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"WJCategoryTableViewCell"];
//                if (!categoryCell) {
//                    categoryCell = [[WJCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJCategoryTableViewCell" ];
//                    categoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
//
//                [categoryCell configData:self.categoriesArray];
//                return categoryCell;

            }
                break;
            case 2:{
                if (self.brandsArray.count == 0) {
                    return cell;
                }
                WJHotBrandTableViewCell *hotBrandCell = [tableView dequeueReusableCellWithIdentifier:@"WJHotBrandTableViewCell"];
                if (!hotBrandCell) {
                    hotBrandCell = [[WJHotBrandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJHotBrandTableViewCell" ];
                    hotBrandCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                [hotBrandCell configData:self.brandsArray];
                return hotBrandCell;
            }
            
                break;
            case 3:{
                if (self.activitiesArray.count == 0) {
                    return cell;
                }
                WJActivityTableViewCell *activityCell = [tableView dequeueReusableCellWithIdentifier:@"WJActivityTableViewCell"];
                if (!activityCell) {
                    activityCell = [[WJActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJActivityTableViewCell" ];
                    activityCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                [activityCell configData:self.activitiesArray];
                return activityCell;
            }
                break;
                
            default:
                break;
        }
        
        
    }else{
        if (self.bottomDataArray.count != 0) {
            if (indexPath.row == 0) {
                WJCommendTableViewCell *commendCell = [tableView dequeueReusableCellWithIdentifier:@"WJCommendTableViewCell"];
                if (!commendCell) {
                    commendCell = [[WJCommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJCommendTableViewCell" ];
                    commendCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                return commendCell;
                
            }
//            else if(indexPath.row == self.bottomDataArray.count + 1){
//                WJCheckAllShopTableViewCell *checkCell = [tableView dequeueReusableCellWithIdentifier:@"WJCheckAllShopTableViewCell"];
//                if (!checkCell) {
//                    checkCell = [[WJCheckAllShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJCheckAllShopTableViewCell" ];
//                    checkCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
//                return checkCell;
//            }
            else {
//                NSString *CellIdentifier = [NSString stringWithFormat:@"WJShopAndCardsTableViewCell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
//                WJShopAndCardsTableViewCell *shopAndCardsCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//                if (!shopAndCardsCell) {
//                    shopAndCardsCell = [[WJShopAndCardsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//                    shopAndCardsCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
//                shopAndCardsCell.tag = 10086 + indexPath.row;
//                __weak typeof(self) weakSelf = self;
//                WJHomePageBottomModel *model = [self.bottomDataArray objectAtIndex:indexPath.row - 1];
//                [shopAndCardsCell sendPicUrls:model selectImageHandle:^(NSInteger index) {
//                    NSLog(@"第%zd张图片",index);
//                    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_RecommendCard"];
//                    __strong typeof(self) strongSelf = weakSelf;
//                    WJHomePageCardsModel *cards = [model.cardsArray objectAtIndex:index];
//                    WJHomeCardDetailsViewController *cardVC = [[WJHomeCardDetailsViewController alloc] initWithNibName:nil bundle:nil];
//                    cardVC.cardID       = cards.cardId;
//                    cardVC.cardIndex    = index;
//                    cardVC.titleStr     = cards.merchantName;
//                    cardVC.merchantID   = model.merchantId;
//                    [strongSelf.navigationController pushViewController:cardVC animated:YES whetherJump:NO];
//                    strongSelf.tabBarView.hidden = YES;
//                }];
//                if (self.bottomDataArray.count == 0) {
//                    return cell;
//                }
//                return shopAndCardsCell;
                
                NSString *CellIdentifier = [NSString stringWithFormat : @"WJFairECardListTableViewCell%ld%ld", indexPath.section,indexPath.row];
                WJFairECardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (!cell) {
                    cell = [[WJFairECardListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                __weak typeof(self)weakSelf = self;
                cell.selectECardBlock = ^(WJECardModel *model){
                    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_Ecardclick"];
                    WJEleCardDeteilViewController * eCardVC = [[WJEleCardDeteilViewController alloc] init];
                    eCardVC.eCardModel = model;
                    model.isEntitycard = NO;
                    eCardVC.electronicCardComeFrom = ComeFromHome;
                    [weakSelf.navigationController pushViewController:eCardVC animated:YES ];
                    weakSelf.tabBarView.hidden = YES;
                };
                [cell configData:[NSMutableArray arrayWithArray:self.bottomDataArray]];
                return cell;
            }
        }else{
            if (self.bottomDataArray.count == 0 && self.activitiesArray.count == 0 && self.brandsArray.count == 0 && self.cityActivityArray.count == 0 && self.categoriesArray.count == 0) {
                return cell;
            }
            if (indexPath.row == 0) {
                WJCommendTableViewCell *commendCell = [tableView dequeueReusableCellWithIdentifier:@"WJCommendTableViewCell"];
                if (!commendCell) {
                    commendCell = [[WJCommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJCommendTableViewCell" ];
                    commendCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                return commendCell;
                
            }
//            else{
//                WJCheckAllShopTableViewCell *checkCell = [tableView dequeueReusableCellWithIdentifier:@"WJCheckAllShopTableViewCell"];
//                if (!checkCell) {
//                    checkCell = [[WJCheckAllShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WJCheckAllShopTableViewCell" ];
//                    checkCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
//                return checkCell;
//            }
        }

    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath.section == 1 && indexPath.row == self.bottomDataArray.count + 1 && self.bottomDataArray.count != 0) {
//        [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_moreMerchant"];
//        WJMerchantListViewController *merVC = [[WJMerchantListViewController alloc] initWithNibName:nil bundle:nil];
//        merVC.from = EnterFromHome;
//        [self.navigationController pushViewController:merVC animated:YES whetherJump:NO];
//        self.tabBarView.hidden = YES;
//    }else if(indexPath.section == 0 && indexPath.row == 0 && self.cityActivityArray.count == 1){
//        [self selectForActivity:0];
//    }
    
    if (indexPath.section == 0 && indexPath.row == 0 && self.cityActivityArray.count == 1) {
        [self selectForActivity:0];
    }
}
#pragma mark- Event Activity
- (void)selectForActivity:(NSInteger)index{
    WJHomePageCityActivityModel *model = [self.cityActivityArray objectAtIndex:index];
    self.model = model;
    NSInteger activityType = [model.type integerValue];
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_HomeBanner"];
    switch (activityType) {
        case 1://H5
        {
            if ([model.isLogin boolValue]) {
                if ([WJGlobalVariable sharedInstance].defaultPerson) {
                    [self pushForWebView:nil];
                }else{
                    WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
                    loginVC.from = LoginFromWebView;
                    WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
                    [self.navigationController presentViewController:nav animated:YES completion:nil];
                    
                }
            }else{
                [self pushForWebView:nil];
            }
        }
            break;
        case 2://商家品牌列表
        {
            WJHotBrandShopListViewController *hotVC = [[WJHotBrandShopListViewController alloc] initWithNibName:nil bundle:nil];
            hotVC.categoryTitle = model.brandName;
            hotVC.searchManager.merchantAccountId = model.merchantAccountId;
            [self.navigationController pushViewController:hotVC animated:YES];
            self.tabBarView.hidden = YES;
            
        }
            break;
        case 3://商家卡详情
        {
            WJHomeCardDetailsViewController *cardVC = [[WJHomeCardDetailsViewController alloc] initWithNibName:nil bundle:nil];
            cardVC.cardID       = model.url;
            cardVC.cardIndex    = 0;
            cardVC.titleStr     = model.merchantName;
            cardVC.merchantID   = model.merchantId;
            [self.navigationController pushViewController:cardVC animated:YES whetherJump:NO];
            self.tabBarView.hidden = YES;
        }
            break;
        case 4://电子卡品牌列表
        {
            WJElectronicCardListViewController *eCardListVC = [[WJElectronicCardListViewController alloc]
                                                               initWithNibName:nil bundle:nil];
            eCardListVC.title = model.brandName;
            eCardListVC.merchantBranchId = model.merchantBranchId;
            [self.navigationController pushViewController:eCardListVC animated:YES];
            self.tabBarView.hidden = YES;

        }
        case 5://现金转账
        {
            WJReceiptViewController   *cashVC = [[WJReceiptViewController alloc] init];
            cashVC.select = 0;
            [self.navigationController pushViewController:cashVC animated:YES];
            self.tabBarView.hidden = YES;
        }
            break;
        case 6 :
        {
            if ([model.isLogin boolValue]) {
                if ([WJGlobalVariable sharedInstance].defaultPerson) {
                    [self pushForCarExchange:nil];
                }else{
                    WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
                    loginVC.from = LoginFromCardExchange;
                    WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
                    [self.navigationController presentViewController:nav animated:YES completion:nil];
                }
            }else{
                [self pushForCarExchange:nil];
            }
        }
            break;
            

        default:
            break;
    }
}
#pragma mark- ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < - 64 ) {
        self.navigationController.navigationBar.hidden = YES;
    }else{
        
        self.navigationController.navigationBar.hidden = NO;
        self.title = @"首页";
        CGFloat tempOffset = ALD(ImageHight - 64*3);
        if (offsetY > tempOffset) {
            CGFloat temp = ALD(ImageHight - 64*2 ) - offsetY ;
            
            color = WJColorNavigationBar;
            alpha = MIN(1, 1 - temp / ALD(64));
        }

        if (offsetY == - 64) {
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
            self.title = @"";

        }else{
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        }
    }

    
}
#pragma mark- Event Response
//选择城市
//- (void)chooseCityAction
//{
//    
//    if (![self.view viewWithTag:1000]) {
//        
//        [self.view addSubview:self.cityView];
//    }
//    
//    isCityViewShow = !isCityViewShow;
//    chooseCityImageView.highlighted = !chooseCityImageView.highlighted;
//    
//    if (isCityViewShow) {
//        self.navigationController.navigationBar.translucent = NO;
//        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:1]];
//        self.cityView.hidden = NO;
//        _cityView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTabbarHeight-64);
//
//    }else{
//        self.navigationController.navigationBar.translucent = YES;
//        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
//        self.cityView.hidden = YES;
//
//    }
//}

//左上消息按钮
- (void)pushForMessage{
    
//    if ([self.view viewWithTag:1000]) {
//        //如果城市是展开状态，收回
//        if (isCityViewShow) {
//            
//            isCityViewShow = NO;
//            chooseCityImageView.highlighted = NO;
//            self.cityView.hidden = YES;
//        }
//    }
    if ([WJGlobalVariable sharedInstance].defaultPerson) {
        WJMessageCenterViewController *messageVC = [[WJMessageCenterViewController alloc]init];
        [self.navigationController pushViewController: messageVC animated:YES whetherJump:NO];
        self.tabBarView.hidden = YES;
    }else{
        WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
        loginVC.from = LoginFromHomeMessage;
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

//右上卡包按钮
- (void)pushForCardPackage
{
    if ([WJGlobalVariable sharedInstance].defaultPerson) {
        
        WJCardPackageViewController * cardPackageVC = [[WJCardPackageViewController alloc] init];
        [self.navigationController pushViewController: cardPackageVC animated:YES whetherJump:NO];
        self.tabBarView.hidden = YES;

        
    }else{
        WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
        loginVC.from = LoginFromCardPack;
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

//右上包子按钮
- (void)pushForBaoziView
{
    if ([WJGlobalVariable sharedInstance].defaultPerson) {
        
        WJMyBaoziViewController *baoziVC = [[WJMyBaoziViewController alloc] init];
        [self.navigationController pushViewController:baoziVC animated:YES whetherJump:NO];
        self.tabBarView.hidden = YES;
        
    }else{
        WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
        loginVC.from = LoginFromHomeMyBaoziView;
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }

}

#pragma mark - privateMethod
- (void)UISetup
{
    [self.view addSubview:self.tableView];
    [_tableView hiddenFooter];
    [self navigationSetup];
}

- (void)navigationSetup
{
    self.view.backgroundColor = WJColorViewBg2;
    [self hiddenBackBarButtonItem];
    
//    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
//    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCityAction)];
//    [leftView addGestureRecognizer:tap];
//    
//    _addressLabel                   = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//    _addressLabel.hidden = YES;
//    _addressLabel.font              = WJFont14;
//    _addressLabel.textAlignment     = NSTextAlignmentCenter;
//    _addressLabel.textColor         = WJColorWhite;
//    _addressLabel.text              = self.currentCity;
//    CGFloat addWith = [UILabel getWidthWithTitle:self.currentCity font:WJFont14];
//    _addressLabel.frame = CGRectMake(0, 0, addWith, ALD(25));
//  
//    chooseCityImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_btn_location_nor"] highlightedImage:[UIImage imageNamed:@"Home_btn_location_pressed"]];
//    chooseCityImageView.frame = CGRectMake(_addressLabel.right + ALD(5), _addressLabel.y + ALD(9), ALD(8), ALD(8));
//    
//    [leftView addSubview:_addressLabel];
//    [leftView addSubview:chooseCityImageView];
    
//    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
//    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, ALD(19), ALD(19));
    [leftButton setImage:[UIImage imageNamed:@"nav_message"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(pushForMessage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    messagePoint = [[UIView alloc] initWithFrame:CGRectMake(ALD(13), -ALD(2), ALD(9), ALD(9))];
    messagePoint.backgroundColor = WJColorAmount;
    messagePoint.layer.cornerRadius = messagePoint.width/2;
    messagePoint.layer.masksToBounds = YES;
    messagePoint.hidden = YES;
    [leftButton addSubview:messagePoint];
    
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ALD(55), ALD(20))];

    UIButton *baoziButton = [UIButton buttonWithType:UIButtonTypeCustom];
    baoziButton.frame = CGRectMake(0, 0, ALD(19), ALD(19));
    [baoziButton setImage:[UIImage imageNamed:@"nav_baozi"] forState:UIControlStateNormal];
    [baoziButton addTarget:self action:@selector(pushForBaoziView) forControlEvents:UIControlEventTouchUpInside];

    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = CGRectMake(rightView.width - ALD(19), 0, ALD(19), ALD(19));
    [scanButton setImage:[UIImage imageNamed:@"nav_kabao"] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(pushForCardPackage) forControlEvents:UIControlEventTouchUpInside];
    
    [rightView addSubview:baoziButton];
    [rightView addSubview:scanButton];
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}


#pragma mark - WJCityView Delegate

//- (void)updateCity:(WJCityView *)cityView
//{
//    if(isCityViewShow){
//        isCityViewShow = NO;
//        chooseCityImageView.highlighted = NO;
//        self.cityView.hidden = YES;
//        self.navigationController.navigationBar.translucent = YES;
//        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//        
//        if (![_addressLabel.text isEqualToString:self.currentCity]) {
//            
//            //修改城市名
//            _addressLabel.text = self.currentCity;
//            CGFloat addWith = [UILabel getWidthWithTitle:self.currentCity font:WJFont14];
//            _addressLabel.frame = CGRectMake(0, 0, addWith, ALD(25));
//            chooseCityImageView.frame = CGRectMake(_addressLabel.right + ALD(5), _addressLabel.y + ALD(9), ALD(8), ALD(8));
//            [self.tableView setContentOffset:CGPointMake(0, -NavigationBarHight) animated:YES];
//            [self requestData];
//        }
//    }
//}


//- (void)takeBackView:(WJCityView *)cityView
//{
//    [self chooseCityAction];
//}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"成功 == %@",manager);
    if([manager isKindOfClass:[APIHomePageTopManager class]])
    {
        self.activitiesArray    = nil;
        self.brandsArray        = nil;
        self.categoriesArray    = nil;
        self.cityActivityArray  = nil;
        self.topDataDic         = [NSMutableDictionary dictionaryWithDictionary:[manager fetchDataWithReformer:[[WJHomePageTopReformer alloc] init]]];
        self.activitiesArray    = [_topDataDic objectForKey:@"activities"];
        self.brandsArray        = [_topDataDic objectForKey:@"brands"];
        self.categoriesArray    = [_topDataDic objectForKey:@"categories"];
        self.cityActivityArray  = [_topDataDic objectForKey:@"cityActivity"];

        
        //请求底部数据
        [self.homePageBottomManager loadData];
    }
    if([manager isKindOfClass:[APIHomePageBottomManager class]])
    {
        self.bottomDataArray = nil;
        self.bottomDataArray = [manager fetchDataWithReformer:[[WJHomePageBottomReformer alloc] init]];
        [self endGetData:YES];
        [self hiddenLoadingView];
    }
    if([manager isKindOfClass:[APIUnReadMessagesManger class]]){
        self.unReadMessagesModel =[manager fetchDataWithReformer:[[WJUnReadMessagesReformer alloc] init]];
        if (_unReadMessagesModel.ifRead != nil && ![_unReadMessagesModel.ifRead isEqualToString: @""] && ![_unReadMessagesModel.ifRead isEqualToString: @"0"]) {
            messagePoint.hidden = NO;
        }else{
            messagePoint.hidden = YES;
        }
        NSLog(@"未读消息：%@",_unReadMessagesModel.ifRead);
    }

}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    if([manager isKindOfClass:[APIUnReadMessagesManger class]]){
        NSLog(@"是否有未读消息失败");
        messagePoint.hidden = YES;
    }
    if([manager isKindOfClass:[APIHomePageBottomManager class]])
    {
        NSLog(@"首页底部失败");
        self.bottomDataArray = nil;
        [self endGetData:YES];
        [self hiddenLoadingView];
    }
    if([manager isKindOfClass:[APIHomePageTopManager class]])
    {
        NSLog(@"首页顶部失败");
        [self endGetData:NO];
        [self hiddenLoadingView];
    }
}


#pragma mark- Getter and Setter
// TODO:所有属性的初始化，都写在这
- (APIUnReadMessagesManger *)unReadMessagesManger
{
    if (nil == _unReadMessagesManger) {
        _unReadMessagesManger = [[APIUnReadMessagesManger alloc] init];
        _unReadMessagesManger.delegate = self;
    }
    return _unReadMessagesManger;
}

- (APIHomePageTopManager *)homePageTopManager
{
    if (nil == _homePageTopManager) {
        _homePageTopManager = [[APIHomePageTopManager alloc] init];
        _homePageTopManager.delegate = self;
    }
    _homePageTopManager.areaId = self.currentCityID;
    return _homePageTopManager;
}

- (NSString *)currentCityID
{
    _currentCityID = [LocationManager sharedInstance].choosedArea.areaId;
    
    return _currentCityID;
}

- (NSString *)currentCity
{
    _currentCity = [WJUtilityMethod dealWithAreaName:[LocationManager sharedInstance].choosedArea.name];
    
    return _currentCity;
}

- (APIHomePageBottomManager *)homePageBottomManager
{
    if (nil == _homePageBottomManager) {
        _homePageBottomManager = [[APIHomePageBottomManager alloc] init];
        _homePageBottomManager.delegate = self;
    }
//    _homePageBottomManager.areaId = self.currentCityID;
//    if ([WJGlobalVariable sharedInstance].appLocation.longitude == 0 || [WJGlobalVariable sharedInstance].appLocation.latitude == 0) {
//        _homePageBottomManager.longitude = [LocationManager sharedInstance].choosedArea.lng;
//        _homePageBottomManager.latitude = [LocationManager sharedInstance].choosedArea.lat;
//    }else{
//        _homePageBottomManager.longitude = [WJGlobalVariable sharedInstance].appLocation.longitude;
//        _homePageBottomManager.latitude = [WJGlobalVariable sharedInstance].appLocation.latitude;
//    }

    return _homePageBottomManager;
}
- (WJRefreshTableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, -NavigationBarHight, kScreenWidth, kScreenHeight + kNavigationBarHeight + kStatusBarHeight)
                                                         style:UITableViewStylePlain
                                                    refreshNow:NO
                                               refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

//- (WJCityView  *)cityView
//{
//    if (nil == _cityView) {
//        
//        _cityView = [[WJCityView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTabbarHeight-64)];
//        _cityView.delegate = self;
//        _cityView.tag = 1000;
//    }
//    _cityView.currentCity = _addressLabel.text?:@"北京";
//
//    return _cityView;
//}

- (NSMutableArray *)bottomDataArray
{
    if(nil == _bottomDataArray)
    {
        _bottomDataArray = [NSMutableArray array];
    }
    return _bottomDataArray;
}
- (NSMutableDictionary *)topDataDic
{
    if (nil == _topDataDic) {
        _topDataDic = [NSMutableDictionary dictionary];
    }
    return _topDataDic;
}
- (NSMutableArray *)activitiesArray
{
    if(nil == _activitiesArray)
    {
        _activitiesArray = [NSMutableArray array];
    }
    return _activitiesArray;
}
- (NSMutableArray *)brandsArray
{
    if(nil == _brandsArray)
    {
        _brandsArray = [NSMutableArray array];
    }
    return _brandsArray;
}
- (NSMutableArray *)categoriesArray
{
    if(nil == _categoriesArray)
    {
        _categoriesArray = [NSMutableArray array];
    }
    return _categoriesArray;
}
- (NSMutableArray *)cityActivityArray
{
    if(nil == _cityActivityArray)
    {
        _cityActivityArray = [NSMutableArray array];
    }
    return _cityActivityArray;
}

- (WJHomePageCityActivityModel *)model
{
    if (nil == _model) {
        _model = [[WJHomePageCityActivityModel alloc] init];
    }
    return _model;
}

@end
