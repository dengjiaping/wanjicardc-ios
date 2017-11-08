//
//  WJVerifyNewPhoneController.m
//  WanJiCard
//
//  Created by Angie on 15/12/14.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJVerifyNewPhoneController.h"
#import "APIUpdateMobileManager.h"
#import "APIVerificationCodeManager.h"
#import "WJPersonModel.h"
#import "WJUserLocalLoginReformer.h"
#import "WJCrashManager.h"

@interface WJVerifyNewPhoneController ()<UITextFieldDelegate, APIManagerCallBackDelegate>{
    UITextField *phoneTF;
    UITextField *verifyTF;
    UIButton    *getVerifyCodeBtn;

    NSTimer *verifyTimer;
    NSString *orginPhone;
    NSString *enterPassword;
    
    NSInteger timeCount;
}

@property (nonatomic, strong) APIUpdateMobileManager *updateMobileManager;
@property (nonatomic, strong) APIVerificationCodeManager *verifyCodeManager;

@end

@implementation WJVerifyNewPhoneController
- (instancetype)initWithPhone:(NSString *)phone enterPassword:(NSString *)enterPsw{
    if (self = [super init]) {
        
        orginPhone = phone;
        enterPassword = enterPsw;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"验证新手机";

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(89))];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    

    UILabel *phoneL = [[UILabel alloc] init];
    phoneL.font = WJFont15;
    phoneL.text = @"新手机号";
    [phoneL sizeToFit];
    [phoneL setFrame:CGRectMake(ALD(15), 0, phoneL.width, ALD(44))];
    phoneL.textColor = WJColorDarkGray;
    [bgView addSubview:phoneL];
    
    phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(phoneL.right + ALD(10), 0, SCREEN_WIDTH - ALD(40)-phoneL.width, ALD(44))];
    phoneTF.font = WJFont14;
    phoneTF.textColor = WJColorDarkGray;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;//无小数点
    phoneTF.placeholder = @"请输入您的手机号";
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTF.delegate = self;
    [bgView addSubview:phoneTF];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), phoneL.bottom, kScreenWidth - ALD(24), 0.5)];
    line.backgroundColor = WJColorSeparatorLine;
    [bgView addSubview:line];
    
    UILabel *verifyL = [[UILabel alloc] init];
    verifyL.font = WJFont15;
    verifyL.textColor = WJColorDarkGray;
    verifyL.text = @"验证码";
    [verifyL sizeToFit];
    [verifyL setFrame:CGRectMake(ALD(15), line.bottom, verifyL.width, ALD(44))];
    [bgView addSubview:verifyL];
    
    verifyTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(phoneTF.frame), CGRectGetMinY(verifyL.frame), CGRectGetWidth(phoneTF.frame) -ALD(90), ALD(44))];
    verifyTF.font = [UIFont systemFontOfSize:14];
    verifyTF.textColor = WJColorDarkGray;
    verifyTF.keyboardType = UIKeyboardTypeNumberPad;
    verifyTF.placeholder = @"请输入您的验证码";
    verifyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    verifyTF.delegate = self;
    [bgView addSubview:verifyTF];
    
    getVerifyCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getVerifyCodeBtn.frame = CGRectMake(kScreenWidth - ALD(95), verifyTF.centerY-ALD(15), ALD(80), ALD(30));
    [getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerifyCodeBtn setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
    getVerifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    getVerifyCodeBtn.layer.cornerRadius = 4;
    getVerifyCodeBtn.layer.borderColor = [WJColorNavigationBar CGColor];
    getVerifyCodeBtn.layer.borderWidth = 0.5;
    [getVerifyCodeBtn addTarget:self action:@selector(getVerifyAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:getVerifyCodeBtn];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(89)-0.5, kScreenWidth, 0.5)];
    bottomLine.backgroundColor = WJColorSeparatorLine;
    [bgView addSubview:bottomLine];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:WJColorNavigationBar];
    nextBtn.layer.cornerRadius = 4;
    [nextBtn addTarget:self action:@selector(changePhoneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    [self.view addConstraint:[nextBtn constraintCenterXEqualToView:self.view]];
    [self.view addConstraints:[nextBtn constraintsSize:CGSizeMake(kScreenWidth-ALD(30), ALD(40))]];
    [self.view addConstraints:[nextBtn constraintsTop:ALD(30) FromView:bgView]];
    
    [phoneTF becomeFirstResponder];
    timeCount = 60;
}

#pragma mark - UIButton Action

- (void)backBarButton:(UIButton *)btn{
    [verifyTimer invalidate];
    verifyTimer = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTokenForChangePhone];
    [super backBarButton:btn];
}


- (void)changePhoneAction{
    [self changePhoneRequest];
}


- (void)getVerifyAction {
    
    //验证手机号
    if(![phoneTF.text isMobilePhoneNumber])
    {
        ALERT(@"请输入正确手机号");
        return;
    }
    
    NSString *oriPhone = [[WJGlobalVariable sharedInstance].defaultPerson phone];
    if (oriPhone) {
        if ([oriPhone isEqualToString:phoneTF.text]) {
            ALERT(@"您当前正在使用此号码无需再次更改");
            return;
        }
    }
    
    verifyTF.text = @"";
    [verifyTF becomeFirstResponder];
    
    [self.verifyCodeManager loadData];
    [self startTimer];
}


#pragma mark - request
- (void)changePhoneRequest
{
    if (![WJUtilityMethod isValidatePhone:phoneTF.text]) {
        ALERT(@"请输入正确手机号");
        return;
    }
    if (![WJUtilityMethod isValidateVerifyCode:verifyTF.text]) {
        ALERT(@"请输入正确格式的验证码");
        return;
    }
    
    NSString *oriPhone = [[WJGlobalVariable sharedInstance].defaultPerson phone];
    if (oriPhone) {
        if ([oriPhone isEqualToString:phoneTF.text]) {
            ALERT(@"您当前正在使用此号码无需再次更改");
            return;
        }
    }
    [self showLoadingView];
    [self.updateMobileManager loadData];
}

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager{
    if ([manager isKindOfClass:[APIUpdateMobileManager class]]) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTokenForChangePhone];

        [self hiddenLoadingView];
        [verifyTimer invalidate];
        verifyTimer = nil;
        
        WJPersonModel *person = [manager fetchDataWithReformer:[[WJUserLocalLoginReformer alloc] init]];
        person.isActively = YES;
        [WJGlobalVariable sharedInstance].defaultPerson = nil;

        BOOL su = [[WJDBPersonManager new] insertPerson:person];
        if (su) {
            
            WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
            if (nil == person.payPassword || person.payPassword.length == 0) {
                NSString *text = [[enterPassword stringByAppendingString:person.payPsdSalt] getSha1String];
                person.payPassword = text;
                [[WJDBPersonManager new] updatePerson:person];
            }
            
            [[WJCrashManager sharedCrashManager] changeUserId]; //bugly用户身份切换后调用此接口进行修改
        }

        [kDefaultCenter postNotificationName:kChangePhoneSuccess object:nil userInfo:nil];
        
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager{
    [self hiddenLoadingView];
    if(manager.errorMessage){
        if ([ToString(manager.errorMessage) length]>0) {
             ALERT(manager.errorMessage);
        }
    }
}


#pragma mark - 倒计时功能

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
        [verifyTimer invalidate];
        verifyTimer = nil;
        [getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        getVerifyCodeBtn.enabled = YES;
        return;
    }else{
    
        if (deviceIs6P) {
            [getVerifyCodeBtn setTitle:[NSString stringWithFormat:@"%@秒", @(timeCount--)] forState:UIControlStateNormal];

        } else {
            getVerifyCodeBtn.titleLabel.text = [NSString stringWithFormat:@"%@秒", @(timeCount--)];
        }
    }
  
}


#pragma mark - 属性访问

- (APIUpdateMobileManager *)updateMobileManager{
    if (!_updateMobileManager) {
        _updateMobileManager = [APIUpdateMobileManager new];
        _updateMobileManager.delegate = self;
    }
    _updateMobileManager.phone = phoneTF.text;
    _updateMobileManager.code = verifyTF.text;
    return _updateMobileManager;
}


- (APIVerificationCodeManager *)verifyCodeManager{
    if (!_verifyCodeManager) {
        _verifyCodeManager = [APIVerificationCodeManager new];
        _verifyCodeManager.delegate = self;
    }
    
    _verifyCodeManager.phoneNum = phoneTF.text;
    
    return _verifyCodeManager;
}
@end
