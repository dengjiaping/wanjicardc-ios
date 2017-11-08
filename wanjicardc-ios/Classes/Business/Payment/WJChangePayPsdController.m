//
//  WJChangePayPsdController.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/2.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJChangePayPsdController.h"
#import "WJIndividualCenterController.h"
#import "APIChangePayPsdManager.h"
#import "APIInitPasswordManager.h"
#import "WJLoginViewController.h"
#import "APIVerifyPayPwdManager.h"
#import "APIGetKeyForSALManager.h"
#import "WJGeneratedPayCodeController.h"
#import "WJPaySettingController.h"
#import "WJSafetyQuestionController.h"
#import "WJFindPsdWayViewController.h"
#import "APIUpdatePayPsdManager.h"
#import "APIUserLogoutManager.h"
#import "WJCardsViewController.h"
#import "WJAlertView.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define IVTag  200
#define LockTime 60 * 3
#define LimiteTime 60 * 3

@interface WJChangePayPsdController ()<UITextFieldDelegate, APIManagerCallBackDelegate,WJAlertViewDelegate>{
    ResetPsyType psdResetType;
    
    UIView *enterBg;
   
    
    NSInteger selectedIvTag;
    NSString *enterPassword;
   
    NSMutableDictionary *dataDic;
    NSMutableArray *enterPsdViews;
}

@property (nonatomic, strong) APIChangePayPsdManager *changePayPsdManager;
@property (nonatomic, strong) APIInitPasswordManager *initialPayPsdManager;
//@property (nonatomic, strong) APIGetKeyForSALManager *salGetterManager;
@end


@implementation WJChangePayPsdController

- (instancetype)initWithPsdType:(ChangePayPsdType)psdType
                      resetType:(ResetPsyType)resetPsyType{
    if (self = [super init]) {
        enterPsdType = psdType;
        psdResetType = resetPsyType;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    //输入框重置
    self.navigationController.navigationBarHidden = NO;

    [super viewWillAppear:animated];
    if (self.from == ComeFromLogin) {
        [self hiddenBackBarButtonItem];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        NSString *isOpenPaySwitchKey = KIsOpenPaySwitch;
        NSString *isPsdKey = KPasswordSwitch;
        BOOL isBool = NO;
        if (isOpenPaySwitchKey) {
            isBool = [accountDefaults boolForKey:isOpenPaySwitchKey];
        }
        if (!isBool && isOpenPaySwitchKey && isPsdKey) {
            [accountDefaults setBool:YES forKey:isPsdKey];
            [accountDefaults setBool:YES forKey:isOpenPaySwitchKey];
        }
        
        [self checkFingerWithIdenty:0];

    }else if (self.from == ComeFromPayCode) {
    
        [self checkFingerWithIdenty:1];

    }else{
        
        [self changeInputState];
    }
}


- (void)changeInputState
{
    for (UIImageView *iv in enterPsdViews) {
        iv.highlighted = NO;
    }
    [psdArray removeAllObjects];
    self.canInputPassword = YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showKeyBoard];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.eventID = @"iOS_act_ppaypassword";
    [self removeScreenEdgePanGesture];
    
    psdArray = [NSMutableArray arrayWithCapacity:0];

    NSString *filePath = [self filePatch];
    dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    if (dataDic == nil) {
        dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"errorCount",@"0",@"time", @"0",@"limiteTime",nil];
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filePath contents:nil attributes:nil];
        [dataDic writeToFile:filePath atomically:YES];
    }

    
    UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(10, ALD(55), kScreenWidth-20, ALD(36))];
    infoL.text = @"";
    infoL.textColor = WJColorDardGray3;
    infoL.font = WJFont15;
    infoL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:infoL];
    
    enterBg = [[UIView alloc] initWithFrame:CGRectMake(ALD(15), ALD(95), kScreenWidth - ALD(30), ALD(45))];
    [enterBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyBoard)]];
    enterBg.layer.cornerRadius = 3;
    enterBg.clipsToBounds = YES;
    [self.view addSubview:enterBg];
    
    
    enterPsdViews = [NSMutableArray array];
    int ivWidth = enterBg.width/6;
    for (int i = 0; i < 6; i++) {
        UIView *iconBg = [[UIView alloc] initWithFrame:CGRectMake(ivWidth*i, 0, ivWidth-1, enterBg.height)];
        iconBg.backgroundColor = WJColorWhite;
        iconBg.layer.shadowColor = WJColorViewBg.CGColor;
        iconBg.layer.shadowOffset = CGSizeMake(1, 0);
        iconBg.layer.shadowOpacity = 0;
        iconBg.layer.shadowRadius = 0.5;
        [enterBg addSubview:iconBg];
        
        UIImage *normal = [WJUtilityMethod imageFromColor:[UIColor whiteColor] Width:20 Height:20];

        UIImage *hight = [WJUtilityMethod imageFromColor:WJColorNavigationBar Width:20 Height:20];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:normal highlightedImage:hight];
        iv.frame = CGRectMake(0, 0, 20, 20);
        iv.center = CGPointMake(iconBg.width/2, iconBg.height/2);
        iv.layer.cornerRadius = 10;
        iv.layer.masksToBounds = YES;
        iv.tag = IVTag+i;
        [iconBg addSubview:iv];
        [enterPsdViews addObject:iv];
    }
    selectedIvTag = IVTag;
    CGRect frame = enterBg.frame;
    frame.size.width = ivWidth*6-1;
    enterBg.frame = frame;

    enterBg.centerX = self.view.centerX;
    
    NSString *title = nil;
    switch (enterPsdType) {
        case ChangePayPsdTypeVerify:{
            title = @"支付密码验证";
            infoL.text = @"请输入支付密码，以验证身份";
        }
            break;
        case ChangePayPsdTypeNew:{
            title = @"设置支付密码";
            infoL.text = @"请设置支付密码，以保障您账户的安全";
        }
            break;
        case ChangePayPsdTypeConfirm:{
            infoL.hidden = NO;
            title = @"确认支付密码";
            infoL.text = @"请再次确认您输入的支付密码";
        }
            break;

        default:
            title = @"请输入旧密码";
            break;
    }
    self.title = title;
    
    if (self.from == ComeFromLogin) {
        UIButton *changeOtherAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        changeOtherAccountBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [changeOtherAccountBtn setTitle:@"使用其他账号登录？" forState:UIControlStateNormal];
        [changeOtherAccountBtn .titleLabel setFont:WJFont12];
        [changeOtherAccountBtn setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [changeOtherAccountBtn addTarget:self action:@selector(changeAccount) forControlEvents:UIControlEventTouchUpInside];
        changeOtherAccountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.view addSubview:changeOtherAccountBtn];
        
        [self.view addConstraints:[changeOtherAccountBtn constraintsTop:15 FromView:enterBg]];
        [self.view addConstraint:[changeOtherAccountBtn constraintHeight:30]];
        [self.view addConstraint:[changeOtherAccountBtn constraintWidth:ALD(180)]];
        [self.view addConstraint:[changeOtherAccountBtn constraintRightEqualToView:enterBg]];
    }
    
    
    tf = [[UITextField alloc] initWithFrame:CGRectMake(-100, 0, 103, 20)];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.delegate = self;
    tf.alpha = 0;
    [self.view addSubview:tf];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [tf resignFirstResponder];
}

- (void)checkFingerWithIdenty:(int)identy
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
            
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"通过Home键验证已有手机指纹",nil) reply:^(BOOL success, NSError * _Nullable error) {
                
                if (success) {
                    //验证成功，主线程处理UI
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                       
                        WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
                        person.hasVerifyPayPassword = YES;
                        [[WJDBPersonManager new] updatePerson:person];
                        
                        //登陆验证
                        if (identy == 0) {
                            [self verifyPayPasswordCorrect];
                        }
                        if (identy == 1) {
                            
                            WJGeneratedPayCodeController *gvc = [[WJGeneratedPayCodeController alloc] init];
                            [self.navigationController pushViewController:gvc animated:YES whetherJump:YES];
                        }
                        
                    }];
                    
                }else{
                    
                    NSLog(@"%@",error.localizedDescription);
                    switch (error.code) {
                        case LAErrorSystemCancel:
                        {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                //系统取消验证Touch ID
                                [self changeInputState];
                                
                            }];
                        }
                            break;
                        case LAErrorUserCancel:
                        {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                //用户取消验证Touch ID
                                [self changeInputState];
                            }];
                            
                        }
                            break;
                        case LAErrorUserFallback:
                        {
                            NSLog(@"User selected to enter custom password");
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                //用户选择输入密码，切换主线程处理
                                [self changeInputState];
                            }];
                        }
                            break;
                        default:
                        {
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                //其他情况，切换主线程处理
                                [self changeInputState];
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

- (void)cleanPsdView{
    for (UIImageView *iv in enterPsdViews) {
        iv.highlighted = NO;
    }

    selectedIvTag = IVTag;
}


#pragma mark - UIButton Action

- (void)changeAccount{
    APIUserLogoutManager *logoutManager = [APIUserLogoutManager new];
    [logoutManager loadData];

    
    // 删除本地纪录
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    [person logout];


    [[NSNotificationCenter defaultCenter]  postNotificationName:@"kQuitAccountNotification" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showKeyBoard{
    [tf becomeFirstResponder];
}


- (void)startSureBtnAction{
    self.canInputPassword = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sureBtnAction];
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
    
    if (enterPsdType == ChangePayPsdTypeConfirm &&
        ![enterPassword isEqualToString:self.oldPassword]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"两次密码输入不正确！"];
        [psdArray removeAllObjects];
        [self.navigationController popViewControllerAnimated:YES];

        return;
    }
    WJChangePayPsdController *vc = nil;
    if (enterPsdType == ChangePayPsdTypeVerify){
        if(![WJUtilityMethod isNetReachable] && self.from == ComeFromPayCode){
            //无网
            NSString *filePath = [self filePatch];
           
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
               
                [self showAlertViewAndDistanceTime:distanceTime];
                [psdArray removeAllObjects];
                self.canInputPassword = YES;
                
                if (faileNumber == 4) {
                    [dataDic setObject:[NSString stringWithFormat:@"%@",@(++faileNumber)] forKey:@"errorCount"];
                    NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                    [dataDic setObject:nowTime forKey:@"time"];
                    [dataDic writeToFile:[self filePatch] atomically:YES];
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
                            [dataDic writeToFile:[self filePatch] atomically:YES];
                          
                            WJAlertView *alert = [[WJAlertView alloc]initWithTitle:nil
                                                                           message:[NSString stringWithFormat:@"支付密码错误！您还有%d次验证机会",(5-faileNumber)]
                                                                          delegate:self
                                                                 cancelButtonTitle:@"取消"
                                                                 otherButtonTitles:@"找回支付密码"
                                                                     textAlignment:NSTextAlignmentCenter];
                            [alert showIn];
                            
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
                WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
            
                if ([person.payPsdSalt length] > 0) {
                    NSString *input = [enterPassword stringByAppendingString:person.payPsdSalt];
                    self.verPayPsdManager.password = [input getSha1String];
                    [self.verPayPsdManager loadData];
                    
                }else{
                    
//                    [self showLoadingView];
//                    [self.salGetterManager loadData];
                    WJChangePayPsdController *changePayVC = [[WJChangePayPsdController alloc] initWithPsdType:ChangePayPsdTypeNew resetType:ResetPsyTypeInit];
                    [self.navigationController pushViewController:changePayVC animated:YES];
//                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismiss) name:@"LoginProvingPass" object:nil];
                    
                }
            }

        
    }else if (enterPsdType == ChangePayPsdTypeNew){
        
        vc = [[WJChangePayPsdController alloc] initWithPsdType:ChangePayPsdTypeConfirm resetType:psdResetType];
        vc.oldPassword = enterPassword;
        vc.verifyCode = self.verifyCode;
        
        vc.from = self.from;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        [self requestSetPayPassword];
    }
}


#pragma mark - Logic

- (void)verifyPayPasswordCorrect{
    
    if (self.from == ComeFromTouchID) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PasswordSwitchProvingPass" object:nil userInfo:@{@"FingerOpen":@"1"}];
        
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PasswordSwitchProvingPass" object:nil];
    }
  
    if (self.from == ComeFromLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginProvingPass" object:nil];
    }
}


#pragma mark - APIManagerCallBackDelegate

- (void)requestSetPayPassword{
    
    [self showLoadingView];
    
    if (psdResetType == ResetPsyTypeReset) {
        
        if ((self.from == ComeFromModifyPsd) || (self.from == ComeFromRetrievePsd)) {
            
            [self.initialPayPsdManager loadData];
            
        }else{

            [self.changePayPsdManager loadData];
        }
        
        
    }else if (psdResetType == ResetPsyTypeInit){
        
        
        [self.initialPayPsdManager loadData];
       
    }
}


- (void)payPasswordSettingSuccess{
    NSString *filePath = [self filePatch];
    dataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    [dataDic setObject:@"0" forKey:@"errorCount"];
    [dataDic setObject:@"0" forKey:@"time"];
    [dataDic setObject:@"0" forKey:@"lockTime"];
    [dataDic writeToFile:filePath atomically:YES];
    
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    person.hasVerifyPayPassword = YES;
    [[WJDBPersonManager new] updatePerson:person];
}


- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    
    if ([manager isKindOfClass:[APIChangePayPsdManager class]] ||
        [manager isKindOfClass:[APIInitPasswordManager class]]) {
        
        [self hiddenLoadingView];
        
        WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
        
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *key = dic[@"salt"];
            NSString *text = [enterPassword stringByAppendingString:key];
            person.payPassword = [text getSha1String];
            person.payPsdSalt = key;
        }

        //如果是修改支付密码
        if (psdResetType == ResetPsyTypeReset) {
          
            [[WJDBPersonManager new] updatePerson:person];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"支付密码修改成功"];
    
            //跳转到验证密码前一个controller
            WJViewController *vc = [[WJGlobalVariable sharedInstance] fromController];
            [self.navigationController popToViewController:vc animated:YES];
            
        }else{
            
            person.isSetPayPassword = YES;
            [[WJDBPersonManager new] updatePerson:person];
            
            BOOL isFromPaySwtich = NO;
            WJViewController *wvc;
            for (wvc in self.navigationController.viewControllers) {
                if ([wvc isKindOfClass:[WJPaySettingController class]]) {
                    isFromPaySwtich = YES;
                    break;
                }
            }
            if (isFromPaySwtich) {
                [self.navigationController popToViewController:wvc animated:YES];
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"支付密码设置成功"];
            }else{
                if(self.from == ComeFromPayCode){
                    WJGeneratedPayCodeController *gvc = [[WJGeneratedPayCodeController alloc] init];
                    [self.navigationController pushViewController:gvc animated:YES];
                }else{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }
        
        [self verifyPayPasswordCorrect];
        [self payPasswordSettingSuccess];

    }else if ([manager isKindOfClass:[APIVerifyPayPwdManager class]]) {
        
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *certificate = dic[@"certificate"];
            WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
            
            if ([[person.token getSha1String] isEqualToString:certificate]) {
                
                [self hiddenLoadingView];
                [self verifyPayPasswordCorrect];
                [self payPasswordSettingSuccess];
                
                NSString *text = [[enterPassword stringByAppendingString:person.payPsdSalt] getSha1String];
                
                if (![person.payPassword isEqualToString:text]) {
                    person.payPassword = text;
                    [[WJDBPersonManager new] updatePerson:person];
                }
                
                
                if (self.from == ComeFromPayCode) {
                    WJGeneratedPayCodeController *gvc = [[WJGeneratedPayCodeController alloc] init];
                    [self.navigationController pushViewController:gvc animated:YES whetherJump:YES];
                }
                
                
                if (self.from == ComeFromSafetyQuestion) {
                    WJSafetyQuestionController *sqVC = [[WJSafetyQuestionController alloc] initWithPsdType:SafetyQuestionTypeNew];
                    [(WJNavigationController *)self.navigationController pushViewController:sqVC animated:YES whetherJump:YES];
                }
                
                if (self.from == ComeFromModifyPsd) {
                    
                    WJChangePayPsdController *vc = [[WJChangePayPsdController alloc] initWithPsdType:ChangePayPsdTypeNew resetType:ResetPsyTypeReset];
                    if (self.from == ComeFromModifyPsd) {
                        vc.from = ComeFromModifyPsd;
                    }
                    [self.navigationController pushViewController:vc animated:YES whetherJump:YES];
                }
                
            }
            
        }
        
    } else if([manager isKindOfClass:[APIGetKeyForSALManager class]]){
        NSString * sal1String = [manager fetchDataWithReformer:nil];
        //保存key值 以后要修改存储位置
        if ([sal1String isKindOfClass:[NSString class]]) {
            WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
            [[WJDBPersonManager new] updatePersonSalt:sal1String forPerson:person];
            self.verPayPsdManager.password = [[enterPassword stringByAppendingString:sal1String] getSha1String];
            [self.verPayPsdManager loadData];
        }else{
            [psdArray removeAllObjects];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"支付密码错误，请重新输入"];
        }
    }
    
    [self hiddenLoadingView];

}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager{
    NSLog(@"验证密码请求 Failed");
    [self hiddenLoadingView];
    [psdArray removeAllObjects];
    [tf resignFirstResponder];
    if ([manager isKindOfClass:[APIVerifyPayPwdManager class]]){
    
        if (enterPsdType == ChangePayPsdTypeVerify){

            NSInteger faileNumber = [[dataDic objectForKey:@"errorCount"] intValue];
            if (manager.errorCode == 40) {
                if (faileNumber < 5) {
                   
                    [dataDic setObject:[NSString stringWithFormat:@"%@",@(++faileNumber)] forKey:@"errorCount"];
                    NSLog(@"错误次数==========%ld",(long)faileNumber);
                    NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                    [dataDic setObject:nowTime forKey:@"time"];
                    //记录第一次错误的时间
                    if(faileNumber == 1){
                        [dataDic setObject:nowTime forKey:@"limiteTime"];
                    }
                    [dataDic writeToFile:[self filePatch] atomically:YES];
                }
            }
      
            NSString *messageStr = manager.errorMessage;
            if (messageStr) {
                if ([messageStr length] > 0) {
                    WJAlertView *alert = [[WJAlertView alloc]initWithTitle:nil
                                                                   message:messageStr
                                                                  delegate:self
                                                         cancelButtonTitle:@"取消"
                                                         otherButtonTitles:@"找回支付密码"
                                                             textAlignment:NSTextAlignmentCenter];
                    
                    
                    [alert showIn];
                }
       
            }else{
            
                self.canInputPassword = YES;
                [self showKeyBoard];
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"当前网络不可用，请检查网络"];
            }
        }
        
    }else{
        if (manager.errorMessage) {
            if ([manager.errorMessage length]>0) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:manager.errorMessage];
            }
        }else{
        
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"当前网络不可用，请检查网络"];
       
        }
        
        self.canInputPassword = YES;
        [self showKeyBoard];
    }
}

- (void)showAlertViewAndDistanceTime:(NSInteger)time
{
   
    NSString *messageStr;
    if ((LockTime - time/60)/60 >= 1) {
        messageStr = [NSString stringWithFormat:@"支付密码错误,输入次数过多,请%@小时后再试",@((LockTime - time/60)/60 + 1)];
    }else{
        messageStr = [NSString stringWithFormat:@"支付密码错误，输入次数过多,请%@分钟后再试",@((LockTime - time/60))];
    }

    
    WJAlertView *alert = [[WJAlertView alloc]initWithTitle:nil
                                                   message:messageStr
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"找回支付密码"
                                             textAlignment:NSTextAlignmentCenter];
    [alert showIn];

    
}

#pragma mark - WJAlertDelegate

- (void)wjAlertView:(WJAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 0) {
       
        self.canInputPassword = YES;
        [self showKeyBoard];
    }
    
    if (buttonIndex == 1) {
        //找回方式
        [WJGlobalVariable sharedInstance].fromController = self;
        WJFindPsdWayViewController *findPswVC = [[WJFindPsdWayViewController alloc] init];
        [self.navigationController pushViewController:findPswVC animated:YES whetherJump:YES];
    }
}
#pragma mark - 存储路径和时间比较方法

- (NSInteger)distanceTimeWithBeforeTime:(NSInteger)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    NSInteger distance = now - beTime;
    return distance;
}

- (NSString *)filePatch{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    NSString *filePatch = [path stringByAppendingPathComponent:[person.userID stringByAppendingString:@"errorInformation.plist"]];
    NSLog(@"路径：%@",filePatch);
    return filePatch;
}

#pragma mark - 属性访问方法

- (APIChangePayPsdManager *)changePayPsdManager{
    if (!_changePayPsdManager) {
        _changePayPsdManager = [[APIChangePayPsdManager alloc] init];
        _changePayPsdManager.delegate = self;
        _changePayPsdManager.phone = [WJGlobalVariable sharedInstance].defaultPerson.phone;
        _changePayPsdManager.code = self.verifyCode;
    }
    _changePayPsdManager.password = enterPassword;
    return _changePayPsdManager;
}


//- (APIGetKeyForSALManager *)salGetterManager
//{
//    if (nil == _salGetterManager)
//    {
//        _salGetterManager = [[APIGetKeyForSALManager alloc] init];
//        _salGetterManager.delegate = self;
//    }
//    return _salGetterManager;
//}
//

- (APIVerifyPayPwdManager *)verPayPsdManager
{
    if (nil == _verPayPsdManager) {
        _verPayPsdManager = [[APIVerifyPayPwdManager alloc] init];
        _verPayPsdManager.delegate = self;
    }
    
    return _verPayPsdManager;
}


- (APIInitPasswordManager *)initialPayPsdManager{
    if (!_initialPayPsdManager) {
        _initialPayPsdManager = [APIInitPasswordManager new];
        _initialPayPsdManager.delegate = self;
    }
    _initialPayPsdManager.password = enterPassword;
    return _initialPayPsdManager;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
@end
