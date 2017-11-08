//
//  WJVerificationCodeViewController.m
//  WanJiCard
//
//  Created by reborn on 16/6/24.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJVerificationCodeViewController.h"
#import "APIRealNameVerificationCodeManager.h"
#import "APISetCardNumberManager.h"
#import "WJCompleteRealNameViewController.h"
#import "WJSystemAlertView.h"

@interface WJVerificationCodeViewController()<UITextFieldDelegate, WJSystemAlertViewDelegate>
{
    NSInteger   timeCount;
    UITextField *verifyTF;
    NSTimer     *verifyTimer;
    UIButton    *verifyCodeBtn;
    UIButton    *commitButton;
    UILabel     *desLabel;
}
@property(nonatomic, strong)APIRealNameVerificationCodeManager *realNameVerificationCodeManager;
@property(nonatomic, strong)APISetCardNumberManager            *realNameAuthenticationManager;

@end

@implementation WJVerificationCodeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    
    [kDefaultCenter addObserver:self selector:@selector(checkInputState:) name:UITextFieldTextDidChangeNotification object:nil];

    
    [self initContentView];
}

- (void)dealloc{
    
    [kDefaultCenter removeObserver:self];
}

- (void)initContentView
{
    desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(65))];
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.textColor = WJColorDardGray6;
    desLabel.font = WJFont15;
    desLabel.numberOfLines = 0;
    [self.view addSubview:desLabel];
    
    NSRange trange = NSMakeRange(3, 4);
    NSString *tPhoneStr = [self.registerPhone stringByReplacingCharactersInRange:trange withString:@"＊＊＊＊"];
    NSString *strContent = [NSString stringWithFormat:@"已向您%@的手机发送验证码",tPhoneStr];
    desLabel.attributedText = [self attributedText:strContent];
    [self.view addSubview:desLabel];
    
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, desLabel.bottom, kScreenWidth, ALD(45))];
    middleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:middleView];
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, ALD(70), ALD(45))];
    nameL.textColor = WJColorDardGray6;
    nameL.text = @"验证码";
    [middleView addSubview:nameL];
    
    verifyTF = [[UITextField alloc] initWithFrame:CGRectMake(nameL.right + ALD(15), 0, kScreenWidth - ALD(110), ALD(45))];
    verifyTF.delegate = self;
    verifyTF.textColor = WJColorDardGray6;
    [middleView addSubview:verifyTF];

    
    verifyCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verifyCodeBtn.frame = CGRectMake(kScreenWidth - ALD(100), verifyTF.centerY-ALD(15), ALD(90), ALD(30));
    [verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    verifyCodeBtn.enabled = NO;
    [self changeBtnColor];
    [verifyCodeBtn setTitleColor:WJColorViewNotEditable forState:UIControlStateDisabled];
    [verifyCodeBtn setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
    verifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    verifyCodeBtn.layer.cornerRadius = 4;
    verifyCodeBtn.layer.borderWidth = 0.5;
    [verifyCodeBtn addTarget:self action:@selector(getVerifyAction) forControlEvents:UIControlEventTouchUpInside];
    [middleView addSubview:verifyCodeBtn];
    
    timeCount = 120;
    
    commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(ALD(15), middleView.bottom + ALD(30), kScreenWidth - ALD(30), ALD(45));
    [commitButton setTitle:@"立即实名" forState:UIControlStateNormal];
    [commitButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorViewNotEditable] forState:UIControlStateDisabled];
    [commitButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorNavigationBar] forState:UIControlStateNormal];
    commitButton.enabled = NO;
    commitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    commitButton.layer.cornerRadius = 5;
    commitButton.layer.masksToBounds = YES;
    [commitButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitButton];
    
    [self startTimer];

}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APISetCardNumberManager class]]) {
        
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
            
            defaultPerson.authentication = AuthenticationCompleted;
            defaultPerson.IDCard = [dic objectForKey:@"idCode"];
            
            [[WJDBPersonManager new] updatePerson:defaultPerson];
            
            [[TKAlertCenter defaultCenter]  postAlertWithMessage:@"认证成功！"];
            
            [kDefaultCenter postNotificationName:@"RealNameAuthenticationSuccess" object:nil];
            
            WJViewController *vc = [[WJGlobalVariable sharedInstance] realAuthenfromController];
            
            if (self.comefrom == ComeFromIndividualCenter) {
                
                [self.navigationController popToViewController:vc animated:YES];
                
                
            } else if (self.comefrom == ComeFromIndividualInformation) {
                
                [self.navigationController popToViewController:vc animated:YES];
                
            } else if (self.comefrom == ComeFromCardPackageView) {
                
                [self.navigationController popToViewController:vc animated:YES];
                
            } else if(self.comefrom == ComeFromECardRechargeConfirm){
            
                [self.navigationController popToViewController:vc animated:YES];
            
            } else if (self.comefrom == ComeFromActivitiesShare) {
                
                [self.navigationController popToViewController:vc animated:YES];

            }else{
                
                //商家卡详情、用户卡详情、电子卡详情、个人中心卡包充值分情况跳转
                [self.navigationController popToViewController:vc animated:YES];
                
                if (self.isjumpOrderConfirmController) {
                    
                    if (self.authenticationSuc) {
                        self.authenticationSuc();
                    }
                }
            }
            
        }
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"fail:%@",manager);
    [[TKAlertCenter defaultCenter]  postAlertWithMessage:@"认证失败！"];
}

#pragma mark - WJSystemAlertViewdelegate
- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1==buttonIndex) {
        
    }else{
        
        [self deleteTimerWhenBack];
        WJViewController *vc = [[WJGlobalVariable sharedInstance] realAuthenfromController];
        [self.navigationController popToViewController:vc animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == verifyTF) {
        if ([string length] > 0) {
            if (textField.text.length >= 7) {
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - UITextFieldTextDidChangeNotification

- (void)checkInputState:(NSNotification *)notification
{
    if (verifyTF.text.length >0) {
        commitButton.enabled = YES;
    }else{
        commitButton.enabled = NO;
    }
}

#pragma mark - action
- (void)getVerifyAction {
    NSLog(@"获取验证码接口调用");
    //验证手机号
    if([self.registerPhone isMobilePhoneNumber]) {
        
        [self verficationRequest];
        
        [self startTimer];
        verifyTF.text = @"";
        [verifyTF becomeFirstResponder];
        
    } else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入正确手机号"];
    }
    
}

- (NSAttributedString *)attributedText:(NSString *)text{
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]
                                         initWithString:text];
    NSDictionary *attributesForFirstWord = @{
                                             NSFontAttributeName : WJFont15,
                                             NSForegroundColorAttributeName : WJColorDardGray6,
                                             };

    [result setAttributes:attributesForFirstWord
                    range:NSMakeRange(0, 11)];
    return [[NSAttributedString alloc] initWithAttributedString:result];
}


#pragma mark - Request
- (void)requestLoad{
    
    [self.realNameAuthenticationManager loadData];
}

- (void)verficationRequest
{
    [self.realNameVerificationCodeManager loadData];
}

- (void)commitAction
{
    if (verifyTF.text.length == 0) {
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入验证码"];

    } else {
        
        [self requestLoad];
    }
}

- (void)backBarButton:(UIButton *)btn
{
    WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
                                                                message:@"您确定要放弃实名认证"
                                                               delegate:self
                                                      cancelButtonTitle:@"中途放弃"
                                                      otherButtonTitles:@"继续"
                                                          textAlignment:NSTextAlignmentCenter];
    [alert showIn];
    [verifyTF resignFirstResponder];

}

- (void)startTimer{
    [verifyCodeBtn setTitle:@"120秒" forState:UIControlStateNormal];
    verifyCodeBtn.enabled = NO;
    [self changeBtnColor];

    [verifyTimer invalidate];
    verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeBtnTitle) userInfo:nil repeats:YES];
    [verifyTimer fire];
    
}

- (void)changeBtnTitle{
    
    if (timeCount <= 0) {
        timeCount = 120;
        [self deleteTimerWhenBack];
        [verifyCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        verifyCodeBtn.enabled = YES;
        [self changeBtnColor];
        
    } else {
        
        [verifyCodeBtn setTitle:[NSString stringWithFormat:@"%@秒", @(timeCount--)] forState:UIControlStateNormal];
    }
}

- (void)changeBtnColor
{
    if (verifyCodeBtn.enabled) {
        verifyCodeBtn.layer.borderColor = WJColorNavigationBar.CGColor;
        
    } else {
        verifyCodeBtn.layer.borderColor = WJColorLightGray.CGColor;
        
    }
    
}

- (void)deleteTimerWhenBack{
    [verifyTimer invalidate];
    verifyTimer = nil;
}

#pragma mark - 属性方法
-(APIRealNameVerificationCodeManager *)realNameVerificationCodeManager
{
    if (nil == _realNameVerificationCodeManager) {
        _realNameVerificationCodeManager = [[APIRealNameVerificationCodeManager alloc] init];
        _realNameVerificationCodeManager.delegate = self;
        _realNameVerificationCodeManager.realName = self.realName;
        _realNameVerificationCodeManager.cardNum = self.cardNumber;
        _realNameVerificationCodeManager.bankCardNum = self.BankCard;
        _realNameVerificationCodeManager.phoneNum = self.registerPhone;
    }
    return _realNameVerificationCodeManager;
}

-(APISetCardNumberManager *)realNameAuthenticationManager
{
    if (nil== _realNameAuthenticationManager) {
        _realNameAuthenticationManager = [[APISetCardNumberManager alloc]init];
        _realNameAuthenticationManager.delegate = self;
    }
    
    _realNameAuthenticationManager.messageCode = verifyTF.text;
    
    return _realNameAuthenticationManager;
}
@end
