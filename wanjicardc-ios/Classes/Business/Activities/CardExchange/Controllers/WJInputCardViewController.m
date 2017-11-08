//
//  WJInputCardViewController.m
//  WanJiCard
//
//  Created by 林有亮 on 16/12/6.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJInputCardViewController.h"
#import "WJCardExchangeModel.h"
#import "WJChangeResultViewController.h"
#import "APICardExchangeVerifyManager.h"
#import "WJFaceValueModel.h"

@interface WJInputCardViewController ()<UITextFieldDelegate,APIManagerCallBackDelegate,UIAlertViewDelegate>
{
    UITextField * cardNumTF;
    UITextField * passTF;
}

@property (nonatomic , strong) APICardExchangeVerifyManager * verifyManager;

@end

@implementation WJInputCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI
{
    self.title = @"输入卡号密码";
    
    self.view.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"f1f2f3"];
    UIView * cardBGView = [[UIView alloc] initWithFrame:CGRectMake(ALD(40), ALD(20), kScreenWidth-ALD(40)*2, ALD(165))];
    cardBGView.layer.cornerRadius = 5;
    cardBGView.backgroundColor = [WJUtilityMethod colorWithHexColorString:self.cardModel.cardColorValue];
    
    UIImageView * logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(40), ALD(30), cardBGView.width - ALD(80), cardBGView.height - ALD(60))];
    logoIV.layer.cornerRadius = 5;
    logoIV.layer.masksToBounds = YES;
    [logoIV sd_setImageWithURL:[NSURL URLWithString:self.cardModel.cardLogolUrl] placeholderImage:[UIImage imageNamed:@""]];
    [cardBGView addSubview:logoIV];
    
    UIView * inputBGView = [[UIView alloc] initWithFrame:CGRectMake(-1, ALD(210), kScreenWidth + 2, ALD(90))];
    inputBGView.layer.borderColor = [WJColorCardGray CGColor];
    inputBGView.layer.borderWidth = 1;
    inputBGView.backgroundColor = WJColorWhite;
    
    UILabel * cardNumLabel = [[UILabel alloc] init];
    cardNumLabel.font = WJFont14;
    cardNumLabel.textColor = WJColorDardGray3;
    cardNumLabel.text = @"卡号：";
    [cardNumLabel sizeToFit];
    [cardNumLabel setFrame:CGRectMake(ALD(12), ALD(0), cardNumLabel.width,ALD(44))];
    
    UILabel * passLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(46), cardNumLabel.width,ALD(44))];
    passLabel.font = WJFont14;
    passLabel.textColor = WJColorDardGray3;
    passLabel.text = @"密码：";
    
    cardNumTF = [[UITextField alloc] initWithFrame:CGRectMake(cardNumLabel.right + ALD(5) , 0, kScreenWidth - cardNumLabel.right - ALD(17), ALD(44))];
    cardNumTF.placeholder = @"请输入您的卡号";
    cardNumTF.font = WJFont14;
    cardNumTF.borderStyle = UITextBorderStyleNone;
    cardNumTF.delegate = self;
    cardNumTF.tag = 12345;
    
    passTF = [[UITextField alloc] initWithFrame:CGRectMake(cardNumLabel.right + ALD(5) , ALD(46), kScreenWidth - cardNumLabel.right - ALD(17), ALD(44))];
    passTF.placeholder = @"请输入您的密码";
    passTF.font = WJFont14;
    passTF.borderStyle = UITextBorderStyleNone;
    passTF.returnKeyType = UIReturnKeyDone;
    passTF.delegate = self;
    passTF.tag = 12300;
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(45), kScreenWidth, 1)];
    line.backgroundColor = WJColorCardGray;
    
    [inputBGView addSubview:cardNumLabel];
    [inputBGView addSubview:passLabel];
    [inputBGView addSubview:cardNumTF];
    [inputBGView addSubview:passTF];
    [inputBGView addSubview:line];
    
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), inputBGView.bottom + ALD(20), kScreenWidth - ALD(24), ALD(15))];
    tipLabel.text = @"*请确保您的卡与您选择的面值对应,否则将对您的信用造成严重影响";
    tipLabel.adjustsFontSizeToFitWidth = kScreenWidth - ALD(24);
    tipLabel.textColor = WJColorDardGray9;
    
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setFrame:CGRectMake(ALD(12), tipLabel.bottom + ALD(10), kScreenWidth - ALD(24), ALD(44))];
    sureButton.backgroundColor = WJColorCardBlue;
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cardBGView];
    [self.view addSubview:inputBGView];
    [self.view addSubview:tipLabel];
    [self.view addSubview:sureButton];
}

- (void)sureButtonAction
{
    NSLog(@"%s",__func__);
    
    if (cardNumTF.text.length == 0 || passTF.text.length == 0)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入账号密码"];
        return ;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
    {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"请再次确认您的卡号、密码" message:[NSString stringWithFormat:@"%@\n%@",[NSString stringWithFormat:@"卡号:%@",cardNumTF.text],[NSString stringWithFormat:@"密码:%@",passTF.text]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *appealAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.verifyManager.exchangeActivityCardId = [self.faceCard.cardID integerValue];
            self.verifyManager.cardNumber = cardNumTF.text;
            self.verifyManager.cardPassword = passTF.text;
            
            [self.verifyManager loadData];
            
        }];
        [alertControl addAction:cancelAction];
        [alertControl addAction:appealAction];
        [self presentViewController:alertControl animated:YES completion:nil];

    }
    else
    {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"请再次确认您的卡号、密码" message:[NSString stringWithFormat:@"%@\n%@",[NSString stringWithFormat:@"卡号:%@",cardNumTF.text],[NSString stringWithFormat:@"密码:%@",passTF.text]] delegate:self cancelButtonTitle:@"修改" otherButtonTitles:@"确认", nil];
        [av show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
            self.verifyManager.exchangeActivityCardId = [self.faceCard.cardID integerValue];
            self.verifyManager.cardNumber = cardNumTF.text;
            self.verifyManager.cardPassword = passTF.text;

            [self.verifyManager loadData];
    }
}

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    WJChangeResultViewController * vc = [[WJChangeResultViewController alloc] init];
    vc.baoziNum = self.faceCard.sellValue;
    vc.cardName = self.cardModel.cardName;
    vc.faceValue = self.faceCard.faceValue;
    
    [self.navigationController pushViewController:vc animated:YES whetherJump:YES];
    
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"提交失败 请确认卡号密码是否正确"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case 12345:
        {
            [passTF becomeFirstResponder];
        }
            break;
        case 12300:
        {
            [passTF resignFirstResponder];
        }
            break;
        default:
            break;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (APICardExchangeVerifyManager *)verifyManager
{
    if (!_verifyManager) {
        _verifyManager = [[APICardExchangeVerifyManager alloc] init];
        _verifyManager.delegate = self;
    }
    return _verifyManager;
}

@end
