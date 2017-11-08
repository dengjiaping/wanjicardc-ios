//
//  WJOrderConfirmController.m
//  WanJiCard
//
//  Created by Angie on 15/9/21.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJOrderConfirmController.h"
#import "WJPayCompleteController.h"
#import "APIBuyProductManager.h"
#import "APIPayOrderManager.h"
#import "APIChargeTotalManager.h"
#import "APICardRechargeListersManager.h"

#import "Pingpp.h"
#import "WJOrderModel.h"

#import "libPayecoPayPlugin.h"
#import "WJOwnedCardListController.h"
#import "WJAvailableCouponViewController.h"
#import "WJCardChangeModel.h"
#import "WJChoiceCardModel.h"
//#import "WJCouponModel.h"
#import "WJOrderCardModel.h"
#import "WJCardsDetailViewController.h"
#import "WJSystemAlertView.h"
#import "PayPrivilegeModel.h"
#import "WJTicketModel.h"

@interface WJOrderConfirmController ()<UITableViewDataSource, UITableViewDelegate, PayEcoPpiDelegate, WJSystemAlertViewDelegate>{
   
    UITableView *mTb;
    
    NSString *cardID;          //充值（所选充值金额id）、购卡（当前卡id）
    NSString *productName;     //卡名
    NSString *merID;            //商家id
    NSString *merchantName;          //商家名
    BuyType buyType;            //类型
    
    NSString *orderNo;
    NSString *channelType;
    
    NSInteger selectedAmountTag;
    
    UIButton *selectedPayTypeBtn;
    NSInteger selectedPayTypeTag;
    
    WJTicketModel *selectTicket;        //所选优惠券
    
   
    WJCardChangeModel *cardChangeModel;
    WJOrderCardModel *cardOrderModel;
    
    UILabel *moneyLanel;    //购卡时右上角金额
    
    UIButton *payButton;    //立即充值/购买
    UILabel *goodsMoneyVL;      //商品金额
    UILabel *couponVL;          //优惠券
    UILabel *payMoneyVL;        //实付金额
    UILabel *activityCouponVL;  //活动优惠
    
    UILabel *actualPayL;        //实际支付
    
    CGFloat payAmount;          //前台展示金额
    
    WJSystemAlertView     *endAlert;    //结束
    WJSystemAlertView     *noQualifyAlert;//无资格买
    WJSystemAlertView     *noStockAlert;//无库存
    ActivityStatus       activityCodeMsg;
    
    BOOL    hadRequestChargeTotal;
}

@property (nonatomic, strong) NSMutableArray            *conpouArray;
@property (nonatomic, strong) APICardRechargeListersManager      *cardRechargeListersManager;  //充值优惠
@property (nonatomic, strong) APIChargeTotalManager     *chargeTotalManager;                   //购卡优惠
@property (nonatomic, strong) APIBuyProductManager      *buyProductManager;             //订单生成
//@property (nonatomic, strong) APIPayOrderManager        *payOrderManager;             //订单生成
@property (nonatomic, assign) CGFloat                   discount;
@end

@implementation WJOrderConfirmController

- (id)initWithCardId:(NSString *)pcid
            cardName:(NSString *)cardName
               merID:(NSString *)merid
             merName:(NSString *)merName
             buyType:(BuyType)type{
    
    if (self = [super init]) {
        if (pcid) {
            cardID = pcid;
        }

        productName = cardName;
        merID = merid;
        merchantName = merName;
        buyType = type;
        
        self.conpouArray = [NSMutableArray array];
        selectedPayTypeTag = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    NSLog(@"merid = %@",self.chargeTotalManager.merID);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeConpou:) name:@"ShowFinalTicketModel" object:nil];
    
    self.title = @"确认订单";
    self.isNeedToken = YES;
    channelType = @"pingapp";
 
    //充值
    if (buyType == BuyTypeCharge) {
        self.eventID = @"iOS_act_prechargedetails";
        
    } else {
        self.eventID = @"iOS_act_buycardinfo";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alipayCallBack:)
                                                 name:@"alipayResultCallBack"
                                               object:nil];
    
   
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!hadRequestChargeTotal) {
        hadRequestChargeTotal = YES;
        [self requestChargeTotal];
    }
}

- (void)initContent
{
    mTb = [[UITableView alloc] initForAutoLayout];
    mTb.delegate = self;
    mTb.dataSource = self;
    mTb.tag = 10001;
    mTb.separatorInset = UIEdgeInsetsZero;
    mTb.backgroundColor = WJColorViewBg;
    mTb.separatorColor = WJColorSeparatorLine;
    mTb.tableFooterView = [UIView new];
    [self.view addSubview:mTb];

    //底部支付背景图
    UIView *payBackgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 - ALD(48), kScreenWidth, ALD(48))];
    payBackgView.backgroundColor = WJColorWhite;
    [self.view addSubview:payBackgView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = WJColorSeparatorLine;
    [payBackgView addSubview:line];
    
    actualPayL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, ALD(200), ALD(48))];
    actualPayL.textAlignment = NSTextAlignmentLeft;
    actualPayL.textColor = WJColorDarkGray;
    actualPayL.font = WJFont14;
    [payBackgView addSubview:actualPayL];
   
    payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(kScreenWidth-ALD(110), ALD(13)/2, ALD(100), ALD(35));
    
    if (buyType == BuyTypeCharge) {
        
        [payButton setTitle:@"立即充值" forState:UIControlStateNormal];
        if(cardChangeModel.choiceCardArray.count >0){
            
            payButton.backgroundColor = kBlueColor;
            payButton.enabled = YES;
        }else{
            
            payButton.backgroundColor = WJColorViewNotEditable;
            payButton.enabled = NO;
        }

    } else {
        [payButton setTitle:@"立即购买" forState:UIControlStateNormal];
        payButton.backgroundColor = kBlueColor;
        payButton.enabled = YES;
    }
    
    payButton.layer.cornerRadius = 5;
    [payButton addTarget:self action:@selector(commitOrder:) forControlEvents:UIControlEventTouchUpInside];
    [payBackgView addSubview:payButton];
    [self.view addSubview:payBackgView];
    
    mTb.tableHeaderView = [self createHeadView];
    mTb.tableFooterView = [self createTableFooterView];
    
    [self.view VFLToConstraints:@"H:|[mTb]|" views:NSDictionaryOfVariableBindings(mTb)];
    [self.view VFLToConstraints:@"V:|-0-[mTb]-48-|" views:NSDictionaryOfVariableBindings(mTb)];
    [self.view addConstraints:[mTb constraintsTopInContainer:0]];
    
}

- (UIView *)createHeadView
{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = WJColorViewBg;

    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = WJColorWhite;

    [headView addSubview:bgView];
    
    UIView *bgViewbottomLine = [[UIView alloc] init];
    bgViewbottomLine.backgroundColor = WJColorSeparatorLine;
    [headView addSubview:bgViewbottomLine];
    
    //充值
    if (buyType == BuyTypeCharge) {
       
//        NSArray *amounts = @[@100, @300, @500, @1000];
        
        if (cardChangeModel.choiceCardArray.count > 0) {
            
            NSArray *amounts = cardChangeModel.choiceCardArray;
            
            CGFloat cellHeight = ALD(44);
            CGFloat titleHeight = ALD(44);
            
            bgView.frame = CGRectMake(0,0, kScreenWidth, cellHeight*amounts.count + titleHeight);
            headView.frame = CGRectMake(0, 0, kScreenWidth, bgView.height);
            bgViewbottomLine.frame = CGRectMake(0, headView.bottom - 0.5, kScreenWidth, 0.5);
            
            UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, kScreenWidth, titleHeight)];
            titleL.text = @"选择充值金额";
            titleL.font = WJFont14;
            titleL.textColor = WJColorDardGray3;
            [bgView addSubview:titleL];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), titleL.bottom, kScreenWidth-ALD(12)*2, 0.5)];
            line.backgroundColor = WJColorSeparatorLine;
            [bgView addSubview:line];
            
            
            for (int i = 0; i < amounts.count; i++) {
                
                WJChoiceCardModel * cardModel = (WJChoiceCardModel *)[amounts objectAtIndex:i];
                
                UILabel *amountL1 = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), titleL.bottom+cellHeight*i, kScreenWidth -ALD(10), cellHeight)];
                amountL1.text = [NSString stringWithFormat:@"￥ %@",[WJUtilityMethod floatNumberForMoneyFomatter:cardModel.cardFacePrice]];//元
                amountL1.font = WJFont14;
                amountL1.tag = 1000+i;
                amountL1.textColor = WJColorDardGray3;
                amountL1.userInteractionEnabled = YES;
                [bgView addSubview:amountL1];
                
                UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                chooseBtn.frame = CGRectMake(amountL1.size.width - ALD(15) -30, (cellHeight-30)/2, 30, 30);
                chooseBtn.tag = 400+i;
                [chooseBtn setImage:[UIImage imageNamed:@"toggle_button_nor"] forState:UIControlStateNormal];
                [chooseBtn setImage:[UIImage imageNamed:@"toggle_button_selected"] forState:UIControlStateSelected];
                chooseBtn.userInteractionEnabled = NO;
                [amountL1 addSubview:chooseBtn];
                
                
                line = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), amountL1.bottom, kScreenWidth-ALD(12)*2, 0.5)];
                line.backgroundColor = WJColorSeparatorLine;
                [bgView addSubview:line];
                
                if (i == 0) {
                    chooseBtn.selected = YES;
                }
                
                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAmountAction:)];
                [amountL1 addGestureRecognizer:gesture];
            }
            
            selectedAmountTag = 400;
        }
        
    }else{
        //购卡
        headView.frame = CGRectMake(0, 0, kScreenWidth, ALD(131));
        bgView.frame = CGRectMake(0, 0, kScreenWidth, ALD(131));
        bgViewbottomLine.frame = CGRectMake(0, headView.bottom - 0.5, kScreenWidth, 0.5);
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(20), kScreenWidth-ALD(130), ALD(17))];
        titleL.text = productName;
        titleL.font = WJFont15;
        titleL.textColor = WJColorDarkGray;
        [bgView addSubview:titleL];
        
        UILabel *amountL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), titleL.bottom+ALD(10), ALD(200), ALD(14))];
        amountL.text = [NSString stringWithFormat:@"面值%@元",self.currentCard.faceValue];
        amountL.font = WJFont12;
        amountL.textColor = WJColorLightGray;
        [bgView addSubview:amountL];
        
        moneyLanel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-ALD(110), ALD(20), ALD(100), ALD(16))];
        if([self.isLimitForSale boolValue]){
            moneyLanel.text = [NSString stringWithFormat:@"￥ %@",[WJUtilityMethod floatNumberForMoneyFomatter:[self.currentCard.price floatValue]]];
        }else{
            moneyLanel.text = [NSString stringWithFormat:@"￥ %@",[WJUtilityMethod floatNumberForMoneyFomatter:[self.currentCard.salePrice floatValue]]];
        }
       
        moneyLanel.font = WJFont16;
        moneyLanel.textAlignment = NSTextAlignmentRight;
        moneyLanel.textColor = WJColorAmount;
        [bgView addSubview:moneyLanel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ALD(10), amountL.bottom+ALD(20), kScreenWidth-ALD(10)*2, 0.5)];
        line.backgroundColor = WJColorSeparatorLine;
        [bgView addSubview:line];
        
        UILabel *amountL1 = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), line.bottom+ALD(17), ALD(50), ALD(16))];
        amountL1.text = @"特权";
        amountL1.font = WJFont14;
        amountL1.textColor = WJColorLightGray;
        [bgView addSubview:amountL1];
          

        int maxCount = (kScreenWidth - 60)/ALD(50);
        if (self.currentCard.privilegeArray.count >0) {
            for (int i = 0; i < MIN(maxCount, self.currentCard.privilegeArray.count); i++) {
                
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(amountL1.right+ALD(50)*i, line.bottom+ALD(10), ALD(30), ALD(30))];
                iv.layer.masksToBounds = YES;
                iv.layer.cornerRadius = iv.width/2;
                    
                PayPrivilegeModel *privilege = [self.currentCard.privilegeArray objectAtIndex:i];
                [iv sd_setImageWithURL:[NSURL URLWithString:privilege.privilegePic]
                      placeholderImage:[UIImage imageNamed:@"topic_default"]];
                
                [bgView addSubview:iv];
            }
        }
    }

    return headView;
}


- (UIView *)createTableFooterView
{
    //脚视图
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = WJColorViewBg;
    footerView.frame = CGRectMake(0, 0, kScreenWidth, buyType == BuyTypeCharge? ALD(118) : ALD(159));
    
    UIView *footertopLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(10), kScreenWidth, 0.5)];
    footertopLine.backgroundColor = WJColorSeparatorLine;
    [footerView addSubview:footertopLine];
    
    //背景View
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, footertopLine.bottom, kScreenWidth, footerView.height - ALD(10))];
    backView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:backView];
    
    //商品金额label
    UILabel *goodsMoneyL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(20), ALD(150), ALD(16))];
    goodsMoneyL.text = @"商品金额";
    goodsMoneyL.textColor = WJColorDarkGray;
    goodsMoneyL.font = WJFont14;
    [backView addSubview:goodsMoneyL];
    
    //优惠券
    UILabel *couponL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), goodsMoneyL.bottom+ALD(15), ALD(150), ALD(16))];
    couponL.text = @"优惠券";
    couponL.textColor = WJColorDarkGray;
    couponL.font = WJFont14;
    [backView addSubview:couponL];
    
    //实付金额
    UILabel *payMoneyL = [[UILabel alloc] init];
    payMoneyL.text = @"实付金额";
    payMoneyL.textColor = WJColorDarkGray;
    payMoneyL.font = WJFont14;
    [backView addSubview:payMoneyL];
    
    
    //商品金额Value
    goodsMoneyVL = [[UILabel alloc] init];
    [goodsMoneyVL setFrame:CGRectMake(kScreenWidth-ALD(150), ALD(20), ALD(140), ALD(16))];
    goodsMoneyVL.textAlignment = NSTextAlignmentRight;
    goodsMoneyVL.textColor = WJColorDarkGray;
    goodsMoneyVL.font = WJFont14;
    [backView addSubview:goodsMoneyVL];
    
    //优惠券Value
    couponVL = [[UILabel alloc] init];
    [couponVL setFrame:CGRectMake(kScreenWidth-ALD(150), goodsMoneyVL.bottom+ALD(15), ALD(140), ALD(16))];
    couponVL.textAlignment = NSTextAlignmentRight;
    couponVL.textColor = WJColorDarkGray;
    couponVL.font = WJFont14;
    [backView addSubview:couponVL];
    
    //实付金额Value
    payMoneyVL = [[UILabel alloc] init];
    payMoneyVL.textAlignment = NSTextAlignmentRight;
    payMoneyVL.textColor = WJColorDarkGray;
    payMoneyVL.font = WJFont14;
    [backView addSubview:payMoneyVL];
    
    //购卡
    if (buyType == BuyTypeOrder) {
        
        UILabel *activityCouponL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), couponL.bottom+ALD(15), ALD(150), ALD(16))];
        activityCouponL.text = @"活动优惠";
        activityCouponL.textColor = WJColorDarkGray;
        activityCouponL.font = WJFont14;
        [backView addSubview:activityCouponL];
        
        //活动优惠Value
        activityCouponVL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-ALD(150), couponVL.bottom+ALD(15), ALD(140), ALD(16))];
        activityCouponVL.textAlignment = NSTextAlignmentRight;
        activityCouponVL.font = WJFont14;
        activityCouponVL.textColor = WJColorDarkGray;
        [backView addSubview:activityCouponVL];
        
        payMoneyL.frame = CGRectMake(ALD(10), activityCouponL.bottom+ALD(15), ALD(150), ALD(16));
        payMoneyVL.frame = CGRectMake(kScreenWidth-ALD(150), activityCouponVL.bottom+ALD(15), ALD(140), ALD(16));
        
    }else{
        
        payMoneyL.frame = CGRectMake(ALD(10), couponL.bottom+ALD(15), ALD(150), ALD(16));
        payMoneyVL.frame = CGRectMake(kScreenWidth-ALD(150), couponVL.bottom+ALD(15), ALD(140), ALD(16));
    }
    
    
    UIView *footerbottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, footerView.height - 0.5, kScreenWidth, 0.5)];
    footerbottomLine.backgroundColor = WJColorSeparatorLine;
    [footerView addSubview:footerbottomLine];
    
    [self refreshCommitAmountL];
    
    return footerView;
}


- (NSAttributedString *)attributedText:(CGFloat)blance{
    NSString *string = [NSString stringWithFormat:@"实际支付：￥%@", [WJUtilityMethod floatNumberForMoneyFomatter:blance]];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]
                                         initWithString:string];
    NSDictionary *attributesForFirstWord = @{
                                             NSFontAttributeName : WJFont13,
                                             NSForegroundColorAttributeName : WJColorDarkGray,
                                             };
    
    NSDictionary *attributesForSecondWord = @{
                                              NSFontAttributeName : WJFont18,
                                              NSForegroundColorAttributeName : WJColorAmount,
                                              };
    [result setAttributes:attributesForFirstWord
                    range:NSMakeRange(0, 5)];
    [result setAttributes:attributesForSecondWord
                    range:NSMakeRange(5, string.length - 5)];
    return [[NSAttributedString alloc] initWithAttributedString:result];
}


#pragma mark - Request

- (void)requestChargeTotal
{
    [self showLoadingView];
    
    if (buyType == BuyTypeCharge) {
        [self.cardRechargeListersManager loadData];
    }else{
     
        [self.chargeTotalManager loadData];
    }
}


- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    //充值
    if ([manager isKindOfClass:[APICardRechargeListersManager class]]) {

        [self hiddenLoadingView];
        
        NSDictionary * dic = [manager fetchDataWithReformer:nil];
        cardChangeModel = [[WJCardChangeModel alloc] initWithDic:dic];
       
        self.discount = cardChangeModel.discount;
        
        if (cardChangeModel.couponArray.count > 0) {
            self.conpouArray = [NSMutableArray arrayWithArray:cardChangeModel.couponArray];
            selectTicket = [self.conpouArray objectAtIndex:0];
        }
        
        if ([cardChangeModel.choiceCardArray count] > 0) {
            cardID =  ((WJChoiceCardModel *)[cardChangeModel.choiceCardArray objectAtIndex:0]).cardId;
        }
        
        [self initContent];

        
    } else if ([manager isKindOfClass:[APIChargeTotalManager class]]){
        
        //购卡
        [self hiddenLoadingView];
        
        NSDictionary * dic = [manager fetchDataWithReformer:nil];
        cardOrderModel = [[WJOrderCardModel alloc] initWithDic:dic];
        
        if(cardOrderModel.couponArray.count > 0){
            self.conpouArray = [NSMutableArray arrayWithArray:cardOrderModel.couponArray];
            selectTicket = [self.conpouArray objectAtIndex:0];
        }
       
        [self initContent];
        
        //如果限购
        if ([self.isLimitForSale boolValue]) {
            activityCodeMsg = [cardOrderModel.code integerValue];
            [self checkView];
        }
        
    } else if ([manager isKindOfClass:[APIBuyProductManager class]]) {
        
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        orderNo = dic[@"cardOrderNo"];
        payAmount = [ToString(dic[@"cardOrderAmount"]) floatValue];
 
        //易联支付
        if ([self.buyProductManager.channelType isEqualToString:@"payeco"]) {
            
            channelType = @"payeco";
            
            //商户需要提交给支付插件的订单内容
            [self performSelectorOnMainThread:@selector(goNext:) withObject:dic[@"charge"] waitUntilDone:NO];
            
            return;
        }
        channelType = @"pingapp";
        [self hiddenLoadingView];
        __weak typeof(self) weakSelf = self;
        [Pingpp createPayment:dic[@"charge"]
               viewController:self
                 appURLScheme:KAppURLScheme
               withCompletion:^(NSString *result, PingppError *error) {
                   if ([result isEqualToString:@"success"]) {
                       // 支付成功
                       
                       [weakSelf paymentSuccess];
                       
                   } else {
                       if (error.code == PingppErrCancelled) {
                           ALERT(@"已取消付款操作，交易失败！");
                       }else{
                           ALERT(@"交易失败");
                       }
                       [weakSelf.navigationController popViewControllerAnimated:YES];
                   }
               }];
        
    }
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    if (manager.errorMessage && manager.errorMessage.length >0) {
        ALERT(manager.errorMessage);
    }
}


- (void)checkView
{
    
    switch (activityCodeMsg) {
        case ActivityPause:
            if (endAlert == nil) {
                
                endAlert = [[WJSystemAlertView alloc]initWithTitle:nil
                                                           message:@"活动已结束，将为您恢复原价"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil
                                                     textAlignment:NSTextAlignmentCenter];
            }
            
            [endAlert showIn];
            break;
            
        case ActivityEnd:
            if (endAlert == nil) {
                
                
                endAlert = [[WJSystemAlertView alloc]initWithTitle:nil
                                                           message:@"活动已结束，将为您恢复原价"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil
                                                     textAlignment:NSTextAlignmentCenter];
            }

            [endAlert showIn];
            break;
            
        case ActivityNoQualification:
            if (noQualifyAlert == nil) {
                
                noQualifyAlert = [[WJSystemAlertView alloc]initWithTitle:nil
                                                                 message:@"您尚未满足参与活动的条件，将为您恢复原价"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil
                                                           textAlignment:NSTextAlignmentCenter];
                
            }
            

            [noQualifyAlert showIn];
            break;
            
        case ActivityNoStock:
            if (noStockAlert == nil) {
                
                
                noStockAlert = [[WJSystemAlertView alloc]initWithTitle:nil
                                                               message:@"活动太火爆，已经被抢光了，但仍有用户尚未支付，您可以"
                                                              delegate:self
                                                     cancelButtonTitle:@"稍后再试"
                                                     otherButtonTitles:@"原价购买"
                                                         textAlignment:NSTextAlignmentCenter];
            }

            [noStockAlert showIn];
            break;
            
        default :
            break;
    }
    
}

- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == endAlert) {
        if (0 ==buttonIndex) {
            //恢复原价
            self.isLimitForSale = @"0";
            //刷新上面展示的价格
            moneyLanel.text = [NSString stringWithFormat:@"￥ %@",[WJUtilityMethod floatNumberForMoneyFomatter:[self.currentCard.salePrice floatValue]]];
            

            [self refreshCommitAmountL];
        }
    }
    
    if (alertView == noQualifyAlert) {
        if (0 ==buttonIndex) {
            //恢复原价
            self.isLimitForSale = @"0";
            //刷新上面展示的价格
            moneyLanel.text = [NSString stringWithFormat:@"￥ %@",[WJUtilityMethod floatNumberForMoneyFomatter:[self.currentCard.salePrice floatValue]]];
            [self refreshCommitAmountL];
            
        }
    }
    
    if (alertView == noStockAlert) {
        if (0 ==buttonIndex) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            //原价购买
            self.isLimitForSale = @"0";
            //刷新上面展示的价格
            moneyLanel.text = [NSString stringWithFormat:@"￥ %@",[WJUtilityMethod floatNumberForMoneyFomatter:[self.currentCard.salePrice floatValue]]];
            [self refreshCommitAmountL];
        }
    }
}

#pragma mark 易联支付

/*
 *  下单成功，开始调用易联支付插件进行支付
 */
- (void)goNext:(NSString *)orderData{
    
    //使加载控件消失
    [self hiddenLoadingView];
    
    //orderData为商户下单返回的数据，将下单返回的数据转换成json字符串
    //    NSString *reqJson = [self toJsonStringWithJsonObject:orderData];
    NSLog(@"PayEcoPpi startPay: %@\n\n",orderData);
    
    //初始化易联支付类对象
    PayEcoPpi *payEcoPpi = [[PayEcoPpi alloc] init];
    
    /*
     *  跳转到易联支付SDK
     *  delegate: 用于接收支付结果回调
     *  env:环境参数 00: 测试环境  01: 生产环境
     *  orientation: 支付界面显示的方向 00：横屏  01: 竖屏
     */
    NSString *envStr = @"01";
    [payEcoPpi startPay:orderData delegate:self env:envStr orientation:@"01"];
    
}


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
- (void)payResponse:(NSString *)respJsonStr{
    
    NSLog(@"\nPayEco PpiDelegate payResponse:%@",respJsonStr);
    
    //json字符串转为dictionary
    NSData *jsonData = [respJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err= nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    
    NSString *respCode  = [dict objectForKey:@"respCode"];
    NSString *respTitle = @"支付出错";
    
    if ([respCode isEqualToString:@"0000"]) {
        respTitle = @"支付成功";
        
        NSString *status = [dict objectForKey:@"Status"];
        NSString *ret = @"未知状态";
        if (status) {
            
            if ([status isEqualToString:@"01"]) {
                ret = @"未支付";
            }else if ([status isEqualToString:@"02"]) {
                ret = @"已支付";
            }else if ([status isEqualToString:@"03"]) {
                ret = @"已退款";
            }else if ([status isEqualToString:@"04"]) {
                ret = @"已过期";
            }else if ([status isEqualToString:@"05"]) {
                ret = @"已作废";
            }
            
            NSLog(@"%@",ret);
        }
    }
    
    NSString *respDesc = [dict objectForKey:@"respDesc"];
    if (!respDesc) {
        if ([respCode isEqualToString:@"0000"]) {
            respDesc  = @"支付成功";
        }else{
            respTitle = @"未知错误支付信息";
        }
    }else{
        
        NSLog(@"%@",respDesc);
    }
    
    NSLog(@"%@",respTitle);
    
    
    if([respTitle isEqualToString:@"支付成功"]){
        WJViewController *vc = [[WJGlobalVariable sharedInstance] payfromController];
        
        //充值
        if([vc isKindOfClass:[WJCardsDetailViewController class]]){
            [kDefaultCenter postNotificationName:kChargeSuccess object:nil];
        }
        
        if([vc isKindOfClass:[WJOwnedCardListController class]]){
            
            //传面值
            WJChoiceCardModel * card = (WJChoiceCardModel *)[cardChangeModel.choiceCardArray objectAtIndex:selectedAmountTag - 400];
            
            WJPayCompleteModel *model = [[WJPayCompleteModel alloc] initWithDic:
                                         @{kOrderNumber:orderNo,
                                           kOrderAmount:[WJUtilityMethod floatNumberForMoneyFomatter:card.cardFacePrice],
                                           kMerId:merID?:@"",
                                           kMerName:productName?:@""
                                           }];
            model.paymentChannel = channelType;
            model.paymentType = (buyType == BuyTypeCharge)?PaymentTypeCharge:PaymentTypeBuy;
            model.payTime = [WJUtilityMethod dateStringFromDate:[NSDate date] withFormatStyle:@"yyyy-MM-dd"];
            
            [kDefaultCenter postNotificationName:kChargeSuccess object:model];
        }
        
        [self.navigationController popToViewController:vc animated:YES];
    }
    
}


- (void)paymentSuccess
{
    WJPayCompleteModel *model = [[WJPayCompleteModel alloc] init];
    model.paymentChannel = channelType;
    model.paymentType = (buyType == BuyTypeCharge)?PaymentTypeCharge:PaymentTypeBuy;
    
    if (buyType == BuyTypeOrder) {
        model.cardName = self.currentCard.name;
        model.cardFaceValue = self.currentCard.faceValue;
        model.realPay = [NSString stringWithFormat:@"%.2f",payAmount];
        if (self.currentCard.privilegeArray.count >0) {
            model.privilegeArray = [NSArray arrayWithArray:self.currentCard.privilegeArray];
        }
        
        WJPayCompleteController *vc = [[WJPayCompleteController alloc]
                                       initWithinfo:model];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (buyType == BuyTypeCharge){
        
        WJChoiceCardModel * card = (WJChoiceCardModel *)[cardChangeModel.choiceCardArray objectAtIndex:selectedAmountTag - 400];
        model.amount = [NSString stringWithFormat:@"%.2f",card.cardFacePrice];
        model.cardName = card.merchantCardName;
        model.cardFaceValue = [NSString stringWithFormat:@"%.2f",card.cardFacePrice];
        model.realPay = [NSString stringWithFormat:@"%.2f",payAmount];
        if (card.privilegeArray.count >0) {
            model.privilegeArray = [NSArray arrayWithArray:card.privilegeArray];
        }

        WJPayCompleteController *vc = [[WJPayCompleteController alloc]
                                       initWithinfo:model];

        [self.navigationController pushViewController:vc animated:YES];
    }
    

}

#pragma mark - WJWapAlipayControllerDelegate

//- (void)wapAlipayFinish:(BOOL)success{
//    if (success) {
//        [self paymentSuccess];
//    }
//}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            if (buyType == BuyTypeCharge) {
                return cardChangeModel.ecoEnable ? 2:1;
            }else {
                return cardOrderModel.ecoEnable ? 2:1;
            }
            
        }
            break;
        default:
            return 0;
            break;
    }
    
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return ALD(44);
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
    {
        if (buyType == BuyTypeCharge) {
            if ([cardChangeModel.choiceCardArray count] > 0) {
                return ALD(10);
            }else
            {
                return 0;
            }
            
        }else{
            return ALD(10);
        }
    }
    if(section == 1)
    {
        return ALD(54);
    }
    
    return ALD(0);
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0) {
        UIView *head = [UIView new];
        head.backgroundColor = WJColorViewBg;
        return head;
    }
    UIView *head = [UIView new];
    head.backgroundColor = WJColorViewBg;
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(10), kScreenWidth, 0.5)];
    topLine.backgroundColor = WJColorSeparatorLine;
    [head addSubview:topLine];
    
    UIView *infoBg = [[UIView alloc] initWithFrame:CGRectMake(0, topLine.bottom, kScreenWidth, ALD(44))];
    infoBg.backgroundColor = [UIColor whiteColor];
    [head addSubview:infoBg];
    
    
    UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, kScreenWidth - ALD(20), ALD(44))];
    //  infoL.text = (self.conpouArray.count>0) ? ((section == 0) ? @"选择优惠券":@"选择支付方式") : @"选择支付方式";
    infoL.text =  @"选择支付方式";
    infoL.font = WJFont14;
    infoL.textColor = WJColorDardGray3;
    [infoBg addSubview:infoL];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(54) - 0.5, kScreenWidth, 0.5)];
    bottomLine.backgroundColor = WJColorSeparatorLine;
    [head addSubview:bottomLine];
    
    return head;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSString *CellIdentifier = @"CouponCell";
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];

            cell.textLabel.textColor = WJColorDardGray3;
            cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
            
            UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
            topLine.backgroundColor = WJColorSeparatorLine;
            [cell.contentView addSubview:topLine];
            
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(44) - 0.5, kScreenWidth, 0.5)];
            bottomLine.backgroundColor = WJColorSeparatorLine;
            [cell.contentView addSubview:bottomLine];
            
        }
        
        
        UILabel *availableCouponL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), ALD(14),ALD(90), ALD(16))];
        availableCouponL.text = @"可用优惠券";
        availableCouponL.textColor = WJColorDarkGray;
        availableCouponL.font = WJFont14;
        [cell.contentView addSubview:availableCouponL];
        
        UILabel *couponCount = [[UILabel alloc] initWithFrame:CGRectMake(availableCouponL.right+ALD(10), ALD(15), ALD(100), ALD(14))];
        couponCount.text = [NSString stringWithFormat:@"%ld张可用",[self.conpouArray count]];
        couponCount.font = WJFont12;
        couponCount.textAlignment = NSTextAlignmentLeft;
        couponCount.textColor = WJColorAlert;
        [cell.contentView addSubview:couponCount];
        
        UIImageView * rightIV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - ALD(16), ALD(33)/2, ALD(6), ALD(11))];
        rightIV.image = [UIImage imageNamed:@"details_rightArrowIcon"];
        [cell.contentView addSubview:rightIV];
        
        UILabel *deductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-ALD(130), ALD(14),ALD(100), ALD(16))];
        deductionLabel.textColor = WJColorNavigationBar;
        deductionLabel.font = WJFont12;
        deductionLabel.tag = 10000;
        deductionLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:deductionLabel];
        
        if(selectTicket){
        
            deductionLabel.text = [NSString stringWithFormat:@"已抵用%@元",[WJUtilityMethod floatNumberFomatter:selectTicket.amount]];
            deductionLabel.hidden = NO;
            
        }else{
            deductionLabel.hidden = YES;
        }
        
        return cell;

    }else{
        
        NSString *CellIdentifier = @"PaymentCell";
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));

            cell.textLabel.textColor = WJColorDardGray3;
           
            UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            chooseBtn.frame = CGRectMake(kScreenWidth-ALD(40), ALD(7), ALD(30), ALD(30));
            [chooseBtn setImage:[UIImage imageNamed:@"toggle_button_nor"] forState:UIControlStateNormal];
            [chooseBtn setImage:[UIImage imageNamed:@"toggle_button_selected"] forState:UIControlStateSelected];
            chooseBtn.userInteractionEnabled = NO;
            cell.accessoryView = chooseBtn;

        }
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(44) - 0.5, kScreenWidth - ALD(24), 0.5)];
        bottomLine.backgroundColor = WJColorSeparatorLine;
        [cell.contentView addSubview:bottomLine];
        
        if (indexPath.row == 0) {
            bottomLine.frame = CGRectMake(ALD(12), ALD(44) - 0.5, kScreenWidth - ALD(24), 0.5);
        } else {
            bottomLine.frame = CGRectMake(0, ALD(44) - 0.5, kScreenWidth, 0.5);
            
        }

        UIButton *chooseBtn = (UIButton *)cell.accessoryView;
        chooseBtn.tag = 100 + indexPath.row;
        
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"recharge_alipay"];
        }else{
            
            cell.imageView.image = [UIImage imageNamed:@"recharge_yeepay"];
        }
        
        chooseBtn.selected = (selectedPayTypeTag == indexPath.row);
        if (chooseBtn.selected) {
            selectedPayTypeBtn = chooseBtn;
        }
        
        return cell;
    }
 }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
//        if (self.conpouArray.count>0) {
//           
//            //wzj 跳转到可用优惠券
//            WJMyTicketController *myTicketVC = [[WJMyTicketController alloc] initWithShowSelector:YES];
//            myTicketVC.dataArray = self.conpouArray;
//            [self.navigationController pushViewController:myTicketVC animated:YES whetherJump:NO];
//        }
    }
    else
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *btn = (UIButton *)cell.accessoryView;
        
        if (btn.selected) {
            return;
        }
        btn.selected = YES;
       
        selectedPayTypeBtn.selected = NO;
        selectedPayTypeBtn = btn;
        selectedPayTypeTag = btn.tag % 100;
        
        channelType = selectedPayTypeTag % 100 == 0?@"pingapp":@"payeco";
       
    }
   
}
#pragma mark - Uibutton action


//支付跳转
- (void)commitOrder:(UIButton *)btn{
    
    [self showLoadingView];
    
    btn.enabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.enabled = YES;
    });
    //充值
    if (buyType == BuyTypeCharge) {
        
        self.buyProductManager.specialCode = selectTicket ? selectTicket.couponCode : @"";
        self.buyProductManager.orderType = OrderTypeCharge;
        self.buyProductManager.isLimitForSale = @"0";
        self.buyProductManager.activityId = @"";
        
        //#pragma message "可以设置金额为0.01元，便于测试"
//        #if TestAPI
//            self.buyProductManager.cardOrderAmount = 0.01;
//        #else
            self.buyProductManager.cardOrderAmount = payAmount;
//        #endif

        [self.buyProductManager loadData];
        
    } else {
        //购卡
        self.buyProductManager.specialCode = selectTicket ? selectTicket.couponCode : @"";
        self.buyProductManager.orderType = OrderTypeBuyCard;
        self.buyProductManager.isLimitForSale = self.isLimitForSale;
        self.buyProductManager.activityId = [self.isLimitForSale boolValue]? self.currentCard.activityId :@"";
        
//#if TestAPI
//        self.buyProductManager.cardOrderAmount = 0.01;
//#else
        self.buyProductManager.cardOrderAmount = payAmount;
//#endif
        
        [self.buyProductManager loadData];
      
    }
}


- (void)chooseAmountAction:(UITapGestureRecognizer *)gesture{
    
    UILabel *moneyLabel = (UILabel *)[gesture view];
    UIButton *btn = [moneyLabel viewWithTag:400+(moneyLabel.tag-1000)];
    
    if (btn.selected) {
        return;
    }
    
    btn.selected = YES;
    
    NSInteger tag = btn.tag - 400;
    
    if ([cardChangeModel.choiceCardArray count] > tag) {
        cardID =  ((WJChoiceCardModel *)[cardChangeModel.choiceCardArray objectAtIndex:tag]).cardId;
    }
    
    if (selectedAmountTag != btn.tag) {
        
        UIButton *selectedBtn = (UIButton *)[mTb viewWithTag:selectedAmountTag];
        selectedBtn.selected = NO;
        
        selectedAmountTag = btn.tag;
        [self refreshCommitAmountL];
    }
}


#pragma mark - NSNotification

//更换优惠券
- (void)changeConpou:(NSNotification *)notification
{
    UITableViewCell *cell = (UITableViewCell *)[mTb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UILabel *moneyL = [cell viewWithTag:10000];

    if([notification object]){
        WJTicketModel *ticket = (WJTicketModel *)[notification object];
        selectTicket = ticket;
        moneyL.text = [NSString stringWithFormat:@"已抵用%@元",[WJUtilityMethod floatNumberFomatter:selectTicket.amount]];
        moneyL.hidden = NO;
    }else{
        
        selectTicket = nil;
        if (self.conpouArray.count >0) {
            moneyL.text = @"已抵用0元";
            moneyL.hidden = NO;
        }else{
        
            moneyL.hidden = YES;
        }
    }
    
    [self refreshCommitAmountL];
}


- (void)alipayCallBack:(NSNotification *)notice{
    
    NSURL *url = notice.userInfo[@"userInfo"];
    
    __weak typeof(self) weakSelf = self;
    [Pingpp handleOpenURL:url
           withCompletion:^(NSString *result, PingppError *error) {
               
               if ([result isEqualToString:@"success"]) {
                   
                   // 支付成功
                   
                   [weakSelf paymentSuccess];
                   
               } else {
                   if (error.code == PingppErrCancelled) {
                       ALERT(@"已取消付款操作，交易失败！");
                   }else{
                       ALERT(@"交易失败");
                   }
                   [self.navigationController popViewControllerAnimated:YES];
               }
               
           }];
    
}

//刷新footer的值
- (void)refreshCommitAmountL {
    
    //充值
    if (buyType == BuyTypeCharge) {
        //商品金额
        CGFloat productAmount = 0.0;
        if (cardChangeModel.choiceCardArray.count >0) {
            WJChoiceCardModel * card = (WJChoiceCardModel *)[cardChangeModel.choiceCardArray objectAtIndex:selectedAmountTag - 400];
            productAmount = card.cardFacePrice * self.discount;
        }
        goodsMoneyVL.text = [NSString stringWithFormat:@"￥ %.2f",productAmount];
        
        //优惠券
        CGFloat couponVal = 0.0;
        if (selectTicket) {
            couponVal = selectTicket.amount;
        }
        couponVL.text = [NSString stringWithFormat:@"-￥ %.2f",couponVal];
        
        if(productAmount >0){
             payAmount =  MAX(0.0, productAmount - couponVal);
        }else{

            payAmount = 0.0;
        }
            
    } else {
        //购卡
        //商品金额
        goodsMoneyVL.text = [NSString stringWithFormat:@"￥ %.2f",[self.currentCard.salePrice floatValue]];
        
        //优惠券
        CGFloat couponVal = 0.0;
        if (selectTicket) {
            couponVal = selectTicket.amount;
        }
        couponVL.text = [NSString stringWithFormat:@"-￥ %.2f",couponVal];
        //优惠活动
        CGFloat activCoupon = 0.0;
        if ([self.isLimitForSale boolValue]) {
            activCoupon = [self.currentCard.salePrice floatValue] - [self.currentCard.price floatValue];
        }
        activityCouponVL.text = [NSString stringWithFormat:@"-￥ %.2f", activCoupon];
        //购买金额
        payAmount = MAX(0.0, [self.currentCard.salePrice floatValue] - couponVal - activCoupon);
    }
    
    //实付金额
    payMoneyVL.text = [NSString stringWithFormat:@"￥ %.2f",payAmount];
    
    //实际支付
    actualPayL.attributedText = [self attributedText:payAmount];
}


#pragma mark - 属性方法

- (APICardRechargeListersManager *)cardRechargeListersManager
{
    if (!_cardRechargeListersManager) {
        _cardRechargeListersManager = [[APICardRechargeListersManager alloc] init];
        _cardRechargeListersManager.delegate = self;
    }
    _cardRechargeListersManager.merchantAccountId = merID;
    return _cardRechargeListersManager;
}


- (APIChargeTotalManager *)chargeTotalManager
{
    if (!_chargeTotalManager) {
        _chargeTotalManager = [[APIChargeTotalManager alloc] init];
        _chargeTotalManager.delegate = self;
    }
    
    _chargeTotalManager.merID = merID;
    _chargeTotalManager.merchantCardId = cardID;
    _chargeTotalManager.isLimitForSale = self.isLimitForSale;

    if ([self.isLimitForSale boolValue]) {
        _chargeTotalManager.activityId = self.currentCard.activityId ? : @"";
    }else{
        _chargeTotalManager.activityId = @"";
    }

    _chargeTotalManager.ticketType = FavorableTicketTypeBuy;
    
    return _chargeTotalManager;
}


- (APIBuyProductManager *)buyProductManager{
    if (!_buyProductManager) {
        _buyProductManager = [[APIBuyProductManager alloc] init];
        _buyProductManager.delegate = self;
    }
    _buyProductManager.proID = cardID?:@"";
    _buyProductManager.merId = merID;
    _buyProductManager.channelType = channelType;

    return _buyProductManager;
}

//- (APIPayOrderManager *)payOrderManager
//{
//    if (!_payOrderManager) {
//        _payOrderManager = [APIPayOrderManager new];
//        _payOrderManager.delegate = self;
//    }
//    _payOrderManager.proID = productId;
//    _payOrderManager.chargeType = selectedPayTypeTag%100 == 0 ? kChargeTypeAlipay:kChargeTypeYiLianPayWap;
//
//    return _payOrderManager;
//}


@end
