//
//  WJChangePayPsdForPhoneController.m
//  WanJiCard
//
//  Created by Angie on 15/12/14.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJChangePayPsdForPhoneController.h"
#import "APIUserInfoVerifyManager.h"
#import "WJAppealViewController.h"
#import "WJVerifyNewPhoneController.h"
#import "WJFindPsdWayViewController.h"
#import "WJAlertView.h"

#define LockTime 3 * 60
#define LimiteTime 60 * 3

@interface WJChangePayPsdForPhoneController ()<APIManagerCallBackDelegate,WJAlertViewDelegate>{
    NSString *enterPassword;
    NSMutableDictionary *dataDic;
    NSString *orginPhone;
    
}

@property (nonatomic, strong) APIUserInfoVerifyManager  * userInfoVerifyManager;

@end

@implementation WJChangePayPsdForPhoneController

- (instancetype)initWithPhone:(NSString *)phone{
    if (self = [super init]) {
        orginPhone = phone;
        enterPsdType = ChangePayPsdTypeVerify;
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString *filePath = [self filePatch];
    dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    if (dataDic == nil) {
        dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"errorCount",@"0",@"time",@"0",@"limiteTime", nil];
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filePath contents:nil attributes:nil];
        [dataDic writeToFile:filePath atomically:YES];
    }
    
    self.canInputPassword = YES;
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
   
    if (![WJUtilityMethod isNetReachable]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"当前网络不可用，请检查网络"];
        [psdArray removeAllObjects];
        self.canInputPassword = YES;
    }else{
        
        [self showLoadingView];
        [self.userInfoVerifyManager loadData];
    }

}

- (NSString *)filePatch{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    NSString *filePatch = [path stringByAppendingPathComponent:[person.userID stringByAppendingString:@"errorInformation.plist"]];

    return filePatch;
}

- (NSInteger)distanceTimeWithBeforeTime:(NSInteger)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    NSInteger distance = now - beTime;
    return distance;
}


//#pragma mark - alertDelegate
//- (void)wjAlertView:(WJAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        self.canInputPassword = YES;
//        [tf becomeFirstResponder];
//    }
//    if (buttonIndex == 1){
//        
//        //找回方式
//        WJFindPsdWayViewController *findPswVC = [[WJFindPsdWayViewController alloc] init];
//        [self.navigationController pushViewController:findPswVC animated:YES];
//    }
//    
//}

#pragma mark - API

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager{
    
    if ([manager isKindOfClass:[APIUserInfoVerifyManager class]]) {
        
        [self hiddenLoadingView];

        NSString *filePath = [self filePatch];
        [dataDic setObject:@"0" forKey:@"errorCount"];
        [dataDic setObject:@"0" forKey:@"time"];
        [dataDic setObject:@"0" forKey:@"lockTime"];
        [dataDic writeToFile:filePath atomically:YES];
        
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            NSString *token = [dic objectForKey:@"token"];
            [self infoWithToken:token status:nil];
        }
        
        WJVerifyNewPhoneController *vc = [[WJVerifyNewPhoneController alloc] initWithPhone:orginPhone];
        [self.navigationController pushViewController:vc animated:YES whetherJump:YES];
    }
    
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager{
    NSLog(@"验证密码请求 Failed");
    [self hiddenLoadingView];
    [psdArray removeAllObjects];
    [self cleanPsdView];
    [tf resignFirstResponder];
   
    //如果是验证失败
    if (manager.errorCode == 50008052 || manager.errorCode == 50008053) {
    
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *status = ToString([dic objectForKey:@"appealStatus"]);
            if(status){
                [self infoWithToken:nil status:status];
            }

            NSInteger faileNumber = [[dataDic objectForKey:@"errorCount"] intValue];
            if (faileNumber < 5) {
                
                [dataDic setObject:[NSString stringWithFormat:@"%@",@(++faileNumber)] forKey:@"errorCount"];
                NSString *nowTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                [dataDic setObject:nowTime forKey:@"time"];
                //记录第一次错误的时间
                if(faileNumber == 1){
                    [dataDic setObject:nowTime forKey:@"limiteTime"];
                }
                [dataDic writeToFile:[self filePatch] atomically:YES];

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
                [tf becomeFirstResponder];
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"当前网络不可用，请检查网络"];
            }
        }
        
    }else{
        
        NSString *messageStr = manager.errorMessage;
        if(messageStr){

            [[TKAlertCenter defaultCenter] postAlertWithMessage:manager.errorMessage];
        }
        self.canInputPassword = YES;
        [tf becomeFirstResponder];
    }
}


- (void)infoWithToken:(NSString *)token status:(NSString *)status
{
    [[NSUserDefaults standardUserDefaults] setObject:@{@"phone" : orginPhone,
                                                       @"token" : token?:@"",
                                                       @"appealStatus" : status?:@""}
                                              forKey:kTokenForChangePhone];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}
                                    
- (APIUserInfoVerifyManager *)userInfoVerifyManager{
    if (!_userInfoVerifyManager) {
        _userInfoVerifyManager = [APIUserInfoVerifyManager new];
        _userInfoVerifyManager.delegate = self;
    }
    
    _userInfoVerifyManager.phone = orginPhone;
    _userInfoVerifyManager.payPassword = enterPassword;
    
    return _userInfoVerifyManager;
}

@end
