//
//  WJChangeResultViewController.m
//  WanJiCard
//
//  Created by 林有亮 on 16/12/9.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJChangeResultViewController.h"
#import "WJCardExchangeModel.h"
#import "WJCardExchangeListController.h"
#import "WJMyBaoziViewController.h"
#import "UINavigationBar+Awesome.h"

@interface WJChangeResultViewController ()
{
    UILabel * successLabel;
}
@end

@implementation WJChangeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)setupUI
{
    
    self.title = @"兑换成功";
    
    self.view.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"f1f2f3"];
    
    UIView *successView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(143))];
    successView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:successView];
    
    UIImageView *successImageV = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-ALD(50))/2, ALD(25), ALD(50), ALD(50))];
    successImageV.image = [UIImage imageNamed:@"PaySuccessed"];
    [successView addSubview:successImageV];
    
    successLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, successImageV.bottom+ALD(20), kScreenWidth, ALD(18))];
    successLabel.font = WJFont16;
    successLabel.textColor = WJColorDarkGray;
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.text = @"完成提交";
    [successView addSubview:successLabel];
    
    UIView * upline = [[UIView alloc] initWithFrame:CGRectMake(0, successView.height-0.5, SCREEN_WIDTH, 0.5)];
    upline.backgroundColor = WJColorSeparatorLine;
    [successView addSubview:upline];
    
    UIView * inputBGView = [[UIView alloc] initWithFrame:CGRectMake(-1, ALD(155), kScreenWidth + 2, ALD(90))];
    inputBGView.layer.borderColor = [WJColorCardGray CGColor];
    inputBGView.layer.borderWidth = 1;
    inputBGView.backgroundColor = WJColorWhite;
    
    UILabel * cardNumLabel = [[UILabel alloc] init];
    cardNumLabel.font = WJFont14;
    cardNumLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"9099a6"];
    cardNumLabel.text = @"卡号：";
    [cardNumLabel sizeToFit];
    [cardNumLabel setFrame:CGRectMake(ALD(12), ALD(46), cardNumLabel.width,ALD(44))];
    
    UILabel * passLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), 0, cardNumLabel.width,ALD(44))];
    passLabel.font = WJFont14;
    passLabel.textColor =  [WJUtilityMethod colorWithHexColorString:@"9099a6"];;
    passLabel.text = @"密码：";
    
    UITextField * cardNumTF = [[UITextField alloc] initWithFrame:CGRectMake(cardNumLabel.right + ALD(5) , 0, kScreenWidth - cardNumLabel.right - ALD(17), ALD(44))];
    cardNumTF.font = WJFont15;
    cardNumTF.text = [NSString stringWithFormat:@"%@%@元",self.cardName,self.faceValue];
    cardNumTF.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
    cardNumTF.borderStyle = UITextBorderStyleNone;
    cardNumTF.userInteractionEnabled = NO;
    
    UILabel * valueLabel = [[UILabel alloc] init];
    valueLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"d9a109"];
    valueLabel.text = [NSString stringWithFormat:@"%@个包子",self.baoziNum];
    valueLabel.font = WJFont15;
    [valueLabel sizeToFit];
    [valueLabel setFrame:CGRectMake(cardNumLabel.right + ALD(5), ALD(46), valueLabel.width, ALD(44))];
    
    UILabel * tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"(1元 = 1包子)";
    tipLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
    tipLabel.font = WJFont15;
    [tipLabel sizeToFit];
    [tipLabel setFrame:CGRectMake(valueLabel.right + ALD(5), ALD(46), tipLabel.width, ALD(44))];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(45), kScreenWidth, 1)];
    line.backgroundColor = WJColorCardGray;
    
    [inputBGView addSubview:cardNumLabel];
    [inputBGView addSubview:passLabel];
    [inputBGView addSubview:cardNumTF];
    [inputBGView addSubview:valueLabel];
    [inputBGView addSubview:tipLabel];
    [inputBGView addSubview:line];
    
    UILabel * tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), inputBGView.bottom + ALD(12), kScreenWidth - ALD(24), ALD(15))];
    tipsLabel.text = @"兑换成功的包子已经打入您的账户，您可以:";
//    tipsLabel.adjustsFontSizeToFitWidth = kScreenWidth - ALD(24);
    tipsLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"9099a6"];
    tipsLabel.font = WJFont12;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton * useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    useButton.layer.cornerRadius = 5;
    useButton.layer.borderWidth = 1;
    useButton.layer.borderColor = WJColorLightGray.CGColor;
    useButton.backgroundColor = [UIColor clearColor];
    useButton.titleLabel.font = WJFont14;
    [useButton setTitleColor:WJColorLightGray forState:UIControlStateNormal];
    [useButton setTitle:@"立即查看" forState:UIControlStateNormal];
    [useButton setFrame:CGRectMake(kScreenWidth/2 - ALD(140), tipsLabel.bottom + ALD(10), ALD(120), ALD(44))];

    [useButton addTarget:self action:@selector(userButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.layer.cornerRadius = 5;
    changeButton.layer.borderWidth = 1;
    changeButton.layer.borderColor = WJColorLightGray.CGColor;
    changeButton.backgroundColor = [UIColor clearColor];
    changeButton.titleLabel.font = WJFont14;
    [changeButton setTitleColor:WJColorLightGray forState:UIControlStateNormal];
    [changeButton setTitle:@"继续兑换" forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [changeButton setFrame:CGRectMake(ALD(20) + kScreenWidth / 2, tipsLabel.bottom + ALD(10),ALD(120), ALD(44))];

    
    [self.view addSubview:successView];
    [self.view addSubview:inputBGView];
    [self.view addSubview:tipsLabel];
    [self.view addSubview:useButton];
    [self.view addSubview:changeButton];
}

- (void)userButtonAction
{
    WJMyBaoziViewController * vc = [[WJMyBaoziViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES whetherJump:YES];
}

- (void)changeButtonAction
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController * vc in viewControllers) {
        if ([vc isKindOfClass: [WJCardExchangeListController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
