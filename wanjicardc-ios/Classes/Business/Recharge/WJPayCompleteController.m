//
//  WJPayCompleteController.m
//  WanJiCard
//
//  Created by Angie on 15/9/11.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJPayCompleteController.h"
#import "WJCardsDetailViewController.h"
#import "WJOwnedCardListController.h"
#import "AppDelegate.h"
#import "PayPrivilegeModel.h"
#import "WJECardDetailModel.h"

@interface WJPayCompleteController (){
    WJPayCompleteModel *payCompleteModel;
    UILabel *successLabel;
}

@end

@implementation WJPayCompleteController

- (instancetype)initWithinfo:(WJPayCompleteModel *)completeInfo{
    if (self = [super init]) {
        payCompleteModel = completeInfo;
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self removeScreenEdgePanGesture];
    
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
    
    successLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, successImageV.bottom+ALD(20), kScreenWidth, ALD(18))];
    successLabel.font = WJFont16;
    successLabel.textColor = WJColorDarkGray;
    successLabel.textAlignment = NSTextAlignmentCenter;
    [successView addSubview:successLabel];
    
    UIView * upline = [[UIView alloc] initWithFrame:CGRectMake(0, successView.height-0.5, SCREEN_WIDTH, 0.5)];
    upline.backgroundColor = WJColorSeparatorLine;
    [successView addSubview:upline];
    
    //购卡和充值UI
   // if([self.eventID isEqualToString:@"iOS_act_buycardresult"] || [self.eventID isEqualToString:@"iOS_act_prechargeresult"])
    if(payCompleteModel.paymentType != PaymentTypeConsume)
    {
        
        UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, successView.bottom+ALD(10), kScreenWidth, ALD(131))];
        detailView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:detailView];
        
        UIView * topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        topline.backgroundColor = WJColorSeparatorLine;
        [detailView addSubview:topline];
        
        //卡名
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(20), ALD(200), ALD(17))];
        titleL.font = WJFont15;
        titleL.textColor = WJColorDarkGray;
        [detailView addSubview:titleL];
        
        //面值
        UILabel *amountL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), titleL.bottom+10, ALD(200), ALD(14))];
        amountL.font = WJFont12;
        amountL.textColor = WJColorLightGray;
        [detailView addSubview:amountL];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(ALD(10), amountL.bottom+ALD(20), kScreenWidth -ALD(20), 0.5)];
        line.backgroundColor = WJColorSeparatorLine;
        [detailView addSubview:line];
        
        
        UILabel *  moneyLanel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-ALD(120), ALD(20), ALD(110), ALD(16))];
        moneyLanel.font = WJFont14;
        moneyLanel.textAlignment = NSTextAlignmentRight;
        moneyLanel.textColor = WJColorDarkGray;
        [detailView addSubview:moneyLanel];
        
        UILabel *privilegeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), line.bottom+ALD(10), 50, ALD(30))];
        privilegeLabel.text = @"特权";
        privilegeLabel.font = WJFont15;
        privilegeLabel.textColor = WJColorLightGray;
        [detailView addSubview:privilegeLabel];
        
        
        UIButton *cardPackageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cardPackageBtn.layer.cornerRadius = 5;
        cardPackageBtn.layer.borderWidth = 1;
        cardPackageBtn.layer.borderColor = WJColorLightGray.CGColor;
        cardPackageBtn.backgroundColor = [UIColor clearColor];
        cardPackageBtn.frame = CGRectMake(ALD(56), detailView.bottom+ALD(30), ALD(117), ALD(35));
        [cardPackageBtn setTitleColor:WJColorLightGray forState:UIControlStateNormal];
        cardPackageBtn.titleLabel.font = WJFont14;
        [cardPackageBtn addTarget:self action:@selector(pushToCardPackageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cardPackageBtn];
        
        
        titleL.text = payCompleteModel.cardName;
        amountL.text = [NSString stringWithFormat:@"面值%@元",payCompleteModel.cardFaceValue];
        moneyLanel.text = [NSString stringWithFormat:@"￥%@",payCompleteModel.realPay];

        
        int maxCount = (kScreenWidth - 60)/ALD(50);
        if (payCompleteModel.privilegeArray.count >0) {
            
            for (int i = 0; i < MIN(maxCount, payCompleteModel.privilegeArray.count); i++) {
                PayPrivilegeModel *model = payCompleteModel.privilegeArray[i];
                
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(privilegeLabel.right+ALD(50)*i, line.bottom+7.5, ALD(35), ALD(35))];
                iv.layer.cornerRadius = iv.width/2;
                iv.layer.masksToBounds = YES;
                [iv sd_setImageWithURL:[NSURL URLWithString:model.privilegePic?:@""]
                      placeholderImage:[UIImage imageNamed:@"topic_default"]];
                [detailView addSubview:iv];
            }
            
        }

        
        UIButton *backHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backHomeBtn.layer.cornerRadius = 5;
        backHomeBtn.layer.borderWidth = 1;
        backHomeBtn.layer.borderColor = WJColorLightGray.CGColor;
        backHomeBtn.backgroundColor = [UIColor clearColor];
        backHomeBtn.titleLabel.font = WJFont14;
        [backHomeBtn setTitleColor:WJColorLightGray forState:UIControlStateNormal];
        backHomeBtn.frame = CGRectMake(kScreenWidth-ALD(117)-ALD(56), detailView.bottom+ALD(30), ALD(117), ALD(35));
        [backHomeBtn setTitle:@"回首页" forState:UIControlStateNormal];
        [backHomeBtn addTarget:self action:@selector(backHomeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backHomeBtn];
        
        UIView * bottomline = [[UIView alloc] initWithFrame:CGRectMake(0, detailView.height-0.5, SCREEN_WIDTH, 0.5)];
        bottomline.backgroundColor = WJColorSeparatorLine;
        [detailView addSubview:bottomline];
        
        if(payCompleteModel.paymentType == PaymentTypeBuy)
        {
            self.eventID = @"iOS_act_buycardresult";
            self.title = @"支付成功";
            successLabel.text = @"购卡成功";
            
            [cardPackageBtn setTitle:@"去卡包看看" forState:UIControlStateNormal];
            cardPackageBtn.tag = 1001;
            backHomeBtn.tag =1003;
        }
        else
        {
            self.eventID = @"iOS_act_prechargeresult";
            self.title = @"支付成功";
            successLabel.text = @"充值成功";
            
            
            [cardPackageBtn setTitle:@"去消费" forState:UIControlStateNormal];
            cardPackageBtn.tag = 1002;
            backHomeBtn.tag =1004;
        }


    }
    else
    {
        
        self.eventID = @"iOS_act_consumeresult";
        self.title = @"交易结果";
        [self hiddenBackBarButtonItem];
        successLabel.text = @"支付成功";
        
        
        UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, successView.bottom+ALD(10), self.view.width, ALD(88.5))];
        detailView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:detailView];
        
        UIView * topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        topline.backgroundColor = WJColorSeparatorLine;
        [detailView addSubview:topline];
        
        UILabel *  payeeMerchantL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(14), ALD(110), ALD(16))];
        payeeMerchantL.text = @"收款商户";
        payeeMerchantL.font = WJFont15;
        payeeMerchantL.textColor = WJColorDarkGray;
        payeeMerchantL.textAlignment = NSTextAlignmentLeft;
        [detailView addSubview:payeeMerchantL];
        
        UILabel *  MerchantL = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - ALD(220), ALD(14), ALD(210), ALD(16))];
        MerchantL.text = payCompleteModel.merName?:@"";
        MerchantL.font = WJFont14;
        MerchantL.textColor = WJColorLightGray;
        MerchantL.textAlignment = NSTextAlignmentRight;
        [detailView addSubview:MerchantL];
        
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(ALD(10), ALD(44), kScreenWidth -ALD(20), 0.5)];
        line.backgroundColor = WJColorSeparatorLine;
        [detailView addSubview:line];
        
        
        UILabel *  consumeMoneyL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(14+44.5), ALD(110), ALD(16))];
        consumeMoneyL.text = @"消费金额";
        consumeMoneyL.font = WJFont15;
        consumeMoneyL.textColor = WJColorDarkGray;
        consumeMoneyL.textAlignment = NSTextAlignmentLeft;
        [detailView addSubview:consumeMoneyL];
        
        UILabel *  moneyL = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-ALD(210), ALD(14+44.5), ALD(200), ALD(16))];
        moneyL.text = [NSString stringWithFormat:@"￥ %.2f", [payCompleteModel.amount floatValue]];
        moneyL.font = WJFont14;
        moneyL.textColor = WJColorLightGray;
        moneyL.textAlignment = NSTextAlignmentRight;
        [detailView addSubview:moneyL];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.layer.masksToBounds = YES;
        closeBtn.layer.cornerRadius = 10;
        closeBtn.titleLabel.font = WJFont15;
        closeBtn.backgroundColor = WJColorNavigationBar;
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        closeBtn.frame = CGRectMake((self.view.width-ALD(345))/2, detailView.bottom+ALD(30), ALD(345), ALD(44));
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeBtn];
        
        UIView * bottomline = [[UIView alloc] initWithFrame:CGRectMake(0, detailView.height-0.5, SCREEN_WIDTH, 0.5)];
        bottomline.backgroundColor = WJColorSeparatorLine;
        [detailView addSubview:bottomline];
        
    }
}

#pragma mark - 关闭按钮
//关闭
- (void)closeClick
{
    [self goBackLast];
}

//返回
- (void)backBarButton:(UIButton *)btn
{
    [self goBackLast];
}


- (void)goBackLast{
    
    //跳转确认订单前一个controller
    WJViewController *vc = [[WJGlobalVariable sharedInstance] payfromController];

    //充值
    if([vc isKindOfClass:[WJCardsDetailViewController class]]){
        [kDefaultCenter postNotificationName:kChargeSuccess object:nil];
    }
    if([vc isKindOfClass:[WJOwnedCardListController class]]){
        
        [kDefaultCenter postNotificationName:kChargeSuccess object:payCompleteModel];
    }
    
    [kDefaultCenter postNotificationName:kRefreshCards object:nil];
    
    if(payCompleteModel.paymentType == PaymentTypeConsume){
        
        [self.navigationController popViewControllerAnimated:NO];
    }else{
      
        [self.navigationController popToViewController:vc animated:YES];
        
    }
  
   
}

#pragma mark - 去卡包看看
- (void)pushToCardPackageClick:(UIButton *)btn
{
    if (btn.tag == 1001) {
        [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_PaygotoCardBag1"];
    }
    if (btn.tag == 1002) {
        [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_RechargegotoCardBag"];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.myTab.selectedIndex != 2) {
        
        [appDelegate.myTab changeTabIndex:2];
    }
}


#pragma mark - 回首页
- (void)backHomeClick:(UIButton *)btn
{
    if (btn.tag == 1003) {
        [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_PaygotoHome"];
    }
    if (btn.tag == 1004) {
        [[WJStatisticsManager sharedStatisManager] event:@"iOS_act_RechargegotoHome"];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (appDelegate.myTab.selectedIndex != 0) {
        [appDelegate.myTab changeTabIndex:0];
    }
}

@end
