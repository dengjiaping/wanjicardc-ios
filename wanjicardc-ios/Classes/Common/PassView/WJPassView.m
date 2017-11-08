//
//  WJPassView.m
//  WanJiCard
//
//  Created by 林有亮 on 16/8/17.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJPassView.h"

#import "APIVerifyPayPwdManager.h"
#import "WJSystemAlertView.h"

#define IVTag  200
#define LockTime 60 * 3
#define LimiteTime 60 * 3

@interface WJPassView ()<UITextFieldDelegate, APIManagerCallBackDelegate, WJSystemAlertViewDelegate>
{
    UIView      * bgView;
    UIView      * blackView;
    UIButton    * closeButton;
    UIButton    * helpButton;
    UILabel     * titleLabel;
    UIView      * topLine;
    UILabel     * conttentLabel;
    UIImageView * baoziImageView;
    UILabel     * baoziNumberLabel;
    UIView      * bottomLine;
    UILabel     * baoziHasNumLabel;
    UIButton    * submitButton;
    UIButton    * bottomButton;
    UIImageView * tipImageView;
    UILabel     * tipLabel;
   
    UITextField *tf;
    UIView * enterBg;
    NSMutableArray *enterPsdViews;
    NSInteger selectedIvTag;
    NSString *enterPassword;
    NSMutableDictionary *dataDic;
    NSMutableArray *psdArray;

}

@property (nonatomic, assign) PassViewType type;

@property (nonatomic, assign) BOOL canInputPassword;
@property (nonatomic ,strong) APIVerifyPayPwdManager *verPayPsdManager;

@end

@implementation WJPassView

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                     cardName:(NSString *)cardName
                    faceValue:(NSString *)faceValue
                      cardNum:(NSString *)cardNum
                 baoziNeedNum:(NSString *)baoziNeedNum
                  baoziHasNum:(NSString *)baoziHasNum
                 passViewType:(PassViewType)passViewType
{
    if (self = [super initWithFrame:frame]) {
        self.alertTag = kBuyECardPsdAlertViewTag;
        self.type = passViewType;
        //        CGFloat height = CGRectGetHeight(frame);
        UIColor * lineColor = [WJUtilityMethod colorWithHexColorString:@"d9d9d9"];
        blackView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = .4;
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(ALD(52), ALD(100), kScreenWidth -  ALD(104), kScreenWidth -  ALD(74))];
        bgView.backgroundColor = [UIColor whiteColor];
        CGFloat width = CGRectGetWidth(bgView.frame);

        bgView.layer.cornerRadius = 10;
        
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(ALD(16), ALD(18), ALD(14), ALD(14))];
        [closeButton setImage:[UIImage imageNamed:@"inventedcard_ic_close"] forState:UIControlStateNormal];
        [closeButton setImage:[UIImage imageNamed:@"inventedcard_ic_close_press"] forState:UIControlStateHighlighted];
        [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        
        helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [helpButton setFrame:CGRectMake(width - ALD(30), ALD(18), ALD(14), ALD(14))];
        [helpButton setImage:[UIImage imageNamed:@"inventedcard_ic_doubt"] forState:UIControlStateNormal];
        [helpButton setImage:[UIImage imageNamed:@"inventedcard_ic_doubt_press"] forState:UIControlStateHighlighted];
        [helpButton addTarget:self action:@selector(helpAction) forControlEvents:UIControlEventTouchUpInside];
    
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(30), 0, width - ALD(60), ALD(50))];
        titleLabel.font = WJFont17;
        titleLabel.textColor = WJColorDarkGray;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        topLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(50), width, 1)];
        topLine.backgroundColor = lineColor;
        
        conttentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(16), ALD(10) + CGRectGetMaxY(topLine.frame),  width - ALD(32), ALD(40))];
        conttentLabel.font = WJFont13;
        conttentLabel.textColor = WJColorDarkGray;
        conttentLabel.textAlignment = NSTextAlignmentCenter;
        conttentLabel.numberOfLines = 0;
        conttentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        baoziImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inventedcard_ic_baozi"]];
        baoziNumberLabel = [[UILabel alloc] init];
        baoziNumberLabel.font = WJFont32;
        baoziNumberLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"d9a109"];
        
        bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = lineColor;
        
        baoziHasNumLabel = [[UILabel alloc] init];
        baoziHasNumLabel.textColor = WJColorDarkGray;
        baoziHasNumLabel.font = WJFont12;
        
        psdArray = [NSMutableArray arrayWithCapacity:0];
        NSString *filePath = [WJGlobalVariable payPasswordVerifyFailedErrorFilePatch];
        dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        if (dataDic == nil) {
            dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"errorCount",@"0",@"time", @"0",@"limiteTime",nil];
            NSFileManager *fm = [NSFileManager defaultManager];
            [fm createFileAtPath:filePath contents:nil attributes:nil];
            [dataDic writeToFile:filePath atomically:YES];
        }
        
        enterBg = [[UIView alloc] initWithFrame:CGRectMake(ALD(16), baoziHasNumLabel.bottom + ALD(12), width - ALD(32), ALD(40))];
        [enterBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyBoard)]];
        //        enterBg.layer.cornerRadius = 5;
        //        enterBg.clipsToBounds = YES;
        enterBg.backgroundColor = WJColorWhite;
        enterBg.layer.borderColor = WJColorDarkGrayLine.CGColor;
        enterBg.layer.borderWidth = 1;
        
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
        
        submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        submitButton.layer.cornerRadius = 5;
        submitButton.backgroundColor = WJColorNavigationBar;
        [submitButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
        
        bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomButton addTarget:self action:@selector(bottonAction) forControlEvents:UIControlEventTouchUpInside];
        bottomButton.backgroundColor = WJColorWhite;
        [bottomButton setTitleColor:[WJUtilityMethod colorWithHexColorString:@"007aff"] forState:UIControlStateNormal];
        [bottomButton setTitleColor:[WJUtilityMethod colorWithHexColorString:@"2c9ed7"] forState:UIControlStateNormal];
        bottomButton.titleLabel.font = WJFont12;
        
        tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inventedcard_ic_lack"]];
        
        tipLabel = [[UILabel alloc] init];
        tipLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"FF635B"];
        tipLabel.font = WJFont12;
        tipLabel.text = @"包子数不足";
        [tipLabel sizeToFit];
        
        tf = [[UITextField alloc] initWithFrame:CGRectMake(-100, 0, 103, 20)];
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.delegate = self;
        tf.alpha = 0;
        [self addSubview:tf];
        
        
        [bgView addSubview:closeButton];
        [bgView addSubview:helpButton];
        [bgView addSubview:titleLabel];
        [bgView addSubview:topLine];
        [bgView addSubview:conttentLabel];
        [bgView addSubview:baoziImageView];
        [bgView addSubview:baoziNumberLabel];
        [bgView addSubview:bottomLine];
        [bgView addSubview:baoziHasNumLabel];
        [bgView addSubview:enterBg];
        [bgView addSubview:submitButton];
        [bgView addSubview:bottomButton];
        [bgView addSubview:tipImageView];
        [bgView addSubview:tipLabel];
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:blackView];
        [self addSubview:bgView];
        [self addSubview:tf];
        [self refreshViewWithtitle:title cardName:cardName faceValue:faceValue cardNum:cardNum baoziNeedNum:baoziNeedNum baoziHasNum:baoziHasNum passViewType:passViewType];
    }
    return self;
}


- (void)refreshViewWithtitle:(NSString *)title
                    cardName:(NSString *)cardName
                   faceValue:(NSString *)faceValue
                     cardNum:(NSString *)cardNum
                baoziNeedNum:(NSString *)baoziNeedNum
                 baoziHasNum:(NSString *)baoziHasNum
                passViewType:(PassViewType)passViewType
{
    CGFloat width = CGRectGetWidth(bgView.frame);

    titleLabel.text = title;
    conttentLabel.text = [NSString stringWithFormat:@"%@ 面值%@元 数量X%@",cardName,[WJUtilityMethod  baoziNumberFormatter:[NSString stringWithFormat:@"%f",[faceValue floatValue]]],cardNum];
    
    CGSize sizeThatFits =  [conttentLabel sizeThatFits:CGSizeMake(width - ALD(32), MAXFLOAT)];
    
//    [conttentLabel sizeToFit];
//    CGSize conttentSize = conttentLabel.frame.size;
    [conttentLabel setFrame:CGRectMake(ALD(16), ALD(10) + CGRectGetMaxY(topLine.frame),  width - ALD(32), sizeThatFits.height)];
 
    baoziNumberLabel.text = [WJUtilityMethod baoziNumberFormatter:baoziNeedNum];;
    [baoziNumberLabel sizeToFit];
    [baoziImageView setFrame:CGRectMake( ( width -  CGRectGetWidth(baoziNumberLabel.frame) - ALD(35) )/2.0  , conttentLabel.bottom + ALD(8), ALD(26), ALD(22))];
    [baoziNumberLabel setFrame:CGRectMake(CGRectGetMaxX(baoziImageView.frame) + ALD(9),
                                          CGRectGetMinY(baoziImageView.frame) - (CGRectGetHeight(baoziNumberLabel.frame) - ALD(22))/2.0,
                                          CGRectGetWidth(baoziNumberLabel.frame),
                                          CGRectGetHeight(baoziNumberLabel.frame))];

    [bottomLine setFrame: CGRectMake(0, ALD(8) + baoziNumberLabel.bottom, width, 1)];
    
    baoziHasNumLabel.text = [NSString stringWithFormat:@"可用包子数：%@个", [WJUtilityMethod  baoziNumberFormatter:[NSString stringWithFormat:@"%f",[baoziHasNum floatValue]]]];
    [baoziHasNumLabel setFrame:CGRectMake(ALD(16), ALD(10) + bottomLine.bottom, width - ALD(32), ALD(30))];
    
    [enterBg setFrame:CGRectMake(ALD(16), baoziHasNumLabel.bottom + ALD(10), width - ALD(32), ALD(40))];
    
    [submitButton setFrame:CGRectMake (ALD(16), baoziHasNumLabel.bottom + ALD(5), width - ALD(32), ALD(40))];

    [bottomButton setFrame:CGRectMake (ALD(16), submitButton.bottom + ALD(12), width - ALD(32), ALD(30))];

    [bgView setFrame:CGRectMake(ALD(52), ALD(100), kScreenWidth -  ALD(104), bottomButton.bottom + ALD(16))];

    [tipLabel setFrame:CGRectMake(width - tipLabel.width - ALD(16), baoziHasNumLabel.y, tipLabel.width, baoziHasNumLabel.height)];
    
    [tipImageView setFrame:CGRectMake(tipLabel.x - ALD(3) - ALD(13), tipLabel.y + (tipLabel.height - ALD(13))/2, ALD(13), ALD(13))];
    
    switch (passViewType) {
        case PassViewTypeSubmit:
        {
            [self tipHidden];
            enterBg.hidden = YES;
            submitButton.hidden = NO;
            [submitButton setTitle:@"确认支付" forState:UIControlStateNormal];
            [bottomButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        }
            break;
        case PassViewTypeSubmitTip:
        {
            [self tipShow];
            enterBg.hidden = YES;
            submitButton.hidden = NO;
            [submitButton setTitle:@"立即充值" forState:UIControlStateNormal];
            [bottomButton setTitle:@"取消" forState:UIControlStateNormal];
        }
            break;
        case PassViewTypeInputPassword:
        {
            [self tipHidden];
            enterBg.hidden = NO;
            submitButton.hidden = YES;
            [bottomButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
            [self showKeyBoard];
            [self changeInputState];
        }
            break;
        default:
            break;
    }
    [bgView setFrame:CGRectMake(ALD(52), ALD(100), kScreenWidth -  ALD(104), bottomButton.bottom + ALD(6))];
}

- (void)showIn
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.alpha = 0;
    self.frame = window.bounds;
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


- (void)tipShow
{
    tipLabel.hidden = NO;
    tipImageView.hidden = NO;
}

- (void)tipHidden
{
    tipImageView.hidden = YES;
    tipLabel.hidden = YES;
}

- (void)closeAction
{
    NSLog(@"%s",__func__);
    
    [self dismiss];
    
}

- (void)submitAction
{
    NSLog(@"%s",__func__);
    
    if (self.type == PassViewTypeSubmit) {
        //支付
        if(self.delegate && [self.delegate respondsToSelector:@selector(payWithAlert:)]){
            [self.delegate payWithAlert:self];
        }
        
    } else if (self.type == PassViewTypeSubmitTip) {
        //充值
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(RechargeWithAlert:)]) {
            [self.delegate RechargeWithAlert:self];
        }
        [self dismiss];
    }
}

- (void)bottonAction
{
    NSLog(@"%s",__func__);
    
    if (self.type == PassViewTypeSubmitTip) {
        // 取消
    } else
    {
        //忘记密码
        [self forgetPassword];
    }
    [self dismiss];

    
}

- (void)forgetPassword
{
    if ([self.delegate respondsToSelector:@selector(forgetPasswordActionWith:)]) {
        [self.delegate forgetPasswordActionWith:self];
    }
}

- (void)helpAction
{
    NSLog(@"%s",__func__);
    if ([self.delegate respondsToSelector:@selector(helpAction)]) {
        [self dismiss];
        [self.delegate helpAction];
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
  
    NSLog(@"验证成功");
    //本地验证次数归零
    [WJGlobalVariable payPasswordVerifySuccess];
    
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    if (person) {
        NSString *text = [[enterPassword stringByAppendingString:person.payPsdSalt] getSha1String];
        if (![person.payPassword isEqualToString:text]) {
            person.payPassword = text;
            [[WJDBPersonManager new] updatePerson:person];
        }
    }
    
    
    [self dismiss];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(successWithVerifyPsdAlert:)]){

        [self.delegate successWithVerifyPsdAlert:self];
    }
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager{
    
    NSLog(@"验证失败");
    [psdArray removeAllObjects];
    [tf resignFirstResponder];
    
    //验证失败
    if (manager.errorCode == 50008052 || manager.errorCode == 50008053) {
        
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        [self recordErrorNumber];
        
        NSString *errMsg = manager.errorMessage;
        if (errMsg) {
            if (errMsg.length > 0) {
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(failedWithVerifyPsdAlert:errerMessage:isLocked:)]) {
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
