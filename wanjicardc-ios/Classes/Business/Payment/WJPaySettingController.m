
//
//  WJPaySettingController.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/2.
//  Copyright (c) 2015年 zOne. All rights reserved.
//
#import "WJPaySettingController.h"
#import "WJPaySettingSwtichCell.h"
#import "WJSafetyQuestionController.h"
#import "WJFindSafetyQuestionController.h"
#import "WJVerifyPasswordController.h"
#import "WJSystemAlertView.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "WJSafetyQuestionController.h"
#import "WJStatisticsManager.h"


@interface WJPaySettingController ()<UITableViewDataSource, UITableViewDelegate,WJSystemAlertViewDelegate,WJPaySettingSwtichCellDelegate>{
    
    UITableView *mTb;
    NSArray *titleArray;     //标题Arr
    BOOL isAvail;      //设备是否支持指纹验证功能
}

@end

@implementation WJPaySettingController

-(void)dealloc
{
    [kDefaultCenter removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"安全设置";
    self.eventID = @"iOS_act_Securitysetting";
    
    //检查设备是否支持指纹验证
    isAvail = [WJGlobalVariable touchIDIsAvailable];
    titleArray = [NSArray arrayWithObjects:@"开启无密支付",@"开启指纹验证", @"开启后，消费时可使用Touch ID验证指纹快速完成支付", @"修改支付密码", @"账户安全问题",@"更换手机号",nil];
    
    [kDefaultCenter addObserver:self selector:@selector(changePhoneNotice) name:kChangePhoneSuccess object:nil];
    [kDefaultCenter addObserver:self selector:@selector(checkView) name:kTouchIDChange object:nil];
    
    mTb = [[UITableView alloc] initForAutoLayout];
    mTb.delegate = self;
    mTb.dataSource = self;
    mTb.scrollEnabled = NO;
    mTb.separatorInset = UIEdgeInsetsZero;
    mTb.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    mTb.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    mTb.separatorColor = [WJUtilityMethod colorWithHexColorString:@"e6e7e8"];
    mTb.backgroundColor = WJColorViewBg;
    [self.view addSubview:mTb];
    
    
    [self.view VFLToConstraints:@"H:|[mTb]|" views:NSDictionaryOfVariableBindings(mTb)];
    [self.view VFLToConstraints:@"V:|[mTb]|" views:NSDictionaryOfVariableBindings(mTb)];
    
    UILabel *numberL = [[UILabel alloc]initForAutoLayout];
    numberL.textAlignment = NSTextAlignmentCenter;
    numberL.text = @"万集卡客服电话400-872-2002";
    numberL.textColor = WJColorDardGray9;
    numberL.font = WJFont10;
    numberL.numberOfLines = 0;
    [self.view addSubview:numberL];
    [self.view addConstraints:[numberL constraintsBottomInContainer:ALD(40)]];
    [self.view addConstraint:[numberL constraintCenterXEqualToView:self.view]];
    [self.view addConstraints:[numberL constraintsSize:CGSizeMake(ALD(100), ALD(40))]];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self checkView];
}


- (void)checkView
{
    //检查设备是否支持指纹验证
    isAvail = [WJGlobalVariable touchIDIsAvailable];
    [mTb reloadData];
    
    //刷新开发状态
    [self verifySwitchStateWithIdenty:0];
    [self verifySwitchStateWithIdenty:1];
}


#pragma mark- Event Response

- (void)changePhoneNotice{
    
    ALERT(@"手机号更改成功");
    [mTb reloadData];
    [self.navigationController popToViewController:self animated:YES];
    
}

- (void)reloadCurrentData
{
    [mTb reloadData];
}


#pragma mark - UIButton Action
//修改开关状态
- (void)verifySwitchStateWithIdenty:(int)num{
    
    if (num == 0) {
        WJPaySettingSwtichCell *cell = (WJPaySettingSwtichCell *)[mTb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        //保持无密开关状态和存储key值状态一致
        NSString *key = KPasswordSwitch;
        if (key) {
            cell.switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:key];
        }
    }
    if (num == 1) {
        WJPaySettingSwtichCell *cell = (WJPaySettingSwtichCell *)[mTb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
        //保持无密开关状态和存储key值状态一致
        NSString *key = KFingerIdentySwitch;
        if (key) {
            cell.switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:key];
        }
    }
    
}


//打开无密开关密码验证成功后
- (void)openSwitch:(NSNotification *)notice{
    
    if ([notice userInfo]) {
        //开启指纹
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"开启成功"];
        [self setUserDefaultWithDifference:1 Bool:YES];
        [self verifySwitchStateWithIdenty:1];
        [self.navigationController popToViewController:self animated:YES];
    }else{
        
        //开启无密
        [self setUserDefaultWithDifference:0 Bool:YES];
        [self verifySwitchStateWithIdenty:0];
        [self.navigationController popToViewController:self animated:YES];
    }
    
    [kDefaultCenter removeObserver:self name:@"PasswordSwitchProvingPass" object:nil];
    
}


//修改本地值
-(void)setUserDefaultWithDifference:(int)identy Bool:(BOOL)setBool
{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    
    if (identy == 0) {
        NSString *key = KPasswordSwitch;
        if (key) {
            [accountDefaults setBool:setBool forKey:key];
        }
    }
    
    if (identy == 1) {
        NSString *key = KFingerIdentySwitch;
        if (key) {
            [accountDefaults setBool:setBool forKey:key];
        }
    }
}


-(void)showAlterViewWithIndex:(NSIndexPath *)index
{
    if(index.row == 0){
        
        WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
                                                                    message:@"老板，你确定要关闭无密支付功能？"
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"确定"
                                                              textAlignment:NSTextAlignmentCenter];
        alert.alertTag = 1;
        [alert showIn];
        
    }
    if(index.row == 1){
        
        WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil
                                                                    message:@"确定关闭指纹验证？"
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"关闭"
                                                              textAlignment:NSTextAlignmentCenter];
        alert.alertTag = 2;
        [alert showIn];
        
    }
    
}


#pragma mark----WJSystemAlertViewDelegate

- (void)wjAlertView:(WJSystemAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //无密
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            [self verifySwitchStateWithIdenty:0];
        }
        if (buttonIndex == 1) {
            
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"无密支付功能已关闭"];
            [self setUserDefaultWithDifference:0 Bool:NO];
            [self verifySwitchStateWithIdenty:0];
        }
    }
    //指纹
    if (alertView.tag == 2) {
        if(buttonIndex == 0){
            [self verifySwitchStateWithIdenty:1];
        }
        
        if (buttonIndex == 1) {
            
            [self setUserDefaultWithDifference:1 Bool:NO];
            [self verifySwitchStateWithIdenty:1];
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"关闭成功"];
        }
    }
}


#pragma mark----WJPaySettingSwtichCellDelegate

- (void)switchCell:(WJPaySettingSwtichCell *)cell cellIndex:(NSIndexPath *)index
{
    if (index.row == 0) {
        NSString *key = KPasswordSwitch;
        BOOL isPasswordSwitchOn = NO;
        if (key) {
            isPasswordSwitchOn = [[NSUserDefaults standardUserDefaults] boolForKey:key];
        }
        if (!isPasswordSwitchOn) {
            if (![WJUtilityMethod isNotReachable]) {
                cell.switchView.on = NO;
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"当前网络不可用，请检查网络"];
            }else{
                
                WJVerifyPasswordController *verifyVC = [[WJVerifyPasswordController alloc] init];
                [WJGlobalVariable sharedInstance].fromController = self;
                verifyVC.from = ComeFromOpenNoPsd;
                [self.navigationController pushViewController:verifyVC animated:YES];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openSwitch:) name:@"PasswordSwitchProvingPass" object:nil];
            }
        }else{
            
            [self showAlterViewWithIndex:index];
        }
    }
    if (index.row == 1) {
        
        
        NSString *fingerIdenty = KFingerIdentySwitch;
        BOOL isBool = NO;
        if (fingerIdenty) {
            isBool = [[NSUserDefaults standardUserDefaults] boolForKey:fingerIdenty];
        }
        //开启指纹验证
        if (!isBool) {
            if(![WJUtilityMethod isNotReachable]){
                
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"当前网络不可用，请检查网络"];
                cell.switchView.on = NO;
                
            }else{
                
                if(IOS8_LATER){
                    
                    //进行指纹识别，获取指纹验证结果
                    LAContext *context = [LAContext new];
                    context.localizedFallbackTitle = @"";
                    
                    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"通过Home键验证已有手机指纹",nil) reply:^(BOOL success, NSError * _Nullable error) {
                        
                        if (success) {
                            NSLog(@"恭喜，您通过了Touch ID指纹验证！") ;
                            
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                
                                //成功跳转支付密码验证页
                                WJVerifyPasswordController *verifyVC = [[WJVerifyPasswordController alloc] init];
                                [WJGlobalVariable sharedInstance].fromController = self;
                                verifyVC.from = ComeFromTouchID;
                                [self.navigationController pushViewController:verifyVC animated:YES];
                                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openSwitch:) name:@"PasswordSwitchProvingPass" object:nil];
                                
                            }];
                            
                        }else{
                            
                            switch (error.code) {
                                case LAErrorSystemCancel:
                                {
                                    NSLog(@"Authentication was cancelled by the system");
                                    //切换到其他APP，系统取消验证Touch ID
                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                        //用户选择输入密码，切换主线程处理
                                        [cell.switchView setOn:NO];
                                        
                                    }];
                                    break;
                                }
                                case LAErrorUserCancel:
                                {
                                    NSLog(@"Authentication was cancelled by the user");
                                    //用户取消验证Touch ID
                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                        //用户选择输入密码，切换主线程处理
                                        [cell.switchView setOn:NO];
                                        
                                    }];
                                    break;
                                }
                                case LAErrorUserFallback:
                                {
                                    NSLog(@"User selected to enter custom password");
                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                        //用户选择输入密码，切换主线程处理
                                        [cell.switchView setOn:NO];
                                        
                                    }];
                                    break;
                                }
                                default:
                                {
                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                        //其他情况，切换主线程处理
                                        
                                        [cell.switchView setOn:NO];
                                        
                                        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"指纹不匹配"];
                                    }];
                                    break;
                                }
                            }
                            
                        }
                    }];
                    
                }
                
            }
            
        }else{
            
            //关闭指纹验证
            [self showAlterViewWithIndex:index];
            
        }
    }
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    footView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e6e7e8"];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1){
        
        return isAvail ?  MAX(ALD(45), 44): 0;
        
    }else if(indexPath.row == 2){
        
        return isAvail ?  MAX(ALD(32), 32): 0;
        
    }else{
        
        return MAX(ALD(45), 44);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
    if(indexPath.row == 0 || indexPath.row == 1){
        
        WJPaySettingSwtichCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell1"];
        if (cell == nil) {
            cell = [[WJPaySettingSwtichCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            cell.clipsToBounds = YES;
            cell.delegate = self;
            
        }
        
        cell.textL.text = [titleArray objectAtIndex:indexPath.row];
        cell.myIndex = indexPath;
        
        if (indexPath.row == 0) {
            NSString *isPsdKey = KPasswordSwitch;
            BOOL isBool = NO;
            if (isPsdKey) {
                isBool = [[NSUserDefaults standardUserDefaults] boolForKey:isPsdKey];
            }
            cell.switchView.on = isBool;
        }
        if (indexPath.row == 1) {
            NSString *fingerIdenty = KFingerIdentySwitch;
            BOOL isBool = NO;
            if (fingerIdenty) {
                isBool = [[NSUserDefaults standardUserDefaults] boolForKey:fingerIdenty];
            }
            cell.switchView.on = isBool;
        }
        
        return cell;
        
    }else{
        
        if (indexPath.row == 2) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell2"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell2"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.backgroundColor = WJColorViewBg;
                cell.textLabel.textColor = WJColorLightGray;
                cell.textLabel.font = WJFont12;
            }
            if (isAvail) {
                cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
            }else{
                cell.textLabel.text = @"";
            }
            return cell;
            
        }else{
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell3"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell3"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.textColor = WJColorDarkGray;
                cell.textLabel.font = WJFont15;
                
                CGFloat cellHeight = MAX(ALD(45), 44);
                UIView *accView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ALD(150), cellHeight)];
                accView.backgroundColor = [UIColor clearColor];
                
                UIImageView * rightIV = [[UIImageView alloc] initWithFrame:CGRectMake(accView.width - ALD(6), (cellHeight-ALD(11))/2, ALD(6), ALD(11))];
                rightIV.image = [UIImage imageNamed:@"details_rightArrowIcon"];
                [accView addSubview:rightIV];
                
                UILabel *stateL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, accView.width - ALD(16), cellHeight)];
                stateL.textAlignment = NSTextAlignmentRight;
                stateL.tag = 5000 + indexPath.row;
                stateL.textColor = WJColorLightGray;
                stateL.font = WJFont12;
                [accView addSubview:stateL];
                cell.accessoryView = accView;
                
            }
            cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
            
            UIView *accView = (UIView *)cell.accessoryView;
            UILabel *stateL = [accView viewWithTag:5000 + indexPath.row];
            
            if (indexPath.row == 4){
                stateL.text = @"已设置";
                if (!person.isSetPsdQuestion) {
                    stateL.text = @"未设置";
                    stateL.textColor = WJColorAmount;
                }
            }
            
            if (indexPath.row == 5) {
                stateL.text = [person.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }
            
            return cell;
        }
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0,12);
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0,12);
        //        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WJModelPerson * person = [WJGlobalVariable sharedInstance].defaultPerson;
    if (indexPath.row >2) {
        
        switch (indexPath.row) {
            case 3:{
                if(person.isSetPayPassword){
                    
                    WJVerifyPasswordController *verifyVC = [[WJVerifyPasswordController alloc] init];
                    [WJGlobalVariable sharedInstance].fromController = self;
                    verifyVC.from = ComeFromModifyPsd;
                    [self.navigationController pushViewController:verifyVC animated:YES];
                }
            }
                break;
                
            case 4:{
                
                if(person.isSetPsdQuestion) {
                    WJSafetyQuestionController * safeVC = [[WJSafetyQuestionController alloc] init];
                    [self.navigationController pushViewController:safeVC animated:YES];
                } else {
                    
                    WJVerifyPasswordController *verifyVC = [[WJVerifyPasswordController alloc] init];
                    [WJGlobalVariable sharedInstance].fromController = self;
                    verifyVC.from = ComeFromSafetyQuestion;
                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadCurrentData) name:@"safetyQuestion" object:nil];
                    [self.navigationController pushViewController:verifyVC animated:YES];
                }
            }
                break;
                
            case 5:{
                
                WJVerifyPasswordController *verifyVC = [[WJVerifyPasswordController alloc] init];
                [WJGlobalVariable sharedInstance].fromController = self;
                verifyVC.orginPhone = person.phone;
                verifyVC.from = ComeFromChangePhone;
                [self.navigationController pushViewController:verifyVC animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }
}


@end
