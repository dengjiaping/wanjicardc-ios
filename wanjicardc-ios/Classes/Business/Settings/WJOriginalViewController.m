//
//  WJOriginalViewController.m
//  WanJiCard
//
//  Created by Lynn on 15/12/1.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJOriginalViewController.h"
#import "WJVerifyPasswordController.h"
@interface WJOriginalViewController ()<UITextFieldDelegate>
{
    UITextField * originalTF;
}
@end

@implementation WJOriginalViewController

#pragma mark- Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UISet];
}

#pragma mark- Event Response
// TODO:所有 button、gestureRecognizer、notification 的事件相应方法，与跳转到其他 controller 的出口方法都写在这里。
- (void)nextButtonAction {
    if ([WJUtilityMethod isValidatePhone:originalTF.text]) {
        
        [WJGlobalVariable sharedInstance].fromController = self;
        WJVerifyPasswordController *verifyVC = [[WJVerifyPasswordController alloc] init];
        verifyVC.orginPhone = originalTF.text;
        verifyVC.from = ComeFromChangePhone;
        [self.navigationController pushViewController:verifyVC animated:YES];
    }else{
        ALERT(@"请输入正确的手机号");
    }
}

#pragma mark- Rotation
// TODO:转屏处理写在这。
#pragma mark- Private Methods
// TODO:理论上来说，此处不应有私有方法存在，都应该在上面找到归类。这里应该放置拆分的中间方法。

- (void)UISet
{
    self.title = @"输入原手机号";
    self.view.backgroundColor = WJColorViewBg;
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(44))];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UILabel * originalLabel = [[UILabel alloc] init];
    originalLabel.text = @"原手机号";
    originalLabel.font = WJFont15;
    originalLabel.textColor = WJColorDarkGray;
    [originalLabel sizeToFit];
    [originalLabel setFrame:CGRectMake(ALD(15), 0, originalLabel.width, ALD(44))];
    [bgView addSubview:originalLabel];
    
    originalTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(originalLabel.frame) + ALD(10), 0, kScreenWidth - originalLabel.width - ALD(40), ALD(44))];
    originalTF.borderStyle = UITextBorderStyleNone;
    originalTF.delegate = self;
    originalTF.font = WJFont14;
    originalTF.textColor = WJColorDarkGray;
    originalTF.placeholder = @"请输入您的手机号";
    originalTF.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:originalTF];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(44)-0.5, SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor = WJColorSeparatorLine;
    [bgView addSubview:bottomLine];
    
    [self.view addSubview:bgView];
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(ALD(15), bgView.bottom + ALD(100), kScreenWidth - ALD(30), ALD(40))];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setBackgroundColor:WJColorNavigationBar];
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius = 5;
    [self.view addSubview:nextButton];
    
    [originalTF becomeFirstResponder];
    
}




@end
