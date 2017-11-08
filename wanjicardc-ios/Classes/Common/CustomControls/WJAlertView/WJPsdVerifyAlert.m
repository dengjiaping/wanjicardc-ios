//
//  WJPsdVerifyAlert.m
//  WanJiCard
//
//  Created by 孙明月 on 16/8/16.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJPsdVerifyAlert.h"

#define IVTag  200
#define LockTime 60 * 3
#define LimiteTime 60 * 3

@implementation WJPsdVerifyAlert
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.bounds]) {
        self.alertTag = kPsdAlertViewTag;
        self.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.5f];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - ALD(270))/2, ALD(231), ALD(270), ALD(165))];
        backView.layer.masksToBounds = YES;
        backView.layer.cornerRadius = 13;
//        backView.center = self.center;
        backView.backgroundColor = WJColorViewBg;
        [self addSubview:backView];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backView.width, ALD(50))];
        titleL.text = @"请验证支付密码";
        titleL.font = WJFont17;
        titleL.textColor = WJColorDarkGray;
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.userInteractionEnabled = YES;
        [backView addSubview:titleL];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(ALD(15), ALD(18), ALD(14), ALD(14));
        [closeBtn setImage:[UIImage imageNamed:@"inventedcard_ic_close_press"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:closeBtn];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, titleL.bottom, backView.width, 0.5)];
        line.backgroundColor = WJColorSeparatorLine;
        [backView addSubview:line];
        
        psdArray = [NSMutableArray arrayWithCapacity:0];
        NSString *filePath = [WJGlobalVariable payPasswordVerifyFailedErrorFilePatch];
        dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        if (dataDic == nil) {
            dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"errorCount",@"0",@"time", @"0",@"limiteTime",nil];
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm createFileAtPath:filePath contents:nil attributes:nil];
            [dataDic writeToFile:filePath atomically:YES];
        }
        
        enterBg = [[UIView alloc] initWithFrame:CGRectMake(ALD(15), line.bottom + ALD(27), ALD(240), ALD(40))];
        [enterBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyBoard)]];
        //        enterBg.layer.cornerRadius = 5;
        //        enterBg.clipsToBounds = YES;
        enterBg.backgroundColor = WJColorWhite;
        enterBg.layer.borderColor = WJColorDarkGrayLine.CGColor;
        enterBg.layer.borderWidth = 1;
        [backView addSubview:enterBg];
        
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
        UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [forgetBtn setBackgroundColor:[UIColor clearColor]];
        forgetBtn.frame = CGRectMake((backView.width-ALD(90))/2, CGRectGetMaxY(enterBg.frame)+ALD(16), ALD(90), ALD(20));
        [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [forgetBtn.titleLabel setFont:WJFont12];
        //        [forgetBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [forgetBtn setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [forgetBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:forgetBtn];
        
        
        tf = [[UITextField alloc] initWithFrame:CGRectMake(-100, 0, 103, 20)];
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.delegate = self;
        tf.alpha = 0;
        [self addSubview:tf];
        
        [self showKeyBoard];
        [self changeInputState];
        
    }
    
    return self;
}


- (void)showIn
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.alpha = 0;
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1;
    }];
    self.tag = self.alertTag;
    [window addSubview:self];
}


- (void)dismiss
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *alertView = [window viewWithTag:self.alertTag];
    [UIView animateWithDuration:0.16f animations:^{
        alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [alertView removeFromSuperview];
    }];
}


- (void)forgetPassword
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(findPasswordWithAlert:)]) {
        [self.delegate findPasswordWithAlert:self];
    }
}


- (void)showKeyBoard{
    [tf becomeFirstResponder];
}


- (void)cleanPsdView{
    for (UIImageView *iv in enterPsdViews) {
        iv.highlighted = NO;
    }
    selectedIvTag = IVTag;
}


- (void)changeInputState
{
    for (UIImageView *iv in enterPsdViews) {
        iv.highlighted = NO;
    }
    [psdArray removeAllObjects];
    self.canInputPassword = YES;
    
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
    
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    if(person){
        NSString *input = [enterPassword stringByAppendingString:person.payPsdSalt];
        self.verPayPsdManager.password = [input getSha1String];
        [self.verPayPsdManager loadData];
    }
}


#pragma mark - APIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    
    //本地验证次数归零
    [WJGlobalVariable payPasswordVerifySuccess];
    
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    //    NSDictionary *dic = [manager fetchDataWithReformer:nil];
    if (person) {
        NSString *text = [[enterPassword stringByAppendingString:person.payPsdSalt] getSha1String];
        if (![person.payPassword isEqualToString:text]) {
            person.payPassword = text;
            [[WJDBPersonManager new] updatePerson:person];
        }
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(successWithVerifyPsdAlert:)]){
        
        [self.delegate successWithVerifyPsdAlert:self];
    }
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager{
    
    [psdArray removeAllObjects];
    [tf resignFirstResponder];
    
    //验证失败
    if (manager.errorCode == 50008052 || manager.errorCode == 50008053) {
        
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        [self recordErrorNumber];
        
        NSString *errMsg = manager.errorMessage;
        if (errMsg) {
            if (errMsg.length > 0) {
                
                if(self.delegate && [self.delegate respondsToSelector:@selector(failedWithVerifyPsdAlert:errerMessage:isLocked:)]){
                    [self.delegate failedWithVerifyPsdAlert:self errerMessage:manager.errorMessage isLocked:[dic[@"lockedStatus"] boolValue] ?YES:NO];
                }
                
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


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.canInputPassword) {
        if (string.length == 0) {
            if (selectedIvTag > IVTag) {
                selectedIvTag -= 1;
                UIImageView *iv = (UIImageView *)[self viewWithTag:selectedIvTag];
                iv.highlighted = NO;
                [psdArray removeLastObject];
            }
        }else{
            if (selectedIvTag < 206) {
                UIImageView *iv = (UIImageView *)[self viewWithTag:selectedIvTag];
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


#pragma mark - 存储路径和时间比较方法

- (NSInteger)distanceTimeWithBeforeTime:(NSInteger)beTime
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSInteger distance = now - beTime;
    return distance;
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


#pragma mark - 属性访问方法
- (void)setAlertTag:(NSInteger)alertTag
{
    if (_alertTag != alertTag) {
        _alertTag = alertTag;
        self.tag = alertTag;
    }
}


- (APIVerifyPayPwdManager *)verPayPsdManager
{
    if (nil == _verPayPsdManager) {
        _verPayPsdManager = [[APIVerifyPayPwdManager alloc] init];
        _verPayPsdManager.delegate = self;
    }
    
    return _verPayPsdManager;
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
