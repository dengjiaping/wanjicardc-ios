//
//  WJBaoziOrderConfirmController.m
//  WanJiCard
//
//  Created by 孙明月 on 16/8/16.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJBaoziOrderConfirmController.h"
#import "WJSteameReChargeCell.h"
#import "WJBaoziPayCompleteController.h"
#import "APIBaoziRechargeListManager.h"
#import "APIBaoziRechargeOrderManager.h"
#import "WJBaoziRechargeListModel.h"
#import "WJBaoziRechargeModel.h"
#import "Pingpp.h"
#import "libPayecoPayPlugin.h"
#import "WJWebViewController.h"
#import "WJRechargeAgreementCell.h"
#import "WJRealNameAuthenticationViewController.h"
#import "WJVerificationReceiptMoneyController.h"

@interface WJBaoziOrderConfirmController ()<UITableViewDelegate,UITableViewDataSource,PayEcoPpiDelegate, WJRechargeAgreementCellDelegate>
{
    UITableView *mTb;
    UIButton *payButton;        //立即充值/购买
    UILabel *actualPayL;        //实际支付
    
    NSString *channelType;
    NSInteger selectedAmountTag;        //所选充值金额tag
    NSInteger selectedPayTypeTag;       //所选支付方式tag
    
    WJBaoziRechargeListModel *rechargeListModel;
    
    CGFloat payAmount;          //金额
    BOOL    hadRequestChargeTotal;
    
}

@property (nonatomic, strong) NSMutableArray  *conpouArray;
@property (nonatomic, strong) APIBaoziRechargeListManager  *rechargeListManager;   //包子充值列表
@property (nonatomic, strong) APIBaoziRechargeOrderManager *rechargeOrderManager;  //包子充值生成订单

@end


@implementation WJBaoziOrderConfirmController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.eventID = @"iOS_act_prechargedetails";
    //    self.isNeedToken = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alipayCallBack:)
                                                 name:@"alipayResultCallBack"
                                               object:nil];
    
    self.title = @"充值";
    channelType = @"pingapp";
    selectedAmountTag = 0;
    selectedPayTypeTag = 0;
    
    UIButton * instructionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [instructionBtn setFrame:CGRectMake(0, 0, ALD(19), ALD(19))];
    [instructionBtn setImage:[UIImage imageNamed:@"mybaozi_ic_help"] forState:UIControlStateNormal];
    [instructionBtn setImage:[UIImage imageNamed:@"mybaozi_ic_help"] forState:UIControlStateHighlighted];
    [instructionBtn addTarget:self action:@selector(showInstruction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:instructionBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!hadRequestChargeTotal) {
        hadRequestChargeTotal = YES;
        [self requestChargeTotal];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initContent
{
    mTb = [[UITableView alloc] initForAutoLayout];
    mTb.delegate = self;
    mTb.dataSource = self;
    mTb.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTb.backgroundColor = WJColorViewBg;
    //    mTb.tag = 20001;
    //    mTb.separatorInset = UIEdgeInsetsZero;
    //    mTb.separatorColor = WJColorSeparatorLine;
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
    [payButton setTitle:@"立即充值" forState:UIControlStateNormal];
    payButton.backgroundColor = kBlueColor;
    payButton.layer.cornerRadius = 5;
    [payButton addTarget:self action:@selector(commitOrder:) forControlEvents:UIControlEventTouchUpInside];
    [payBackgView addSubview:payButton];
    [self.view addSubview:payBackgView];
    
    [self.view VFLToConstraints:@"H:|[mTb]|" views:NSDictionaryOfVariableBindings(mTb)];
    [self.view VFLToConstraints:@"V:|-0-[mTb]-48-|" views:NSDictionaryOfVariableBindings(mTb)];
    [self.view addConstraints:[mTb constraintsTopInContainer:0]];
    
    [self refreshCommitAmountL];
}


//刷新实际支付
- (void)refreshCommitAmountL {
    
    //商品金额
    CGFloat productAmount = 0.0;
    if (rechargeListModel.bunList.count >0) {
        WJBaoziRechargeModel  * moneyModel = (WJBaoziRechargeModel *)[rechargeListModel.bunList objectAtIndex:selectedAmountTag];
        productAmount = moneyModel.rechargeAmount;
    }
    
    payAmount =  MAX(0.0, productAmount);
    
    //实际支付
    actualPayL.attributedText = [self attributedText:payAmount];
}


- (NSAttributedString *)attributedText:(CGFloat)blance{
    NSString *string = [NSString stringWithFormat:@"实际支付：￥%@", [WJUtilityMethod floatNumberForMoneyFomatter:blance]];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]
                                         initWithString:string];
    NSDictionary *attributesForFirstWord = @{
                                             NSFontAttributeName : WJFont14,
                                             NSForegroundColorAttributeName : WJColorDarkGray,
                                             };
    
    NSDictionary *attributesForSecondWord = @{
                                              NSFontAttributeName : WJFont14,
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
    [self.rechargeListManager loadData];
}


- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    //充值
    if ([manager isKindOfClass:[APIBaoziRechargeListManager class]]) {
        
        [self hiddenLoadingView];
        
        NSDictionary * dic = [manager fetchDataWithReformer:nil];
        if(dic){
            rechargeListModel = [[WJBaoziRechargeListModel alloc] initWithDic:dic];
        }
        
        [self initContent];
        
    } else if ([manager isKindOfClass:[APIBaoziRechargeOrderManager class]]) {
        
        [self hiddenLoadingView];
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        payAmount = [ToNSNumber(dic[@"rechargeAmount"]) floatValue];
        
        //易联支付
        if ([self.rechargeOrderManager.channelType isEqualToString:@"payeco"]) {
            
            channelType = @"payeco";
            //商户需要提交给支付插件的订单内容
            [self performSelectorOnMainThread:@selector(goNext:) withObject:dic[@"charge"] waitUntilDone:NO];
            
            return;
        }
        channelType = @"pingapp";
        
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


#pragma mark 易联支付

/*
 *  下单成功，开始调用易联支付插件进行支付
 */
- (void)goNext:(NSString *)orderData{
    
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
        //跳转确认订单前一页（个人中心、市集tab、电子卡详情）
        WJViewController *vc = [[WJGlobalVariable sharedInstance] payfromController];
        [self.navigationController popToViewController:vc animated:YES];
    }
}


- (void)paymentSuccess
{
    WJBaoziRechargeModel * rechargeCard = (WJBaoziRechargeModel *)[rechargeListModel.bunList objectAtIndex:selectedAmountTag];
    
    WJPayCompleteModel *model = [[WJPayCompleteModel alloc] init];
    model.paymentType = PaymentTypeCharge;
    model.realPay = [NSString stringWithFormat:@"%.2f",payAmount];
    model.rechargeDescribe = rechargeCard.describe;
    model.promptStr = rechargeCard.successdescribe;
    
    WJBaoziPayCompleteController *completeVC = [[WJBaoziPayCompleteController alloc]
                                                initWithinfo:model];
    [self.navigationController pushViewController:completeVC animated:YES whetherJump:YES];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            
            return rechargeListModel.bunList.count;
        }
            break;
        case 1:
        {
            
            return rechargeListModel.ecoEnable ? 2:1;
        }
            break;
        case 2:
        {
            return 1;
        }
            break;
        default:
            return 0;
            break;
    }
    
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
         return ALD(60);
    }else{
    
        return ALD(44);
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section ==0)
    {
        return ALD(44);
       
    }else if(section == 1){
        
        return ALD(54);
    }else{
        
        return ALD(10);
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section == 2) {
        UIView *head = [UIView new];
        head.backgroundColor = WJColorViewBg;
        return head;
    }
    
    UIView *head = [UIView new];
    head.backgroundColor = WJColorViewBg;
    
    UIView *infoBg = [[UIView alloc] init];
    infoBg.backgroundColor = [UIColor whiteColor];
    [head addSubview:infoBg];
    
    UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), 0, kScreenWidth - ALD(24), ALD(44))];
    infoL.font = WJFont15;
    infoL.textColor = WJColorDarkGray;
    [infoBg addSubview:infoL];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = WJColorSeparatorLine;
    [head addSubview:bottomLine];
    
    if (section == 0) {
        infoBg.frame = CGRectMake(0, 0, kScreenWidth, ALD(44));
        infoL.text = @"选择充值金额";
        CGFloat titleWidth = [UILabel getWidthWithTitle:@"选择充值金额" font:WJFont15];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12) + titleWidth + ALD(18), 0, ALD(150), ALD(44))];
        tipLabel.text = @"（1元=1个包子）";
        tipLabel.font = WJFont12;
        tipLabel.textColor = WJColorLightGray;
        [infoBg addSubview:tipLabel];
        
        bottomLine.frame = CGRectMake(0, ALD(44) - 0.5, kScreenWidth, 0.5);
        
        return head;
        
    }else {
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(10), kScreenWidth, 0.5)];
        topLine.backgroundColor = WJColorSeparatorLine;
        [head addSubview:topLine];
        
        infoBg.frame = CGRectMake(0, topLine.bottom, kScreenWidth, ALD(44));
        infoL.text = @"选择支付方式";
        bottomLine.frame = CGRectMake(0, ALD(54) - 0.5, kScreenWidth, 0.5);
        
        return head;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"SteameCell";
        WJSteameReChargeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[WJSteameReChargeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            chooseBtn.frame = CGRectMake(kScreenWidth-ALD(42), ALD(23.5), ALD(13), ALD(13));
            [chooseBtn setImage:[UIImage imageNamed:@"toggle_button_nor"] forState:UIControlStateNormal];
            [chooseBtn setImage:[UIImage imageNamed:@"toggle_button_selected"] forState:UIControlStateSelected];
            chooseBtn.userInteractionEnabled = NO;
            cell.accessoryView = chooseBtn;
        }
        
        if (indexPath.row == rechargeListModel.bunList.count-1) {
            cell.bottomLine.frame = CGRectMake(0, ALD(60) - 0.5, kScreenWidth, 0.5);
        }
        
        UIButton *chooseBtn = (UIButton *)cell.accessoryView;
        chooseBtn.selected = (selectedAmountTag == indexPath.row);
        [cell configCellWithOrder:[rechargeListModel.bunList objectAtIndex:indexPath.row]];
        
        return cell;
        
    }else if (indexPath.section == 1){
        static NSString *PayIdentifier = @"PaymentCell";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:PayIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PayIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            chooseBtn.frame = CGRectMake(kScreenWidth-ALD(42), ALD(15.5), ALD(13), ALD(13));
            [chooseBtn setImage:[UIImage imageNamed:@"toggle_button_nor"] forState:UIControlStateNormal];
            [chooseBtn setImage:[UIImage imageNamed:@"toggle_button_selected"] forState:UIControlStateSelected];
            chooseBtn.userInteractionEnabled = NO;
            cell.accessoryView = chooseBtn;
            
            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(44) - 0.5, kScreenWidth-ALD(24), 0.5)];
            bottomLine.tag = 100;
            bottomLine.backgroundColor = WJColorSeparatorLine;
            [cell.contentView addSubview:bottomLine];
        }
        
        
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"recharge_alipay"];
        }else{
            
            cell.imageView.image = [UIImage imageNamed:@"recharge_yeepay"];
            UIView *line = [cell.contentView viewWithTag:100];
            line.frame = CGRectMake(0, ALD(44) - 0.5, kScreenWidth, 0.5);
        }
        UIButton *chooseBtn = (UIButton *)cell.accessoryView;
        chooseBtn.selected = (selectedPayTypeTag == indexPath.row);
        
        return cell;
        
    }else{
        
        static NSString *AgreementIdentifier = @"AgreementCell";
        WJRechargeAgreementCell *cell =[tableView dequeueReusableCellWithIdentifier:AgreementIdentifier];
        if (!cell) {
            cell = [[WJRechargeAgreementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AgreementIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }

        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *btn = (UIButton *)cell.accessoryView;
        
        if (btn.selected) {
            return;
        }
        
        btn.selected = YES;
        
        //        if ([cardChangeModel.choiceCardArray count] > tag) {
        //            cardID =  ((WJChoiceCardModel *)[cardChangeModel.choiceCardArray objectAtIndex:indexPath.row]).cardId;
        //        }
        
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedAmountTag inSection:0]];
        UIButton *lastBtn = (UIButton *)lastCell.accessoryView;
        lastBtn.selected = NO;
        selectedAmountTag = indexPath.row;
        
        [self refreshCommitAmountL];
    }
    else if(indexPath.section == 1)
    {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *btn = (UIButton *)cell.accessoryView;
        
        if (btn.selected) {
            return;
        }
        btn.selected = YES;
        
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedPayTypeTag inSection:1]];
        UIButton *lastBtn = (UIButton *)lastCell.accessoryView;
        lastBtn.selected = NO;
        selectedPayTypeTag = indexPath.row;
        
        channelType = selectedPayTypeTag == 0?@"pingapp":@"payeco";
    }else
    {
        
        WJWebViewController *webVC = [[WJWebViewController alloc] init];
        webVC.titleStr = @"充值协议";
        NSString *urlStr = rechargeListModel.rechargeAgreement;
        [webVC loadWeb:urlStr];
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
    
}


#pragma mark - 充值协议cell代理
- (void)chooseAgreement:(WJRechargeAgreementCell *)cell
{
    if (cell.chooseBtn.selected) {
        payButton.backgroundColor = kBlueColor;
        payButton.enabled = YES;
    }else{
        payButton.backgroundColor = WJColorViewNotEditable;
        payButton.enabled = NO;
    }
}


#pragma mark - Uibutton action

- (void)showInstruction
{
//    WJBaoziDescriptionController *vc = [[WJBaoziDescriptionController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}


//支付跳转
- (void)commitOrder:(UIButton *)btn{
    
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
    
    if (defaultPerson.authentication == AuthenticationNo) {
        
        NSString *record = [[NSUserDefaults standardUserDefaults] valueForKey:@"RealNameReciveMoneyRecord"];
        
        if (!record) {
            
            WJRealNameAuthenticationViewController *realNameAuthenticationVC = [[WJRealNameAuthenticationViewController alloc] init];
            realNameAuthenticationVC.comefrom = ComeFromECardRechargeConfirm;
            realNameAuthenticationVC.isjumpOrderConfirmController = NO;
            [WJGlobalVariable sharedInstance].realAuthenfromController = self;
            [self.navigationController pushViewController:realNameAuthenticationVC animated:YES];
            
        } else {
            
            //收款金额验证
            WJVerificationReceiptMoneyController *verificationReceiptMoneyController = [[WJVerificationReceiptMoneyController alloc] init];
            [WJGlobalVariable sharedInstance].realAuthenfromController = self;
            verificationReceiptMoneyController.comefrom = ComeFromECardRechargeConfirm;
            verificationReceiptMoneyController.isjumpOrderConfirmController = NO;
            verificationReceiptMoneyController.BankCard = record;
            [self.navigationController pushViewController:verificationReceiptMoneyController animated:YES];
            
        }
        
    } else {
        
        [self showLoadingView];
        
        btn.enabled = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            btn.enabled = YES;
        });
        
        if(rechargeListModel.bunList.count >0){
            WJBaoziRechargeModel *model = [rechargeListModel.bunList objectAtIndex:selectedAmountTag];
            self.rechargeOrderManager.rechargeMoneyID = model.moneyID;
        }else{
            self.rechargeOrderManager.rechargeMoneyID = @"";
        }
        
        self.rechargeOrderManager.channelType = channelType;
        [self.rechargeOrderManager loadData];
        
    }
 }



#pragma mark - NSNotification
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


#pragma mark - 属性方法

- (APIBaoziRechargeListManager *)rechargeListManager
{
    if (!_rechargeListManager) {
        _rechargeListManager = [[APIBaoziRechargeListManager alloc] init];
        _rechargeListManager.delegate = self;
    }
    return _rechargeListManager;
}


- (APIBaoziRechargeOrderManager *)rechargeOrderManager{
    if (!_rechargeOrderManager) {
        _rechargeOrderManager = [[APIBaoziRechargeOrderManager alloc] init];
        _rechargeOrderManager.delegate = self;
    }
    _rechargeOrderManager.channelType = channelType;
    
    return _rechargeOrderManager;
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
