//
//  WJVerificationReceiptMoneyController.m
//  WanJiCard
//
//  Created by reborn on 16/9/20.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJVerificationReceiptMoneyController.h"
#import "APIReceiptMoneyVerifyManager.h"
#import "WJSystemAlertView.h"

@interface WJVerificationReceiptMoneyController()<UITextFieldDelegate,WJSystemAlertViewDelegate>
{
    UITextField *receiptMoneyTF;
    UIButton    *commitButton;
    UILabel     *desLabel;

}
@property(nonatomic, strong)APIReceiptMoneyVerifyManager *receiptMoneyVerifyManager;
@end


@implementation WJVerificationReceiptMoneyController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"实名认证";

    [kDefaultCenter addObserver:self selector:@selector(checkInputState:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [kDefaultCenter addObserver:self selector:@selector(recordStatus) name:kRealNameReciveMoneyRecord object:nil];

    [WJGlobalVariable sharedInstance].realAuthenReciveMoneyfromController = self;
    
    [self initContentView];
}

- (void)dealloc{
    
    [kDefaultCenter removeObserver:self];
}

- (void)initContentView
{
    desLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), 0, kScreenWidth - ALD(24), ALD(65))];
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.textColor = WJColorDardGray6;
    desLabel.font = WJFont14;
    desLabel.numberOfLines = 0;
    [self.view addSubview:desLabel];
    
    NSString *lastBankCard = [self.BankCard substringFromIndex:self.BankCard.length - 4];
    NSString *strContent = [NSString stringWithFormat:@"我们已经向您尾号%@的银行卡打款，请输入收到的金额",lastBankCard];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:strContent];
    [str addAttribute:NSForegroundColorAttributeName value:WJColorNavigationBar range:NSMakeRange(8, 4)];
    desLabel.attributedText = str;

    [self.view addSubview:desLabel];
    
    
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, desLabel.bottom, kScreenWidth, ALD(45))];
    middleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:middleView];
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, ALD(70), ALD(45))];
    nameL.textColor = WJColorDardGray6;
    nameL.text = @"收款金额";
    [middleView addSubview:nameL];
    
    receiptMoneyTF = [[UITextField alloc] initWithFrame:CGRectMake(nameL.right + ALD(15), 0, kScreenWidth - ALD(110), ALD(45))];
    receiptMoneyTF.delegate = self;
    receiptMoneyTF.textColor = WJColorDardGray6;
    receiptMoneyTF.placeholder = @"请输入收到的金额";
    receiptMoneyTF.keyboardType = UIKeyboardTypeDefault;
    [middleView addSubview:receiptMoneyTF];
    
    
    commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(ALD(15), middleView.bottom + ALD(30), kScreenWidth - ALD(30), ALD(45));
    [commitButton setTitle:@"立即实名" forState:UIControlStateNormal];
    [commitButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorViewNotEditable] forState:UIControlStateDisabled];
    [commitButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorNavigationBar] forState:UIControlStateNormal];
    commitButton.enabled = NO;
    commitButton.titleLabel.font = WJFont15;
    commitButton.layer.cornerRadius = 5;
    commitButton.layer.masksToBounds = YES;
    [commitButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitButton];
    
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = WJColorAlert;
    tipLabel.font = WJFont14;
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSString *tipStrContent = [NSString stringWithFormat:@"24小时之内收不到验证金额或需要更换银行卡请直接点击左上角''返回''按钮重新提交"];
    NSMutableAttributedString *tipStr = [[NSMutableAttributedString alloc]initWithString:tipStrContent];
    [tipStr addAttribute:NSForegroundColorAttributeName value:WJColorNavigationBar range:NSMakeRange(31, 2)];
    tipLabel.attributedText = tipStr;
    
    CGRect txtFrame=tipLabel.frame;
    txtFrame.size.height =[tipLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth- ALD(20), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:tipLabel.font,NSFontAttributeName, nil] context:nil].size.height;
    tipLabel.frame=CGRectMake(ALD(10), commitButton.bottom + ALD(30), kScreenWidth - ALD(20), txtFrame.size.height);

    [self.view addSubview:tipLabel];
    
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    if ([manager isKindOfClass:[APIReceiptMoneyVerifyManager class]]) {
        
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            WJModelPerson *defaultPerson = [WJGlobalVariable sharedInstance].defaultPerson;
            
            defaultPerson.authentication = AuthenticationCompleted;
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
                
            } else{
                
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
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RealNameReciveMoneyRecord"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        WJViewController *vc = [[WJGlobalVariable sharedInstance] realAuthenfromController];
        [self.navigationController popToViewController:vc animated:YES];
    }
}

#pragma mark - UITextFieldTextDidChangeNotification

- (void)checkInputState:(NSNotification *)notification
{
    if (receiptMoneyTF.text.length >0) {
        commitButton.enabled = YES;
    }else{
        commitButton.enabled = NO;
    }
}

- (void)recordStatus
{
    [[NSUserDefaults standardUserDefaults] setObject:self.BankCard forKey:@"RealNameReciveMoneyRecord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - Request
- (void)requestLoad{
    
    [self.receiptMoneyVerifyManager loadData];
}

- (void)commitAction
{
    if (receiptMoneyTF.text.length == 0) {
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入收款金额"];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RealNameReciveMoneyRecord"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
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
    [receiptMoneyTF resignFirstResponder];
    
}


- (NSAttributedString *)attributedText:(NSString *)text firstLength:(NSInteger)len secondLocation:(NSInteger)secondLocation
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]
                                         initWithString:text];
    NSDictionary *attributesForFirstWord = @{
                                             NSFontAttributeName : WJFont12,
                                             NSForegroundColorAttributeName : WJColorAlert,
                                             };
    
    NSDictionary *attributesForSecondWord = @{
                                              NSFontAttributeName : WJFont12,
                                              NSForegroundColorAttributeName : WJColorNavigationBar,
                                              };
    
    NSDictionary *attributesForThirdWord = @{
                                              NSFontAttributeName : WJFont12,
                                              NSForegroundColorAttributeName : WJColorAlert,
                                              };
    [result setAttributes:attributesForFirstWord
                    range:NSMakeRange(0, len)];
    [result setAttributes:attributesForSecondWord
                    range:NSMakeRange(len + 1, secondLocation)];
    [result setAttributes:attributesForThirdWord
                    range:NSMakeRange(secondLocation, text.length - secondLocation)];
    
    return [[NSAttributedString alloc] initWithAttributedString:result];
}

-(APIReceiptMoneyVerifyManager *)receiptMoneyVerifyManager
{
    if (nil== _receiptMoneyVerifyManager) {
        _receiptMoneyVerifyManager = [[APIReceiptMoneyVerifyManager alloc]init];
        _receiptMoneyVerifyManager.delegate = self;
    }
    
    _receiptMoneyVerifyManager.money = receiptMoneyTF.text;
    
    return _receiptMoneyVerifyManager;
}

@end
