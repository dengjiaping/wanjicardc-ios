//
//  WJReceiptViewController.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/22.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJReceiptViewController.h"
#import "WJPaymentMethodViewController.h"
#import "WJPromptAddCardViewController.h"
#import "WJCashLoginViewController.h"

#import "WJReceiptView.h"
#import "APIReciptManager.h"

@interface WJReceiptViewController ()<APIManagerCallBackDelegate>
{
    NSInteger   maxLimits;
    NSInteger   minLimits;
}

@property(nonatomic,strong)WJReceiptView             * receiptView;
@property(nonatomic,strong)APIReciptManager          * reciptManager;


@end

@implementation WJReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收款";
    
    [self.reciptManager loadData];
    
    [self.view addSubview:self.receiptView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressGesture)];
    [self.view  addGestureRecognizer:tapGesture];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSDictionary *dataDic = [manager fetchDataWithReformer:nil];
    maxLimits = [[dataDic objectForKey:@"maxLimits"] intValue];
    minLimits = [[dataDic objectForKey:@"minLimits"] intValue];
    [self.receiptView configDataWithDictionary:dataDic];
    
    NSLog(@"成功 == %@",manager);
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"失败 == %@",manager);
    ALERT(manager.errorMessage);
}


-(void)handletapPressGesture
{
    [self.receiptView.textField resignFirstResponder];
}

- (void)buttonAction
{
    NSString *token = cashToken;
    NSString * bankAmount = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:KCashUser] objectForKey:@"bankAmount"];

    
    if (token.length == 0 || token == nil) {
        WJCashLoginViewController *cashLoginVC = [[WJCashLoginViewController alloc]init];
        WJNavigationController *nav = [[WJNavigationController alloc] initWithRootViewController:cashLoginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else{
    
        if ([self.receiptView.textField.text isEqualToString:@""] || [self.receiptView.textField.text length]==0) {
            ALERT(@"没有输入文本");
        }else{
            
            NSInteger text =[self.receiptView.textField.text integerValue];
            if (text < minLimits) {
                ALERT(@"收款金额不能小于最低限额");
            }else{
                if (text > maxLimits) {
                    ALERT(@"收款金额不能大于最高限额")
                }else{
                    if ([bankAmount intValue] < 1) {
                        WJPromptAddCardViewController *promtVC = [[WJPromptAddCardViewController alloc]init];
                        promtVC.titleStr = @"收款";
                        [self.navigationController pushViewController:promtVC animated:YES];
                    }else{
                        WJPaymentMethodViewController *paymentMethodVC = [[WJPaymentMethodViewController alloc]init];
                        NSLog(@"textField.text =  %@",self.receiptView.textField.text);
                        paymentMethodVC.amountStr = [NSString stringWithFormat:@"%.2f",[self.receiptView.textField.text floatValue]];
                        [self.navigationController pushViewController:paymentMethodVC animated:YES];
                    }
                }
            }
            
        }
        
    }
}

- (WJReceiptView *)receiptView
{
    if (_receiptView == nil) {
        _receiptView = [[WJReceiptView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 115)];
        [_receiptView.sureButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receiptView;
}


- (APIReciptManager *)reciptManager
{
    if (nil == _reciptManager) {
        _reciptManager = [[APIReciptManager alloc] init];
        _reciptManager.delegate = self;
    }
    return _reciptManager;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
