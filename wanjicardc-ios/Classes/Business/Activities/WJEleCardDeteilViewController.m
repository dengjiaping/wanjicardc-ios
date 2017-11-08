//
//  WJEleCardDeteilViewController.m
//  WanJiCard
//
//  Created by 林有亮 on 16/8/18.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJEleCardDeteilViewController.h"
#import "WJPassView.h"
#import "WJEleCardHeaderView.h"
#import "WJECardModel.h"
#import "WJWebTableViewCell.h"
#import "WJInputKeyBoardView.h"
#import "APIECardDetailManager.h"
#import "APIGenECardOrderManager.h"
#import "APIBuyECardManager.h"
#import "WJSystemAlertView.h"
#import "WJAppealViewController.h"
#import "WJFindSafetyQuestionController.h"
#import "WJFindRealNameAuthenticationViewController.h"
#import "WJBaoziOrderConfirmController.h"
#import "WJECardDetailModel.h"
#import "WJBaoziPayCompleteController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "WJPayCompleteModel.h"
#import "WJShare.h"
#import "WJOrderDetailViewController.h"
#import "WJLoginViewController.h"
#import "WJRealNameAuthenticationViewController.h"
#import "WJVerificationReceiptMoneyController.h"

@interface WJEleCardDeteilViewController ()<UITableViewDelegate,UITableViewDataSource,
APIManagerCallBackDelegate,UITextFieldDelegate,WJSystemAlertViewDelegate,UIActionSheetDelegate,WJPassViewDelegate,NeedReloadListDelegate>
{
    NSString * orderNo;
    BOOL       isShowKeyBoard;
    CGFloat    cellHeight;
    NSInteger    buyNumber;
    UITapGestureRecognizer  * tap;
    BOOL       isShowPassView;
    NSString * totolBaoziNum;
}

@property (nonatomic, strong) WJEleCardHeaderView   * headerView;
@property (nonatomic, strong) UITableView           * tableView;
@property (nonatomic, strong) WJInputKeyBoardView   * inputView;

@property (nonatomic, strong) APIECardDetailManager * eCardDetailManager;
@property (nonatomic, strong) APIGenECardOrderManager * genECardManager;
@property (nonatomic, strong) APIBuyECardManager    * buyECardManager;
@property (nonatomic, strong) WJECardDetailModel    * detailModel;
@property (nonatomic, strong) UIView                * blackView;

@end

@implementation WJEleCardDeteilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    WJPassView * passView = [[WJPassView alloc] initWithFrame:self.view.bounds title:@"请输入支付密码" cardName:@"1号店礼品卡" faceValue:@"1000" cardNum:@"111111" baoziNeedNum:@"900" baoziHasNum:@"900" passViewType:PassViewTypeSubmit];
//    [passView showIn];
    
    self.eventID = @"iOS_vie_MyBunDetail";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.blackView];
    [self.view addSubview:self.inputView];
    
//    self.view.backgroundColor = [WJUtilityMethod randomColor];
    self.eCardModel.isEntitycard = self.isEntityCard;
    [self.headerView refreshWithECardModel:self.eCardModel];
    CGFloat height = [self.headerView headerViewHeight];
    
    
    [self.headerView setFrame:CGRectMake(0, 0, kScreenWidth, height)];
    [self.tableView setTableHeaderView:self.headerView];
    
    [self requestData];
    
    [self addNotification];

    self.view.backgroundColor = [WJUtilityMethod randomColor];
    
    self.navigationItem.title = self.eCardModel.commodityName;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, ALD(22), ALD(22));
    [rightButton setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shareCard) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestData];
}

- (void)requestData
{
    self.eCardDetailManager.eCardID = self.eCardModel.cardId;
    [self.eCardDetailManager loadData];
}

- (void)dealloc
{
    [self removeNotification];
}


- (void)addNotification
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeNotification
{
    [kDefaultCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [kDefaultCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [kDefaultCenter removeObserver:self];
}

- (void)shareCard
{
    [WJShare sendShareController:self
                         LinkURL:self.detailModel.url
                         TagName:@"TAG_ECardDetail"
                           Title:self.detailModel.commodityName
                     Description:self.detailModel.desString
                      ThumbImage:self.detailModel.logoUrl];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    NSLog(@"%d",height);
    [self.inputView setFrame:CGRectMake(0, kScreenHeight - 64 - height - ALD(50), kScreenWidth, ALD(50))];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTap)];
    [self.tableView addGestureRecognizer:tap];
    
//    [self.blackView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - height)];
    self.blackView.hidden = NO;
    
}

- (void)addTap
{
    [self.inputView.textTF resignFirstResponder];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self.inputView setFrame:CGRectMake(0, kScreenHeight - 64 - ALD(50), kScreenWidth, ALD(50))];
    [self.tableView removeGestureRecognizer:tap];
    self.blackView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 支付密码重新设置成功
- (void)resetPasswordSuccess
{
//    [self checkAlertWithBaoziNum:totolBaoziNum];
    self.inputView.textTF.enabled = YES;
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
    [kDefaultCenter addObserver:self selector:@selector(resetPasswordSuccess) name:@"FindPasswordFromECardDetail" object:nil];
    
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

//指纹校验
- (void)checkFingerWithIdenty
{
    if(IOS8_LATER) {
        //进行指纹识别，获取指纹验证结果
        LAContext *context = [[LAContext alloc] init];
        context.localizedFallbackTitle = @"输入支付密码";
        
        __weak typeof(self) weakSelf = self;
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"通过Home键验证已有手机指纹",nil) reply:^(BOOL success, NSError * _Nullable error) {
            
            __strong typeof(self) strongSelf = weakSelf;
            if (success) {
                //验证成功，主线程处理UI
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [self showLoadingView];
                    [strongSelf.buyECardManager loadData];
                }];
                
            }else{
                NSLog(@"%@",error.localizedDescription);
            }
        }];
    }
}

#pragma mark - WJPassViewDelegate
- (void)successWithVerifyPsdAlert:(WJPassView *)alertView
{
    [self showLoadingView];
    [self.buyECardManager loadData];
}

//确认支付（已开启指纹）
- (void)payWithAlert:(WJPassView *)alertView
{
    [alertView dismiss];
    isShowPassView = NO;
    [self checkFingerWithIdenty];
}

- (void)failedWithVerifyPsdAlert:(WJPassView *)alertView errerMessage:(NSString * )errerMessage isLocked:(BOOL)isLocked
{
    [alertView dismiss];
    isShowPassView = NO;
    //失败重新弹出输入弹窗
    [self showAlertWithMessage:errerMessage isLocked:isLocked];
}


- (void)forgetPasswordActionWith:(WJPassView *)alertView
{
    [alertView dismiss];
    isShowPassView = NO;
    [self findPassword];
}


//立即充值（包子不足）
- (void)RechargeWithAlert:(WJPassView *)alertView{
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
    } else {
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

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%f",cellHeight);
    
    return cellHeight > 0? cellHeight:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifyStr = @"CellID";
    WJWebTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifyStr];
    if (!cell) {
        cell = [[WJWebTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyStr];
        cell.delegate = self;
    }
   
    if (self.detailModel != nil && cellHeight == 0) {
         [cell configWithURL:self.detailModel.useRule];
//        [cell configWithURL:@"http://blog.csdn.net/worldzhy/article/details/41045387"];
    }
    
    cell.contentView.backgroundColor = [WJUtilityMethod randomColor];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(44) + 10)];
    headerView.backgroundColor = WJColorCardGray;
    headerView.layer.borderColor = [WJColorCardGray CGColor];
    headerView.layer.borderWidth = 1;
    
    UILabel * textLable = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), 0, ALD(200), ALD(44))];
    textLable.text = @"商品介绍";
    textLable.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
    textLable.font = WJFont14;
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:textLable];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ALD(44);
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIECardDetailManager class]]) {
        NSDictionary * dic = [manager fetchDataWithReformer:nil];
        NSLog(@"%@",dic);
       self.detailModel = [[WJECardDetailModel alloc] initWithDictionary:dic];
        if ([self.detailModel.stock integerValue] <= 0)
        {
            [self.inputView.buyButton setTitle:@"无货" forState:UIControlStateNormal];
            [self.inputView.buyButton setBackgroundColor:[WJUtilityMethod colorWithHexColorString:@"cccccc"]];
            self.inputView.buyButton.enabled = NO;
            self.inputView.textTF.text = 0;
        }else {
            [self.inputView.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
            [self.inputView.buyButton setBackgroundColor:[WJUtilityMethod colorWithHexColorString:@"31b0ef"]];
            self.inputView.buyButton.enabled = YES;
        }
        self.detailModel.isEntitycard = self.isEntityCard;
        [self.headerView refreshWithECardModel:self.detailModel];
        CGFloat height = [self.headerView headerViewHeight];
        [self.headerView setFrame:CGRectMake(0, 0, kScreenWidth, height)];
        [self.tableView setTableHeaderView:self.headerView];
        [self.tableView reloadData];
        [self checkTF:1];
    } else if ([manager isKindOfClass:[APIGenECardOrderManager class]]) {
        NSDictionary * dic = [manager fetchDataWithReformer:nil];
        NSLog(@"%@",dic);
        //        orderNo = 101716082900016;
        orderNo = dic[@"orderNo"];
        self.buyECardManager.orderNo = orderNo;
        
        totolBaoziNum = [NSString stringWithFormat:@"%@",dic[@"totalBunNum"]];
        [self checkAlertWithBaoziNum:totolBaoziNum];
        self.inputView.textTF.enabled = YES;
        
    } else if ([manager isKindOfClass:[APIBuyECardManager class]]) {
        NSLog(@"%@",@"购买成功");
        
        [self hiddenLoadingView];
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        WJPassView *alert = (WJPassView *)[window viewWithTag:100005];
        if (alert) {
            [alert dismiss];
        }
        
        WJPayCompleteModel *model = [[WJPayCompleteModel alloc] init];
        model.paymentType = PaymentTypeBuy;
        model.orderNo = orderNo;
        model.ecard = self.detailModel;
        model.ecardsNum = [NSString stringWithFormat:@"%ld",buyNumber];
        model.electronicCardPayType = ElectronicCardPayTypeBaoZi;

        isShowPassView = NO;
        [WJGlobalVariable sharedInstance].payfromController = self;
        //进入交易结果页
        WJBaoziPayCompleteController *vc = [[WJBaoziPayCompleteController alloc] initWithinfo:model];
        vc.electronicCardComeFrom = self.electronicCardComeFrom;
        orderNo = @"";
        buyNumber = 0;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIECardDetailManager class]]) {
//        NSDictionary * dic = [manager fetchDataWithReformer:nil];
    } else if ([manager isKindOfClass:[APIGenECardOrderManager class]]) {
        NSLog(@"%@",manager.errorMessage);
        if (manager.errorMessage.length > 0)
        {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:manager.errorMessage];
        }
        self.inputView.textTF.enabled = YES;
    } else if ([manager isKindOfClass:[APIBuyECardManager class]]) {
        self.inputView.textTF.enabled = YES;
        //        NSDictionary * dic = [manager fetchDataWithReformer:nil];
        WJSystemAlertView *sysAlert = [[WJSystemAlertView alloc] initWithTitle:@"支付失败" message:@"支付遇到问题，您可以到我的订单页面查看订单详情" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
        [sysAlert showIn];
    }

}

- (void)reloadByHeight:(CGFloat)height
{
    cellHeight = height;
    [self.tableView reloadData];
}

- (void)checkAlertWithBaoziNum:(NSString *)num
{
    CGFloat  salePrice = [self.detailModel.salePrice floatValue];
    CGFloat  needPrice = salePrice * [self.inputView.textTF.text floatValue];
    //num 数量是否需要充值
    
    if ([num floatValue] < needPrice) {
        WJPassView * passView = [[WJPassView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - ALD(50)) title:@"支付" cardName:self.detailModel.commodityName  faceValue: [WJUtilityMethod baoziNumberFormatter:[NSString stringWithFormat:@"%f",[self.detailModel.facePrice floatValue]]]  cardNum:self.inputView.textTF.text baoziNeedNum:[NSString stringWithFormat:@"%f",needPrice] baoziHasNum:num passViewType:PassViewTypeSubmitTip];
        passView.delegate = self;
        [passView showIn];
        return;
    }
    //    return
    //判断是否设置了指纹验证
    NSString *fingerIdenty = KFingerIdentySwitch;
    BOOL isBool = NO;
    if (fingerIdenty) {
        isBool = [[NSUserDefaults standardUserDefaults] boolForKey:fingerIdenty];
    }
    
    [WJGlobalVariable sharedInstance].fromController = self;
    if (isBool) {
        WJPassView * passView = [[WJPassView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - ALD(50)) title:@"支付" cardName:self.detailModel.commodityName  faceValue:  [WJUtilityMethod baoziNumberFormatter:[NSString stringWithFormat:@"%f",[self.detailModel.facePrice floatValue]]] cardNum:self.inputView.textTF.text baoziNeedNum:[NSString stringWithFormat:@"%f",needPrice] baoziHasNum:num passViewType:PassViewTypeSubmit];
        
        passView.delegate = self;
        [passView showIn];
    } else {
        WJPassView * passView = [[WJPassView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - ALD(50)) title:@"支付" cardName:self.detailModel.commodityName  faceValue: [WJUtilityMethod baoziNumberFormatter:[NSString stringWithFormat:@"%f",[self.detailModel.facePrice floatValue]]] cardNum:self.inputView.textTF.text baoziNeedNum:[NSString stringWithFormat:@"%f",needPrice]  baoziHasNum:num passViewType:PassViewTypeInputPassword];
        passView.delegate = self;
        [passView showIn];
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   
    NSInteger num = [[NSString stringWithFormat:@"%@%@",textField.text,string] integerValue];
    [self checkTF:num];

    return YES;
}

- (void)checkTF:(NSInteger)num
{
    if (num <= 1) {
        num = 1;
        self.inputView.subtractButton.selected = NO;
        self.inputView.subtractButton.enabled = NO;
    } else
    {
        self.inputView.subtractButton.selected = YES;
        self.inputView.subtractButton.enabled = YES;
    }
    
    if (num >= [self.detailModel.stock integerValue]) {
        self.inputView.addButton.selected = NO;
        self.inputView.addButton.enabled = NO;
    }else {

        self.inputView.addButton.selected = YES;
        self.inputView.addButton.enabled = YES;
    }
}


- (void)buyECardAction
{
    if([self.inputView.textTF.text floatValue] == 0)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"数量不能为0，请重新输入"];
//    NSInteger num = [self.inputView.textTF.text integerValue];
//    if (num == 0) {
//        ALERT(@"数量不能为0");
        self.inputView.textTF.text = @"1";
        return;
//    }
    }
    if ([self.detailModel.stock floatValue] == 0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"库存不足"];
    }else {
        WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
        //判断是否登录
        if (defaultPerson) {
            
            [self checkAuthentication];
            
        } else {
            //去登陆
            [kDefaultCenter addObserver:self selector:@selector(buyECardAction) name:@"LoginForBuyECard" object:nil];
            WJLoginViewController *loginVC = [[WJLoginViewController alloc] init];
            loginVC.from = LoginFromBuyElectronicCard;
            WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:loginVC];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    }
}

- (void)buyEcard
{
    if (self.electronicCardComeFrom == ComeFromFair || self.electronicCardComeFrom == ComeFromHome)
    {
        [self payEcard];
    } else {
        if (([self.inputView.textTF.text integerValue] > self.detailModel.limitCount) && (self.detailModel.activityType != 0)) {
            
            [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"您还可以购买%d张限购商品",(int)self.detailModel.limitCount]];
            return;
            
        }
        
        WJOrderDetailViewController * orderDetailVC = [[WJOrderDetailViewController alloc] init];
        orderDetailVC.eCardModel = self.detailModel;
        orderDetailVC.electronicCardComeFrom = self.electronicCardComeFrom;
        orderDetailVC.orderNum = [self.inputView.textTF.text integerValue];
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
}

- (void)payEcard
{
    CGFloat num = [self.inputView.textTF.text floatValue];
    if (num > MIN([self.detailModel.stock floatValue], 200))
    {
        // 库存不足
        //清重新选择购买数量
        if (num > [self.detailModel.stock integerValue]) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"库存不足"];
        } else if (num > 200) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"购买数量不能超过200"];
        }
        
    } else {
        
        if (self.detailModel.activityType != 0) {
            //活动电子卡
            if (num > self.detailModel.limitCount) {
                
                [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"您每天最多可以购买%ld张限购商品",(long)self.detailModel.allowBuyCount]];
                
            } else {
                
                if (num > self.detailModel.allowBuyCount) {
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"您还可以购买%ld张限购商品",(long)self.detailModel.allowBuyCount]];
                    
                } else {
                    
                    self.genECardManager.eCardID = self.detailModel.cardId;
                    self.genECardManager.buyNumber = num;
                    buyNumber = num;
                    [self.genECardManager loadData];
                    self.inputView.textTF.enabled = NO;
                }
            }
            
            
        } else {
            //非活动电子卡
            self.genECardManager.eCardID = self.detailModel.cardId;
            self.genECardManager.buyNumber = num;
            buyNumber = num;
            [self.genECardManager loadData];
            self.inputView.textTF.enabled = NO;
        }
        
    }
}

- (void)subtractECardNumAction
{
    NSString * str = self.inputView.textTF.text;
    NSInteger num = [str integerValue];
    num--;
    [self checkTF:num];
    self.inputView.textTF.text = [NSString stringWithFormat:@"%ld",(long)num];
}

- (void)addECardNumAction
{
    
    NSString * str = self.inputView.textTF.text;
    NSInteger num = [str integerValue];
    num++;
    [self checkTF:num];
    self.inputView.textTF.text = [NSString stringWithFormat:@"%ld",(long)num];
}
#pragma mark - 核对实名认证
- (void)checkAuthentication
{
    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
//    if (defaultPerson.authentication == AuthenticationNo) {
    if (0) {

        
        NSString *record = [[NSUserDefaults standardUserDefaults] valueForKey:@"RealNameReciveMoneyRecord"];
        
        if (!record) {
            
            WJRealNameAuthenticationViewController *realNameAuthenticationVC = [[WJRealNameAuthenticationViewController alloc] init];
            realNameAuthenticationVC.comefrom = ComeFromEleCardDetail;
            realNameAuthenticationVC.isjumpOrderConfirmController = YES;
            [WJGlobalVariable sharedInstance].realAuthenfromController = self;
            [self.navigationController pushViewController:realNameAuthenticationVC animated:YES];
            
            __weak typeof(self) weakSelf = self;
            [realNameAuthenticationVC setRealNameAuthenticationSuc:^(void){
                
                __strong typeof(self) strongSelf = weakSelf;
                
                [strongSelf buyEcard];
                
            }];
            
        } else {
            
            //收款金额验证
            WJVerificationReceiptMoneyController *verificationReceiptMoneyController = [[WJVerificationReceiptMoneyController alloc] init];
            [WJGlobalVariable sharedInstance].realAuthenfromController = self;
            verificationReceiptMoneyController.comefrom = ComeFromEleCardDetail;
            verificationReceiptMoneyController.isjumpOrderConfirmController = YES;
            verificationReceiptMoneyController.BankCard = record;
            [self.navigationController pushViewController:verificationReceiptMoneyController animated:YES];
            
            
            __weak typeof(self) weakSelf = self;
            [verificationReceiptMoneyController setAuthenticationSuc:^(void){
                
                __strong typeof(self) strongSelf = weakSelf;
                
                [strongSelf buyEcard];
                
            }];
            
        }
        
    } else {
        
        [self buyEcard];
        
    }
}


- (WJECardModel *)eCardModel
{
    if (!_eCardModel) {
        _eCardModel = [[WJECardModel alloc] init];
        
//        _eCardModel.cardId = @"1";
//        _eCardModel.cardColor = arc4random()%4 + 1;
//        _eCardModel.faceValue = @"200";
//        _eCardModel.stock = @"1201";
//        _eCardModel.salePrice = @"150";
//        _eCardModel.cardDes = @"植入广告植入广告植入广告植入广告植入广告植入广告植入广告植入广告植入广告植入广告植入广告植入广告植入广告植入广告植入广告";
//        _eCardModel.logoUrl = @"";
//        _eCardModel.commodityName = @"唯品会200元电子卡";
//        _eCardModel.soldCount = @"554";
        
    }
    return _eCardModel;
}

- (WJEleCardHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[WJEleCardHeaderView alloc] init];
    }
    return _headerView;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        self.headerView.backgroundColor = WJColorWhite;
    }
    return _tableView;
}

- (WJInputKeyBoardView *)inputView
{
    if (!_inputView) {
        _inputView = [[WJInputKeyBoardView alloc] initWithFrame:CGRectMake(0, kScreenHeight - ALD(50) - 64, kScreenWidth, ALD(50))];
        _inputView.textTF.delegate = self;
        _inputView.textTF.text = @"1";
        _inputView.textTF.keyboardType = UIKeyboardTypeNumberPad;
        _inputView.textTF.returnKeyType =UIReturnKeyDone;
        [_inputView.buyButton addTarget:self action:@selector(buyECardAction) forControlEvents:UIControlEventTouchUpInside];
        [_inputView.addButton addTarget:self action:@selector(addECardNumAction) forControlEvents:UIControlEventTouchUpInside];
        [_inputView.subtractButton addTarget:self action:@selector(subtractECardNumAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inputView;
}

//@property (nonatomic, strong) APIECardDetailManager * eCardDetailManager;
//@property (nonatomic, strong) APIGenECardOrderManager * genECardManager;
//@property (nonatomic, strong) APIBuyECardManager    * buyECardManager;

- (APIECardDetailManager *)eCardDetailManager
{
    if (!_eCardDetailManager) {
        _eCardDetailManager = [[APIECardDetailManager alloc] init];
        _eCardDetailManager.delegate = self;
    }
    return _eCardDetailManager;
}

- (APIGenECardOrderManager *)genECardManager
{
    if (!_genECardManager) {
        _genECardManager = [[APIGenECardOrderManager alloc] init];
        _genECardManager.delegate = self;
    }
    return _genECardManager;
}

- (APIBuyECardManager *)buyECardManager
{
    if (!_buyECardManager) {
        _buyECardManager = [[APIBuyECardManager alloc] init];
        _buyECardManager.delegate = self;
    }
    return _buyECardManager;
}

- (UIView *)blackView
{
    if (!_blackView) {
        _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _blackView.backgroundColor =  [UIColor blackColor];
        _blackView.alpha = 0.4;
        _blackView.hidden = YES;
        
        UITapGestureRecognizer * t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTap)];
        [_blackView addGestureRecognizer:t];
    }
    return _blackView;
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
