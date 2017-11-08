//
//  WJCashTransfersBaseController.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/22.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCashTransfersBaseController.h"
#import "WJUtilityMethod.h"

#import "WJReceiptViewController.h"
#import "WJCashRateViewController.h"
#import "WJAccountViewController.h"



@interface WJCashTransfersBaseController ()

@property(nonatomic,strong)UIView              *topLine;
@property(nonatomic,strong)UIView              *leftLine;
@property(nonatomic,strong)UIView              *rightLine;

@property(nonatomic,strong)UIButton            *receiptBut;
@property(nonatomic,strong)UIButton            *cashRateBut;
@property(nonatomic,strong)UIButton            *accountBut;


@end

@implementation WJCashTransfersBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 19, 19);
    [rightBtn setImage:[UIImage imageNamed:@"colseDefault"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(closeButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    if (self.buttonNotShow == YES) {
        return;
    }
    
    [self.view addSubview:self.topLine];
    [self.view addSubview:self.leftLine];
    [self.view addSubview:self.rightLine];

    [self.view addSubview:self.receiptBut];
    [self.view addSubview:self.cashRateBut];
    [self.view addSubview:self.accountBut];
    
}


- (void)closeButton:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)receiptButAction
{
    WJReceiptViewController *receiptVC = [[WJReceiptViewController alloc]init];
    receiptVC.select = 0;
    [self.navigationController pushViewController:receiptVC animated:YES];
}

-(void)cashRateButAction
{
    WJCashRateViewController *cashRateVC = [[WJCashRateViewController alloc]init];
    cashRateVC.select = 1;
    [self.navigationController pushViewController:cashRateVC animated:YES];

}

-(void)accountButAction
{
    WJAccountViewController *accountVC = [[WJAccountViewController alloc]init];
    accountVC.select = 2;
    [self.navigationController pushViewController:accountVC animated:YES];
}

-(UIButton *)receiptBut
{
    if (_receiptBut == nil) {
        _receiptBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _receiptBut.frame = CGRectMake(0, kScreenHeight - 49 - 64, (kScreenWidth - 2)/3, 49);
        [_receiptBut setTitle:@"收款" forState:UIControlStateNormal];
        [_receiptBut setTitleColor:WJColorDardGray3 forState:UIControlStateNormal];
        [_receiptBut setTitleColor:WJColorNavigationBar forState:UIControlStateSelected];
        [_receiptBut addTarget:self action:@selector(receiptButAction) forControlEvents:UIControlEventTouchUpInside];
        if (self.select == 0) {
            _receiptBut.selected=YES;
            self.cashRateBut.selected=NO;
            self.accountBut.selected=NO;
        }
    }
    return _receiptBut;
}

-(UIButton *)cashRateBut
{
    if (_cashRateBut == nil) {
        _cashRateBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _cashRateBut.frame = CGRectMake((kScreenWidth - 1)/3, kScreenHeight - 49 - 64, (kScreenWidth - 2)/3, 49);
        [_cashRateBut setTitle:@"费率" forState:UIControlStateNormal];
        [_cashRateBut setTitleColor:WJColorDardGray3 forState:UIControlStateNormal];
        [_cashRateBut setTitleColor:WJColorNavigationBar forState:UIControlStateSelected];
        [_cashRateBut addTarget:self action:@selector(cashRateButAction) forControlEvents:UIControlEventTouchUpInside];
        if (self.select == 1) {
            self.receiptBut.selected=NO;
            _cashRateBut.selected=YES;
            self.accountBut.selected=NO;
        }
    }
    return _cashRateBut;
}

-(UIButton *)accountBut
{
    if (_accountBut == nil) {
        _accountBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _accountBut.frame = CGRectMake((kScreenWidth)/3 * 2, kScreenHeight - 49 - 64, (kScreenWidth - 2)/3, 49);
        [_accountBut setTitle:@"账户" forState:UIControlStateNormal];
        [_accountBut setTitleColor:WJColorDardGray3 forState:UIControlStateNormal];
        [_accountBut setTitleColor:WJColorNavigationBar forState:UIControlStateSelected];
        [_accountBut addTarget:self action:@selector(accountButAction) forControlEvents:UIControlEventTouchUpInside];
        if (self.select == 2) {
            self.receiptBut.selected=NO;
            self.cashRateBut.selected=NO;
            _accountBut.selected=YES;
        }
    }
    return _accountBut;
}

-(UIView *)topLine
{
    if (_topLine == nil) {
        _topLine = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 49 - 65, kScreenWidth, 1)];
        _topLine.backgroundColor =WJColorSeparatorLine;
    }
    return _topLine;
}

-(UIView *)leftLine
{
    if (_leftLine == nil) {
        _leftLine = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/3, kScreenHeight - 49 - 65, 1, 49)];
        _leftLine.backgroundColor =WJColorSeparatorLine;
    }
    return _leftLine;
}

-(UIView *)rightLine
{
    if (_rightLine == nil) {
        _rightLine = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth)/3 * 2 + 1, kScreenHeight - 49 - 65, 1, 49)];
        _rightLine.backgroundColor =WJColorSeparatorLine;
    }
    return _rightLine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
