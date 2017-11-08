//
//  WJRealNameAuthenticationViewController.m
//  WanJiCard
//
//  Created by reborn on 16/6/15.
//  Copyright © 2016年 zOne. All rights reserved.
//
#import "WJRealNameAuthenticationViewController.h"
#import "WJCompleteRealNameViewController.h"
#import "WJVerificationCodeViewController.h"
#import "APIRealNameVerificationCodeManager.h"
#import "WJSupportBankCardViewController.h"
#import "WJStatisticsManager.h"
#import "WJVerificationReceiptMoneyController.h"

#define  topHeaderViewHeight                            (iPhone6OrThan?(ALD(170)):(ALD(155)))
#define  TopIconViewTopMargin                           (iPhone6OrThan?(20.f):(10.f))
#define  attachLabelTopMargin                           (iPhone6OrThan?(15.f):(10.f))
#define  descriptionLabelTopMargin                      (iPhone6OrThan?(10.f):(5.f))
#define  spaceMargin                                    (iPhone6OrThan?(ALD(0)):(ALD(15)))
@interface WJRealNameAuthenticationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *realNameTF;
    UITextField *cardNumberTF;
    UITextField *selectBankCardTF;
    UITextField *bankCardTF;
    UITextField *registerPhoneTF;
    
    UIButton    *nextButton;
    UIButton    *bankBtn;
    UIView      *tipView;
    UIView      *topHeaderView;
}
@property(nonatomic,strong)APIRealNameVerificationCodeManager *realNameVerificationCodeManager;//获取验证码
@property(nonatomic,strong)UITableView *mTb;
@property(nonatomic,strong)NSArray     *listdataMiddle;

@end

@implementation WJRealNameAuthenticationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"实名认证";
    self.view.backgroundColor = WJColorViewBg;
    self.eventID = @"iOS_vie_certification";
    
    [self initContentView];
    
    [kDefaultCenter addObserver:self selector:@selector(checkInputState:) name:UITextFieldTextDidChangeNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressGesture)];
    [self.view  addGestureRecognizer:tapGesture];
    
}

- (void)initContentView
{
    
    tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(32))];
    tipView.backgroundColor = WJColorPageControlTintColor;
    [self.view addSubview:tipView];
    
    UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12),(tipView.height - ALD(14))/2, ALD(14), ALD(14))];
    tipImageView.image = [UIImage imageNamed:@"tip_safe_image"];
    [tipView addSubview:tipImageView];
    
    UILabel *tipL = [[UILabel alloc] initWithFrame:CGRectMake(tipImageView.right + ALD(10), CGRectGetMinY(tipImageView.frame), kScreenWidth - ALD(36), ALD(14))];
    tipL.text = @"实名认证提交后则不支持修改，请填写真实有效信息";
    tipL.font = WJFont12;
    tipL.textColor = WJColorPageControlTintColor;
    [tipView addSubview:tipL];
    
    [self.view addSubview:self.mTb];
    

    topHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topHeaderViewHeight)];
    topHeaderView.backgroundColor = WJColorViewBg;
    self.mTb.tableHeaderView = topHeaderView;
    
    UIImageView *topIconView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - ALD(100))/2,TopIconViewTopMargin, ALD(100), ALD(100))];
    topIconView.image = [UIImage imageNamed:@"Center_CheckIDCard"];
    [topHeaderView addSubview:topIconView];
    
    UILabel *attachLabel = [[UILabel alloc] init];
    attachLabel.text = @"为保障您的账号资产安全，请完善实名信息";
    attachLabel.font = [UIFont systemFontOfSize:12];
    attachLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"#9099a6"];
    [attachLabel setTextAlignment:NSTextAlignmentCenter];
    attachLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    CGSize txtSize = [attachLabel.text sizeWithAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    CGSize txtSize = [attachLabel.text sizeWithAttributes:@{NSFontAttributeName:WJFont12} constrainedToSize:CGSizeMake(1000000, 20)];
    
    attachLabel.frame = CGRectMake((kScreenWidth - txtSize.width)/2, topIconView.bottom + attachLabelTopMargin, txtSize.width, ALD(20));
    [topHeaderView addSubview:attachLabel];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    self.mTb.tableFooterView = bottomView;
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(ALD(15), ALD(5), kScreenWidth - ALD(30), ALD(45));
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorViewNotEditable] forState:UIControlStateDisabled];
    [nextButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorNavigationBar] forState:UIControlStateNormal];
    nextButton.enabled = NO;
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.masksToBounds = YES;
    [nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:nextButton];
    
    UILabel *descriptionLabel=[[UILabel alloc]init];
    [descriptionLabel setText:@"根据国家监管部门最新规定，我们需要您配合完成实名认证。完成认证后您的资金将由平安银行担保，以保障您的账户资金安全。此信息只用于实名认证使用我们将严格保密请放心填写。"];
    [descriptionLabel setFont:[UIFont systemFontOfSize:14]];
    descriptionLabel.numberOfLines = 0;
    [descriptionLabel setTextColor:WJColorAlert];
    descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    CGRect txtFrame=descriptionLabel.frame;
    txtFrame.size.height =[descriptionLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth- ALD(20), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:descriptionLabel.font,NSFontAttributeName, nil] context:nil].size.height;
    descriptionLabel.frame=CGRectMake(ALD(10), nextButton.bottom + descriptionLabelTopMargin, kScreenWidth - ALD(20), txtFrame.size.height);

    [bottomView addSubview:descriptionLabel];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [realNameTF resignFirstResponder];
    [cardNumberTF resignFirstResponder];
    [selectBankCardTF resignFirstResponder];
    [bankCardTF resignFirstResponder];
    [registerPhoneTF resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];

    if ([manager isKindOfClass:[APIRealNameVerificationCodeManager class]]) {
        
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            NSString *certificate = dic[@"certificate"];
    
            BOOL verifyType = [dic[@"isUnionVerify"] boolValue];
            
            NSInteger isAuthentication =  [ToString(dic[@"isAuthentication"]) integerValue];
            WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
            
            if ([[defaultPerson.token getSha1String] isEqualToString:certificate]) {
                
                if (isAuthentication == 1) {
                    
                    WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
                    defaultPerson.authentication = AuthenticationCompleted;
        
                    [[WJDBPersonManager new] updatePerson:defaultPerson];
                    
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"验证成功"];
                    
                    WJViewController *vc = [[WJGlobalVariable sharedInstance] realAuthenfromController];
                    [self.navigationController popToViewController:vc animated:YES];
                    
                    
                }  else {
                    
                    if (verifyType) {
                        //短信验证
                        WJVerificationCodeViewController *verifyCodeVC = [[WJVerificationCodeViewController alloc] init];
                        verifyCodeVC.realName = realNameTF.text;
                        verifyCodeVC.cardNumber = cardNumberTF.text;
                        verifyCodeVC.BankCard = bankCardTF.text;
                        verifyCodeVC.registerPhone = registerPhoneTF.text;
                        verifyCodeVC.comefrom = self.comefrom;
                        verifyCodeVC.isjumpOrderConfirmController = self.isjumpOrderConfirmController;
                        [self.navigationController pushViewController:verifyCodeVC animated:YES whetherJump:YES];
                        
                        __weak typeof(self) weakSelf = self;
                        [verifyCodeVC setAuthenticationSuc:^(void){
                            
                            __strong typeof(self) strongSelf = weakSelf;
                            
                            if (strongSelf.RealNameAuthenticationSuc) {
                                
                                strongSelf.RealNameAuthenticationSuc();
                            }
                        }];
                        
                    } else {
                    
                        //收款金额验证
                        WJVerificationReceiptMoneyController *verificationReceiptMoneyController = [[WJVerificationReceiptMoneyController alloc] init];
                        verificationReceiptMoneyController.comefrom = self.comefrom;
                        verificationReceiptMoneyController.isjumpOrderConfirmController = self.isjumpOrderConfirmController;
                        verificationReceiptMoneyController.BankCard = bankCardTF.text;
                        [self.navigationController pushViewController:verificationReceiptMoneyController animated:YES whetherJump:YES];

                        
                        __weak typeof(self) weakSelf = self;
                        [verificationReceiptMoneyController setAuthenticationSuc:^(void){
                            
                            __strong typeof(self) strongSelf = weakSelf;
                            
                            if (strongSelf.RealNameAuthenticationSuc) {
                                
                                strongSelf.RealNameAuthenticationSuc();
                            }
                        }];
                        
                    }
                    
                    
                }
                
            }
            
        }
        
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];

    if ([manager isKindOfClass:[APIRealNameVerificationCodeManager class]]) {
        
        [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
    }
}


#pragma mark - Request

- (void)requestLoad{
    
    [self showLoadingView];
    [self.realNameVerificationCodeManager loadData];
}

#pragma mark -event
-(void)handletapPressGesture
{
    [realNameTF resignFirstResponder];
    [cardNumberTF resignFirstResponder];
    [selectBankCardTF resignFirstResponder];
    [bankCardTF resignFirstResponder];
    [registerPhoneTF resignFirstResponder];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        _mTb.tableHeaderView = topHeaderView;
        _mTb.frame = CGRectMake(0, tipView.bottom, kScreenWidth, kScreenHeight);

    }];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (0 == section) {
        return 2;
    } else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(45);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section) {
        return 0.01f;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"realCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"realCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
        [cell.textLabel setTextColor:WJColorDardGray3];
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, ALD(100), ALD(45))];
        nameL.textColor = WJColorDardGray6;
        nameL.tag = 2001;
        [cell.contentView addSubview:nameL];
        
        UITextField *contentL = [[UITextField alloc] initWithFrame:CGRectMake(nameL.right + spaceMargin, 0, kScreenWidth - ALD(115), ALD(45))];
        contentL.tag = 2002;
        contentL.textColor = WJColorDardGray6;
        contentL.delegate = self;
        [cell.contentView addSubview:contentL];
    }
    
    UILabel *nameL = (UILabel *)[cell.contentView viewWithTag:2001];
    UITextField *contentTF = (UITextField *)[cell.contentView viewWithTag:2002];

    NSDictionary * dic = [NSDictionary dictionary];
    
    if (0 == indexPath.section) {
        
        if (0 == indexPath.row) {
            contentTF.keyboardType = UIKeyboardTypeDefault;
            contentTF.clearButtonMode = UITextFieldViewModeWhileEditing;

            realNameTF = contentTF;
            
            dic = [self.listdataMiddle  objectAtIndex:0];
            nameL.text = dic[@"key"];
            contentTF.placeholder = dic[@"value"];
            
        } else if (1 == indexPath.row) {
            
            contentTF.clearButtonMode = UITextFieldViewModeWhileEditing;
            cardNumberTF = contentTF;
            
            dic = [self.listdataMiddle  objectAtIndex:1];
            nameL.text = dic[@"key"];
            contentTF.placeholder = dic[@"value"];
        }
        
    } else if (1 == indexPath.section) {
        
        if (0 == indexPath.row) {
            
            selectBankCardTF = contentTF;
            
            dic = [self.listdataMiddle  objectAtIndex:2];
            nameL.text = dic[@"key"];
            contentTF.placeholder = dic[@"value"];
            
            
            UIImageView * arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-ALD(21), ALD(16),ALD(6), ALD(11))];
            arrowImageView.image =[UIImage imageNamed:@"details_rightArrowIcon"];
            [cell.contentView addSubview:arrowImageView];
            
            
        } else if (1 == indexPath.row) {
            
            bankBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(31), (cell.contentView.height - ALD(21))/2, ALD(21), ALD(21))];
            bankBtn.tag = 2003;
            [bankBtn setImage:[UIImage imageNamed:@"supportBank"] forState:UIControlStateNormal];
            bankBtn.hidden = YES;
            [cell.contentView addSubview:bankBtn];
            [bankBtn addTarget:self action:@selector(supportBankAction) forControlEvents:UIControlEventTouchUpInside];
            contentTF.keyboardType = UIKeyboardTypeNumberPad;
            
            bankCardTF = contentTF;
            dic = [self.listdataMiddle  objectAtIndex:3];
            nameL.text = dic[@"key"];
            contentTF.placeholder = dic[@"value"];
            
        } else if (2 == indexPath.row) {
            contentTF.keyboardType = UIKeyboardTypeNumberPad;
            contentTF.clearButtonMode = UITextFieldViewModeWhileEditing;

            registerPhoneTF = contentTF;
            
            dic = [self.listdataMiddle  objectAtIndex:4];
            nameL.text = dic[@"key"];
            contentTF.placeholder = dic[@"value"];
        }
    }
    
    return cell;
}

- (void)dealloc{
    
    [kDefaultCenter removeObserver:self];
}

#pragma mark - UITextFieldTextDidChangeNotification

- (void)checkInputState:(NSNotification *)notification
{
    if (realNameTF.text.length != 0 && cardNumberTF.text.length != 0 && selectBankCardTF.text.length != 0 && bankCardTF.text.length != 0 && registerPhoneTF.text.length != 0) {
        nextButton.enabled = YES;
        
    } else {
        nextButton.enabled = NO;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3f animations:^{
        _mTb.tableHeaderView = nil;
        _mTb.frame = CGRectMake(0, tipView.bottom, kScreenWidth, kScreenHeight);

    }];
    
    if (textField == selectBankCardTF) {
        
        WJSupportBankCardViewController *supportBankCardViewController = [[WJSupportBankCardViewController alloc] init];
        [self.navigationController pushViewController:supportBankCardViewController animated:YES];
        
        supportBankCardViewController.selectSupportBankBlock = ^(NSString *bankName){
            
            selectBankCardTF.text = bankName;
            
            [self checkInputState:nil];

        };
        
    }
    
    if (textField == bankCardTF) {
        bankBtn.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == bankCardTF) {
        
        bankBtn.hidden = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == bankCardTF) {
        
        
        // 4位分隔银行卡卡号
        NSString *text = [textField text];
                
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (text.length >= 25) {
            return NO;
        }
        
        //删除单个字符
        if (range.location > 0 && range.length == 1 && string.length == 0)
        {
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
            return NO;
        }
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        [textField setText:newString];
        
        [self checkInputState:nil];

        return NO;
    }
    
    if (textField == cardNumberTF) {
        if ([string length] > 0) {
            if (textField.text.length >= 18) {
                return NO;
            }
        }
        
    }

    if (textField == registerPhoneTF) {
        if ([string length] > 0) {
            if (textField.text.length >= 11) {
                return NO;
            }
        }
    }

    return YES;
}

- (void)nextAction
{
    NSString * actionStr = [realNameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (nil == realNameTF.text || [actionStr length] != [realNameTF.text length] || [realNameTF.text isEqualToString:@""]) {
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入真实姓名"];

        return;
        
    } else if (![cardNumberTF.text isIDCardNumber]) {
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"身份证号格式不正确"];

        
    } else if (selectBankCardTF.text == nil || [selectBankCardTF.text isEqualToString:@""]) {
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请选择银行卡"];

        
    } else if (![bankCardTF.text isBankCardID]) {
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"银行卡号格式不正确"];

        
    } else if (![WJUtilityMethod isValidatePhone:registerPhoneTF.text]) {
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入正确的手机号"];
        
    } else {

        [self requestLoad];
        
    }

}

- (void)supportBankAction
{
    WJSupportBankCardViewController *supportBankCardViewController = [[WJSupportBankCardViewController alloc] init];
    [self.navigationController pushViewController:supportBankCardViewController animated:YES];
}

-(NSArray *)listdataMiddle
{
    if(nil==_listdataMiddle)
    {
        _listdataMiddle=@[@{@"key":@"真实姓名",@"value":@"请输入您的真实姓名"},
                          @{@"key":@"身份证号",@"value":@"请输入您的身份证号码"},
                          @{@"key":@"选择银行卡",@"value":@"选择您的银行卡"},
                          @{@"key":@"银行卡号",@"value":@"请输入您的银行卡号"},
                          @{@"key":@"预留手机号",@"value":@"请填写银行预留手机号"}
                          ];
    }
    return _listdataMiddle;
}

#pragma mark - 属性方法
- (UITableView *)mTb{
    if (_mTb == nil) {
        _mTb = [[UITableView alloc] initWithFrame:CGRectMake(0, tipView.bottom, kScreenWidth, kScreenHeight - tipView.height) style:UITableViewStyleGrouped];
        
        _mTb.delegate = self;
        _mTb.dataSource = self;
        _mTb.separatorInset = UIEdgeInsetsZero;
        _mTb.backgroundColor = WJColorViewBg;
        _mTb.scrollEnabled = NO;
        _mTb.separatorColor = WJColorSeparatorLine;
        _mTb.tableFooterView = [UIView new];
    }
    return _mTb;
}

-(APIRealNameVerificationCodeManager *)realNameVerificationCodeManager
{
    if (nil == _realNameVerificationCodeManager) {
        _realNameVerificationCodeManager = [[APIRealNameVerificationCodeManager alloc] init];
        _realNameVerificationCodeManager.delegate = self;

    }
    _realNameVerificationCodeManager.realName = realNameTF.text;
    _realNameVerificationCodeManager.cardNum = cardNumberTF.text;
    _realNameVerificationCodeManager.bankCardNum = bankCardTF.text;
    _realNameVerificationCodeManager.phoneNum = registerPhoneTF.text;
    
    return _realNameVerificationCodeManager;
}

@end
