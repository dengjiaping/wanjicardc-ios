//
//  WJBaoziPayCompleteController.m
//  WanJiCard
//
//  Created by 孙明月 on 16/8/16.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJBaoziPayCompleteController.h"
#import "AppDelegate.h"
#import "WJPsdVerifyAlert.h"
#import "WJAppealViewController.h"
#import "WJFindSafetyQuestionController.h"
#import "WJFindRealNameAuthenticationViewController.h"
#import "WJSystemAlertView.h"
#import "WJECardDetailModel.h"

@interface WJBaoziPayCompleteController ()<WJPsdVerifyAlertDelegate, UIActionSheetDelegate, WJSystemAlertViewDelegate>
{
    WJPayCompleteModel *payCompleteModel;
//    WJElectronicCardModel *buyOrderModel;
}
@end

@implementation WJBaoziPayCompleteController
- (instancetype)initWithinfo:(WJPayCompleteModel *)completeInfo{
    if (self = [super init]) {
        payCompleteModel = completeInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self removeScreenEdgePanGesture];
    self.title = @"支付成功";
    [self initViews];
}

- (void)initViews
{
    
    UIView *successView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(143))];
    successView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:successView];
    
    UIImageView *successImageV = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-ALD(50))/2, ALD(25), ALD(50), ALD(50))];
    successImageV.image = [UIImage imageNamed:@"PaySuccessed"];
    [successView addSubview:successImageV];
    
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, successImageV.bottom+ALD(20), kScreenWidth, ALD(18))];
    successLabel.font = WJFont16;
    successLabel.textColor = WJColorDarkGray;
    successLabel.textAlignment = NSTextAlignmentCenter;
    [successView addSubview:successLabel];
    
    UIView * upline = [[UIView alloc] initWithFrame:CGRectMake(0, successView.height-0.5, SCREEN_WIDTH, 0.5)];
    upline.backgroundColor = WJColorSeparatorLine;
    [successView addSubview:upline];
    
    
    UIView *detailView = [[UIView alloc] init];
    detailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:detailView];
    
    UIView * topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    topline.backgroundColor = WJColorSeparatorLine;
    [detailView addSubview:topline];
    
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(15), ALD(240), ALD(20))];
    titleL.font = WJFont15;
    titleL.textColor = WJColorDarkGray;
    [detailView addSubview:titleL];
    
    
    UILabel *amountL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), titleL.bottom, ALD(200), ALD(20))];
    amountL.font = WJFont12;
    amountL.textColor = WJColorLightGray;
    [detailView addSubview:amountL];
    
    
    UIView * bottomline = [[UIView alloc] init];
    bottomline.backgroundColor = WJColorSeparatorLine;
    [detailView addSubview:bottomline];
    
    
    UIButton *cardPackageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cardPackageBtn.layer.cornerRadius = 5;
    cardPackageBtn.layer.borderWidth = 1;
    cardPackageBtn.layer.borderColor = WJColorLightGray.CGColor;
    cardPackageBtn.backgroundColor = [UIColor clearColor];
    [cardPackageBtn setTitleColor:WJColorLightGray forState:UIControlStateNormal];
    cardPackageBtn.titleLabel.font = WJFont14;
    [self.view addSubview:cardPackageBtn];
    
    UIButton *backHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backHomeBtn.layer.cornerRadius = 5;
    backHomeBtn.layer.borderWidth = 1;
    backHomeBtn.layer.borderColor = WJColorLightGray.CGColor;
    backHomeBtn.backgroundColor = [UIColor clearColor];
    backHomeBtn.titleLabel.font = WJFont14;
    [backHomeBtn setTitleColor:WJColorLightGray forState:UIControlStateNormal];
    [self.view addSubview:backHomeBtn];
    
    
    if(payCompleteModel.paymentType == PaymentTypeBuy)
    {
        self.eventID = @"iOS_act_buycardresult";
        successLabel.text = @"购卡成功";
        detailView.frame = CGRectMake(0, successView.bottom+ALD(10), kScreenWidth, ALD(90));
        
//        buyOrderModel = [[WJElectronicCardModel alloc] initWithEcard:payCompleteModel.ecard];
//        buyOrderModel.modelOrderNo = payCompleteModel.orderNo;
//        buyOrderModel.modelNums = payCompleteModel.ecardsNum;
        
        //数量
        UILabel *countL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), amountL.bottom, ALD(200), ALD(20))];
        countL.font = WJFont12;
        countL.textColor = WJColorLightGray;
        [detailView addSubview:countL];
        
        UILabel *moneyL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -ALD(12), titleL.y, ALD(100), ALD(20))];
        moneyL.textAlignment = NSTextAlignmentRight;
        moneyL.font = WJFont18;
        [detailView addSubview:moneyL];
        
        UIImageView *baoziView = [[UIImageView alloc] initWithFrame:CGRectMake(moneyL.x - ALD(21), moneyL.y, ALD(16), ALD(13))];
        baoziView.centerY = moneyL.centerY;
        baoziView.hidden = YES;
        baoziView.image = [UIImage imageNamed:@"fair_ic_baozi"];
        [detailView addSubview:baoziView];


        //包子支付
        NSString *baoziNum = [WJUtilityMethod baoziNumberFormatter: payCompleteModel.ecard.salePrice];
        NSString *salePriceRmb = [NSString stringWithFormat:@"%@", [WJUtilityMethod floatNumberForMoneyFomatter:[payCompleteModel.ecard.salePriceRmb floatValue]]];

        CGFloat moneyWidth = [UILabel getWidthWithTitle:baoziNum font:WJFont18];
        CGFloat rmbMoneyWidth = [UILabel getWidthWithTitle:salePriceRmb font:WJFont18];

        // 包子支付
        if (payCompleteModel.electronicCardPayType == ElectronicCardPayTypeBaoZi) {
            
            baoziView.hidden = NO;
            moneyL.frame = CGRectMake(SCREEN_WIDTH -ALD(12)-moneyWidth, titleL.y, moneyWidth, ALD(20));
            baoziView.frame = CGRectMake(moneyL.x - ALD(21), moneyL.y, ALD(16), ALD(13));
            moneyL.textColor = WJYellowColorAmount;
            moneyL.text = baoziNum;
            
        } else {
           // 人民币支付
            baoziView.hidden = YES;
            moneyL.frame = CGRectMake(SCREEN_WIDTH -ALD(12)-rmbMoneyWidth, titleL.y, rmbMoneyWidth, ALD(20));
            moneyL.textColor = WJColorAmount;
            moneyL.text = [NSString stringWithFormat:@"￥ %@",salePriceRmb];

        }
        
        
//        UILabel *moneyL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -ALD(12)-moneyWidth, titleL.y, moneyWidth, ALD(20))];
//        moneyL.font = WJFont18;
//        moneyL.text = baoziNum;
//        moneyL.textAlignment = NSTextAlignmentRight;
//        moneyL.textColor = WJYellowColorAmount;
//        [detailView addSubview:moneyL];
        
//        UIImageView *baoziView = [[UIImageView alloc] initWithFrame:CGRectMake(moneyL.x - ALD(21), moneyL.y, ALD(16), ALD(13))];
//        baoziView.centerY = moneyL.centerY;
//        baoziView.hidden = YES;
//        baoziView.image = [UIImage imageNamed:@"fair_ic_baozi"];
//        [detailView addSubview:baoziView];
        
        titleL.text = payCompleteModel.ecard.commodityName;
        amountL.text = [NSString stringWithFormat:@"面值%.0f元",[payCompleteModel.ecard.facePrice floatValue]];
        countL.text = [NSString stringWithFormat:@"数量:%@",payCompleteModel.ecardsNum];
        
        UILabel *  tipsL = [[UILabel alloc] initWithFrame:CGRectMake(0, detailView.bottom + ALD(12), SCREEN_WIDTH, ALD(15))];
        tipsL.font = WJFont12;
        tipsL.text = @"您可以在个人中心“我的资产-电子卡”中查看持有的卡";
        tipsL.textAlignment = NSTextAlignmentCenter;
        tipsL.textColor = WJColorLightGray;
        [self.view addSubview:tipsL];
        
//        cardPackageBtn.frame = CGRectMake(ALD(56), tipsL.bottom+ALD(30), ALD(117), ALD(35));
//        [cardPackageBtn setTitle:@"立即提取" forState:UIControlStateNormal];
//        [cardPackageBtn addTarget:self action:@selector(extractCardClick:) forControlEvents:UIControlEventTouchUpInside];
        
        backHomeBtn.frame = CGRectMake((kScreenWidth-ALD(117))/2, tipsL.bottom+ALD(30), ALD(117), ALD(35));
        [backHomeBtn setTitle:@"再去逛逛" forState:UIControlStateNormal];
        [backHomeBtn addTarget:self action:@selector(pushToFairClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        self.eventID = @"iOS_act_prechargeresult";
        successLabel.text = @"充值成功";
        if( payCompleteModel.promptStr.length > 0){
            
            CGFloat textH = [UILabel getHeightByWidth:SCREEN_WIDTH - ALD(24) title:payCompleteModel.promptStr font:WJFont12];
            UILabel *promptL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), amountL.bottom,  SCREEN_WIDTH - ALD(24),  textH)];
            promptL.font = WJFont12;
            promptL.text = payCompleteModel.promptStr;
            promptL.numberOfLines = 0;
            promptL.textAlignment = NSTextAlignmentLeft;
            promptL.textColor = WJColorLightGray;
            [detailView addSubview:promptL];
            
            detailView.frame = CGRectMake(0, successView.bottom+ALD(10), kScreenWidth, ALD(55) + textH + ALD(15));
            
        }else{
            detailView.frame = CGRectMake(0, successView.bottom+ALD(10), kScreenWidth, ALD(70));
        }
        
        titleL.text = [NSString stringWithFormat:@"到账:%@",payCompleteModel.rechargeDescribe];
        amountL.text = [NSString stringWithFormat:@"实付:￥%@",payCompleteModel.realPay];
        
        
        UIButton *cardPackageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cardPackageBtn.layer.cornerRadius = 5;
        cardPackageBtn.layer.borderWidth = 1;
        cardPackageBtn.layer.borderColor = WJColorLightGray.CGColor;
        cardPackageBtn.backgroundColor = [UIColor clearColor];
        [cardPackageBtn setTitleColor:WJColorLightGray forState:UIControlStateNormal];
        cardPackageBtn.titleLabel.font = WJFont14;
        [self.view addSubview:cardPackageBtn];

        cardPackageBtn.frame = CGRectMake(ALD(56), detailView.bottom+ALD(30), ALD(117), ALD(35));
        [cardPackageBtn setTitle:@"去包子商城" forState:UIControlStateNormal];
        [cardPackageBtn addTarget:self action:@selector(pushToFairClick:) forControlEvents:UIControlEventTouchUpInside];
        
        backHomeBtn.frame = CGRectMake(kScreenWidth-ALD(117)-ALD(56), cardPackageBtn.y, ALD(117), ALD (35));
        [backHomeBtn setTitle:@"完成" forState:UIControlStateNormal];
        [backHomeBtn addTarget:self action:@selector(goBackLast) forControlEvents:UIControlEventTouchUpInside];
    }
    
    bottomline.frame = CGRectMake(0, detailView.height-0.5, SCREEN_WIDTH, 0.5);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//返回
- (void)backBarButton:(UIButton *)btn
{
    [self goBackLast];
}


- (void)goBackLast{
    
    if(payCompleteModel.paymentType == PaymentTypeBuy){
        //购卡
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //充值,回到确认订单页前一页（市集tab、个人tab、电子卡详情）
        WJViewController *vc = [[WJGlobalVariable sharedInstance] payfromController];
        [self.navigationController popToViewController:vc animated:YES];
    }
}


#pragma mark - 再去逛逛回市集
- (void)pushToFairClick:(UIButton *)btn
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    if (appDelegate.myTab.selectedIndex != 1) {
//        
//        [appDelegate.myTab changeTabIndex:1];
//    }
    
    if (self.electronicCardComeFrom == ComeFromFair) {
        
        if (appDelegate.myTab.selectedIndex != 1) {
            
            [appDelegate.myTab changeTabIndex:1];
        }
    } else {
        if (appDelegate.myTab.selectedIndex != 2) {
            
            [appDelegate.myTab changeTabIndex:2];
        }
    }
}


//#pragma mark - 提取
//- (void)extractCardClick:(UIButton *)btn
//{
//    //先验证通过跳转提取电子卡提取页
//    WJPsdVerifyAlert *alert = [[WJPsdVerifyAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    alert.delegate = self;
//    [alert showIn];
//}
//
//
//#pragma mark - 找回密码逻辑
//
//- (void)showAlertWithMessage:(NSString *)msg isLocked:(BOOL)isLocked
//{
//    
//    NSString *title = nil;
//    NSString *otherBtnTitle = nil;
//    if (isLocked) {
//        title = @"账号已被锁定";
//        otherBtnTitle = @"找回支付密码";
//    }else{
//        title = @"验证失败";
//        otherBtnTitle = @"再试一次";
//    }
//    
//    WJSystemAlertView *sysAlert = [[WJSystemAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:otherBtnTitle textAlignment:NSTextAlignmentCenter];
//    
//    [sysAlert showIn];
//}
//
//
//- (void)findPassword
//{
//    
//    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
//    NSInteger appealStatus = person.appealStatus;
//    BOOL isSetQuestion = person.isSetPsdQuestion;
//    NSInteger realnameStatus = person.authentication;
//    NSString *realname = nil;
//    NSString *userPhone = person.phone;
//    
//    if (person.realName) {
//        if ([person.realName length]>0) {
//            realname = person.realName;
//        }
//    }
//    
//    if (IOS8_LATER) {
//        
//        __weak typeof(self) weakSelf = self;
//        __weak NSString *weakName = realname;
//        __weak NSString *weakPhone = userPhone;
//        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"找回密码" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alertControl addAction:cancelAction];
//        
//        UIAlertAction *appealAction = [UIAlertAction actionWithTitle:@"申诉找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            __strong typeof(self) strongSelf = weakSelf;
//            
//            if (appealStatus == AppealProcessing){
//                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"申诉处理中"];
//                
//            }else{
//                
//                [WJGlobalVariable sharedInstance].findPwdFromController = strongSelf;
//                //申诉找回
//                WJAppealViewController *findPswVC = [[WJAppealViewController alloc] init];
//                if (weakPhone) {
//                    findPswVC.userPhone = weakPhone;
//                }
//                [strongSelf.navigationController pushViewController:findPswVC animated:YES];
//            }
//        }];
//        
//        [alertControl addAction:appealAction];
//        
//        if (isSetQuestion) {
//            
//            UIAlertAction *quesAction = [UIAlertAction actionWithTitle:@"安全问题找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                __strong typeof(self) strongSelf = weakSelf;
//                [WJGlobalVariable sharedInstance].findPwdFromController = strongSelf;
//                //安全问题找回
//                WJFindSafetyQuestionController *findSafeVC = [[WJFindSafetyQuestionController alloc] init];
//                findSafeVC.phoneNumber = weakPhone;
//                [strongSelf.navigationController pushViewController:findSafeVC animated:YES];
//            }];
//            
//            [alertControl addAction:quesAction];
//        }
//        
//        if (realnameStatus == 2) {
//            
//            UIAlertAction *authAction = [UIAlertAction actionWithTitle:@"实名验证找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                __strong typeof(self) strongSelf = weakSelf;
//                [WJGlobalVariable sharedInstance].findPwdFromController = strongSelf;
//                //实名验证找回
//                WJFindRealNameAuthenticationViewController *authenticVC = [[WJFindRealNameAuthenticationViewController alloc] init];
//                if (weakName) {
//                    authenticVC.realName = weakName;
//                }
//                [strongSelf.navigationController pushViewController:authenticVC animated:YES];
//                
//            }];
//            [alertControl addAction:authAction];
//        }
//        
//        [self presentViewController:alertControl animated:YES completion:nil];
//        
//    }else{
//        
//        
//        UIActionSheet *actionSheet = nil;
//        if (isSetQuestion && realnameStatus == 2) {
//            actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"实名验证找回",@"安全问题找回",@"申诉找回", nil];
//            
//        }else {
//            
//            if (isSetQuestion) {
//                actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"安全问题找回",@"申诉找回", nil];
//                
//            }else if (realnameStatus == 2){
//                actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"实名验证找回",@"申诉找回", nil];
//                
//            }else{
//                actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"申诉找回", nil];
//            }
//        }
//        
//        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//        [actionSheet showInView:self.view];
//    }
//    
//}
//
//
//#pragma mark - WJPsdVerifyAlertDelegate
//- (void)successWithVerifyPsdAlert:(WJPsdVerifyAlert *)alertView
//{
//    [alertView dismiss];
//    
//    //进入提取卡密页面
//    WJExtraCardController *vc = [[WJExtraCardController alloc] initWithModel:buyOrderModel];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//
//- (void)failedWithVerifyPsdAlert:(WJPsdVerifyAlert *)alertView
//                    errerMessage:(NSString *)errerMessage
//                        isLocked:(BOOL)isLocked
//{
//    [alertView dismiss];
//    [self showAlertWithMessage:errerMessage isLocked:isLocked];
//}
//
//
//- (void)findPasswordWithAlert:(WJPsdVerifyAlert *)alert
//{
//    [alert dismiss];
//    [self findPassword];
//}
//
//
//#pragma mark - WJSystemAlertViewDelegate
//- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    //取消
//    if (buttonIndex == 0) {
//        [alertView dismiss];
//    }else{
//        
//        if ([alertView.title isEqualToString:@"验证失败"]) {
//            //再试一次
//            WJPsdVerifyAlert *alert = [[WJPsdVerifyAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//            alert.delegate = self;
//            [alert showIn];
//            
//        }else if ([alertView.title isEqualToString:@"账号已被锁定"]) {
//            
//            [alertView dismiss];
//            [self findPassword];
//        }
//    }
//}
//
//
//#pragma mark - UIActionSheetDelegate
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
//    NSInteger appealStatus = person.appealStatus;
//    BOOL isSetQuestion = person.isSetPsdQuestion;
//    NSInteger realnameStatus = person.authentication;
//    NSString *realname = nil;
//    NSString *userPhone = person.phone;
//    
//    if (person.realName) {
//        if ([person.realName length]>0) {
//            realname = person.realName;
//        }
//    }
//    
//    if (realnameStatus == 2) {
//        if (buttonIndex == 0) {
//            //实名验证找回
//            [WJGlobalVariable sharedInstance].findPwdFromController = self;
//            WJFindRealNameAuthenticationViewController *authenticVC = [[WJFindRealNameAuthenticationViewController alloc] init];
//            if (realname) {
//                authenticVC.realName = realname;
//            }
//            [self.navigationController pushViewController:authenticVC animated:YES];
//            
//        }else{
//            
//            if (isSetQuestion && buttonIndex == 1) {
//                //安全问题
//                [WJGlobalVariable sharedInstance].findPwdFromController = self;
//                WJFindSafetyQuestionController *findSafeVC = [[WJFindSafetyQuestionController alloc] init];
//                [self.navigationController pushViewController:findSafeVC animated:YES];
//                return;
//                
//            }else if((isSetQuestion && buttonIndex == 2) || (!isSetQuestion && buttonIndex == 1)){
//                //账户申诉找回
//                
//                switch (appealStatus) {
//                    case AppealProcessing:
//                    {
//                        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"申诉处理中"];
//                    }
//                        break;
//                        
//                    default:
//                    {
//                        [WJGlobalVariable sharedInstance].findPwdFromController = self;
//                        WJAppealViewController *findPswVC = [[WJAppealViewController alloc] init];
//                        if (userPhone) {
//                            findPswVC.userPhone = userPhone;
//                        }
//                        [self.navigationController pushViewController:findPswVC animated:YES];
//                    }
//                        break;
//                }
//                return;
//            }
//        }
//        
//    }else{
//        
//        if (isSetQuestion && buttonIndex == 0) {
//            
//            //安全问题找回
//            [WJGlobalVariable sharedInstance].findPwdFromController = self;
//            WJFindSafetyQuestionController *findSafeVC = [[WJFindSafetyQuestionController alloc] init];
//            [self.navigationController pushViewController:findSafeVC animated:YES];
//            return;
//            
//        }else if ((isSetQuestion && buttonIndex == 1) || (!isSetQuestion && buttonIndex == 0)) {
//            
//            //申诉找回
//            if (appealStatus == AppealProcessing){
//                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"申诉处理中"];
//            }else{
//                [WJGlobalVariable sharedInstance].findPwdFromController = self;
//                WJAppealViewController *findPswVC = [[WJAppealViewController alloc] init];
//                if (userPhone) {
//                    findPswVC.userPhone = userPhone;
//                }
//                [self.navigationController pushViewController:findPswVC animated:YES];
//            }
//            
//            return;
//        }
//    }
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
