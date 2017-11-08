//
//  WJWebViewController.m
//  WanJiCard
//
//  Created by Lynn on 15/9/30.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJWebViewController.h"

#import "WJBridgeActivity.h"
#import "WJMerchantDetailController.h"
#import "WJMerchantCard.h"
#import "WJHomeCardDetailsViewController.h"
#import "WJHotBrandShopListViewController.h"
#import "WJStatisticsManager.h"
#import "WJShare.h"
#import "WJRealNameAuthenticationViewController.h"
#import "WJVerificationReceiptMoneyController.h"

@interface WJWebViewController ()<UIWebViewDelegate>{
    WJBridgeActivity *bridge;
}

@end

@implementation WJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.eventID = @"iOS_act_adpage";
    __weak typeof(self)weakSelf = self;

    if (self.isShowPriManual)
    {
        [self navigationSetup];
    }
    
    bridge = [WJBridgeActivity bridgeForWebView:weakSelf.webView webViewDelegate:weakSelf result:^(NSArray *args) {
        
        NSDictionary *dic = nil;
        if (args[1]) {
            dic = [NSJSONSerialization JSONObjectWithData:[args[1] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        }
        NSLog(@"%@", dic);
        
        if ([args[0] isEqualToString:@"product"]) {
            
            WJHomeCardDetailsViewController *cardVC = [[WJHomeCardDetailsViewController alloc] initWithNibName:nil bundle:nil];
            cardVC.cardID       = ToString(dic[@"cardId"]);
            cardVC.cardIndex    = 0;
            cardVC.titleStr     = ToString(dic[@"title"]);
            [weakSelf.navigationController pushViewController:cardVC animated:YES];
            
        }else if ([args[0] isEqualToString:@"merchant"]) {
            WJMerchantDetailController *mvc = [WJMerchantDetailController new];
            mvc.merId = ToString(dic[@"merId"]);
            [weakSelf.navigationController pushViewController:mvc animated:YES];
            
        } else  if ([args[0] isEqualToString:@"brand"]) {
            
            WJHotBrandShopListViewController *hotVC = [[WJHotBrandShopListViewController alloc] initWithNibName:nil bundle:nil];
            hotVC.categoryTitle = ToString(dic[@"brandName"]);
            hotVC.searchManager.merchantAccountId = ToString(dic[@"brandId"]);
            [self.navigationController pushViewController:hotVC animated:YES];
            
        }else if ([args[0] isEqualToString:@"share"]) {
            
            WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
            
            if (defaultPerson.authentication == AuthenticationNo) {
                [self pushToRealName];
            }else{
                [WJShare sendShareController:self
                                     LinkURL:ToString(dic[@"url"])
                                     TagName:@"TAG_Webview"
                                       Title:ToString(dic[@"title"])
                                 Description:ToString(dic[@"desc"])
                                  ThumbImage:ToString(dic[@"logo"])];
            }
            
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
        }else{
            
        }
    }];
    
    [self.view addSubview:self.webView];
//    [self.view addConstraints:[self.webView constraintsFill]];
    
 
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = self.titleStr;
}

- (void)backBarButton:(UIButton *)btn{
    bridge = nil;
    [super backBarButton:btn];
}

- (void)navigationSetup
{
    UIButton * priManualBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [priManualBtn setFrame:CGRectMake(0, 0, 50, 30)];
    [priManualBtn setTitle:@"特权说明" forState:UIControlStateNormal];
    priManualBtn.titleLabel.font = WJFont14;
    [priManualBtn sizeToFit];
    [priManualBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [priManualBtn addTarget:self action:@selector(goToShowManual) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:priManualBtn];
}

- (void)goToShowManual
{
    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_PrivilegeExplain"];
    WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
    NSString * token = person.token?:@"";
    NSString *merID = self.merID?:@"";
    
    WJWebViewController *web = [[WJWebViewController alloc] init];
    web.titleStr = @"特权说明";
    //            privilegeType=user
    [web loadWeb:[NSString stringWithFormat:@"http://e.wjika.com/tequan/?merchantId=%@&token=%@&privilegeType=merchant",merID,token]];
    //            [self.navigationController pushViewController:web animated:YES];
    [self.navigationController pushViewController:web animated:YES whetherJump:NO];
}

#pragma mark - Logic
- (void)loadWeb:(NSString *)urlString{
    
    [self showLoadingView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

#pragma mark - 属性访问

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _webView.delegate = self;
    }
    return _webView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hiddenLoadingView];
}

#pragma mark - 实名跳转
- (void)pushToRealName
{
    NSString *record = [[NSUserDefaults standardUserDefaults] valueForKey:@"RealNameReciveMoneyRecord"];
    
    if (!record) {
        WJRealNameAuthenticationViewController *realNameAuthenticationVC = [[WJRealNameAuthenticationViewController alloc] init];
        realNameAuthenticationVC.comefrom = ComeFromActivitiesShare;
        realNameAuthenticationVC.isjumpOrderConfirmController = NO;
        [WJGlobalVariable sharedInstance].realAuthenfromController = self;
        [self.navigationController pushViewController:realNameAuthenticationVC animated:YES];
    } else {
        //收款金额验证
        WJVerificationReceiptMoneyController *verificationReceiptMoneyController = [[WJVerificationReceiptMoneyController alloc] init];
        [WJGlobalVariable sharedInstance].realAuthenfromController = self;
        verificationReceiptMoneyController.comefrom = ComeFromActivitiesShare;
        verificationReceiptMoneyController.isjumpOrderConfirmController = NO;
        verificationReceiptMoneyController.BankCard = record;
        [self.navigationController pushViewController:verificationReceiptMoneyController animated:YES];
        
    }
}
@end
