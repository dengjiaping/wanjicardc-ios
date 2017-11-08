//
//  WJGeneratedPayCodeController.m
//  WanJiCard
//
//  Created by Angie on 15/9/8.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJGeneratedPayCodeController.h"

#import "APIQRCodeManager.h"
#import "APISpendConsumeManager.h"

#import "APIQRCodeManager.h"

#import <ZXingObjC/ZXingObjC.h>

#import "SM3Generation.h"
#import "NSString+SHA.h"
#import "NSString+CoculationSize.h"

#import "CreatQRCodeAndBarCodeFromLeon.h"


@interface WJGeneratedPayCodeController ()<APIManagerCallBackDelegate>{
    UIImageView *QBarImageView;
    UIImageView *QRImageView;
    UIImageView *qrCodeView;
    UILabel *qbarL;
    
    CGFloat screenLight;
    NSTimer *screenLightimer;
}

@end

@implementation WJGeneratedPayCodeController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    isCorrectedBundleId;
    self.navigationController.navigationBarHidden = YES;
    
    screenLight = [[UIScreen mainScreen] brightness];
    [self changeBright];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self changeDark];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"#343746"];
    self.eventID = @"iOS_act_qrcode";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(8, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    BOOL status = [WJUtilityMethod isValidateDevice:[WJGlobalVariable sharedInstance].currentID];
    if (!status) {
        ALERT(@"设备异常");
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBright) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDark) name:UIApplicationWillResignActiveNotification object:nil];
    
 
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 44)];
    titleL.centerX = kScreenWidth/2;
    titleL.text = @"付款";
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = [UIColor whiteColor];
    titleL.font = WJFont18;
    [self.view addSubview:titleL];
    
    UIView *baseBg = [[UIView alloc] initWithFrame:CGRectMake(ALD(15), 0, kScreenWidth - ALD(30), ALD(467))];
    baseBg.center = self.view.center;
    if (kScreenHeight < 500) {
        baseBg.y = 64;
    }
    baseBg.backgroundColor = [UIColor whiteColor];
    baseBg.layer.cornerRadius = 4;
    baseBg.clipsToBounds = YES;
    [self.view addSubview:baseBg];
    
    
    UIView *upBaseBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, baseBg.width, ALD(130))];
    upBaseBg.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"#f7f6f4"];
    [baseBg addSubview:upBaseBg];

    QBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ALD(18), ALD(300), ALD(75))];
    QBarImageView.centerX = upBaseBg.centerX;
    [baseBg addSubview:QBarImageView];
    
    qbarL = [[UILabel alloc] initWithFrame:CGRectMake(0, QBarImageView.bottom, baseBg.width, ALD(26))];
    qbarL.textAlignment = NSTextAlignmentCenter;
    qbarL.textColor = WJColorDardGray3;
    qbarL.font = WJFont14;
    [baseBg addSubview:qbarL];
    
    
    UIView *downBaseBg = [[UIView alloc] initWithFrame:CGRectMake(0, upBaseBg.bottom, baseBg.width, baseBg.height-ALD(130))];
    downBaseBg.backgroundColor = WJColorViewBg;
    [baseBg addSubview:downBaseBg];

    
    qrCodeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, upBaseBg.bottom+10, ALD(188), ALD(188))];
    qrCodeView.centerX = downBaseBg.centerX;
//    qrCodeView.errorCorrectionLevel = MIHErrorCorrectionLevelMedium;
    [baseBg addSubview:qrCodeView];

    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(qrCodeView.x, qrCodeView.bottom+ALD(25), qrCodeView.width, ALD(40));
    [refreshBtn setBackgroundColor:WJColorNavigationBar];
    [refreshBtn setTitle:@"更新二维码" forState:UIControlStateNormal];
    refreshBtn.layer.cornerRadius = 4;
    [refreshBtn addTarget:self action:@selector(refreshQRImage) forControlEvents:UIControlEventTouchUpInside];
    [baseBg addSubview:refreshBtn];

    [self requestPayCode];
}


- (void)changeScreenLight:(NSTimer *)time{
    BOOL moreLight = [time.userInfo[@"moreLight"] boolValue];
    if (moreLight) {
        CGFloat light = [UIScreen mainScreen].brightness;
        if (light >= 1.0) {
            [time invalidate];
            time = nil;
        }else{
            [UIScreen mainScreen].brightness = light+0.03;
        }
    }else{
        CGFloat light = [UIScreen mainScreen].brightness;
        if (light <= screenLight) {
            [time invalidate];
            time = nil;
        }else{
            [UIScreen mainScreen].brightness = light-0.03;
        }
    }
}

- (void)changeBright
{
    screenLightimer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(changeScreenLight:) userInfo:@{@"moreLight":@(YES)} repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:screenLightimer forMode:NSRunLoopCommonModes];
}

- (void)changeDark
{
    screenLightimer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(changeScreenLight:) userInfo:@{@"moreLight":@(NO)} repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:screenLightimer forMode:NSRunLoopCommonModes];
}


#pragma mark - UIButton Action

- (void)backBtn{
    [screenLightimer invalidate];
    screenLightimer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)refreshQRImage{
    [self requestPayCode];
}


#pragma mark - Logic

- (void)generatedQR:(NSString *)qrCode{

    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:qrCode
                                  format:kBarcodeFormatCode128
                                   width:300
                                  height:70
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        QBarImageView.image = [UIImage imageWithCGImage:image];
    }
    
    qbarL.text = [qrCode macCodeFormaterWithString];
    qrCodeView.image = [CreatQRCodeAndBarCodeFromLeon qrImageWithString:qrCode size:qrCodeView.size color:WJColorBlack backGroundColor:WJColorWhite correctionLevel:ErrorCorrectionLevelMedium];
}

#pragma mark - Request

- (void)requestPayCode{
  
    
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;

    if (person.token.length == 32 && person.payPassword.length > 18) {
        
        NSString *key = [person.token stringByAppendingString:person.payPassword];
        
        NSTimeInterval serverTimeSubLocal = [[[NSUserDefaults standardUserDefaults] objectForKey:kServerTimeSubLocal] doubleValue];
        
        int time = [[NSDate date] timeIntervalSince1970] + serverTimeSubLocal;
        
        NSString *qrToken = [SM3Generation getTokenWithSM3TOTP:time tokenChangeDuring:5 priKey:[key substringWithRange:NSMakeRange(18, 32)] tokenLength:6];
        
        NSString *qrString = [NSString stringWithFormat:@"86%@%@", [person.phone substringFromIndex:1], qrToken];
        
        [self generatedQR:qrString];
    }else{
        if (person.payPassword.length<=18) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"错误18，请重新设置支付密码"];
        }else {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"错误32，请重新登录"];
        }
    }
}


#pragma mark -

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
