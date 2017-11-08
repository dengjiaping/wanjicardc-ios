//
//  WJPasswordSettingController.m
//  WanJiCard
//
//  Created by 孙明月 on 16/6/1.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJPasswordSettingController.h"
#import "APIInitPasswordManager.h"
#import "WJPaySettingController.h"
#import "WJLoginViewController.h"
#import "WJCardPackageViewController.h"
#import "WJPersonModel.h"
#import "WJCrashManager.h"
#import "WJBaoziPayCompleteController.h"
#import "WJEleCardDeteilViewController.h"
#import "WJOrderDetailController.h"
#import "WJMyOrderController.h"

@interface WJPasswordSettingController ()<UITextFieldDelegate>
{
    UITextField *passwordTF;
    UITextField *confirmTF;
    UIButton *nextBtn;
}

@property (nonatomic, strong) APIInitPasswordManager *initialPayPsdManager;

@end

@implementation WJPasswordSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"设置支付密码";
    [self removeScreenEdgePanGesture];
    [kDefaultCenter addObserver:self selector:@selector(checkInputState:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self createSubViews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    
    [kDefaultCenter removeObserver:self];
}


#pragma mark - privateMethod
- (void)createSubViews
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(88)+1)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    CGFloat setwidth = [UILabel getWidthWithTitle:@"设置六位支付密码" font:WJFont15];
    UILabel *setLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), 0, setwidth, ALD(44))];
    setLabel.text = @"设置六位支付密码";
    setLabel.font = WJFont15;
    setLabel.textColor = WJColorLoginTitle;
    [self.view addSubview:setLabel];
    
    passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(setLabel.right + ALD(15), 0, SCREEN_WIDTH - ALD(45)- setLabel.width, ALD(44))];
    passwordTF.font = WJFont15;
    passwordTF.textColor = WJColorLightGray;
    passwordTF.keyboardType = UIKeyboardTypeNumberPad;//无小数点
    passwordTF.secureTextEntry = YES;
    passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTF.delegate = self;
    [self.view addSubview:passwordTF];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ALD(15), passwordTF.bottom, kScreenWidth-ALD(15), 0.5)];
    line.backgroundColor = WJColorSeparatorLine;
    [self.view addSubview:line];
    
    CGFloat conwidth = [UILabel getWidthWithTitle:@"确认支付密码" font:WJFont15];
    UILabel *confirmLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15),line.bottom, conwidth, ALD(44))];
    confirmLabel.text = @"确认支付密码";
    confirmLabel.font = WJFont15;
    confirmLabel.textColor = WJColorLoginTitle;
    [self.view addSubview:confirmLabel];
    
    confirmTF = [[UITextField alloc] initWithFrame:CGRectMake(passwordTF.x, line.bottom, passwordTF.width, ALD(44))];
    confirmTF.font = WJFont15;
    confirmTF.keyboardType = UIKeyboardTypeNumberPad;
    confirmTF.secureTextEntry = YES;
    confirmTF.textColor = WJColorLightGray;
//    confirmTF.clearsOnBeginEditing = YES;
    confirmTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    confirmTF.delegate = self;
    [self.view addSubview:confirmTF];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, confirmTF.bottom, kScreenWidth, 0.5)];
    bottomLine.backgroundColor = WJColorSeparatorLine;
    [self.view addSubview:bottomLine];
    
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(ALD(15), ALD(30) + bottomLine.bottom, kScreenWidth - ALD(30), ALD(44))];
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    [nextBtn setTitleColor:WJColorWhite forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:WJFont15];
    [nextBtn setBackgroundColor:WJColorNavigationBar];
    [nextBtn setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorViewNotEditable] forState:UIControlStateDisabled];
    [nextBtn setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorNavigationBar] forState:UIControlStateNormal];
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 4;
    [nextBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.enabled = NO;
    nextBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:nextBtn];
    
    [passwordTF becomeFirstResponder];
}


#pragma mark - UITextFieldTextDidChangeNotification

- (void)checkInputState:(NSNotification *)notification
{
    if (passwordTF.text.length >0  && confirmTF.text.length >0) {
        nextBtn.enabled = YES;
       
    }else{
        nextBtn.enabled = NO;
    }
    
    if ([passwordTF.text length] == 6) {
        [passwordTF resignFirstResponder];
        [confirmTF becomeFirstResponder];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == passwordTF) {
        if ([string length] > 0) {
            if (textField.text.length >= 6) {
               
                return NO;
            }
        }
    }
    
    if (textField == confirmTF) {
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
//    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"支付密码设置成功"];
    //本地验证次数归零
    [WJGlobalVariable payPasswordVerifySuccess];
  
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    NSDictionary *dic = [manager fetchDataWithReformer:nil];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *key = dic[@"salt"];
        NSString *text = [passwordTF.text stringByAppendingString:key];
        //如果已经登录
        if (person) {
            person.payPassword = [text getSha1String];
            person.payPsdSalt = key;
            [[WJDBPersonManager new] updatePerson:person];
        }else{
            self.currentPerson.payPassword = [text getSha1String];
            self.currentPerson.payPsdSalt = key;
            self.currentPerson.isSetPayPassword = YES;
            self.currentPerson.token = [dic objectForKey:@"token"];
            self.currentPerson.isActively = YES;
            
            BOOL su = [[WJDBPersonManager new] insertPerson:self.currentPerson];
            if (su) {
                [[WJCrashManager sharedCrashManager] changeUserId]; //bugly用户身份切换后调用此接口进行修改
            }
        }
    }
   
    WJViewController *vc = [[WJGlobalVariable sharedInstance] fromController];
    
    if (self.from == ComeFromLogin || [vc isKindOfClass:[WJLoginViewController class]]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginProvingPass"
                                                            object:nil];
       
    }else{
        //如果是登录页账户锁定找回
        WJViewController *findFromVC = [WJGlobalVariable sharedInstance].findPwdFromController;
        if ([findFromVC isKindOfClass:[WJLoginViewController class]]) {
           
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
//        else if([findFromVC isKindOfClass:[WJElectronicCardController class]]){
//
//            [self.navigationController popToViewController:findFromVC animated:YES];
//            
//        }
        else if([findFromVC isKindOfClass:[WJEleCardDeteilViewController class]]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FindPasswordFromECardDetail"
                                                                object:nil];
            [self.navigationController popToViewController:findFromVC animated:YES];
        
        }else if([findFromVC isKindOfClass:[WJMyOrderController class]]||
                 [findFromVC isKindOfClass:[WJOrderDetailController class]]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FindPasswordFromECardOrder"
                                                                object:nil];
            [self.navigationController popToViewController:findFromVC animated:YES];
        
        }else{
            
            //付款码页
            if ([vc isKindOfClass:[WJCardPackageViewController class]]) {
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                
            }else{
        
                [self.navigationController popToViewController:vc animated:YES];
            }
        
        }
     
    }
    
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
 
    [self hiddenLoadingView];
    
    if (manager.errorMessage && [manager.errorMessage length]>0) {
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:manager.errorMessage];
    }
}

#pragma mark- Event Response

- (void)allTFResignFirstResponder
{
    [passwordTF resignFirstResponder];
    [confirmTF resignFirstResponder];
}


//确定
-(void)confirmAction
{
    [self allTFResignFirstResponder];

    if ([passwordTF.text length] != 6) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"密码位数为6位"];
        return;
    }
        
    if (![passwordTF.text isEqualToString:confirmTF.text]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"两次密码输入不一致！"];
        return;
    }
    
    [self requestSetPayPassword];
}


//发起请求
- (void)requestSetPayPassword{
    
    [self showLoadingView];
    [self.initialPayPsdManager loadData];
}


#pragma mark - setter and getter

- (APIInitPasswordManager *)initialPayPsdManager{
    if (!_initialPayPsdManager) {
        _initialPayPsdManager = [APIInitPasswordManager new];
        _initialPayPsdManager.delegate = self;
    }
    _initialPayPsdManager.password = passwordTF.text;
    NSString *identy = [[NSUserDefaults standardUserDefaults] objectForKey:@"PersonIdentity"];
    if (identy) {
        _initialPayPsdManager.identity = identy;
    }
    
    return _initialPayPsdManager;
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
