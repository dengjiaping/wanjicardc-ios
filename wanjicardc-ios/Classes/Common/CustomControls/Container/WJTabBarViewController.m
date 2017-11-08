//
//  WJTabBarViewController.m
//  WanJiCard
//
//  Created by 孙明月 on 16/5/9.
//  Copyright © 2016年 zOne. All rights reserved.
//
#import "AppDelegate.h"
#import "WJTabBarViewController.h"
#import "WJNavigationController.h"

#import "WJHomeViewController.h"
#import "WJMerchantListViewController.h"
#import "WJCardPackageViewController.h"
#import "WJFairViewController.h"

//#import "WanJiCard-Swift.h"
//#import "WanJiCard_InHouse-Swift.h"
#import "WJDBPersonManager.h"
#import "WJLoginViewController.h"

#import "WJHomeCardDetailsViewController.h"
#import "WJPayCompleteController.h"
#import "WJPayCompleteModel.h"
#import "WJWebViewController.h"

#import "WJSystemAlertView.h"
#import "WJUpgradeAlert.h"
#import "WJPsdVerifyAlert.h"
#import "WJPassView.h"


#import "WJMyBaoziViewController.h"
#import "WJBaoziOrderConfirmController.h"
#import "WJEleCardDeteilViewController.h"
#import "WJBaoziPayCompleteController.h"
#import "WJCardShopViewController.h"
#import "WJMyIndividualViewController.h"


#define IMAGE_W 22
#define IMAGE_H 22
#define LABEL_W 60
#define LABEL_H 20

@interface WJTabBarViewController ()
{
    UIImageView *_backGroundImageView;
    NSArray *_titlesArray;
    NSArray *_normalImages;
    NSArray *_highlightedImages;
    
    WJCardPackageViewController *cardVC;
    
    BOOL isShow;      //是否弹出过被踢出的弹窗
}
@end

@implementation WJTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBar setHidden:YES];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [kDefaultCenter addObserver:self selector:@selector(logOutFromPush:) name:kNoLogin object:nil];
    [kDefaultCenter addObserver:self selector:@selector(loginForPayCode) name:@"LoginForPayCode" object:nil];
    [kDefaultCenter addObserver:self selector:@selector(changeNoKicked) name:@"NOKickedOut" object:nil];
    
    
    isShow = NO;
//    _titlesArray = @[@"首页",@"商家",@"卡包",@"市集",@"我的"];
    _titlesArray = @[@"首页",@"包子商城",@"卡商城",@"我的"];

//    _normalImages = @[@"tab_btn_home_nor",@"tab_btn_business_nor",@"home_menu_Card_nor",@"tab_ic_fair",@"tab_btn_my_nor"];
//    _highlightedImages = @[@"tab_btn_home_pressed",@"tab_btn_business_-pressed",@"home_menu_Card_nor",@"tab_ic_fair_press",@"tab_btn_my_-pressed"];
    
    _normalImages = @[@"tab_btn_home_nor",@"tab_ic_fair",@"tab_btn_business_nor",@"tab_btn_my_nor"];
    _highlightedImages = @[@"tab_btn_home_pressed",@"tab_ic_fair_press",@"tab_btn_business_-pressed",@"tab_btn_my_-pressed"];
    
    
    //自定义tabBar
    [self createCustomTabBarView];
    
    //关联viewController
    [self createViewControllerToTabBarView];
}


//自定义tab
- (void)createCustomTabBarView
{
    //底图
    _backGroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kTabbarHeight, SCREEN_WIDTH, kTabbarHeight)];
    _backGroundImageView.image = [UIImage imageNamed:@"tab_backImage"];
    _backGroundImageView.userInteractionEnabled = YES;
    [self.view addSubview:_backGroundImageView];
    
#pragma mark 标签
    for (int i=0; i<_titlesArray.count; i++) {
        
        CGFloat buttonWidth = SCREEN_WIDTH/_titlesArray.count;
        
        UIButton * itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.tag = 100+i;
        [itemButton addTarget:self action:@selector(clickTabBarAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backGroundImageView addSubview:itemButton];
        
        UIImageView *tabImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[_normalImages objectAtIndex:i]] highlightedImage:[UIImage imageNamed:[_highlightedImages objectAtIndex:i]]];
        [itemButton addSubview:tabImageView];
        
//        if (i != 2) {
        
            itemButton.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, kTabbarHeight);
            tabImageView.frame = CGRectMake((buttonWidth-IMAGE_W)/2, 7, IMAGE_W, IMAGE_H);
            
            UILabel * itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, tabImageView.bottom, buttonWidth, LABEL_H)];
            itemLabel.text = [_titlesArray objectAtIndex:i];
            itemLabel.backgroundColor = [UIColor clearColor];
            itemLabel.textAlignment = NSTextAlignmentCenter;
            itemLabel.font = WJFont10;
            [itemButton addSubview:itemLabel];
            
            if (i == 0) {
                tabImageView.highlighted = YES;
                itemLabel.textColor = WJColorNavigationBar;
            }else{
                tabImageView.highlighted = NO;
                itemLabel.textColor = WJColorDardGray6;
            }
//        }else{
//            
//            itemButton.frame = CGRectMake(i * buttonWidth, -14, buttonWidth, 63);
//            tabImageView.frame = CGRectMake((buttonWidth-56)/2, 0, 56, 58);
//        }
    }
    
}


- (void)changeTabIndex:(NSInteger)index{
    
    UIButton * indexButton = (UIButton *)[_backGroundImageView viewWithTag:100+index];
    [self clickTabBarAction:indexButton];
}


//点击button响应事件
//- (void)clickTabBarAction:(id)sender
//{
//    UIButton * button = (UIButton *)sender;
//    
//    //点击卡包未登录时，弹登录页面
//    WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
//    if (button.tag == 102 && (nil == person || nil == person.token || person.token.length == 0)) {
//        
//        WJLoginViewController * loginVC = [[WJLoginViewController alloc] init];
//        loginVC.from = LoginFromCardPack;
//        WJNavigationController *nvc = [[WJNavigationController alloc] initWithRootViewController:loginVC];
//        [self presentViewController:nvc animated:YES completion:nil];
//        
//    }else{
//        
//        for (int j = 0; j<_titlesArray.count; j++) {
//            
//            //如果点击卡包
//            if(button.tag -100 == 2){
//                //                //改变其他tab状态
//                //                if(j != 2){
//                //                    UIButton *normalBtn = [_backGroundImageView viewWithTag:j+100];
//                //                    ((UIImageView *)normalBtn.subviews[0]).highlighted = NO;
//                //                    ((UILabel *)normalBtn.subviews[1]).textColor = WJColorDardGray6;
//                //                }
//                
//                //记录点击卡包前的controller
//                [WJGlobalVariable sharedInstance].tabBarIndex = self.selectedIndex;
//                
//            }else{
//                
//                //点击其他
//                if(j != 2){
//                    //点击的tab变选中
//                    if (button.tag-100 == j) {
//                        ((UIImageView *)button.subviews[0]).highlighted = YES;
//                        ((UILabel *)button.subviews[1]).textColor = WJColorNavigationBar;
//                        
//                    }else{
//                        
//                        UIButton *normalBtn = [_backGroundImageView viewWithTag:j+100];
//                        ((UIImageView *)normalBtn.subviews[0]).highlighted = NO;
//                        ((UILabel *)normalBtn.subviews[1]).textColor = WJColorDardGray6;
//                    }
//                }
//            }
//        }
//        
//        self.selectedIndex = button.tag - 100;
//        
//        
//        //商家列表
//        if(self.selectedIndex == 1){
//            
//            [kDefaultCenter postNotificationName:@"ReloadMerchant" object:nil];
//        }
//        
//    }
//    
//}

- (void)clickTabBarAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    
    for (int j = 0; j<_titlesArray.count; j++) {
        
        //点击的tab变选中
        if (button.tag-100 == j) {
            ((UIImageView *)button.subviews[0]).highlighted = YES;
            ((UILabel *)button.subviews[1]).textColor = WJColorNavigationBar;
            
        }else{
            
            UIButton *normalBtn = [_backGroundImageView viewWithTag:j+100];
            ((UIImageView *)normalBtn.subviews[0]).highlighted = NO;
            ((UILabel *)normalBtn.subviews[1]).textColor = WJColorDardGray6;
        }
    }
    
    self.selectedIndex = button.tag - 100;
    
    //卡商城
    if(self.selectedIndex == 2){
        
//        [kDefaultCenter postNotificationName:@"ReloadMerchant" object:nil];
        [kDefaultCenter postNotificationName:@"ReloadCardShop" object:nil];

    }
    
    if (self.selectedIndex ==1) {
        
        [kDefaultCenter postNotificationName:@"ReloadFair" object:nil];
        
    }
    
}



//关联viewController
- (void)createViewControllerToTabBarView
{
    //首页
    WJHomeViewController *homeVC = [[WJHomeViewController alloc] init];
    homeVC.tabBarView = _backGroundImageView;
    WJNavigationController *homeNav = [[WJNavigationController alloc] initWithRootViewController:homeVC];
    
    //商家
//    WJMerchantListViewController *merchantListVC = [[WJMerchantListViewController alloc] init];
//    merchantListVC.tabBarView = _backGroundImageView;
//    merchantListVC.from = EnterFromTab;
//    WJNavigationController *merchantNav = [[WJNavigationController alloc] initWithRootViewController:merchantListVC];
    
    //卡包
//    cardVC = [[WJCardPackageViewController alloc] init];
//    cardVC.tabBarView = _backGroundImageView;
//    WJNavigationController *cardNav = [[WJNavigationController alloc] initWithRootViewController:cardVC];
    
    //活动
    //    WJActivityThemeController *activityVC = [[WJActivityThemeController alloc] init];
    //    activityVC.tabBarView = _backGroundImageView;
    //    WJNavigationController *activityNav = [[WJNavigationController alloc] initWithRootViewController:activityVC];
    
    //包子商城
    WJFairViewController *fairVC = [[WJFairViewController alloc] init];
    fairVC.tabBarView = _backGroundImageView;
    WJNavigationController *fairNav = [[WJNavigationController alloc] initWithRootViewController:fairVC];
    
    
    WJCardShopViewController *cardShopVC = [[WJCardShopViewController alloc] init];
    cardShopVC.tabBarView = _backGroundImageView;
    WJNavigationController *cardShopNav = [[WJNavigationController alloc] initWithRootViewController:cardShopVC];
    
    
    ///我的
    WJMyIndividualViewController *indiCenterVC = [[WJMyIndividualViewController alloc] init];
    indiCenterVC.tabBarView = _backGroundImageView;
    WJNavigationController *indiCenterNav = [[WJNavigationController alloc] initWithRootViewController:indiCenterVC];
    
//    self.viewControllers = @[homeNav,merchantNav,cardNav,fairNav,indiCenterNav];
//    self.viewControllers = @[homeNav,fairNav,merchantNav,indiCenterNav];
    self.viewControllers = @[homeNav,fairNav,cardShopNav,indiCenterNav];

    [self changeTabIndex:0];
    
}


#pragma mark - notification
//登录后恢复值
- (void)changeNoKicked
{
    isShow = NO;
}


//点击卡包登录后
- (void)loginForPayCode
{
//    [self changeTabIndex:2];
    
    WJNavigationController *nav = (WJNavigationController *)self.selectedViewController;
    [nav dismissViewControllerAnimated:NO completion:nil];
    [nav popToRootViewControllerAnimated:NO];

    WJCardPackageViewController *cardPackageVC = [[WJCardPackageViewController alloc] init];
    cardPackageVC.tabBarView = _backGroundImageView;
    [nav pushViewController:cardPackageVC animated:YES];
}


//3D Touch进来
- (void)enterFromTouchWithIndex:(NSInteger)index{
    
    WJNavigationController *nav = (WJNavigationController *)self.selectedViewController;
    [nav dismissViewControllerAnimated:NO completion:nil];
    [nav popToRootViewControllerAnimated:NO];
    
//    [self changeTabIndex:index];
    
//    if (index == 2) {
//        [cardVC monitorPayCodeView];
//    }
    
    if (index == 1) {
       
        [self changeTabIndex:2];
        
    } else if (index == 2) {
        
        if ([WJGlobalVariable sharedInstance].defaultPerson) {
            
            WJCardPackageViewController * cardPackageVC = [[WJCardPackageViewController alloc] init];
            cardPackageVC.tabBarView = _backGroundImageView;
            [nav pushViewController:cardPackageVC animated:YES];
            
        }else{
            
            WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
            loginVC.from = LoginFrom3DTouchPayCode;
            WJNavigationController *Navigation = [[WJNavigationController alloc] initWithRootViewController:loginVC];
            [nav presentViewController:Navigation animated:YES completion:nil];

        }
        
    }
}


//踢出登录（接口）
- (void)logOutFromPush:(NSNotification *)notification
{
    NSString *msg = [notification object];
    [self forcedLoginOut:msg];
}


//踢出登录
- (void)forcedLoginOut:(NSString *)showMsg
{
    WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
    if (person) {
        [person logout];
        [self alertRemove];
        
        if (!isShow) {
            isShow = YES;
            [[TKAlertCenter defaultCenter] postAlertWithMessage:showMsg];
        }
        WJNavigationController *nav = (WJNavigationController *)self.selectedViewController;
//        if(self.selectedIndex == 2){
//            
//            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
//            //回到首页
//            [self changeTabIndex:0];
//            
//        }else if(self.selectedIndex == 3){
//            //向市集发送一个通知
//            [kDefaultCenter postNotificationName:@"LogOutForFair" object:nil];
//            
//            UIViewController *currentVC = [nav visibleViewController];
//            
//            //我的包子、充值确认、电子卡详情、提取电子卡、购买电子卡成功页返回一级页面
//            if([currentVC isKindOfClass:[WJMyBaoziViewController class]] ||
//               [currentVC isKindOfClass:[WJBaoziOrderConfirmController class]] ||
//               [currentVC isKindOfClass:[WJEleCardDeteilViewController class]] ||
//               //               [currentVC isKindOfClass:[WJExtraCardController class]] ||
//               [currentVC isKindOfClass:[WJBaoziPayCompleteController class]]){
//                
//                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
//            }
//            
//        }else if(self.selectedIndex == 4){
//            //向个人中心发送一个通知
//            [kDefaultCenter postNotificationName:@"ReloadCurrentView" object:nil];
//            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
//            
//        }else{
//            
//            //如果显示的是商品详情，更新card
//            UIViewController *currentVC = [nav visibleViewController];
//            
//            if([currentVC isKindOfClass:[WJHomeCardDetailsViewController class]]){
//                //商家卡详情，刷新页面
//                [kDefaultCenter postNotificationName:@"LogOutToProductCardDetail" object:nil];
//            }else{
//                for (WJViewController *wvc in nav.viewControllers) {
//                    if (wvc.isNeedToken) {
//                        
//                        //跳转确认订单前一个controller（商品卡详情）
//                        [kDefaultCenter postNotificationName:@"LogOutToProductCardDetail" object:nil];
//                        WJViewController *vc = [[WJGlobalVariable sharedInstance] payfromController];
//                        [nav popToViewController: vc animated:YES];
//                        break;
//                    }
//                }
//            }
//        }
        
        
        if(self.selectedIndex == 1){
            //向包子商城发送一个通知
            [kDefaultCenter postNotificationName:@"LogOutForFair" object:nil];
            
            UIViewController *currentVC = [nav visibleViewController];
            
            //我的包子、充值确认、电子卡详情、提取电子卡、购买电子卡成功页返回一级页面
            if([currentVC isKindOfClass:[WJMyBaoziViewController class]] ||
               [currentVC isKindOfClass:[WJBaoziOrderConfirmController class]] ||
               [currentVC isKindOfClass:[WJEleCardDeteilViewController class]] ||
               //               [currentVC isKindOfClass:[WJExtraCardController class]] ||
               [currentVC isKindOfClass:[WJBaoziPayCompleteController class]]){
                
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
            }
            
        }else if(self.selectedIndex == 3){
            //向个人中心发送一个通知
            [kDefaultCenter postNotificationName:@"ReloadCurrentView" object:nil];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
            
        }else{
            
//            //如果显示的是商品详情，更新card
//            UIViewController *currentVC = [nav visibleViewController];
//            
//            if([currentVC isKindOfClass:[WJHomeCardDetailsViewController class]]){
//                //商家卡详情，刷新页面
//                [kDefaultCenter postNotificationName:@"LogOutToProductCardDetail" object:nil];
//            }else{
//                for (WJViewController *wvc in nav.viewControllers) {
//                    if (wvc.isNeedToken) {
//                        
//                        //跳转确认订单前一个controller（商品卡详情）
//                        [kDefaultCenter postNotificationName:@"LogOutToProductCardDetail" object:nil];
//                        WJViewController *vc = [[WJGlobalVariable sharedInstance] payfromController];
//                        [nav popToViewController: vc animated:YES];
//                        break;
//                    }
//                }
//            }
            
            //向卡商城发送一个通知
            [kDefaultCenter postNotificationName:@"LogOutForCardShop" object:nil];
            
            UIViewController *currentVC = [nav visibleViewController];
            
            //我的包子、充值确认、电子卡详情、提取电子卡、购买电子卡成功页返回一级页面
            if([currentVC isKindOfClass:[WJMyBaoziViewController class]] ||
               [currentVC isKindOfClass:[WJBaoziOrderConfirmController class]] ||
               [currentVC isKindOfClass:[WJEleCardDeteilViewController class]] ||
               //               [currentVC isKindOfClass:[WJExtraCardController class]] ||
               [currentVC isKindOfClass:[WJBaoziPayCompleteController class]]){
                
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
            }
        }
        
        
    }
    
}

//通知
- (void)receiveNotification{
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"PushArguments"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PushArguments"];
    
    NSDictionary *pushUserInfo = dic[@"PushUserInfo"];
    NSInteger type = [dic[@"pushType"] integerValue];
    switch (type) {
            
        case PushTypeChargeComplete:
        {
            WJNavigationController *nav = (WJNavigationController *)self.selectedViewController;
            
            WJPayCompleteModel *model = [[WJPayCompleteModel alloc] initWithDic:pushUserInfo];
            model.paymentType = PaymentTypeConsume;
            WJPayCompleteController *payComVC = [[WJPayCompleteController alloc] initWithinfo:model];
            [nav pushViewController:payComVC animated:NO];
        }
            break;
            
        case PushTypeLogout:
        {
            [self forcedLoginOut:@"您的账号已退出，请重新登录"];
        }
            break;
            
        case PushTypeActivity:
        {
            NSString *linkUrl = pushUserInfo[@"link"];
            NSString *title = pushUserInfo[@"title"];
            WJWebViewController *web = [WJWebViewController new];
            web.titleStr = title;
            [web loadWeb:linkUrl];
            
            WJNavigationController *nav = (WJNavigationController *)self.selectedViewController;
            [nav pushViewController:web animated:YES];
        }
            break;
            
        case PushTypeKickedOut:
        {
            [self forcedLoginOut: @"您的账号已经被限制使用,请联系客服"];
        }
            break;
            
        case PushTypeFair:
        {
            [self alertRemove];
            [self delayMethod];
//            [self changeTabIndex:3];
            [self changeTabIndex:1];

        }
            break;
            
        case PushTypeSystom:
            
        default:
        {
            NSLog(@"No deal");
        }
            break;
    }
}


- (void)delayMethod
{
    WJNavigationController *nav = (WJNavigationController *)self.selectedViewController;
    [nav dismissViewControllerAnimated:NO completion:nil];
    [nav popToRootViewControllerAnimated:NO];
}

- (void)alertRemove
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    WJUpgradeAlert *upgradeAlert = (WJUpgradeAlert *)[window viewWithTag:100002];
    WJSystemAlertView *alertView = (WJSystemAlertView *)[window viewWithTag:100003];
    WJPsdVerifyAlert *psdAlert = (WJPsdVerifyAlert *)[window viewWithTag:100004];
    WJPassView *buyECardAlert = (WJPassView *)[window viewWithTag:100005];
    
    if (upgradeAlert) {
        [upgradeAlert dismiss];
    }
    if (alertView) {
        [alertView dismiss];
    }
    if (psdAlert) {
        [psdAlert dismiss];
    }
    if (buyECardAlert) {
        [buyECardAlert dismiss];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
