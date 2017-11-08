//
//  WJOrderDetailController.m
//  WanJiCard
//
//  Created by Angie on 15/9/26.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJOrderDetailController.h"
#import "WJRelationMerchantController.h"
#import "WJPayCompleteController.h"
#import "APIOrderDetailsManager.h"
#import "APIDeleteOrderManager.h"
#import "WJOrderDetailModel.h"
#import "WJOrderCell.h"
#import <Pingpp/Pingpp.h>
#import "libPayecoPayPlugin.h"
#import "APIOrderDetailsPayManager.h"
#import "WJBaoziRechargeModel.h"
#import "WJBaoziPayCompleteController.h"
#import "WJSystemAlertView.h"
#import "WJAppealViewController.h"
#import "WJFindSafetyQuestionController.h"
#import "WJFindRealNameAuthenticationViewController.h"
#import "WJPassView.h"
#import "APIBuyECardManager.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "WJECardDetailModel.h"
#import "WJBaoziOrderConfirmController.h"

#define  rightArrowMargin                                  (iPhone6OrThan?(140):(120))

@interface WJOrderDetailController ()<APIManagerCallBackDelegate, UITableViewDataSource, UITableViewDelegate,PayEcoPpiDelegate,WJOrderCellDelegate,WJSystemAlertViewDelegate,UIActionSheetDelegate,WJPassViewDelegate>{
    
    UITableView  *mTB;
    UIView       *bottom;
    
    NSDate        *startDate;
    NSDate        *nowDate;
    NSInteger     during;
    
    NSMutableArray *mArrayTableViewSectionType;
    NSString       *payCharge;
}

@property (nonatomic, strong) APIOrderDetailsManager    *orderDetailManager;
@property (nonatomic, strong) APIDeleteOrderManager     *deleteOrderManager;
@property (nonatomic, strong) APIOrderDetailsPayManager *orderDetailsPayManager; //获取charge
@property (nonatomic, strong) APIBuyECardManager        *buyECardManager;        //电子卡支付
@property (nonatomic, strong) WJOrderDetailModel        *detailOrder;

@end

@implementation WJOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"订单详情";
    self.eventID = @"iOS_act_pindentdetails";

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alipayCallBack:)
                                                 name:@"alipayResultCallBack"
                                               object:nil];
    
    mArrayTableViewSectionType = [[NSMutableArray alloc] init];
    
    startDate = [NSDate date];
    
    [self requestLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.translucent = NO;

}

#pragma mark - Request

- (void)requestLoad{
    
    [self showLoadingView];

    [self.orderDetailManager loadData];
}

- (void)initContentView{

    if (self.detailOrder.orderInfo.orderStatus == OrderStatusUnfinished) {
        
        bottom = [[UIView alloc] initForAutoLayout];
        bottom.backgroundColor = [UIColor whiteColor];

        [self.view addSubview:bottom];
        
        UILabel *amountL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, ALD(57))];
        amountL.textColor = WJColorAmount;
        amountL.font = WJFont13;
        amountL.attributedText = [self attributedText:[NSString stringWithFormat:@"总价：￥%@", self.orderSummary.PayAmount] firstLength:3 lastColor:WJColorAmount];
        [bottom addSubview:amountL];
        
        UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        payButton.translatesAutoresizingMaskIntoConstraints = NO;
        [payButton setTitle:@"立即支付"//self.orderSummary.orderType == OrderTypeCharge?@"立即充值":@"立即购买"
                   forState:UIControlStateNormal];
        [payButton setBackgroundColor:WJColorNavigationBar];
        payButton.layer.cornerRadius = 4;
        payButton.titleLabel.font = WJFont14;
        [payButton addTarget:self action:@selector(paymentRightNowAction) forControlEvents:UIControlEventTouchUpInside];
        [bottom addSubview:payButton];
        
        [bottom addConstraints:[payButton constraintsSize:CGSizeMake(90, 40)]];
        [bottom addConstraint:[payButton constraintCenterYEqualToView:bottom]];
        [bottom addConstraints:[payButton constraintsRightInContainer:ALD(10)]];
        
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.translatesAutoresizingMaskIntoConstraints = NO;
        rightBtn.layer.cornerRadius = 4;
        rightBtn.titleLabel.font = WJFont14;
        rightBtn.layer.borderWidth = 0.5;
        rightBtn.layer.borderColor = WJColorAlert.CGColor;
        [rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [rightBtn setTitleColor:WJColorAlert forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(cancelOrderAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottom addSubview:rightBtn];
        
        [bottom addConstraints:[rightBtn constraintsSize:CGSizeMake(90, 40)]];
        [bottom addConstraint:[rightBtn constraintCenterYEqualToView:bottom]];
        [bottom addConstraints:[rightBtn constraintsRight:ALD(5) FromView:payButton]];

        
        [self.view addConstraints:[bottom constraintsFillWidth]];
        [self.view addConstraint:[bottom constraintHeight:ALD(57)]];
        [self.view addConstraints:[bottom constraintsBottomInContainer:0]];
        
    }
    
    mTB = [[UITableView alloc] initForAutoLayout];
    mTB.delegate = self;
    mTB.dataSource = self;
    mTB.backgroundColor = WJColorViewBg;
    mTB.tableFooterView = [UIView new];
    mTB.separatorInset = UIEdgeInsetsZero;
    mTB.separatorColor = WJColorSeparatorLine;
    mTB.bounces = NO;
    [self.view addSubview:mTB];
    
    if (self.detailOrder.orderInfo.orderStatus == OrderStatusUnfinished) {
        [self.view addConstraints:[mTB constraintsFillWidth]];
        [self.view addConstraints:[mTB constraintsTopInContainer:0]];
        [self.view addConstraints:[mTB constraintsBottomInContainer:ALD(57)]];
    }else{
        [self.view addConstraints:[mTB constraintsFill]];
    }
}

- (void)updateTableViewSectionTypeList
{
    NSUInteger indexSecond = [mArrayTableViewSectionType indexOfObject:[NSNumber numberWithInteger:SeTypeCardDetail]];
    if (indexSecond == NSNotFound) {
        [mArrayTableViewSectionType addObject:[NSNumber  numberWithInteger:SeTypeCardDetail]];

    } else {
        [mArrayTableViewSectionType removeObject:[NSNumber numberWithInteger:SeTypeCardDetail]];

    }
    
    if (self.detailOrder.orderInfo.orderType != OrderTypeElectronicCard && (self.detailOrder.orderInfo.orderType != OrderTypeBaoZiCharge)) {
        
        NSUInteger index = [mArrayTableViewSectionType indexOfObject:[NSNumber numberWithInteger:SeTypeMerchantInformation]];
        if (index == NSNotFound) {
            [mArrayTableViewSectionType addObject:[NSNumber  numberWithInteger:SeTypeMerchantInformation]];
        } else {
            [mArrayTableViewSectionType removeObject:[NSNumber numberWithInteger:SeTypeMerchantInformation]];
        }
    }
    
    NSUInteger indexThird = [mArrayTableViewSectionType indexOfObject:[NSNumber numberWithInteger:SeTypeOrderDetail]];
    if (indexThird == NSNotFound) {
        [mArrayTableViewSectionType addObject:[NSNumber  numberWithInteger:SeTypeOrderDetail]];
        
    } else {
        [mArrayTableViewSectionType removeObject:[NSNumber numberWithInteger:SeTypeOrderDetail]];
        
    }
    
    [mArrayTableViewSectionType sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber* number1 = nil;
        NSNumber* number2 = nil;
        if ([obj1 isKindOfClass:[NSNumber class]]) {
            number1 = (NSNumber*)obj1;
        }
        if ([obj2 isKindOfClass:[NSNumber class]]) {
            number2 = (NSNumber*)obj2;
        }
        
        if ([number2 integerValue]>[number1 integerValue]) {
            return NSOrderedAscending;
        }
        
        return NSOrderedDescending;
    }];
}

#pragma mark - UIButtonAction

- (void)paymentRightNowAction{
    [self showLoadingView];
    
    if (self.detailOrder.orderInfo.orderType == OrderTypeElectronicCard) {
        
        [self checkAlertWithBaoziNum];
    } else {
        
        //商家卡购卡充值、包子充值
        if (self.detailOrder.orderInfo.orderType == OrderTypeBaoZiCharge) {
            
            CGFloat totalPrice = [self.detailOrder.orderInfo.rechargeMoney floatValue] + [self.detailOrder.orderInfo.PayAmount floatValue];
            
            if (totalPrice <= 2000) {
                
                [self getOrderCharge];

            } else {
                
                WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil message:@"土豪！您充太多钱了，明天再来好不好！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
                [alert showIn];
            }
            
        
        } else if (self.detailOrder.orderInfo.orderType == OrderTypeBuyCard || self.detailOrder.orderInfo.orderType == OrderTypeCharge) {
            
            [self getOrderCharge];

        }

    }
}


#pragma mark - 购买弹窗
- (void)checkAlertWithBaoziNum
{
    //电子卡包子支付弹框
    NSString *cardNum = [NSString stringWithFormat:@"%ld",(long)self.detailOrder.orderInfo.count];
    
    //包子数足够
    if ([self.detailOrder.orderInfo.baoZiCount floatValue] >= [self.detailOrder.orderInfo.PayAmount floatValue]) {
        [WJGlobalVariable sharedInstance].fromController = self;
        //判断是否设置了指纹验证
        NSString *fingerIdenty = KFingerIdentySwitch;
        BOOL isBool = NO;
        if (fingerIdenty) {
            isBool = [[NSUserDefaults standardUserDefaults] boolForKey:fingerIdenty];
        }
        
        if (isBool) {
            
            WJPassView *passView = [[WJPassView alloc] initWithFrame:self.view.bounds title:@"支付"  cardName:self.detailOrder.orderInfo.name faceValue:self.detailOrder.orderInfo.faceValue  cardNum:cardNum baoziNeedNum:self.detailOrder.orderInfo.PayAmount baoziHasNum:self.detailOrder.orderInfo.baoZiCount passViewType:PassViewTypeSubmit];
            passView.delegate = self;
            [passView showIn];
            
        } else {
            
            WJPassView *passView = [[WJPassView alloc] initWithFrame:self.view.bounds title:@"请输入支付密码"  cardName:self.detailOrder.orderInfo.name faceValue:self.detailOrder.orderInfo.faceValue  cardNum:cardNum baoziNeedNum:self.detailOrder.orderInfo.PayAmount baoziHasNum:self.detailOrder.orderInfo.baoZiCount passViewType:PassViewTypeInputPassword];
            passView.delegate = self;
            [passView showIn];
        }
    } else {
        
        //包子数不足
        WJPassView *passView = [[WJPassView alloc] initWithFrame:self.view.bounds title:@"请输入支付密码"  cardName:self.detailOrder.orderInfo.name faceValue:self.detailOrder.orderInfo.faceValue  cardNum:cardNum baoziNeedNum:self.detailOrder.orderInfo.PayAmount baoziHasNum:self.detailOrder.orderInfo.baoZiCount passViewType:PassViewTypeSubmitTip];
        passView.delegate = self;
        [passView showIn];
        
    }
    
}


- (void)getOrderCharge
{
    [self.orderDetailsPayManager loadData];
}

- (void)goToPay:(NSString*)charge
{
    //易联支付
    if ([self.detailOrder.orderInfo.paychannel isEqualToString:@"payeco"]) {
        
        [self performSelectorOnMainThread:@selector(goNext:) withObject:charge waitUntilDone:NO];
        
        return;
    }
    
    //支付宝支付
    [self hiddenLoadingView];
    __weak typeof(self) weakSelf = self;
    [Pingpp createPayment:charge
           viewController:weakSelf
             appURLScheme:KAppURLScheme
           withCompletion:^(NSString *result, PingppError *error) {
               if ([result isEqualToString:@"success"]) {
                   
                   [weakSelf updateOrderStatus:OrderStatusSuccess];
                   [kDefaultCenter postNotificationName:kPayOrderSuccess object:nil];
                   
                   [WJGlobalVariable sharedInstance].payfromController = weakSelf;
                   
                   // 支付成功
                   [weakSelf paySuccessToResultViewController];
                   
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


- (void)paySuccessToResultViewController
{
    //商家卡
    if (self.detailOrder.orderInfo.orderType == OrderTypeBuyCard || self.detailOrder.orderInfo.orderType == OrderTypeCharge) {
        
        WJPayCompleteModel *model = [[WJPayCompleteModel alloc] init];
        model.paymentChannel = self.detailOrder.orderInfo.paychannel;
        model.paymentType = (self.detailOrder.orderInfo.orderType == OrderTypeCharge)?PaymentTypeCharge:PaymentTypeBuy;
        model.cardName =  self.detailOrder.orderInfo.name;
        model.cardFaceValue = self.detailOrder.orderInfo.faceValue;
        model.privilegeArray = self.detailOrder.privilegeArray;
        model.realPay = [NSString stringWithFormat:@"%.2f",[self.detailOrder.orderInfo.PayAmount floatValue]];
        
        
        WJPayCompleteController *vc = [[WJPayCompleteController alloc]
                                       initWithinfo:model];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //包子充值
    if (self.detailOrder.orderInfo.orderType == OrderTypeBaoZiCharge) {
        
        WJPayCompleteModel *model = [[WJPayCompleteModel alloc] init];
        model.paymentType = PaymentTypeCharge;
        model.realPay = [NSString stringWithFormat:@"%@",self.detailOrder.orderInfo.PayAmount];
        model.rechargeDescribe = self.detailOrder.orderInfo.arrivalAmount;
        model.promptStr = self.detailOrder.orderInfo.successdescribe;
        
        WJBaoziPayCompleteController *completeVC = [[WJBaoziPayCompleteController alloc]
                                                    initWithinfo:model];
        [self.navigationController pushViewController:completeVC animated:YES];
        
    }
    //电子卡
    if (self.detailOrder.orderInfo.orderType == OrderTypeElectronicCard) {
        
        WJECardDetailModel *eCardDetailModel = [[WJECardDetailModel alloc] init];
        eCardDetailModel.cardId = self.detailOrder.orderInfo.pcid;
        eCardDetailModel.cardColor = self.detailOrder.orderInfo.ctype;
        eCardDetailModel.facePrice = self.detailOrder.orderInfo.faceValue;
        eCardDetailModel.salePrice = self.detailOrder.orderInfo.salePrice;
        eCardDetailModel.commodityName = self.detailOrder.orderInfo.name;
        
        WJPayCompleteModel *model = [[WJPayCompleteModel alloc] init];
        model.paymentType = PaymentTypeBuy;
        model.orderNo = self.detailOrder.orderInfo.orderNo;
        model.ecardsNum = [NSString stringWithFormat:@"%ld",self.detailOrder.orderInfo.count];
        model.ecard = eCardDetailModel;

        WJBaoziPayCompleteController *completeVC = [[WJBaoziPayCompleteController alloc]
                                                    initWithinfo:model];
        [self.navigationController pushViewController:completeVC animated:NO];
    }
}

- (void)moreStoreAction:(UIButton *)btn{
    WJRelationMerchantController *vc = [[WJRelationMerchantController alloc] init];
    vc.merId = self.detailOrder.orderInfo.merId;
    vc.title = @"商家列表";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cancelOrderAction:(UIButton *)btn{
    [self.deleteOrderManager loadData];
    [self showLoadingView];
}

#pragma mark - Button Action

- (void)backBarButton:(UIButton *)btn {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager{
   
    if ([manager isKindOfClass:[APIDeleteOrderManager class]]) {
        ALERT(@"取消成功");
        [self hiddenLoadingView];
        
        [self updateOrderStatus:OrderStatusClose];
        [kDefaultCenter postNotificationName:kDeleteOrderSuccess object:nil];
        
    }else if ([manager isKindOfClass:[APIOrderDetailsManager class]]) {
        
        NSTimeInterval timeBetween = [[NSDate date] timeIntervalSinceDate:startDate];
        during = ceil(timeBetween);
        
        [self hiddenLoadingView];
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        self.detailOrder = [[WJOrderDetailModel alloc] initWithDic:dic];
        [self initContentView];
        
        [self updateTableViewSectionTypeList];
        
    } else if ([manager isKindOfClass:[APIOrderDetailsPayManager class]]){
        
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        payCharge = [dic objectForKey:@"charge"];
        
        [self goToPay:payCharge];
        
    } else if ([manager isKindOfClass:[APIBuyECardManager class]]) {
        
        NSLog(@"%@",@"购买成功");
        //支付成功 进入交易结果页
        [self updateOrderStatus:OrderStatusSuccess];
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


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager{
    
    [self hiddenLoadingView];
    if ([manager isKindOfClass:[APIOrderDetailsManager class]]) {
     
        if (manager.errorMessage && manager.errorMessage.length>0) {
            
            [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
        }
    } else if ([manager isKindOfClass:[APIOrderDetailsPayManager class]]) {
        
        if (manager.errorMessage && manager.errorMessage.length>0) {
            
            [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
        }
        
    } else if ([manager isKindOfClass:[APIBuyECardManager class]]) {
        
        if (manager.errorMessage && manager.errorMessage.length>0) {
            
            [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
        }
    }
    
}


//更改订单状态
- (void)updateOrderStatus:(OrderStatus)status
{
    
    self.navigationItem.rightBarButtonItem = nil;
    [bottom removeFromSuperview];
    bottom = nil;
    self.detailOrder.orderInfo.orderStatus = status;
    [mTB reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];

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
//    NSLog(@"PayEcoPpi startPay: %@\n\n",reqJson);
    
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
    
//    [[TKAlertCenter defaultCenter]postAlertWithMessage:respTitle];
     NSLog(@"%@",respTitle);
   
    //更改订单状态
    if([respTitle isEqualToString:@"支付成功"]){
    
        [self updateOrderStatus:OrderStatusSuccess];
        [kDefaultCenter postNotificationName:kPayOrderSuccess object:nil];
    }
    
}

#pragma mark - NSNotification
- (void)alipayCallBack:(NSNotification *)notice{
    
    NSURL *url = notice.userInfo[@"userInfo"];
    
    __weak typeof(self) weakSelf = self;
    [Pingpp handleOpenURL:url
           withCompletion:^(NSString *result, PingppError *error) {
               
               if ([result isEqualToString:@"success"]) {
                   [weakSelf updateOrderStatus:OrderStatusSuccess];
                   [kDefaultCenter postNotificationName:kPayOrderSuccess object:nil];
                   
                   [WJGlobalVariable sharedInstance].payfromController = weakSelf;
                   // 支付成功
                   [weakSelf paySuccessToResultViewController];
                   
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


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section < [mArrayTableViewSectionType count]) {
        
        TableViewSectionType type = (TableViewSectionType)[[mArrayTableViewSectionType objectAtIndex:section] integerValue];
        
        switch (type) {
            case SeTypeCardDetail:
                return 1;
                break;
                
            case SeTypeMerchantInformation:
            {
                if (self.detailOrder.supportStoreCount > 0) {
                    return 3;
                } else {
                    return 2;
                }
            }
                break;
            case SeTypeOrderDetail:
                return 3;
                break;

            default:
                break;
        }

    }
    return section;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [mArrayTableViewSectionType count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section>0?ALD(15):0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    NSUInteger section = indexPath.section;
    
    if (section < [mArrayTableViewSectionType count]) {
        
        TableViewSectionType type = (TableViewSectionType)[[mArrayTableViewSectionType objectAtIndex:section] integerValue];
        
        switch (type) {
            case SeTypeCardDetail:
            {
                height = ALD(140);
            }
                break;
                
            case SeTypeMerchantInformation:
            {
                if (indexPath.row == 0) {
                    height = ALD(44);
                }else if (indexPath.row == 1) {
                    height = ALD(70);
                }else {
                    height = ALD(44);
                }
            }
                break;
            case SeTypeOrderDetail:
            {
                if (indexPath.row == 0) {
                    height = ALD(44);
                }else if (indexPath.row == 1){
                    
                    if (self.detailOrder.orderInfo.orderType == OrderTypeElectronicCard) {
                        height = ALD(60);
                        
                    } else {
                        
                        height = ALD(80);
                    }
                    
                }else{
                    
                    height = ALD(50);
                }
            }
                break;
                
            default:
                break;
        }
        
    }
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
    }
    
    NSUInteger section = indexPath.section;
    
    if (section < [mArrayTableViewSectionType count]) {
        
        TableViewSectionType type = (TableViewSectionType)[[mArrayTableViewSectionType objectAtIndex:section] integerValue];
        
        switch (type) {
            case SeTypeCardDetail:
            {
                WJOrderCell *orderCell = [[WJOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell"];
                orderCell.delegate = self;
                orderCell.isOrder = NO;
                orderCell.during = during;
                
                [orderCell configCellWithOrder:self.detailOrder.orderInfo isDetail:YES];
                orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell = orderCell;
            }
                break;
                
            case SeTypeMerchantInformation:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(0.5))];
                        topLine.backgroundColor = WJColorSeparatorLine;
                        [cell.contentView addSubview:topLine];
                        
                        UILabel *merInfoL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, ALD(44))];
                        merInfoL.textColor = WJColorDarkGray;
                        merInfoL.font = WJFont15;
                        merInfoL.text = @"商家信息";
                        [cell.contentView addSubview:merInfoL];
                    }
                        break;
                        
                    case 1:
                    {
                        UILabel *merNameL = [[UILabel alloc] initWithFrame:CGRectMake(10, ALD(10), 300, ALD(22))];
                        merNameL.textColor = WJColorDarkGray;
                        merNameL.font = WJFont15;
                        merNameL.text = self.detailOrder.orderInfo.merName;
                        [cell.contentView addSubview:merNameL];
                        
                        UILabel *merAddressL = [[UILabel alloc] initWithFrame:CGRectMake(10, merNameL.bottom + ALD(5), kScreenWidth - ALD(20), ALD(20))];
                        merAddressL.textColor = WJColorLightGray;
                        merAddressL.font = WJFont12;
                        merAddressL.text = self.detailOrder.orderInfo.merAddress;
                        [cell.contentView addSubview:merAddressL];
                        
                    }
                        break;
                        
                    case 2:
                    {
                        NSString *title = [NSString stringWithFormat:@"查看全部%@家分店", @(self.detailOrder.supportStoreCount)];
                        UIButton *moreStore = [UIButton buttonWithType:UIButtonTypeCustom];
                        moreStore.frame = CGRectMake(0, 0, kScreenWidth, ALD(40));
                        [moreStore setTitle:title forState:UIControlStateNormal];
                        [moreStore setTitleColor:WJColorLightGray forState:UIControlStateNormal];
                        [moreStore  setImage:[UIImage imageNamed:@"details_rightArrowIcon"] forState:UIControlStateNormal];
                        moreStore.titleEdgeInsets = UIEdgeInsetsMake(0, 76, 0, 100);
                        moreStore.imageEdgeInsets = UIEdgeInsetsMake(0, kScreenWidth- rightArrowMargin, 0, 78);
                        moreStore.titleLabel.font = WJFont12;
                        [moreStore addTarget:self action:@selector(moreStoreAction:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:moreStore];
                        
                        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, cell.height - ALD(0.5), kScreenWidth, ALD(0.5))];
                        bottomLine.backgroundColor = WJColorSeparatorLine;
                        [cell.contentView addSubview:bottomLine];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            case SeTypeOrderDetail:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(0.5))];
                        topLine.backgroundColor = WJColorSeparatorLine;
                        [cell.contentView addSubview:topLine];
                        
                        UILabel *merInfoL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, ALD(44))];
                        merInfoL.textColor = WJColorDarkGray;
                        merInfoL.font = WJFont15;
                        merInfoL.text = @"订单详情";
                        [cell.contentView addSubview:merInfoL];
                    }
                        break;
                        
                    case 1:
                    {
                        UILabel *totalAmountL = [[UILabel alloc] initWithFrame:CGRectMake(10, ALD(10), 150, ALD(20))];
                        totalAmountL.textColor = WJColorDarkGray;
                        totalAmountL.font = WJFont12;
                        totalAmountL.textAlignment = NSTextAlignmentLeft;
                        totalAmountL.text = @"售价";
                        [cell.contentView addSubview:totalAmountL];
                        
                        
                        UILabel *totalCountL = [[UILabel alloc] initWithFrame:CGRectMake(10, totalAmountL.bottom, 150, ALD(20))];
                        totalCountL.textColor = WJColorDarkGray;
                        totalCountL.font = WJFont12;
                        totalCountL.textAlignment = NSTextAlignmentLeft;
                        totalCountL.text = @"数量";
                        [cell.contentView addSubview:totalCountL];
                        
                        
                        
                        UILabel *specialL = [[UILabel alloc] initWithFrame:CGRectMake(10, totalCountL.bottom, 150, ALD(20))];
                        specialL.textColor = WJColorDarkGray;
                        specialL.font = WJFont12;
                        specialL.text = @"优惠券";
                        specialL.textAlignment = NSTextAlignmentLeft;
                        [cell.contentView addSubview:specialL];
                        
                        
                        UILabel *totalAmount = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 200, totalAmountL.y, 200, ALD(20))];
                        totalAmount.textColor = WJColorDarkGray;
                        totalAmount.font = WJFont12;
                        totalAmount.textAlignment = NSTextAlignmentRight;
                        totalAmount.text = [NSString stringWithFormat:@"￥%@", [WJUtilityMethod floatNumberForMoneyFomatter:[self.detailOrder.orderInfo.amount floatValue]]];
                        
                        if (self.detailOrder.orderInfo.orderType == OrderTypeElectronicCard) {
                            
                            totalAmount.text = [NSString stringWithFormat:@"%@个包子",[WJUtilityMethod floatNumberForMoneyFomatter:[self.detailOrder.orderInfo.amount floatValue]]];
                            

                        }
                        
                        [cell.contentView addSubview:totalAmount];
                        
                        UILabel *totalCount = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 200, totalCountL.y, 200, ALD(20))];
                        totalCount.textColor = WJColorDarkGray;
                        totalCount.font = WJFont12;
                        totalCount.textAlignment = NSTextAlignmentRight;
                        totalCount.text = [NSString stringWithFormat:@"x %@",@(self.detailOrder.orderInfo.count)];
                        [cell.contentView addSubview:totalCount];
                        
                        
                        UILabel *specialNum = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 200, specialL.y, 200, ALD(20))];
                        specialNum.textColor = WJColorDarkGray;
                        specialNum.font = WJFont12;
                        specialNum.textAlignment = NSTextAlignmentRight;
                        specialNum.text = [NSString stringWithFormat:@"-￥%@",self.detailOrder.orderInfo.SpecialAmount];
                        [cell.contentView addSubview:specialNum];
                        
                        if (self.detailOrder.orderInfo.orderType == OrderTypeElectronicCard) {
                            specialL.hidden = YES;
                            specialNum.hidden = YES;
                        } else if (self.detailOrder.orderInfo.orderType == OrderTypeBaoZiCharge) {
                            totalAmountL.text = @"充值";
                            specialL.text = @"到账";
                            
                            specialNum.text = [NSString stringWithFormat:@"%@",self.detailOrder.orderInfo.arrivalAmount];
                            
                        }
                        
                        
                    }
                        break;
                    case 2:{
                        
                        UILabel *realPayL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 300, ALD(8), 300, ALD(20))];
                        
                        realPayL.attributedText = [self attributedText:[NSString stringWithFormat:@"实付：￥%@",[WJUtilityMethod floatNumberForMoneyFomatter:[self.detailOrder.orderInfo.PayAmount floatValue]]] firstLength:3 lastColor:WJColorAmount];
                        

                        if (self.detailOrder.orderInfo.orderType == OrderTypeElectronicCard) {
                            
                        realPayL.attributedText = [self attributedText:[NSString stringWithFormat:@"实付：%@个包子", [WJUtilityMethod baoziNumberFormatter:self.detailOrder.orderInfo.PayAmount]] firstLength:3 lastColor:WJYellowColorAmount];
                            
                        }
                        
                        realPayL.textAlignment = NSTextAlignmentRight;
                        [cell.contentView addSubview:realPayL];
                        
                        
                        UILabel *orderTimeL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 300, realPayL.bottom, 300, ALD(14))];
                        orderTimeL.textColor = WJColorDardGray9;
                        orderTimeL.font = WJFont10;
                        orderTimeL.textAlignment = NSTextAlignmentRight;
                        orderTimeL.text = [NSString stringWithFormat:@"下单时间：%@", self.detailOrder.orderInfo.createTime];
                        [cell.contentView addSubview:orderTimeL];
                        
                        
                        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(50) - ALD(0.5), kScreenWidth, ALD(0.5))];
                        bottomLine.backgroundColor = WJColorSeparatorLine;
                        [cell.contentView addSubview:bottomLine];
                        
                    }
                        break;
                    default:
                        break;
                }
                
            }
                break;
                
            default:
                break;
        }
        
    }
    
    return cell;
}

#pragma mark - WJOrderCellDelegate

- (void)changeOrderStatus
{
    [self updateOrderStatus:OrderStatusClose];
    [kDefaultCenter postNotificationName:kDeleteOrderSuccess object:nil];
}

- (NSAttributedString *)attributedText:(NSString *)text firstLength:(NSInteger)len lastColor:(UIColor*)lastColor{
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]
                                         initWithString:text];
    
    NSDictionary *attributesForFirstWord = @{
                                             NSFontAttributeName : WJFont14,
                                             NSForegroundColorAttributeName : WJColorDarkGray,
                                             };
    
    NSDictionary *attributesForSecondWord = @{
                                              NSFontAttributeName : WJFont14,
                                              NSForegroundColorAttributeName : lastColor,
                                              };
    [result setAttributes:attributesForFirstWord
                    range:NSMakeRange(0, len)];
    [result setAttributes:attributesForSecondWord
                    range:NSMakeRange(len, text.length - len)];
    return [[NSAttributedString alloc] initWithAttributedString:result];
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
//    [alertView dismiss];
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
            
            NSString *cardNum = [NSString stringWithFormat:@"%ld",self.detailOrder.orderInfo.count];

            WJPassView *passView = [[WJPassView alloc] initWithFrame:self.view.bounds title:@"请输入支付密码"  cardName:self.detailOrder.orderInfo.name faceValue:self.detailOrder.orderInfo.faceValue  cardNum:cardNum baoziNeedNum:self.detailOrder.orderInfo.PayAmount baoziHasNum:self.detailOrder.orderInfo.baoZiCount passViewType:PassViewTypeInputPassword];
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
                    
                    strongSelf.buyECardManager.orderNo = self.detailOrder.orderInfo.orderNo;
                    [strongSelf.buyECardManager loadData];
                    
                }];
                
            }else{
                
                NSLog(@"%@",error.localizedDescription);
            }
        }];
    }
}



#pragma mark - 属性方法

- (APIOrderDetailsManager *)orderDetailManager{
    if (!_orderDetailManager) {
        _orderDetailManager = [APIOrderDetailsManager new];
        _orderDetailManager.delegate = self;
        _orderDetailManager.ordersID = self.orderSummary.orderNo;
    }
    _orderDetailManager.orderType = self.orderSummary.orderType;
    return _orderDetailManager;
}

- (APIDeleteOrderManager *)deleteOrderManager{
    if (!_deleteOrderManager) {
        _deleteOrderManager = [[APIDeleteOrderManager alloc] init];
        _deleteOrderManager.delegate = self;
        _deleteOrderManager.orderNumber = self.orderSummary.orderNo;
    }
    _deleteOrderManager.orderType = self.orderSummary.orderType;
    return _deleteOrderManager;
}

- (APIOrderDetailsPayManager *)orderDetailsPayManager
{
    if (!_orderDetailsPayManager) {
        _orderDetailsPayManager = [[APIOrderDetailsPayManager alloc] init];
        _orderDetailsPayManager.delegate = self;
        _orderDetailsPayManager.ordersID = self.orderSummary.orderNo;
    }
    _orderDetailsPayManager.orderType = self.orderSummary.orderType;
    return _orderDetailsPayManager;
}

- (APIBuyECardManager *)buyECardManager
{
    if (!_buyECardManager) {
        _buyECardManager = [[APIBuyECardManager alloc] init];
        _buyECardManager.delegate = self;
    }
    _buyECardManager.orderNo = self.detailOrder.orderInfo.orderNo;

    return _buyECardManager;
}

@end
