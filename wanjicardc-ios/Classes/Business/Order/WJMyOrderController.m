//
//  WJMyOrderController.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/15.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJMyOrderController.h"
#import "WJMyAllOrderController.h"
#import "WJWaitingOrderController.h"
#import "WJEndedOrderController.h"
#import "WJFinishOrderController.h"
#import "WJMerchantOrderController.h"
#import "WJElectronicCardOrderController.h"
#import "WJSteamedChargeOrderController.h"
#import "WJPayCompleteController.h"
#import "WJMyOrderControllerDelegate.h"
#import "WJOrderModel.h"
#import "Pingpp.h"
#import "TabSwitchView.h"   
#import "libPayecoPayPlugin.h"
#import "WJStatisticsManager.h"
#import "WJOrderTypeView.h"
#import "WJECardDetailModel.h"
#import "WJECardModel.h"

#import "WJBaoziPayCompleteController.h"
#import "WJSystemAlertView.h"
#import "WJAppealViewController.h"
#import "WJFindSafetyQuestionController.h"
#import "WJFindRealNameAuthenticationViewController.h"
#import "WJPassView.h"
#import "APIBuyECardManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

#import "UINavigationBar+Awesome.h"
#import "WJBaoziOrderConfirmController.h"


@interface WJMyOrderController ()<TabSwitchViewDelegage, UIScrollViewDelegate, APIManagerCallBackDelegate, WJMyOrderControllerDelegate,PayEcoPpiDelegate,WJOrderTypeViewDelegate,WJSystemAlertViewDelegate,UIActionSheetDelegate,WJPassViewDelegate>{
    
    TabSwitchView            *tabSwitch;
    UIScrollView             *baseScroll;
    WJMyAllOrderController   *allOrderVC;
    WJWaitingOrderController *waitingOrderVC;
    WJEndedOrderController   *endedOrderVC;
    WJFinishOrderController  *finishOrderVC;
    
    WJMerchantOrderController       *merchantOrderVC;
    WJElectronicCardOrderController *electronicCardOrderVC;
    WJSteamedChargeOrderController  *steamedChargeOrderVC;
    
    UILabel       *orderLabel;
    UIImageView   *chooseOrderImageView;
    BOOL          isOrderViewShow;
    UIView        *rightView;

    
    NSString     *orderNumber;
    WJOrderModel *orderModel;
    CGFloat      totalBunNum;

}

@property(nonatomic, strong)WJOrderTypeView *orderTypeView;
@property(nonatomic, strong)APIBuyECardManager      *buyECardManager; //电子卡支付

@end

@implementation WJMyOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isOrderViewShow = NO;
    
//    self.title = @"我的订单";
    [self navigationSetup];
    
    self.eventID = @"iOS_act_Order";
    
//    tabSwitch = [[TabSwitchView alloc] initWithTitles:@[@"全部", @"待支付", @"已关闭"] andViewControllers:nil];
//    tabSwitch.frame = CGRectMake(0, 0, kScreenWidth, kTabSwitchHeight);
//    tabSwitch.delegate = self;
//    tabSwitch.selectedColor = WJColorNavigationBar;
//    [self.view addSubview:tabSwitch];
//    
//    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(tabSwitch.frame.size.width/3, (tabSwitch.height - 20)/2, 1, 20)];
//    firstLine.backgroundColor = WJColorSeparatorLine;
//    [tabSwitch addSubview:firstLine];
//    
//    UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(tabSwitch.frame.size.width/3*2, (tabSwitch.height - 20)/2, 1, 20)];
//    secondLine.backgroundColor = WJColorSeparatorLine;
//    [tabSwitch addSubview:secondLine];
//    
//    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kTabSwitchHeight, kScreenWidth, 0.5)];
//    bottomLine.backgroundColor = WJColorSeparatorLine;
//    [tabSwitch addSubview:bottomLine];
    
    
    baseScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight-64))];

//    baseScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTabSwitchHeight + 0.5, kScreenWidth, (kScreenHeight-kTabSwitchHeight-64 - 0.5))];
    baseScroll.pagingEnabled = YES;
    baseScroll.bounces = NO;
    baseScroll.scrollsToTop = NO;
    baseScroll.delegate = self;
    baseScroll.showsHorizontalScrollIndicator = NO;
    baseScroll.scrollEnabled = NO;
    [self.view addSubview:baseScroll];
    
    allOrderVC = [[WJMyAllOrderController alloc] init];
    allOrderVC.view.frame = CGRectMake(0, 0, kScreenWidth, baseScroll.height);
    allOrderVC.delegate = self;
    [self addChildViewController:allOrderVC];
    [allOrderVC didMoveToParentViewController:self];
    [baseScroll addSubview:allOrderVC.view];
    
    waitingOrderVC = [[WJWaitingOrderController alloc] init];
    waitingOrderVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, baseScroll.height);
    waitingOrderVC.delegate = self;
    [self addChildViewController:waitingOrderVC];
    [waitingOrderVC didMoveToParentViewController:self];
    [baseScroll addSubview:waitingOrderVC.view];
    
    endedOrderVC = [[WJEndedOrderController alloc] init];
    endedOrderVC.view.frame = CGRectMake(2*kScreenWidth, 0, kScreenWidth, baseScroll.height);
    
    [self addChildViewController:endedOrderVC];
    [endedOrderVC didMoveToParentViewController:self];
    [baseScroll addSubview:endedOrderVC.view];
    
    finishOrderVC = [[WJFinishOrderController alloc] init];
    finishOrderVC.view.frame = CGRectMake(3*kScreenWidth, 0, kScreenWidth, baseScroll.height);
    finishOrderVC.delegate = self;
    [self addChildViewController:finishOrderVC];
    [finishOrderVC didMoveToParentViewController:self];
    [baseScroll addSubview:finishOrderVC.view];
    
    
    merchantOrderVC = [[WJMerchantOrderController alloc] init];
    merchantOrderVC.view.frame = CGRectMake(4*kScreenWidth, 0, kScreenWidth, baseScroll.height);
    [self addChildViewController:merchantOrderVC];
    [merchantOrderVC didMoveToParentViewController:self];
    [baseScroll addSubview:merchantOrderVC.view];
    
    electronicCardOrderVC = [[WJElectronicCardOrderController alloc] init];
    electronicCardOrderVC.view.frame = CGRectMake(5*kScreenWidth, 0, kScreenWidth, baseScroll.height);
    electronicCardOrderVC.delegate = self;
    [self addChildViewController:electronicCardOrderVC];
    [electronicCardOrderVC didMoveToParentViewController:self];
    [baseScroll addSubview:electronicCardOrderVC.view];
    
    steamedChargeOrderVC = [[WJSteamedChargeOrderController alloc] init];
    steamedChargeOrderVC.view.frame = CGRectMake(6*kScreenWidth, 0, kScreenWidth, baseScroll.height);
    [self addChildViewController:steamedChargeOrderVC];
    [steamedChargeOrderVC didMoveToParentViewController:self];
    [baseScroll addSubview:steamedChargeOrderVC.view];

    baseScroll.contentSize = CGSizeMake(7*kScreenWidth, baseScroll.height);
    
  }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)navigationSetup
{
    self.view.backgroundColor = WJColorViewBg2;
    [self.navigationController.navigationBar lt_setBackgroundColor:[WJColorNavigationBar colorWithAlphaComponent:0]];
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 160)/2, 0, 160, ALD(25))];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseOrderAction)];
    [rightView addGestureRecognizer:tap];
    
    orderLabel                   = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, ALD(25))];
    orderLabel.font              = WJFont14;
    orderLabel.textAlignment     = NSTextAlignmentCenter;
    orderLabel.textColor         = WJColorWhite;
    orderLabel.text              = @"全部订单";
    CGFloat addWith = [UILabel getWidthWithTitle:orderLabel.text font:WJFont14];
    orderLabel.frame = CGRectMake(0, 0, addWith, ALD(25));
    rightView.frame = CGRectMake((kScreenWidth - ALD(13) - addWith)/2, 0, addWith, ALD(25));
    
    chooseOrderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_btn_location_nor"] highlightedImage:[UIImage imageNamed:@"Home_btn_location_pressed"]];
    chooseOrderImageView.frame = CGRectMake(orderLabel.right + ALD(5), orderLabel.y + ALD(9), ALD(8), ALD(8));
    
    [rightView addSubview:orderLabel];
    [rightView addSubview:chooseOrderImageView];

    self.navigationItem.titleView = rightView;

}

- (void)chooseOrderAction
{
    if (![self.view viewWithTag:2000]) {
        
        [self.view addSubview:self.orderTypeView];
    }
    
    chooseOrderImageView.highlighted = !chooseOrderImageView.highlighted;
    
    isOrderViewShow = !isOrderViewShow;
    if (isOrderViewShow) {
        self.orderTypeView.hidden = NO;
    } else {
        self.orderTypeView.hidden = YES;
    }

}

#pragma mark - NSNotification

- (void)checkAlertWithBaoziNum{
   
    [self buyAgainWithOrder:orderModel baoziNum:totalBunNum orderNo:orderNumber];
}

#pragma mark - WJOrderTypeViewDelegate
- (void)orderTypeViewUpdateOrder:(NSInteger)index section:(NSInteger)section
{
    if(isOrderViewShow){
        isOrderViewShow = NO;
        chooseOrderImageView.highlighted = NO;
        self.orderTypeView.hidden = YES;
        
        rightView.frame =  CGRectMake((kScreenWidth - 160)/2, 0, 160, ALD(25));
        orderLabel.frame = CGRectMake(0, 0, 150, ALD(25));
        
        NSArray *array1 = [NSArray arrayWithObjects:@"全部订单",@"待支付订单",@"已关闭订单",@"已完成订单",nil];
        NSArray *array2 = [NSArray arrayWithObjects:@"商家卡订单",@"电子卡订单",@"包子充值订单",nil];
        
        switch (section) {
            case 0:
            {
                orderLabel.text = [array1 objectAtIndex:index];

                if (index == 0) {
                    [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_allOrder"];
                    [allOrderVC.mTb startHeadRefresh];
                    
                } else if (index == 1) {

                    [waitingOrderVC.mTb startHeadRefresh];
                    
                } else if (index == 2) {
                    
                    [endedOrderVC.mTb startHeadRefresh];
                    
                } else {
                    
                    [finishOrderVC.mTb startHeadRefresh];
                }
    
                [self updateTopOrderType:index];
                
            }
                break;
                
            case 1:
            {
                orderLabel.text = [array2 objectAtIndex:index];

                if (index == 0) {
                    
                    [merchantOrderVC.mTb startHeadRefresh];
                    
                } else if (index == 1) {
                    
                    [electronicCardOrderVC.mTb startHeadRefresh];
                    
                    
                } else if (index == 2) {
                    
                    [steamedChargeOrderVC.mTb startHeadRefresh];
                    
                }
                [self updateTopOrderType:index + 4];
                
            }
                break;
                
            default:
                break;
        }
        
    }

}

- (void)hideBackOrderTypeView:(WJOrderTypeView *)orderTypeView
{
    [self chooseOrderAction];
}

- (void)updateTopOrderType:(NSInteger)index
{
    self.navigationItem.titleView = rightView;
    CGFloat addWith = [UILabel getWidthWithTitle:orderLabel.text font:WJFont14];
    rightView.frame = CGRectMake((kScreenWidth - ALD(13) - addWith)/2, 0, addWith, ALD(25));
    orderLabel.frame = CGRectMake(0, 0, addWith, ALD(25));
    chooseOrderImageView.frame = CGRectMake(orderLabel.right + ALD(5), orderLabel.y + ALD(9), ALD(8), ALD(8));

    [UIView animateWithDuration:0.3 animations:^{
        baseScroll.contentOffset = CGPointMake(kScreenWidth*index, 0);
    }];
}

#pragma mark - TabSwitchViewDelegage
- (void)tabSwitchAction:(NSNumber *)chooseBtnIndex
{
    NSLog(@"%@", chooseBtnIndex);
    
    if (chooseBtnIndex.integerValue == 0) {
        [allOrderVC.mTb startHeadRefresh];
    } else if (chooseBtnIndex.integerValue == 1) {
        [waitingOrderVC.mTb startHeadRefresh];
    } else if (chooseBtnIndex.integerValue == 2) {
        [endedOrderVC.mTb startHeadRefresh];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        baseScroll.contentOffset = CGPointMake(kScreenWidth*chooseBtnIndex.intValue, 0);
    }];
    
}


#pragma mark - WJMyOrderControllerDelegate

- (void)buyAgainWithOrder:(WJOrderModel *)ord baoziNum:(CGFloat)num orderNo:(NSString *)ordNo
{
    NSString *cardNum = [NSString stringWithFormat:@"%ld",ord.count];
    orderNumber = ordNo;
    orderModel = ord;
    totalBunNum = num;
    
    //包子数足够
    if (num >= [ord.PayAmount floatValue]) {
        
        //判断是否设置了指纹验证
        NSString *fingerIdenty = KFingerIdentySwitch;
        BOOL isBool = NO;
        if (fingerIdenty) {
            isBool = [[NSUserDefaults standardUserDefaults] boolForKey:fingerIdenty];
        }
        
        [WJGlobalVariable sharedInstance].fromController = self;
        
        if (isBool) {
            
            WJPassView *passView = [[WJPassView alloc] initWithFrame:self.view.bounds title:@"请输入支付密码"  cardName:ord.name faceValue:ord.faceValue  cardNum:cardNum baoziNeedNum:ord.PayAmount baoziHasNum:NumberToString(num) passViewType:PassViewTypeSubmit];
            passView.delegate = self;
            [passView showIn];
            
        } else {
            
            WJPassView *passView = [[WJPassView alloc] initWithFrame:self.view.bounds title:@"请输入支付密码"  cardName:ord.name faceValue:ord.faceValue  cardNum:cardNum baoziNeedNum:ord.PayAmount baoziHasNum:NumberToString(num) passViewType:PassViewTypeInputPassword];
            passView.delegate = self;
            [passView showIn];
        }
    } else {
        
        //包子数不足
        WJPassView *passView = [[WJPassView alloc] initWithFrame:self.view.bounds title:@"请输入支付密码"  cardName:ord.name faceValue:ord.faceValue cardNum:cardNum baoziNeedNum:ord.PayAmount baoziHasNum:NumberToString(num)  passViewType:PassViewTypeSubmitTip];
        passView.delegate = self;
        [passView showIn];
    }

}


#pragma mark - RequestCallBack

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIBuyECardManager class]]) {
        NSLog(@"%@",@"购买成功");
     
        //支付成功 进入交易结果页
        [kDefaultCenter postNotificationName:kPayOrderSuccess object:nil];
        [WJGlobalVariable sharedInstance].payfromController = self;
        
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        WJPassView *alert = (WJPassView *)[window viewWithTag:100005];
        if (alert) {
            [alert dismiss];
        }
        
        [self paySuccessToResultViewController];
    }
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{

}


#pragma mark - 指纹校验
- (void)checkFingerWithIdenty
{
    if(IOS8_LATER){
        
        //进行指纹识别，获取指纹验证结果
        LAContext *context = [[LAContext alloc] init];
        context.localizedFallbackTitle = @"输入支付密码";
        
        __weak typeof(self) weakSelf = self;
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"通过Home键验证已有手机指纹",nil) reply:^(BOOL success, NSError * _Nullable error) {
            
            __strong typeof(self) strongSelf = weakSelf;
            
            if (success) {
                //验证成功，主线程处理UI
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    strongSelf.buyECardManager.orderNo = orderNumber;
                    [strongSelf.buyECardManager loadData];
                    
                }];
                
            }else{
                
                NSLog(@"%@",error.localizedDescription);
            }
        }];
    }
}


#pragma mark - 找回密码逻辑

- (void)showAlertWithMessage:(NSString *)msg isLocked:(BOOL)isLocked
{
    
    NSString *title = nil;
    NSString *otherBtnTitle = nil;
    if (isLocked) {
        title = @"账号已被锁定";
        otherBtnTitle = @"找回支付密码";
    }else{
        title = @"验证失败";
        otherBtnTitle = @"再试一次";
    }
    
    WJSystemAlertView *sysAlert = [[WJSystemAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:otherBtnTitle textAlignment:NSTextAlignmentCenter];
    
    [sysAlert showIn];
}


- (void)findPassword
{
    [kDefaultCenter addObserver:self selector:@selector(checkAlertWithBaoziNum) name:@"FindPasswordFromECardOrder" object:nil];
    
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    NSInteger appealStatus = person.appealStatus;
    BOOL isSetQuestion = person.isSetPsdQuestion;
    NSInteger realnameStatus = person.authentication;
    NSString *realname = nil;
    NSString *userPhone = person.phone;
    
    if (person.realName) {
        if ([person.realName length]>0) {
            realname = person.realName;
        }
    }
    
    if (IOS8_LATER) {
        
        __weak typeof(self) weakSelf = self;
        __weak NSString *weakName = realname;
        __weak NSString *weakPhone = userPhone;
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"找回密码" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:cancelAction];
        
        UIAlertAction *appealAction = [UIAlertAction actionWithTitle:@"申诉找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            __strong typeof(self) strongSelf = weakSelf;
            
            if (appealStatus == AppealProcessing){
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"申诉处理中"];
                
            }else{
                
                [WJGlobalVariable sharedInstance].findPwdFromController = strongSelf;
                //申诉找回
                WJAppealViewController *findPswVC = [[WJAppealViewController alloc] init];
                if (weakPhone) {
                    findPswVC.userPhone = weakPhone;
                }
                [strongSelf.navigationController pushViewController:findPswVC animated:YES];
            }
        }];
        
        [alertControl addAction:appealAction];
        
        if (isSetQuestion) {
            
            UIAlertAction *quesAction = [UIAlertAction actionWithTitle:@"安全问题找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                __strong typeof(self) strongSelf = weakSelf;
                [WJGlobalVariable sharedInstance].findPwdFromController = strongSelf;
                //安全问题找回
                WJFindSafetyQuestionController *findSafeVC = [[WJFindSafetyQuestionController alloc] init];
                findSafeVC.phoneNumber = weakPhone;
                [strongSelf.navigationController pushViewController:findSafeVC animated:YES];
            }];
            
            [alertControl addAction:quesAction];
        }
        
        if (realnameStatus == 2) {
            
            UIAlertAction *authAction = [UIAlertAction actionWithTitle:@"实名验证找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(self) strongSelf = weakSelf;
                [WJGlobalVariable sharedInstance].findPwdFromController = strongSelf;
                //实名验证找回
                WJFindRealNameAuthenticationViewController *authenticVC = [[WJFindRealNameAuthenticationViewController alloc] init];
                if (weakName) {
                    authenticVC.realName = weakName;
                }
                [strongSelf.navigationController pushViewController:authenticVC animated:YES];
                
            }];
            [alertControl addAction:authAction];
        }
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }else{
        
        
        UIActionSheet *actionSheet = nil;
        if (isSetQuestion && realnameStatus == 2) {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"实名验证找回",@"安全问题找回",@"申诉找回", nil];
            
        }else {
            
            if (isSetQuestion) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"安全问题找回",@"申诉找回", nil];
                
            }else if (realnameStatus == 2){
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"实名验证找回",@"申诉找回", nil];
                
            }else{
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"申诉找回", nil];
            }
        }
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }
    
}


#pragma mark - WJPassViewDelegate
- (void)successWithVerifyPsdAlert:(WJPassView *)alertView
{
    self.buyECardManager.orderNo = orderNumber;
    [self.buyECardManager loadData];
}


- (void)failedWithVerifyPsdAlert:(WJPassView *)alertView errerMessage:(NSString * )errerMessage isLocked:(BOOL)isLocked
{
    [alertView dismiss];
    
    //失败重新弹出输入弹窗
    [self showAlertWithMessage:errerMessage isLocked:isLocked];
}


- (void)forgetPasswordActionWith:(WJPassView *)alertView
{
    [alertView dismiss];
    [self findPassword];
}

//确认支付（已开启指纹）
- (void)payWithAlert:(WJPassView *)alertView
{
    [alertView dismiss];
    [self checkFingerWithIdenty];
    
}

//立即充值（包子不足）
- (void)RechargeWithAlert:(WJPassView *)alertView
{
    [WJGlobalVariable sharedInstance].payfromController = self;
    WJBaoziOrderConfirmController *baoziVC = [[WJBaoziOrderConfirmController alloc] init];
    [self.navigationController pushViewController:baoziVC animated:YES];
}

//帮助
- (void)helpAction
{
//    WJBaoziDescriptionController *vc = [[WJBaoziDescriptionController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - WJSystemAlertViewDelegate
- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //取消
    if (buttonIndex == 0) {
        [alertView dismiss];
    }else{
        
        if ([alertView.title isEqualToString:@"验证失败"]) {
            //再试一次
            
            NSString *cardNum = [NSString stringWithFormat:@"%ld",orderModel.count];
            
            WJPassView *passView = [[WJPassView alloc] initWithFrame:self.view.bounds title:@"请输入支付密码"  cardName:orderModel.name faceValue:orderModel.faceValue  cardNum:cardNum baoziNeedNum:orderModel.PayAmount baoziHasNum:NumberToString(totalBunNum) passViewType:PassViewTypeInputPassword];
            passView.delegate = self;
            [passView showIn];
            
            
        }else if ([alertView.title isEqualToString:@"账号已被锁定"]) {
            
            [alertView dismiss];
            [self findPassword];
        }
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    NSInteger appealStatus = person.appealStatus;
    BOOL isSetQuestion = person.isSetPsdQuestion;
    NSInteger realnameStatus = person.authentication;
    NSString *realname = nil;
    NSString *userPhone = person.phone;
    
    if (person.realName) {
        if ([person.realName length]>0) {
            realname = person.realName;
        }
    }
    
    if (realnameStatus == 2) {
        if (buttonIndex == 0) {
            //实名验证找回
            [WJGlobalVariable sharedInstance].findPwdFromController = self;
            WJFindRealNameAuthenticationViewController *authenticVC = [[WJFindRealNameAuthenticationViewController alloc] init];
            if (realname) {
                authenticVC.realName = realname;
            }
            [self.navigationController pushViewController:authenticVC animated:YES];
            
        }else{
            
            if (isSetQuestion && buttonIndex == 1) {
                //安全问题
                [WJGlobalVariable sharedInstance].findPwdFromController = self;
                WJFindSafetyQuestionController *findSafeVC = [[WJFindSafetyQuestionController alloc] init];
                [self.navigationController pushViewController:findSafeVC animated:YES];
                return;
                
            }else if((isSetQuestion && buttonIndex == 2) || (!isSetQuestion && buttonIndex == 1)){
                //账户申诉找回
                
                switch (appealStatus) {
                    case AppealProcessing:
                    {
                        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"申诉处理中"];
                    }
                        break;
                        
                    default:
                    {
                        [WJGlobalVariable sharedInstance].findPwdFromController = self;
                        WJAppealViewController *findPswVC = [[WJAppealViewController alloc] init];
                        if (userPhone) {
                            findPswVC.userPhone = userPhone;
                        }
                        [self.navigationController pushViewController:findPswVC animated:YES];
                    }
                        break;
                }
                return;
            }
        }
        
    }else{
        
        if (isSetQuestion && buttonIndex == 0) {
            
            //安全问题找回
            [WJGlobalVariable sharedInstance].findPwdFromController = self;
            WJFindSafetyQuestionController *findSafeVC = [[WJFindSafetyQuestionController alloc] init];
            [self.navigationController pushViewController:findSafeVC animated:YES];
            return;
            
        }else if ((isSetQuestion && buttonIndex == 1) || (!isSetQuestion && buttonIndex == 0)) {
            
            //申诉找回
            if (appealStatus == AppealProcessing){
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"申诉处理中"];
            }else{
                [WJGlobalVariable sharedInstance].findPwdFromController = self;
                WJAppealViewController *findPswVC = [[WJAppealViewController alloc] init];
                if (userPhone) {
                    findPswVC.userPhone = userPhone;
                }
                [self.navigationController pushViewController:findPswVC animated:YES];
            }
            
            return;
        }
    }
}



- (void)paySuccessToResultViewController
{
    
    WJECardDetailModel *eCardDetailModel = [[WJECardDetailModel alloc] init];
    eCardDetailModel.cardId = orderModel.pcid;
    eCardDetailModel.cardColor = orderModel.ctype;
    eCardDetailModel.facePrice = orderModel.faceValue;
    eCardDetailModel.salePrice = orderModel.salePrice;
    eCardDetailModel.commodityName = orderModel.name;
    
    WJPayCompleteModel *model = [[WJPayCompleteModel alloc] init];
    model.paymentType = PaymentTypeBuy;
    model.orderNo = orderNumber;
    model.ecardsNum = [NSString stringWithFormat:@"%ld",orderModel.count];
    model.ecard = eCardDetailModel;
    
    WJBaoziPayCompleteController *completeVC = [[WJBaoziPayCompleteController alloc]
                                                initWithinfo:model];
    [self.navigationController pushViewController:completeVC animated:NO];
}



#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    CGPoint endpoint = scrollView.contentOffset;
//    NSInteger index = round(endpoint.x/kScreenWidth);
//    [tabSwitch selectedIndex:index];
//}

#pragma mark - Request

//- (void)requestLoadOrderPayWith:(WJOrderModel *)ord{
//    
//    //易联支付
//    if ([ord.paychannel isEqualToString:@"payeco"]) {
//        //商户需要提交给支付插件的订单内容
//        [self performSelectorOnMainThread:@selector(goNext:) withObject:ord.charge waitUntilDone:NO];
//        
//        return;
//    }
//    
//    [self hiddenLoadingView];
//    __weak typeof(self) weakSelf = self;
//    [Pingpp createPayment:ord.charge
//           viewController:weakSelf
//             appURLScheme:KAppURLScheme
//           withCompletion:^(NSString *result, PingppError *error) {
//               if ([result isEqualToString:@"success"]) {
//                   
//                   [kDefaultCenter postNotificationName:kPayOrderSuccess object:nil];
//                   [WJGlobalVariable sharedInstance].payfromController = weakSelf;
//                   
//                   // 支付成功
//                   ALERT(@"支付成功");
//                   WJPayCompleteModel *model = [[WJPayCompleteModel alloc] initWithDic:
//                                                @{kOrderNumber:ord.orderNo,
//                                                  kOrderAmount:ord.PayAmount,
//                                                  kMerId:ord.merId?:@"",
//                                                  kMerName:ord.name?:@""
//                                                  }];
//                   model.paymentChannel = ord.paychannel;
//                   model.paymentType = (ord.orderType == OrderTypeCharge)?PaymentTypeCharge:PaymentTypeBuy;
//                   model.payTime = [WJUtilityMethod dateStringFromDate:[NSDate date] withFormatStyle:@"yyyy-MM-dd"];
//                   
//                   WJPayCompleteController *vc = [[WJPayCompleteController alloc]
//                                                  initWithinfo:model];
//                   [self.navigationController pushViewController:vc animated:YES];
//                   
//               } else {
//                   
//                   ALERT([error getMsg]);
//               }
//           }];
//
//}
//
//
//#pragma mark 易联支付
//
///*
// *  下单成功，开始调用易联支付插件进行支付
// */
//- (void)goNext:(NSString *)orderData{
//    
//    //使加载控件消失
//    [self hiddenLoadingView];
//    
//    //orderData为商户下单返回的数据，将下单返回的数据转换成json字符串
////    NSString *reqJson = [self toJsonStringWithJsonObject:orderData];
////    NSLog(@"PayEcoPpi startPay: %@\n\n",reqJson);
//    
//    //初始化易联支付类对象
//    PayEcoPpi *payEcoPpi = [[PayEcoPpi alloc] init];
//    
//    /*
//     *  跳转到易联支付SDK
//     *  delegate: 用于接收支付结果回调
//     *  env:环境参数 00: 测试环境  01: 生产环境
//     *  orientation: 支付界面显示的方向 00：横屏  01: 竖屏
//     */
//    NSString *envStr = @"01";
//    [payEcoPpi startPay:orderData delegate:self env:envStr orientation:@"01"];
//    
//}


//json对象转换成json字符串
- (NSString *)toJsonStringWithJsonObject:(id)jsonObject{
    NSData *result = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                     options:kNilOptions
                                                       error:nil];
    return [[NSString alloc] initWithData:result
                                 encoding:NSUTF8StringEncoding];
}

#pragma mark -
#pragma mark PayEcoPpiDelegate（易联支付插件通过代理方式回调，通知商户支付结果）


/*
 *   易联支付完成后执行回调，返回数据，通知商户。
 */
//- (void)payResponse:(NSString *)respJsonStr{
//    NSLog(@"\nPayEco PpiDelegate payResponse:%@",respJsonStr);
//    
//    //json字符串转为dictionary
//    NSData *jsonData = [respJsonStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err= nil;
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                         options:NSJSONReadingMutableContainers
//                                                           error:&err];
//    
//    NSString *respCode  = [dict objectForKey:@"respCode"];
//    NSString *respTitle = @"支付出错";
//    
//    if ([respCode isEqualToString:@"0000"]) {
//        respTitle = @"支付成功";
//        
//        NSString *status = [dict objectForKey:@"Status"];
//        NSString *ret = @"未知状态";
//        if (status) {
//            
//            if ([status isEqualToString:@"01"]) {
//                ret = @"未支付";
//            }else if ([status isEqualToString:@"02"]) {
//                ret = @"已支付";
//            }else if ([status isEqualToString:@"03"]) {
//                ret = @"已退款";
//            }else if ([status isEqualToString:@"04"]) {
//                ret = @"已过期";
//            }else if ([status isEqualToString:@"05"]) {
//                ret = @"已作废";
//            }
//            
//            NSLog(@"%@",ret);
//        }
//    }
//    
//    NSString *respDesc = [dict objectForKey:@"respDesc"];
//    if (!respDesc) {
//        if ([respCode isEqualToString:@"0000"]) {
//            respDesc  = @"支付成功";
//        }else{
//            respTitle = @"未知错误支付信息";
//        }
//    }else{
//        
//        NSLog(@"%@",respDesc);
//    }
//    
//    //    [[TKAlertCenter defaultCenter]postAlertWithMessage:respTitle];
//    NSLog(@"%@",respTitle);
//    
//    //更改订单状态
//    if([respTitle isEqualToString:@"支付成功"]){
//        
//        [kDefaultCenter postNotificationName:kPayOrderSuccess object:nil];
//    }
//    
//}

- (WJOrderTypeView  *)orderTypeView
{
    if (nil == _orderTypeView) {
        
        _orderTypeView= [[WJOrderTypeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _orderTypeView.delegate = self;
        _orderTypeView.tag = 2000;
    }
    return _orderTypeView;
    
}



- (APIBuyECardManager *)buyECardManager
{
    if (!_buyECardManager) {
        _buyECardManager = [[APIBuyECardManager alloc] init];
        _buyECardManager.delegate = self;
    }
    return _buyECardManager;
}

@end
