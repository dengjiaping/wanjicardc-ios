//
//  WJAddBankCardViewController.m
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJAddBankCardViewController.h"
#import "WJSupportBankCardViewController.h"
#import "APIBindingBankCardManager.h"
#import "APICashGetVerificationCodeManager.h"
#import "WJMyBankCardViewController.h"
#define  spaceMargin                                    (iPhone6OrThan?(ALD(0)):(ALD(15)))
#define  attachLabelTopMargin                           (iPhone6OrThan?(15.f):(10.f))
@interface WJAddBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField  *cardholderTF;
    UITextField  *selectBankCardTF;
    UITextField  *bankCardTF;
    UITextField  *identityCardTF;
    UITextField  *phoneTF;
    UITextField  *verificodeTF;
    UIButton     *submitButton;
    UIButton     *verifiCodeButton;
    
    NSInteger    timeCount;
    NSTimer      *verifyTimer;
    
}
@property(nonatomic,strong)APICashGetVerificationCodeManager *verifyCodeManager;
@property(nonatomic,strong)APIBindingBankCardManager         *bindingBankCardManager;
@property(nonatomic,strong)UITableView                       *mTb;
@property(nonatomic,strong)NSArray                           *listdataMiddle;

@end

@implementation WJAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"添加银行卡";
    self.view.backgroundColor = WJColorViewBg;
    
    [self initTopView];
    
    [self.view addSubview:self.mTb];
    
    [self initBottomView];
    
    [kDefaultCenter addObserver:self selector:@selector(checkInputState:) name:UITextFieldTextDidChangeNotification object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressGesture)];
    [self.view  addGestureRecognizer:tapGesture];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [cardholderTF resignFirstResponder];
    [selectBankCardTF resignFirstResponder];
    [bankCardTF resignFirstResponder];
    [phoneTF resignFirstResponder];
//    [verificodeTF resignFirstResponder];
    
    [self deleteTimerWhenBack];
}

- (void)dealloc{
    
    [kDefaultCenter removeObserver:self];
}

- (void)initTopView
{
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(32))];
    tipView.backgroundColor = WJColorPageControlTintColor;
    [self.view addSubview:tipView];
    
    UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12),(tipView.height - ALD(15))/2, ALD(15), ALD(15))];
    tipImageView.image = [UIImage imageNamed:@"tip_safe_image"];
    [tipView addSubview:tipImageView];
    
    UILabel *tipL = [[UILabel alloc] initWithFrame:CGRectMake(tipImageView.right + ALD(10), CGRectGetMinY(tipImageView.frame), kScreenWidth - ALD(36), ALD(14))];
    tipL.text = @"请绑定持卡人本人的银行卡";
    tipL.font = WJFont14;
    tipL.textColor = WJColorNavigationBar;
    [tipView addSubview:tipL];

}

- (void)initBottomView
{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    self.mTb.tableFooterView = bottomView;
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"他人银行卡无法绑定，请使用本人名下银行卡";
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"#9099a6"];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize txtSize = [tipLabel.text sizeWithAttributes:@{NSFontAttributeName:WJFont12} constrainedToSize:CGSizeMake(1000000, 20)];
    
    tipLabel.frame = CGRectMake((kScreenWidth - txtSize.width)/2, ALD(15), txtSize.width, ALD(20));
    [bottomView addSubview:tipLabel];
    
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(ALD(15), tipLabel.bottom + ALD(40), kScreenWidth - ALD(30), ALD(45));
    [submitButton setTitle:@"绑定" forState:UIControlStateNormal];
    [submitButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorViewNotEditable] forState:UIControlStateDisabled];
    [submitButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorNavigationBar] forState:UIControlStateNormal];
    submitButton.enabled = NO;
    submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    submitButton.layer.cornerRadius = 5;
    submitButton.layer.masksToBounds = YES;
    [submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:submitButton];
}

#pragma mark - Request

- (void)requestLoad
{
    [self showLoadingView];
    [self.bindingBankCardManager loadData];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIBindingBankCardManager class]]) {
        
        WJMyBankCardViewController *myBankCardVC = [[WJMyBankCardViewController alloc] init];
        [self.navigationController pushViewController:myBankCardVC animated:YES whetherJump:YES];
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if ([manager isKindOfClass:[APIBindingBankCardManager class]]) {
        
        [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
    }
    
}

#pragma mark -event
-(void)handletapPressGesture
{
    [cardholderTF resignFirstResponder];
    [selectBankCardTF resignFirstResponder];
    [bankCardTF resignFirstResponder];
    [phoneTF resignFirstResponder];
    [verificodeTF resignFirstResponder];
}

#pragma mark - UITextFieldTextDidChangeNotification

- (void)checkInputState:(NSNotification *)notification
{
    if (cardholderTF.text.length != 0 && bankCardTF.text.length != 0 && identityCardTF.text.length != 0 && phoneTF.text.length != 0) {
        
        submitButton.enabled = YES;
        
    } else {
        submitButton.enabled = NO;
    }
    
    if (phoneTF.text.length !=0) {
        
        verifiCodeButton.enabled = YES;
    } else {
        
        verifiCodeButton.enabled = NO;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == selectBankCardTF) {
        
        WJSupportBankCardViewController *supportBankCardViewController = [[WJSupportBankCardViewController alloc] init];
        [self.navigationController pushViewController:supportBankCardViewController animated:YES];
        
        supportBankCardViewController.selectSupportBankBlock = ^(NSString *bankName){
            
            selectBankCardTF.text = bankName;
            
            [self checkInputState:nil];
            
        };
        
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
    
    if (textField == identityCardTF) {
        if ([string length] > 0) {
            if (textField.text.length >= 18) {
                return NO;
            }
        }
        
    }
    
    if (textField == phoneTF) {
        if ([string length] > 0) {
            if (textField.text.length >= 11) {
                return NO;
            }
        }
    }
    
    return YES;
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return 5;
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ALD(45);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addBankCardCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addBankCardCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.separatorInset = UIEdgeInsetsMake(0, ALD(12), 0, ALD(12));
        [cell.textLabel setTextColor:WJColorDardGray3];
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, ALD(105), ALD(45))];
        nameL.textColor = WJColorDardGray6;
        nameL.tag = 2001;
        [cell.contentView addSubview:nameL];
        
        UITextField *contentL = [[UITextField alloc] initWithFrame:CGRectMake(nameL.right + spaceMargin, 0, kScreenWidth - ALD(130), ALD(45))];
        contentL.tag = 2002;
        contentL.textColor = WJColorDardGray6;
        contentL.delegate = self;
        [cell.contentView addSubview:contentL];
        
        timeCount = 60;
        
        verifiCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        verifiCodeButton.frame = CGRectMake(kScreenWidth - ALD(10) - ALD(85), 0, ALD(85), ALD(45));
        verifiCodeButton.tag = 2003;
        verifiCodeButton.titleLabel.font = WJFont14;
        verifiCodeButton.enabled = NO;
        [verifiCodeButton setTitleColor:WJColorViewNotEditable forState:UIControlStateDisabled];
        [verifiCodeButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
//        [verifiCodeButton setTintColor:WJColorDardGray3];
//        verifiCodeButton.layer.cornerRadius = 4;
//        verifiCodeButton.layer.borderWidth = 0.5;
//        [self changeBtnColor];

        [verifiCodeButton addTarget:self action:@selector(getVerifiCode:) forControlEvents:UIControlEventTouchUpInside];
        [verifiCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [cell.contentView addSubview:verifiCodeButton];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(verifiCodeButton.frame.origin.x - 0.5, ALD(4), ALD(0.5), ALD(36))];
        line.tag = 2004;
        line.backgroundColor = WJColorSeparatorLine;
        [cell.contentView addSubview:line];
    }
    
    UILabel *nameL = (UILabel *)[cell.contentView viewWithTag:2001];
    UITextField *contentTF = (UITextField *)[cell.contentView viewWithTag:2002];
    UIButton *button = (UIButton *)[cell.contentView viewWithTag:2003];
    UILabel  *lineL = (UILabel *)[cell.contentView viewWithTag:2004];
    
    NSDictionary * dic = [NSDictionary dictionary];
    
        if (0 == indexPath.row) {
        
        contentTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        cardholderTF = contentTF;
        button.hidden = YES;
        lineL.hidden = YES;
        
        dic = [self.listdataMiddle  objectAtIndex:0];
        nameL.text = dic[@"key"];
        contentTF.placeholder = dic[@"value"];
        
    }
//        else if (1 == indexPath.row) {
//        
//        selectBankCardTF = contentTF;
//        button.hidden = YES;
//        lineL.hidden = YES;
//
//        dic = [self.listdataMiddle  objectAtIndex:1];
//        nameL.text = dic[@"key"];
//        contentTF.placeholder = dic[@"value"];
//        
//        
//        UIImageView * arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-ALD(21), ALD(16),ALD(6), ALD(11))];
//        arrowImageView.image =[UIImage imageNamed:@"details_rightArrowIcon"];
//        [cell.contentView addSubview:arrowImageView];
//        
//    }
    else if (1 == indexPath.row){
        
        bankCardTF = contentTF;
        contentTF.keyboardType = UIKeyboardTypeNumberPad;
        button.hidden = YES;
        lineL.hidden = YES;
        
        dic = [self.listdataMiddle  objectAtIndex:1];
        nameL.text = dic[@"key"];
        contentTF.placeholder = dic[@"value"];
        
    } else if (2 == indexPath.row) {
        
        contentTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        identityCardTF = contentTF;
        button.hidden = YES;
        lineL.hidden = YES;
        
        dic = [self.listdataMiddle  objectAtIndex:2];
        nameL.text = dic[@"key"];
        contentTF.placeholder = dic[@"value"];
        
    } else if (3 == indexPath.row) {
        
        phoneTF = contentTF;
        button.hidden = YES;
        lineL.hidden = YES;

        contentTF.keyboardType = UIKeyboardTypeNumberPad;
        dic = [self.listdataMiddle  objectAtIndex:3];
        nameL.text = dic[@"key"];
        contentTF.placeholder = dic[@"value"];
        
    }
//    else {
//        
//        verificodeTF = contentTF;
//        contentTF.keyboardType = UIKeyboardTypeNumberPad;
//        button.hidden = NO;
//        lineL.hidden = NO;
//
//        dic = [self.listdataMiddle  objectAtIndex:4];
//        nameL.text = dic[@"key"];
//        contentTF.placeholder = dic[@"value"];
//    }
    
    return cell;
}

#pragma mark Action
- (void)submitButtonAction:(id)sender
{
    NSString * actionStr = [cardholderTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (nil == cardholderTF.text || [actionStr length] != [cardholderTF.text length] || [cardholderTF.text isEqualToString:@""]) {
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入真实姓名"];
        
        return;
        
    }
//    else if (selectBankCardTF.text == nil || [selectBankCardTF.text isEqualToString:@""]) {
//        
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请选择银行卡"];
//
//    }
    else if (bankCardTF.text == nil || [bankCardTF.text isEqualToString:@""]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入银行卡号"];
        
    } else if (![identityCardTF.text isIDCardNumber]) {
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"身份证号格式不正确"];
        
    } else {
        
        [self requestLoad];
    }
}


#pragma mark - action

- (void)getVerifiCode:(id)sender {
    
    //验证手机号
    if([WJUtilityMethod isValidatePhone:phoneTF.text]) {
        [self verficationRequest];
        [self startTimer];
        verificodeTF.text = @"";
        [verificodeTF becomeFirstResponder];
        
    } else {
        
        if(phoneTF.text.length <= 0){
            
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入手机号"];
        } else{
            
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入正确的手机号"];
        }
    }
}


- (void)startTimer{
    [verifiCodeButton setTitle:@"60秒" forState:UIControlStateNormal];
    verifiCodeButton.enabled = NO;
    
    [verifyTimer invalidate];
    verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeBtnTitle) userInfo:nil repeats:YES];
    [verifyTimer fire];
}


- (void)changeBtnTitle{
    
    if (timeCount <= 0) {
        timeCount = 60;
        [self deleteTimerWhenBack];
        [verifiCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        verifiCodeButton.enabled = YES;
    }else{
        
        [verifiCodeButton setTitle:[NSString stringWithFormat:@"%@秒", @(timeCount--)] forState:UIControlStateNormal];
        
    }
}

//- (void)changeBtnColor
//{
//    if (verifiCodeButton.enabled) {
//        verifiCodeButton.layer.borderColor = WJColorNavigationBar.CGColor;
//        
//    } else {
//        verifiCodeButton.layer.borderColor = WJColorLightGray.CGColor;
//        
//    }
//    
//}


- (void)deleteTimerWhenBack{
    [verifyTimer invalidate];
    verifyTimer = nil;
}

- (void)verficationRequest
{
    [self.verifyCodeManager loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 属性方法
- (UITableView *)mTb{
    if (_mTb == nil) {
        _mTb = [[UITableView alloc] initWithFrame:CGRectMake(0, ALD(32), kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        
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

-(NSArray *)listdataMiddle
{
    if(nil==_listdataMiddle)
    {
//        _listdataMiddle=@[@{@"key":@"持卡人",@"value":@"请输入持卡人姓名"},
//                          @{@"key":@"卡号",@"value":@"请输入所属银行卡号"},
//                          @{@"key":@"身份证号",@"value":@"请输入持卡人身份证号"},
//                          @{@"key":@"手机号",@"value":@"请输入持卡人手机号"},
//                          @{@"key":@"手机验证码",@"value":@"请输入验证码"}
//                          ];
        _listdataMiddle=@[@{@"key":@"持卡人",@"value":@"请输入持卡人姓名"},
                          @{@"key":@"卡号",@"value":@"请输入所属银行卡号"},
                          @{@"key":@"身份证号",@"value":@"请输入持卡人身份证号"},
                          @{@"key":@"手机号",@"value":@"请输入持卡人手机号"},
                          ];
    }
    return _listdataMiddle;
}

- (APICashGetVerificationCodeManager *)verifyCodeManager
{
    if (nil == _verifyCodeManager) {
        _verifyCodeManager = [[APICashGetVerificationCodeManager alloc] init];
        _verifyCodeManager.delegate = self;
    }
    
    _verifyCodeManager.phoneNum = phoneTF.text;
    
    return _verifyCodeManager;
}

-(APIBindingBankCardManager *)bindingBankCardManager
{
    if (nil == _bindingBankCardManager) {
        _bindingBankCardManager = [[APIBindingBankCardManager alloc] init];
        _bindingBankCardManager.delegate = self;
        
    }
    _bindingBankCardManager.name = cardholderTF.text;
    _bindingBankCardManager.bankCardNum = bankCardTF.text;
    _bindingBankCardManager.phoneNum = phoneTF.text;
    _bindingBankCardManager.verfiCodeNum = @"";
    _bindingBankCardManager.identityCard = identityCardTF.text;
    
    return _bindingBankCardManager;
}

@end
