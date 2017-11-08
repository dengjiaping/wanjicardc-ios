//
//  WJCashLoginViewController.m
//  WanJiCard
//
//  Created by reborn on 16/11/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCashLoginViewController.h"
#import "APICashLoginManager.h"
#import "APICashGetVerificationCodeManager.h"

@interface WJCashLoginViewController ()<APIManagerCallBackDelegate,UITextFieldDelegate>
{
    UITextField *phoneTF;
    UITextField *verifyTF;
    UITextField *inviteCodeTF;
    UIButton *getVerifyCodeBtn;
    NSTimer *verifyTimer;
    NSInteger timeCount;
    UIButton *loginBtn;
    
}
@property (nonatomic,strong) APICashLoginManager *cashLoginManager;
@property (nonatomic,strong) APICashGetVerificationCodeManager *verifyCodeManager;
@end

@implementation WJCashLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    [self hiddenBackBarButtonItem];
    [self removeScreenEdgePanGesture];
    
    [kDefaultCenter addObserver:self selector:@selector(checkInputState:) name:UITextFieldTextDidChangeNotification object:nil];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(0, 0, 19, 19)];
    [cancelButton setImage:[UIImage imageNamed:@"nav_btn_close"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(goOut) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    [self createSubViews];


}

- (void)dealloc{
    
    [kDefaultCenter removeObserver:self];
}

- (void)createSubViews
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(132)+1)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    CGFloat phWide = [UILabel getWidthWithTitle:@"手机号" font:WJFont15];
    UILabel *phoneL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), 0, phWide, ALD(44))];
    phoneL.font = WJFont15;
    phoneL.textColor = WJColorLoginTitle;
    phoneL.text = @"手机号";
    [self.view addSubview:phoneL];
    
    phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(phoneL.right+ALD(15), 0, SCREEN_WIDTH -ALD(45)-phoneL.width, ALD(44))];
    phoneTF.font = WJFont15;
    phoneTF.textColor = WJColorLoginTitle;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;//无小数点
    phoneTF.placeholder = @"请输入您的手机号";
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTF.delegate = self;
    [self.view addSubview:phoneTF];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ALD(15), phoneL.bottom, kScreenWidth-ALD(15), 0.5)];
    line.backgroundColor = WJColorSeparatorLine;
    [self.view addSubview:line];
    
    
    UILabel *verifyL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), line.bottom, phWide, ALD(44))];
    verifyL.font = WJFont15;
    verifyL.textColor = WJColorLoginTitle;
    verifyL.text = @"验证码";
    [self.view addSubview:verifyL];
    
    verifyTF = [[UITextField alloc] initWithFrame:CGRectMake(verifyL.right+ALD(15), line.bottom, SCREEN_WIDTH - ALD(140)-phoneL.width, ALD(44))];
    verifyTF.font = WJFont15;
    verifyTF.keyboardType = UIKeyboardTypeNumberPad;
    verifyTF.placeholder = @"请输入您的验证码";
    verifyTF.textColor = WJColorLoginTitle;
    verifyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    verifyTF.delegate = self;
    [self.view addSubview:verifyTF];
    
    
    getVerifyCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getVerifyCodeBtn.frame = CGRectMake(kScreenWidth - ALD(95), verifyTF.centerY-ALD(15), ALD(80), ALD(30));
    [getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerifyCodeBtn setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
    getVerifyCodeBtn.titleLabel.font = WJFont12;
    getVerifyCodeBtn.layer.cornerRadius = 4;
    getVerifyCodeBtn.layer.borderColor = [WJColorNavigationBar CGColor];
    getVerifyCodeBtn.layer.borderWidth = 0.5;
    [getVerifyCodeBtn addTarget:self action:@selector(getVerifyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getVerifyCodeBtn];
    
    
    UIView *midline = [[UIView alloc] initWithFrame:CGRectMake(ALD(15), verifyL.bottom, kScreenWidth-ALD(15), 0.5)];
    midline.backgroundColor = WJColorSeparatorLine;
    [self.view addSubview:midline];

    
    CGFloat inviteCodeWide = [UILabel getWidthWithTitle:@"邀请码" font:WJFont15];
     UILabel *inviteCodeL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), midline.bottom, inviteCodeWide, ALD(44))];
    inviteCodeL.font = WJFont15;
    inviteCodeL.textColor = WJColorLoginTitle;
    inviteCodeL.text = @"邀请码";
    [self.view addSubview:inviteCodeL];
    
    
    inviteCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(inviteCodeL.right + ALD(15), midline.bottom, SCREEN_WIDTH -ALD(45)-inviteCodeL.width, ALD(44))];
    inviteCodeTF.font = WJFont15;
    inviteCodeTF.keyboardType = UIKeyboardTypeDefault;
    inviteCodeTF.placeholder = @"请输入邀请码（选填）";
    inviteCodeTF.textColor = WJColorLoginTitle;
    inviteCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    inviteCodeTF.delegate = self;
    [self.view addSubview:inviteCodeTF];
    
    
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, inviteCodeTF.bottom, kScreenWidth, 0.5)];
    bottomLine.backgroundColor = WJColorSeparatorLine;
    [self.view addSubview:bottomLine];
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setFrame:CGRectMake(ALD(15), ALD(30) + bottomLine.bottom, kScreenWidth - ALD(30), ALD(44))];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:WJColorWhite forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:WJFont15];
    [loginBtn setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorViewNotEditable] forState:UIControlStateDisabled];
    [loginBtn setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorNavigationBar] forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 4;
    [loginBtn addTarget:self action:@selector(cashLoginAction) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.enabled = NO;
    loginBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:loginBtn];
    
    
    [phoneTF becomeFirstResponder];
    timeCount = 60;
    
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    NSLog(@"登录成功");
    
    if([manager isKindOfClass:[APICashLoginManager class]])
    {
        NSDictionary *personDic = [manager fetchDataWithReformer:nil];
        if (personDic) {
            [[NSUserDefaults standardUserDefaults] setObject:personDic forKey:KCashUser];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        if (self.cashLoginFrom == LoginFromCashAccount) {
            
            [kDefaultCenter postNotificationName:@"LoginFromCashTransferAccount" object:nil];
        }
    }
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    NSLog(@"登录失败");
    ALERT(manager.errorMessage);
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == phoneTF) {
        if ([string length] > 0) {
            if (textField.text.length >= 11) {
                return NO;
            }
        }
    }
    
    if (textField == verifyTF) {
        if ([string length] > 0) {
            if (textField.text.length >= 4) {
                return NO;
            }
        }
    }
    
    if (textField == inviteCodeTF) {
        if ([string length] > 0) {
            if (textField.text.length >= 6) {
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - UITextFieldTextDidChangeNotification

- (void)checkInputState:(NSNotification *)notification
{
    if (phoneTF.text.length >0 && verifyTF.text.length >0) {
        loginBtn.enabled = YES;
    }else{
        loginBtn.enabled = NO;
    }
}

- (void)cashLoginAction
{
    [self allTFResignFirstResponder];
    
    if (![WJUtilityMethod isValidatePhone:phoneTF.text] ) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入正确的手机号"];
        return;
    }
    if (verifyTF.text.length != 4) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"验证码输入有误"];
        return;
    }
    
    [self cashLoginRequest];
}

- (void)allTFResignFirstResponder
{
    [phoneTF resignFirstResponder];
    [verifyTF resignFirstResponder];
    [inviteCodeTF resignFirstResponder];
}


- (void)getVerifyAction {
    
    //验证手机号
    if([WJUtilityMethod isValidatePhone:phoneTF.text]) {
        [self verficationRequest];
        [self startTimer];
        verifyTF.text = @"";
        [verifyTF becomeFirstResponder];
        
    }else {
        if(phoneTF.text.length <= 0){
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入手机号"];
        }else{
            
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入正确的手机号"];
        }
    }
}


- (void)startTimer{
    [getVerifyCodeBtn setTitle:@"60秒" forState:UIControlStateNormal];
    getVerifyCodeBtn.enabled = NO;
    
    [verifyTimer invalidate];
    verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeBtnTitle) userInfo:nil repeats:YES];
    [verifyTimer fire];
}


- (void)changeBtnTitle{
    
    if (timeCount <= 0) {
        timeCount = 60;
        [self deleteTimerWhenBack];
        [getVerifyCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        getVerifyCodeBtn.enabled = YES;
    }else{
        
        [getVerifyCodeBtn setTitle:[NSString stringWithFormat:@"%@秒", @(timeCount--)] forState:UIControlStateNormal];
        
    }
}

#pragma mark - Request

- (void)cashLoginRequest
{
    [self showLoadingView];
    [self.cashLoginManager loadData];
}


- (void)verficationRequest
{
    [self.verifyCodeManager loadData];
}


- (void)deleteTimerWhenBack{
    [verifyTimer invalidate];
    verifyTimer = nil;
}

- (void)goOut
{
    [self allTFResignFirstResponder];
    [self deleteTimerWhenBack];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- Getter and Setter

- (APICashLoginManager *)cashLoginManager
{
    if (nil == _cashLoginManager) {
        _cashLoginManager = [[APICashLoginManager alloc] init];
        _cashLoginManager.delegate = self;
    }
    _cashLoginManager.loginname = phoneTF.text;
    _cashLoginManager.password = verifyTF.text;
    _cashLoginManager.inviteCode = inviteCodeTF.text;
    return _cashLoginManager;
}

- (APICashGetVerificationCodeManager *)verifyCodeManager
{
    if (!_verifyCodeManager) {
        _verifyCodeManager = [[APICashGetVerificationCodeManager alloc] init];
        _verifyCodeManager.delegate = self;
    }
    _verifyCodeManager.phoneNum = phoneTF.text;
    return _verifyCodeManager;
}

@end
