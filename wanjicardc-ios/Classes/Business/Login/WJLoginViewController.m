//
//  WJLoginViewController.m
//  WanJiCard
//
//  Created by Lynn on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJLoginViewController.h"
#import "APIUserLocalLoginManager.h"
#import "APIVerificationCodeManager.h"
#import "APISynProductManager.h"
#import "WJUserLocalLoginReformer.h"
#import "WJPersonModel.h"
#import "WJOriginalViewController.h"
#import "WJPasswordSettingController.h"
#import "WJVerifyPasswordController.h"
#import "WJAppealViewController.h"
#import "WJFindSafetyQuestionController.h"
#import "WJFindRealNameAuthenticationViewController.h"
#import "WJSystemAlertView.h"
#import "WJTabBarViewController.h"

@interface WJLoginViewController ()<APIManagerCallBackDelegate,UITextFieldDelegate,UIActionSheetDelegate,WJSystemAlertViewDelegate>
{
    UITextField *phoneTF;
    UITextField *verifyTF;
    UIButton *getVerifyCodeBtn;
    NSTimer *verifyTimer;
    NSInteger timeCount;
    WJPersonModel *activePerson;
    UIButton *loginBtn;
    
    NSDictionary *tmpDic;   //用户被锁临时person信息
}
@property (nonatomic, strong)APIUserLocalLoginManager   *loginManager;
@property (nonatomic, strong)APIVerificationCodeManager * verificationManager;

@end

@implementation WJLoginViewController

#pragma mark- Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventID = @"iOS_act_login";
    self.title = @"登录";
    [self hiddenBackBarButtonItem];
    [self removeScreenEdgePanGesture];
    
    //每次登录默认无密
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setBool:YES forKey:KPasswordSwitch];
    
    [kDefaultCenter addObserver:self selector:@selector(updatePersonState) name:kChangePhoneSuccess object:nil];
    [kDefaultCenter addObserver:self selector:@selector(checkInputState:) name:UITextFieldTextDidChangeNotification object:nil];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(0, 0, 19, 19)];
    [cancelButton setImage:[UIImage imageNamed:@"nav_btn_close"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(goOut) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    [self createSubViews];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTokenForChangePhone];
}


- (void)createSubViews
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(88)+1)];
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
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, verifyTF.bottom, kScreenWidth, 0.5)];
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
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.enabled = NO;
    loginBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:loginBtn];
    
    
    //更换手机号
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setFrame:CGRectMake(kScreenWidth - ALD(90)- ALD(15), ALD(15) + loginBtn.bottom, ALD(90), ALD(20))];
    [changeBtn setBackgroundColor:[UIColor clearColor]];
    [changeBtn setTitle:@"更换手机号" forState:UIControlStateNormal];
    [changeBtn setTitleColor:WJColorTitleGray forState:UIControlStateNormal];
    [changeBtn.titleLabel setFont:WJFont12];
    [changeBtn addTarget:self action:@selector(changePhone) forControlEvents:UIControlEventTouchUpInside];
    [changeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.view addSubview:changeBtn];
    
    [phoneTF becomeFirstResponder];
    timeCount = 60;
    
}


- (void)dealloc{
    
    [kDefaultCenter removeObserver:self];
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
            if (textField.text.length >= 6) {
                return NO;
            }
        }
    }
    
    return YES;
}


#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    
    [self hiddenLoadingView];
    
    if([manager isKindOfClass:[APIUserLocalLoginManager class]])
    {
        
        NSDictionary *personDic = [manager fetchDataWithReformer:nil];
        if (personDic) {
            activePerson = [[WJPersonModel alloc] initWithData:personDic];
            
            NSString *identity = [personDic objectForKey:@"identity"];
            if (identity) {
                [[NSUserDefaults standardUserDefaults] setObject:identity forKey:@"PersonIdentity"];
            }
            
            [self goVerifyPayPasswordWithPerson:activePerson];
        }
    }
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    
    if([manager isKindOfClass:[APIVerificationCodeManager class]]){
        //如果用户被锁
        if (manager.errorCode == 50008053) {
            
            tmpDic = [manager fetchDataWithReformer:nil];
            [self showAlertWithMessage:manager.errorMessage];
            
            return;
        }
    }
    
    if (manager.errorMessage && manager.errorMessage.length>0) {
        
        [[TKAlertCenter defaultCenter]  postAlertWithMessage:manager.errorMessage];
    }
}



#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([ToNSNumber(tmpDic[@"isAuthentication"]) integerValue] == 2) {
        if (buttonIndex == 0) {
            [WJGlobalVariable sharedInstance].findPwdFromController = self;
            //实名验证找回
            WJFindRealNameAuthenticationViewController *authenticVC = [[WJFindRealNameAuthenticationViewController alloc] init];
            //            if(activePerson.realName){
            //                if ([activePerson.realName length]>0) {
            //                    authenticVC.realName = activePerson.realName;
            //                }
            //            }
            [self.navigationController pushViewController:authenticVC animated:YES];
            
        }else{
            
            if ([ToNSNumber(tmpDic[@"isSetsecurity"]) boolValue] && buttonIndex == 1) {
                [WJGlobalVariable sharedInstance].findPwdFromController = self;
                //安全问题
                WJFindSafetyQuestionController *findSafeVC = [[WJFindSafetyQuestionController alloc] init];
                //                findSafeVC.phoneNumber = activePerson.phone;
                [self.navigationController pushViewController:findSafeVC animated:YES];
                return;
                
            }else if(([ToNSNumber(tmpDic[@"isSetsecurity"]) boolValue] && buttonIndex == 2) || (![ToNSNumber(tmpDic[@"isSetsecurity"]) boolValue] && buttonIndex == 1)){
                //账户申诉找回
                if ((AppealStatus)[ToNSNumber(tmpDic[@"appealStatus"]) integerValue] == AppealProcessing){
                    
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"申诉处理中"];
                } else {
                    
                    [WJGlobalVariable sharedInstance].findPwdFromController = self;
                    WJAppealViewController *findPswVC = [[WJAppealViewController alloc] init];
                    //                    findPswVC.userPhone = activePerson.phone;
                    [self.navigationController pushViewController:findPswVC animated:YES];
                }
                
                return;
                
            }else{
                
            }
        }
        
    }else{
        
        if (activePerson.isSetPsdQuestion && buttonIndex == 0) {
            
            [WJGlobalVariable sharedInstance].findPwdFromController = self;
            //安全问题找回
            WJFindSafetyQuestionController *findSafeVC = [[WJFindSafetyQuestionController alloc] init];
            findSafeVC.phoneNumber = activePerson.phone;
            [self.navigationController pushViewController:findSafeVC animated:YES];
            return;
            
        }else if ((activePerson.isSetPsdQuestion && buttonIndex == 1) || (!activePerson.isSetPsdQuestion && buttonIndex == 0)) {
            
            //账户申诉找回
            if (activePerson.appealStatus == AppealProcessing){
                
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"申诉处理中"];
            }else{
                
                [WJGlobalVariable sharedInstance].findPwdFromController = self;
                WJAppealViewController *findPswVC = [[WJAppealViewController alloc] init];
                findPswVC.userPhone = activePerson.phone;
                [self.navigationController pushViewController:findPswVC animated:YES];
            }
            return;
            
        }else{
            
        }
    }
    
}


#pragma mark - WJSystemAlertViewDelegate

- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [self findPassword];
    }
}

#pragma mark - UITextFieldTextDidChangeNotification

- (void)checkInputState:(NSNotification *)notification
{
    //    UITextField *text = [notification object];
    if (phoneTF.text.length >0 && verifyTF.text.length >0) {
        loginBtn.enabled = YES;
    }else{
        loginBtn.enabled = NO;
    }
}


#pragma mark - UIButton Action

- (void)changePhone
{
    NSLog(@"%s",__func__);
    WJOriginalViewController * originalVC = [[WJOriginalViewController alloc] init];
    [self.navigationController pushViewController:originalVC animated:YES];
}


- (void)loginAction
{
    [self allTFResignFirstResponder];
    
    if (![WJUtilityMethod isValidatePhone:phoneTF.text] ) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入正确的手机号"];
        return;
    }
    if (verifyTF.text.length != 6) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"验证码输入有误"];
        return;
    }
    
    [self loginRequest];
}


- (void)allTFResignFirstResponder
{
    [phoneTF resignFirstResponder];
    [verifyTF resignFirstResponder];
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
        
        if (deviceIs6P) {
            
            [getVerifyCodeBtn setTitle:[NSString stringWithFormat:@"%@秒", @(timeCount--)] forState:UIControlStateNormal];
        } else {
            
            getVerifyCodeBtn.titleLabel.text = [NSString stringWithFormat:@"%@秒", @(timeCount--)];
        }
    }
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


- (void)updatePersonState{
    
    //登录成功删除临时校验值
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PersonIdentity"];
    
    //登录成功，tab里面的值恢复
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOKickedOut" object:nil];
    
    switch (self.from) {
        case LoginFromPersonal:
             //个人中心页登录（除消息）
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowCertificationAlert" object:nil];
            break;
           
        case LoginFromPersonalMessage:
             //个人中心页消息进入登录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginForPersonalMessage" object:nil];
            break;
            
        case LoginFromCardPack:
            //卡包
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginForPayCode" object:nil];
            break;
            
        case LoginFromBuyCard:
            //购买商家卡
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginForBuyCard" object:nil];
            break;
            
        case LoginFromHomeMessage:
            //首页消息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginForHomeMessage" object:nil];
            break;
            
        case LoginFromBuyElectronicCard:
            //购买电子卡
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginForBuyECard" object:nil];
            break;
        case LoginFromWebView:
            //web活动
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginFromWebView" object:nil];
            break;
            
        default:
            break;
    }
    
    [self goOut];
    
}


- (void)goVerifyPayPasswordWithPerson:(WJPersonModel *)person
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePersonState) name:@"LoginProvingPass" object:nil];
    
    if(person.isSetPayPassword){
        WJVerifyPasswordController *verifyVC = [[WJVerifyPasswordController alloc] init];
        verifyVC.from = ComeFromLogin;
        verifyVC.currentPerson = person;
        [WJGlobalVariable sharedInstance].fromController = self;
        [self.navigationController pushViewController:verifyVC animated:YES];
        
    }else{
        
        WJPasswordSettingController *pswSettingVC = [[WJPasswordSettingController alloc] init];
        pswSettingVC.from = ComeFromLogin;
        pswSettingVC.currentPerson = person;
        [self.navigationController pushViewController:pswSettingVC animated:YES];
    }
}


- (void)showAlertWithMessage:(NSString *)msg
{
    WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:@"账号已被锁定" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"找回支付密码" textAlignment:NSTextAlignmentCenter];
    
    [alert showIn];
}


//忘记密码
- (void)findPassword
{
    if (IOS8_LATER) {
        
        __weak typeof(self) weakSelf = self;
        __weak NSDictionary *perDic = tmpDic;
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"找回密码" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:cancelAction];
        
        UIAlertAction *appealAction = [UIAlertAction actionWithTitle:@"申诉找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            __strong typeof(self) strongSelf = weakSelf;
            
            //申诉找回
            if ((AppealStatus)[ToNSNumber(perDic[@"appealStatus"]) integerValue] == AppealProcessing){
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"申诉处理中"];
                
            }else{
                
                [WJGlobalVariable sharedInstance].findPwdFromController = strongSelf;
                WJAppealViewController *findPswVC = [[WJAppealViewController alloc] init];
                //                findPswVC.userPhone = per.phone;
                [strongSelf.navigationController pushViewController:findPswVC animated:YES];
            }
        }];
        
        [alertControl addAction:appealAction];
        
        if ([ToNSNumber(tmpDic[@"isSetsecurity"]) boolValue]) {
            
            UIAlertAction *quesAction = [UIAlertAction actionWithTitle:@"安全问题找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                __strong typeof(self) strongSelf = weakSelf;
                [WJGlobalVariable sharedInstance].findPwdFromController = strongSelf;
                //安全问题找回
                WJFindSafetyQuestionController *findSafeVC = [[WJFindSafetyQuestionController alloc] init];
                //                findSafeVC.phoneNumber = per.phone;
                [strongSelf.navigationController pushViewController:findSafeVC animated:YES];
            }];
            
            [alertControl addAction:quesAction];
        }
        
        if ([ToNSNumber(tmpDic[@"isAuthentication"]) integerValue] == 2) {
            
            UIAlertAction *authAction = [UIAlertAction actionWithTitle:@"实名验证找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(self) strongSelf = weakSelf;
                [WJGlobalVariable sharedInstance].findPwdFromController = strongSelf;
                //实名验证找回
                WJFindRealNameAuthenticationViewController *authenticVC = [[WJFindRealNameAuthenticationViewController alloc] init];
                //                if(per.realName){
                //                    if ([per.realName length]>0) {
                //                        authenticVC.realName = per.realName;
                //                    }
                //                }
                [strongSelf.navigationController pushViewController:authenticVC animated:YES];
                
            }];
            [alertControl addAction:authAction];
        }
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }else{
        
        UIActionSheet *actionSheet = nil;
        if (activePerson.isSetPsdQuestion && activePerson.authentication == 2) {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"实名验证找回",@"安全问题找回",@"申诉找回", nil];
            
        }else {
            
            if (activePerson.isSetPsdQuestion) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"安全问题找回",@"申诉找回", nil];
                
            }else if (activePerson.authentication == 2){
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"实名验证找回",@"申诉找回", nil];
                
            }else{
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"找回密码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"申诉找回", nil];
            }
        }
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }
}


#pragma mark - Request

- (void)loginRequest
{
    [self showLoadingView];
    [self.loginManager loadData];
}


- (void)verficationRequest
{
    [self.verificationManager loadData];
}


#pragma mark- Getter and Setter

- (APIUserLocalLoginManager *)loginManager
{
    if (nil == _loginManager) {
        _loginManager = [[APIUserLocalLoginManager alloc] init];
        _loginManager.delegate = self;
    }
    
    _loginManager.loginname = phoneTF.text;
    _loginManager.password = verifyTF.text;
    
    return _loginManager;
}


- (APIVerificationCodeManager *)verificationManager
{
    if (nil == _verificationManager) {
        _verificationManager = [[APIVerificationCodeManager alloc] init];
        _verificationManager.delegate = self;
    }
    
    _verificationManager.phoneNum = phoneTF.text;
    
    return _verificationManager;
}



@end
