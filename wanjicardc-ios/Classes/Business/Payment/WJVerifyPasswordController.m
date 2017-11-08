//
//  WJVerifyPasswordController.m
//  WanJiCard
//
//  Created by 孙明月 on 16/6/2.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJVerifyPasswordController.h"

#import "APIVerifyPayPwdManager.h"
#import "WJGeneratedPayCodeController.h"
#import "WJPaySettingController.h"
#import "WJSafetyQuestionController.h"
#import "WJPasswordSettingController.h"
#import "WJFindSafetyQuestionController.h"
#import "WJAppealViewController.h"
#import "APIUserInfoVerifyManager.h"
#import "WJVerifyNewPhoneController.h"
#import "WJPersonModel.h"
#import "WJFindRealNameAuthenticationViewController.h"
#import "WJCrashManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

#import "WJSystemAlertView.h"
#import "WJOriginalViewController.h"

#define IVTag  200
#define LockTime 60 * 3
#define LimiteTime 60 * 3

@interface WJVerifyPasswordController ()<UITextFieldDelegate, APIManagerCallBackDelegate, UIActionSheetDelegate, WJSystemAlertViewDelegate>{
    
    UIView * enterBg;
    NSMutableArray *enterPsdViews;
    NSInteger selectedIvTag;
    NSString *enterPassword;
    NSMutableDictionary *dataDic;
}

@property (nonatomic ,strong) APIVerifyPayPwdManager *verPayPsdManager;
@property (nonatomic, strong) APIUserInfoVerifyManager  * userInfoVerifyManager;

@end

@implementation WJVerifyPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.eventID = @"iOS_act_ppaypassword";
    self.title = @"支付密码验证";
    [self removeScreenEdgePanGesture];
    
    if (self.from == ComeFromLogin) {
        self.orginPhone = self.currentPerson.phone;
    }
    if(self.from == ComeFromPayCode){
    
        [self hiddenBackBarButtonItem];
        
        UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setFrame:CGRectMake(0, 0, 19, 19)];
        [cancelButton setImage:[UIImage imageNamed:@"nav_btn_close"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(goBackToCode) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
        self.navigationItem.leftBarButtonItem = cancelItem;
    }
    
    
    psdArray = [NSMutableArray arrayWithCapacity:0];
    
    NSString *filePath = [WJGlobalVariable payPasswordVerifyFailedErrorFilePatch];
    dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    if (dataDic == nil) {
        dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"errorCount",@"0",@"time", @"0",@"limiteTime",nil];
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filePath contents:nil attributes:nil];
        [dataDic writeToFile:filePath atomically:YES];
    }
    
    UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(75), kScreenWidth-ALD(24), ALD(30))];
    infoL.text = @"请输入六位支付密码";
    infoL.textColor = WJColorDarkGray;
    infoL.font = WJFont12;
    infoL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:infoL];
    
    enterBg = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(120), kScreenWidth - ALD(24), ALD(45))];
    [enterBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyBoard)]];
    enterBg.layer.cornerRadius = 5;
    enterBg.clipsToBounds = YES;
    enterBg.backgroundColor = WJColorWhite;
    enterBg.layer.borderColor = WJColorDarkGrayLine.CGColor;
    enterBg.layer.borderWidth = 1;
    [self.view addSubview:enterBg];
    
    enterPsdViews = [NSMutableArray array];
    CGFloat gap = 1;
    CGFloat ivWidth = (enterBg.width-7*gap)/6;
    for (int i = 0; i < 6; i++) {

        if (i>0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake((gap+ivWidth)*i, 0, 1, enterBg.height)];
            line.backgroundColor = WJColorDarkGrayLine;
            [enterBg addSubview:line];
        }
        
        UIImage *normal = [WJUtilityMethod imageFromColor:[UIColor whiteColor] Width:16 Height:16];
        UIImage *hight = [WJUtilityMethod imageFromColor:WJColorNavigationBar Width:16 Height:16];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:normal highlightedImage:hight];
        iv.frame = CGRectMake(gap + (ivWidth-16)/2 + (gap + ivWidth)*i, (enterBg.height - 16)/2, 16, 16);
        iv.layer.cornerRadius = 8;
        iv.layer.masksToBounds = YES;
        iv.tag = IVTag+i;
        [enterBg addSubview:iv];
        [enterPsdViews addObject:iv];
    }
    
    selectedIvTag = IVTag;
    
    
    //更换原手机号流程验证环节没有忘记密码入口
    WJViewController *vc = [WJGlobalVariable sharedInstance].fromController;
    
    if(![vc isKindOfClass:[WJOriginalViewController class]]){
        UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [forgetBtn setBackgroundColor:[UIColor clearColor]];
        forgetBtn.frame = CGRectMake(SCREEN_WIDTH - ALD(12) - ALD(80), CGRectGetMaxY(enterBg.frame)+ALD(15), ALD(80), ALD(20));
        [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [forgetBtn.titleLabel setFont:WJFont12];
        [forgetBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [forgetBtn setTitleColor:WJColorTitleGray forState:UIControlStateNormal];
        [forgetBtn addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:forgetBtn];
    }
    
    tf = [[UITextField alloc] initWithFrame:CGRectMake(-100, 0, 103, 20)];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.delegate = self;
    tf.alpha = 0;
    [self.view addSubview:tf];
}


- (void)viewWillAppear:(BOOL)animated{
    //输入框重置
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    //注销掉登录环节指纹验证
//    if (self.from == ComeFromLogin) {
//        
//        [self checkFingerWithIdenty:0];
//        
//    }else

    if (self.from == ComeFromPayCode) {
        
        [self checkFingerWithIdenty];
        
    }else{
        
        [self changeInputState];
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showKeyBoard];
}


- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [tf resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - APIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    
    [self hiddenLoadingView];
    
    //本地验证次数归零
    [WJGlobalVariable payPasswordVerifySuccess];
    
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    
    if([manager isKindOfClass:[APIVerifyPayPwdManager class]]){
    
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        
        if (person) {
            NSString *text = [[enterPassword stringByAppendingString:person.payPsdSalt] getSha1String];
            if (![person.payPassword isEqualToString:text]) {
                person.payPassword = text;
                [[WJDBPersonManager new] updatePerson:person];
            }
        }else{
            
            NSString *text = [[enterPassword stringByAppendingString:self.currentPerson.payPsdSalt] getSha1String];
            if (![self.currentPerson.payPassword isEqualToString:text]) {
                self.currentPerson.payPassword = text;
            }
            self.currentPerson.hasVerifyPayPassword = YES;
            self.currentPerson.token = [dic objectForKey:@"token"];
            self.currentPerson.isActively = YES;
            
            BOOL su = [[WJDBPersonManager new] insertPerson:self.currentPerson];
            if (su) {
                [[WJCrashManager sharedCrashManager] changeUserId]; //bugly用户身份切换后调用此接口进行修改
            }
        }
        
        if (self.from == ComeFromLogin) {
                       
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginProvingPass"
                                                                object:nil];

        }
        
        //付款页
        if (self.from == ComeFromPayCode) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PayCodeDismiss" object:nil userInfo:@{@"isShowCode":@"YES"}];
            self.navigationController.navigationBarHidden = YES;
//            [self.navigationController popToRootViewControllerAnimated:NO];
            [self.navigationController popViewControllerAnimated:NO];
            
        }
        
        //开启指纹验证
        if (self.from == ComeFromTouchID) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PasswordSwitchProvingPass" object:nil userInfo:@{@"FingerOpen":@"1"}];
        }
        
        //开启无密
        if(self.from == ComeFromOpenNoPsd){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PasswordSwitchProvingPass" object:nil];
        }
        
        //修改密码
        if (self.from == ComeFromModifyPsd) {
            WJPasswordSettingController *pswSettingVC = [[WJPasswordSettingController alloc] init];
            pswSettingVC.from = ComeFromModifyPsd;
            [self.navigationController pushViewController:pswSettingVC animated:YES whetherJump:YES];
        }
        //安全问题
        if (self.from == ComeFromSafetyQuestion) {
            WJSafetyQuestionController *sqVC = [[WJSafetyQuestionController alloc] initWithPsdType:SafetyQuestionTypeNew];
            [(WJNavigationController *)self.navigationController pushViewController:sqVC animated:YES whetherJump:YES];
        }

    }
    
    //更换手机号验证
    if ([manager isKindOfClass:[APIUserInfoVerifyManager class]]) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            NSString *token = [dic objectForKey:@"token"];
            if(person){
                person.token = token;
                [[WJDBPersonManager new] updatePerson:person];
            }else{
            
                [self infoWithToken:token status:nil authenticate:nil setSecurity:nil];
            }
        }
        
        WJVerifyNewPhoneController *newPhoneVC = [[WJVerifyNewPhoneController alloc] initWithPhone:self.orginPhone enterPassword:enterPassword];
        [self.navigationController pushViewController:newPhoneVC animated:YES whetherJump:YES];
    }
    
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager{
    
    [self hiddenLoadingView];
    [psdArray removeAllObjects];
    [tf resignFirstResponder];
    
    
    //验证失败
    if (manager.errorCode == 50008052 || manager.errorCode == 50008053) {
        
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        
        if([manager isKindOfClass:[APIUserInfoVerifyManager class]]){
            if ([manager isKindOfClass:[APIUserInfoVerifyManager class]]) {
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    NSString *status = ToString([dic objectForKey:@"appealStatus"]);
                    NSString *authentication = ToString([dic objectForKey:@"authentication"]);
                    BOOL setSecurity = [[dic objectForKey:@"setSecurity"] boolValue];
                    
                    [self infoWithToken:nil status:status authenticate:authentication setSecurity:setSecurity ? @"1":@"0"];
                }
            }
        }
      
        
        [self recordErrorNumber];
        
        NSString *errMsg = manager.errorMessage;
        if (errMsg) {
            if (errMsg.length > 0) {
                 [self showAlertWithMessage:manager.errorMessage isLocked:[dic[@"lockedStatus"] boolValue] ?YES:NO];
            }
        }else{
            //text变可编辑
            self.canInputPassword = YES;
            [self showKeyBoard];
        }
        
    }else{
        
        if (manager.errorMessage) {
            if ([manager.errorMessage length] > 0) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:manager.errorMessage];
            }
        }
        //text变可编辑
        self.canInputPassword = YES;
        [self showKeyBoard];
    }
}


- (void)recordErrorNumber
{
    NSInteger faileNumber = [[dataDic objectForKey:@"errorCount"] intValue];
    if (faileNumber < 5) {
        
        [dataDic setObject:[NSString stringWithFormat:@"%@",@(++faileNumber)] forKey:@"errorCount"];
        NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        [dataDic setObject:nowTime forKey:@"time"];
        
        //记录第一次错误的时间
        if(faileNumber == 1){
            [dataDic setObject:nowTime forKey:@"limiteTime"];
        }
        
        [dataDic writeToFile:[WJGlobalVariable payPasswordVerifyFailedErrorFilePatch] atomically:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.canInputPassword) {
        if (string.length == 0) {
            if (selectedIvTag > IVTag) {
                selectedIvTag -= 1;
                UIImageView *iv = (UIImageView *)[self.view viewWithTag:selectedIvTag];
                iv.highlighted = NO;
                [psdArray removeLastObject];
            }
        }else{
            if (selectedIvTag < 206) {
                UIImageView *iv = (UIImageView *)[self.view viewWithTag:selectedIvTag];
                iv.highlighted = YES;
                selectedIvTag += 1;
                [psdArray addObject:string];
                
                if (selectedIvTag == 206) {
                    [self performSelector:@selector(startSureBtnAction) withObject:nil afterDelay:0.3];
                }
            }
        }
    }
    
    return self.canInputPassword;
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    NSInteger appealStatus;
    BOOL isSetQuestion;
    NSInteger realnameStatus;
    NSString *realname = nil;
    NSString *userPhone = nil;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (person) {
         appealStatus = person.appealStatus;
        isSetQuestion = person.isSetPsdQuestion;
        realnameStatus = person.authentication;
        if (person.realName) {
            if ([person.realName length]>0) {
                realname = person.realName;
            }
        }
        userPhone = person.phone;
        
    }else{
        if(self.currentPerson){
            appealStatus = self.currentPerson.appealStatus;
            isSetQuestion = self.currentPerson.isSetPsdQuestion;
            realnameStatus = self.currentPerson.authentication;
            if (self.currentPerson.realName) {
                if ([self.currentPerson.realName length]>0) {
                    realname = self.currentPerson.realName;
                }
            }
             userPhone = self.currentPerson.phone;
        }else{
            appealStatus = [[[userDefault objectForKey:kTokenForChangePhone] objectForKey:@"appealStatus"] integerValue];
            isSetQuestion = [[[userDefault objectForKey:kTokenForChangePhone] objectForKey:@"setSecurity"] boolValue];
            realnameStatus = [[[userDefault objectForKey:kTokenForChangePhone] objectForKey:@"authenticate"] integerValue];
        }
    }
 
    if (realnameStatus == 2) {
        if (buttonIndex == 0) {
            //实名验证找回
            WJFindRealNameAuthenticationViewController *authenticVC = [[WJFindRealNameAuthenticationViewController alloc] init];
            if (realname) {
                authenticVC.realName = realname;
            }
            [self.navigationController pushViewController:authenticVC animated:YES];
            
        }else{
        
            if (isSetQuestion && buttonIndex == 1) {
                //安全问题
                WJFindSafetyQuestionController *findSafeVC = [[WJFindSafetyQuestionController alloc] init];
                if (nil == person) {
                    findSafeVC.phoneNumber = self.orginPhone;
                }
                [self.navigationController pushViewController:findSafeVC animated:YES];
                return;
                
            }else if((isSetQuestion && buttonIndex == 2) || (!isSetQuestion && buttonIndex == 1)){
                //账户申诉找回
               
                switch (appealStatus) {
                    case AppealProcessing:
                    {
                        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"申诉处理中"];
                        self.canInputPassword = YES;
                    }
                        break;
                        
                    default:
                    {
                        WJAppealViewController *findPswVC = [[WJAppealViewController alloc] init];
                        if (userPhone) {
                            findPswVC.userPhone = userPhone;
                        }
                        [self.navigationController pushViewController:findPswVC animated:YES];
                    }
                        break;
                }
                
                
                return;
                
            }else{
                self.canInputPassword = YES;
                [self showKeyBoard];
            }
        }
        
    }else{
        
        if (isSetQuestion && buttonIndex == 0) {
    
            //安全问题找回
            WJFindSafetyQuestionController *findSafeVC = [[WJFindSafetyQuestionController alloc] init];
            if (nil == person) {
                findSafeVC.phoneNumber = self.orginPhone;
            }
            [self.navigationController pushViewController:findSafeVC animated:YES];
            return;
    
        }else if ((isSetQuestion && buttonIndex == 1) || (!isSetQuestion && buttonIndex == 0)) {
    
            //申诉找回
            if (appealStatus == AppealProcessing){
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"申诉处理中"];
                self.canInputPassword = YES;
            }else{
                
                WJAppealViewController *findPswVC = [[WJAppealViewController alloc] init];
                if (userPhone) {
                    findPswVC.userPhone = userPhone;
                }
                [self.navigationController pushViewController:findPswVC animated:YES];
            }
            return;
            
        }else{
            
            self.canInputPassword = YES;
            [self showKeyBoard];
        }
    }
    
}


#pragma mark - WJSystemAlertViewDelegate

- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"验证失败"]) {
        self.canInputPassword = YES;
        [self showKeyBoard];
        
    }else if ([alertView.title isEqualToString:@"账号已被锁定"]) {
        if (buttonIndex == 0) {
            self.canInputPassword = YES;
            [self showKeyBoard];
        }
        if (buttonIndex == 1) {
            [self findPassword];
        }
    }
}


#pragma mark - 存储路径和时间比较方法

- (NSInteger)distanceTimeWithBeforeTime:(NSInteger)beTime
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSInteger distance = now - beTime;
    return distance;
}

#pragma mark - 登录页更换手机号，原手机号验证失败存储找回密码3种方式的状态

- (void)infoWithToken:(NSString *)token status:(NSString *)status authenticate:(NSString *)authenticate setSecurity:(NSString *)setSecurity
{
    [[NSUserDefaults standardUserDefaults] setObject:@{@"token":token ?:@"", @"appealStatus":status ?: @"", @"authenticate":authenticate ?: @"", @"setSecurity":setSecurity ?: @""} forKey:kTokenForChangePhone];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - UIButton Action

- (void)goBackToCode{
  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayCodeDismiss" object:nil userInfo:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}


- (void)showKeyBoard{
    [tf becomeFirstResponder];
}


- (void)changeInputState
{
    for (UIImageView *iv in enterPsdViews) {
        iv.highlighted = NO;
    }
    [psdArray removeAllObjects];
    self.canInputPassword = YES;
    
}


- (void)cleanPsdView{
    for (UIImageView *iv in enterPsdViews) {
        iv.highlighted = NO;
    }
    selectedIvTag = IVTag;
}


- (void)startSureBtnAction{
    self.canInputPassword = NO;

    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf sureBtnAction];
    });
}


- (void)sureBtnAction{
    
    enterPassword = [psdArray componentsJoinedByString:@""];
    
    if (psdArray.count == 0){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"密码位数不能为空"];
        self.canInputPassword = YES;
        return;
    }
    if (psdArray.count < 6) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"密码位数为6位"];
        self.canInputPassword = YES;
        return;
    }
    
    [self cleanPsdView];
    
    if(![WJUtilityMethod isNotReachable] && self.from == ComeFromPayCode){
        //无网
        NSString *filePath = [WJGlobalVariable payPasswordVerifyFailedErrorFilePatch];
        
        int faileNumber = [[dataDic objectForKey:@"errorCount"] intValue];
        NSInteger lastTime = [[dataDic objectForKey:@"time"] intValue];
        NSInteger distanceTime = [self distanceTimeWithBeforeTime:lastTime];
        
        NSInteger FirstErrorTime = [[dataDic objectForKey:@"limiteTime"] intValue];
        NSInteger disTime = [self distanceTimeWithBeforeTime:FirstErrorTime];
        
        //如果锁了
        if (lastTime) {
            if (distanceTime/60 >= LockTime){
                faileNumber = 0;
                [dataDic setObject:[NSString stringWithFormat:@"%ld",(long)faileNumber] forKey:@"errorCount"];
                [dataDic setObject:@"0" forKey:@"time"];
                [dataDic setObject:@"0" forKey:@"lockTime"];
                [dataDic writeToFile:filePath atomically:YES];
            }
            
        }else{
            
            if (disTime/60 >= LimiteTime) {
                faileNumber = 0;
                [dataDic setObject:[NSString stringWithFormat:@"%ld",(long)faileNumber] forKey:@"errorCount"];
                [dataDic setObject:@"0" forKey:@"time"];
                [dataDic setObject:@"0" forKey:@"lockTime"];
                [dataDic writeToFile:filePath atomically:YES];
            }
        }
        
        if(faileNumber >= 4){
            
            NSString *messageStr;
            if ((LockTime - distanceTime/60)/60 >= 1) {
                messageStr = [NSString stringWithFormat:@"支付密码错误,输入次数过多,请%@小时后再试",@((LockTime - distanceTime/60)/60 + 1)];
                
            }else{
                messageStr = [NSString stringWithFormat:@"支付密码错误，输入次数过多,请%@分钟后再试",@((LockTime - distanceTime/60))];
            }
            
            [self showAlertWithMessage:messageStr isLocked:YES];
            [self changeInputState];
            
            if (faileNumber == 4) {
                [dataDic setObject:[NSString stringWithFormat:@"%@",@(++faileNumber)] forKey:@"errorCount"];
                NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                [dataDic setObject:nowTime forKey:@"time"];
                [dataDic writeToFile:[WJGlobalVariable payPasswordVerifyFailedErrorFilePatch] atomically:YES];
            }
            
        }else{
            WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
            
            if (person.payPsdSalt.length > 0) {
                NSString *key = person.payPsdSalt;
                NSString *input = [enterPassword stringByAppendingString:key];
                if ( person.payPassword.length > 0 ) {
                    if ([person.payPassword isEqualToString:[input getSha1String]]) {
                        NSLog(@"支付密码本地验证通过");
                        APIVerifyPayPwdManager *mg = [[APIVerifyPayPwdManager alloc]init];
                        [self managerCallAPIDidSuccess:mg];
                    }else{
                        
                        [dataDic setObject:[NSString stringWithFormat:@"%@",@(++faileNumber)] forKey:@"errorCount"];
                        NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                        [dataDic setObject:nowTime forKey:@"time"];
                        //记录第一次错误的时间
                        if(faileNumber == 1){
                            [dataDic setObject:nowTime forKey:@"limiteTime"];
                        }
                        [dataDic writeToFile:[WJGlobalVariable payPasswordVerifyFailedErrorFilePatch] atomically:YES];
                    
                        [self showAlertWithMessage:[NSString stringWithFormat:@"支付密码错误！您还有%d次验证机会",(5-faileNumber)] isLocked:NO];
                        
                        [psdArray removeAllObjects];
                        self.canInputPassword = YES;
                    }
                    
                }else{
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请连接网络验证支付密码"];
                }
            }
            
        }
        
    }else{
        
        [self showLoadingView];
       
        //更换手机号
        if (self.from == ComeFromChangePhone) {
            
            [self.userInfoVerifyManager loadData];
            
        }else{
        
            if (self.from == ComeFromLogin) {
                NSString *input = [enterPassword stringByAppendingString:self.currentPerson.payPsdSalt];
                self.verPayPsdManager.password = [input getSha1String];
                [self.verPayPsdManager loadData];
                
            }else{
                
                WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
                NSString *input = [enterPassword stringByAppendingString:person.payPsdSalt];
                self.verPayPsdManager.password = [input getSha1String];
                [self.verPayPsdManager loadData];
            }
            
        }
        
    }
    
}


//指纹校验
- (void)checkFingerWithIdenty
{
    if(IOS8_LATER){
        
        //判断是否设置了指纹验证
        NSString *fingerIdenty = KFingerIdentySwitch;
        BOOL isBool = NO;
        if (fingerIdenty) {
            isBool = [[NSUserDefaults standardUserDefaults] boolForKey:fingerIdenty];
        }
        
        //如果已经开启验证
        if (isBool) {
            
            //进行指纹识别，获取指纹验证结果
            LAContext *context = [[LAContext alloc] init];
            context.localizedFallbackTitle = @"输入支付密码";
            
            __weak typeof(self) weakSelf = self;
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"通过Home键验证已有手机指纹",nil) reply:^(BOOL success, NSError * _Nullable error) {
                
                __strong typeof(self) strongSelf = weakSelf;
                
                if (success) {
                    //验证成功，主线程处理UI
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
//                        WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
//                        person.hasVerifyPayPassword = YES;
//                        [[WJDBPersonManager new] updatePerson:person];
                        
//                        //登陆进来
//                        if (identy == 0) {
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginProvingPass" object:nil];
//                        }
                       
//                        if (identy == 1) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PayCodeDismiss" object:nil userInfo:@{@"isShowCode":@"YES"}];
                        strongSelf.navigationController.navigationBarHidden = YES;
//                        [strongSelf.navigationController popToRootViewControllerAnimated:NO];
                        [strongSelf.navigationController popViewControllerAnimated:NO];
                        
                        
//                        }
                        
                    }];
                    
                }else{
                    
                    NSLog(@"%@",error.localizedDescription);
                    switch (error.code) {
                        case LAErrorSystemCancel:
                        {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                //系统取消验证Touch ID
                                [strongSelf changeInputState];
                                
                            }];
                        }
                            break;
                        case LAErrorUserCancel:
                        {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                //用户取消验证Touch ID
                                [strongSelf changeInputState];
                            }];
                            
                        }
                            break;
                        case LAErrorUserFallback:
                        {
                            NSLog(@"User selected to enter custom password");
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                //用户选择输入密码，切换主线程处理
                                [strongSelf changeInputState];
                            }];
                        }
                            break;
                        default:
                        {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                //其他情况，切换主线程处理
                                [strongSelf changeInputState];
                            }];
                        }
                            break;
                    }
                    
                }
            }];
            
        }else{
            
            [self changeInputState];
        }
        
    }else{
        
        //ios8以下系统
        [self changeInputState];
    }
}


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
    
    WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:otherBtnTitle textAlignment:NSTextAlignmentCenter];
    
    [alert showIn];
}


//忘记\找回密码
- (void)findPassword
{
    
    [self cleanPsdView];
    [psdArray removeAllObjects];
    self.canInputPassword = NO;
    [tf resignFirstResponder];
    
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSInteger appealStatus;
    BOOL isSetQuestion;
    NSInteger realnameStatus;
    NSString *realname = nil;
    NSString *userPhone = nil;
    
    if (person) {
        appealStatus = person.appealStatus;
        isSetQuestion = person.isSetPsdQuestion;
        realnameStatus = person.authentication;
        if (person.realName) {
            if ([person.realName length]>0) {
                realname = person.realName;
            }
        }
        userPhone = person.phone;
    }else{
        
        if(self.currentPerson){
            appealStatus = self.currentPerson.appealStatus;
            isSetQuestion = self.currentPerson.isSetPsdQuestion;
            realnameStatus = self.currentPerson.authentication;
            if (self.currentPerson.realName) {
                if ([self.currentPerson.realName length]>0) {
                    realname = self.currentPerson.realName;
                }
            }
            userPhone = self.currentPerson.phone;
        }else{
            appealStatus = [[[userDefault objectForKey:kTokenForChangePhone] objectForKey:@"appealStatus"] integerValue];
            isSetQuestion = [[[userDefault objectForKey:kTokenForChangePhone] objectForKey:@"setSecurity"] boolValue];
            realnameStatus = [[[userDefault objectForKey:kTokenForChangePhone] objectForKey:@"authenticate"] integerValue];
        }
    }
    
    if (IOS8_LATER) {
        
        __weak typeof(self) weakSelf = self;
        __weak WJModelPerson *per = person;
        __weak NSString *weakName = realname;
        __weak NSString *weakPhone = userPhone;
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"找回密码" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.canInputPassword = YES;
            [strongSelf showKeyBoard];

            }];
        [alertControl addAction:cancelAction];
        
        UIAlertAction *appealAction = [UIAlertAction actionWithTitle:@"申诉找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            __strong typeof(self) strongSelf = weakSelf;
            
            if (appealStatus == AppealProcessing){
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"申诉处理中"];
                strongSelf.canInputPassword = YES;

            }else{
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
                //安全问题找回
                WJFindSafetyQuestionController *findSafeVC = [[WJFindSafetyQuestionController alloc] init];
                if (nil == per) {
                    
                    findSafeVC.phoneNumber = strongSelf.orginPhone;
                } else {
                    findSafeVC.phoneNumber = weakPhone;
                }
                
                [strongSelf.navigationController pushViewController:findSafeVC animated:YES];
            }];
            
            [alertControl addAction:quesAction];
        }
        
        if (realnameStatus == 2) {
            
            UIAlertAction *authAction = [UIAlertAction actionWithTitle:@"实名验证找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(self) strongSelf = weakSelf;
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


#pragma mark - 属性访问方法

- (APIVerifyPayPwdManager *)verPayPsdManager
{
    if (nil == _verPayPsdManager) {
        _verPayPsdManager = [[APIVerifyPayPwdManager alloc] init];
        _verPayPsdManager.delegate = self;
    }
    
    NSString *identy = [[NSUserDefaults standardUserDefaults] objectForKey:@"PersonIdentity"];
    if (identy) {
        _verPayPsdManager.identity = identy;
    }
    
    return _verPayPsdManager;
}


- (APIUserInfoVerifyManager *)userInfoVerifyManager{
    if (!_userInfoVerifyManager) {
        _userInfoVerifyManager = [APIUserInfoVerifyManager new];
        _userInfoVerifyManager.delegate = self;
    }
    
    _userInfoVerifyManager.phone = self.orginPhone;
    _userInfoVerifyManager.payPassword = enterPassword;
    
    return _userInfoVerifyManager;
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
