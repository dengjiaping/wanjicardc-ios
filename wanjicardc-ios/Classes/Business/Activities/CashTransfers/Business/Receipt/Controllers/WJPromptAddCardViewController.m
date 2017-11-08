//
//  WJPromptAddCardViewController.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJPromptAddCardViewController.h"
#import "WJAddBankCardViewController.h"
@interface WJPromptAddCardViewController ()

@property(nonatomic,strong)UILabel    *tipLabel;
@property(nonatomic,strong)UIButton   *AddCardButton;

@end

@implementation WJPromptAddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.AddCardButton];
}

- (void)buttonAction
{
    WJAddBankCardViewController *addBankCardVC = [[WJAddBankCardViewController alloc] init];
    [self.navigationController pushViewController:addBankCardVC animated:YES];
}


- (UILabel *)tipLabel
{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ALD(170), kScreenWidth, 14)];
        _tipLabel.text = @"您尚未绑卡认证";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = WJColorViewNotEditable;
        _tipLabel.font = WJFont24;
    }
    return _tipLabel;
}

- (UIButton *)AddCardButton
{
    if (_AddCardButton == nil) {
        _AddCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _AddCardButton.frame = CGRectMake(12, 350, kScreenWidth - 24,44);
        [_AddCardButton setTitle:@"去绑卡" forState:UIControlStateNormal];
        _AddCardButton.layer.cornerRadius = 5;
        [_AddCardButton setBackgroundColor:WJColorNavigationBar];
        [_AddCardButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _AddCardButton;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
