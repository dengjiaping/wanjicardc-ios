//
//  WJCashQRCodeViewController.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCashQRCodeViewController.h"
#import "WJSystemAlertView.h"
#import "APICashQRCodeManager.h"
#import "WJCashQRCodeModel.h"
#import "WJCashQRCodeReformer.h"
#import "WJCashQRCodeView.h"

@interface WJCashQRCodeViewController ()<APIManagerCallBackDelegate>

@property(nonatomic,strong)WJCashQRCodeView         * cashQRCodeView;
@property(nonatomic,strong)APICashQRCodeManager         * cashQRCodeManager;
@property(nonatomic,strong)WJCashQRCodeModel            * cashQRCodeModel;

@end

@implementation WJCashQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫码支付";
    
    [self requestData];
}

- (void)requestData
{
    [self showLoadingView];
    [self.cashQRCodeManager loadData];
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    NSLog(@"成功 == %@",manager);
    self.cashQRCodeModel = [manager fetchDataWithReformer:[[WJCashQRCodeReformer alloc] init]];
    [self.cashQRCodeView configDataWithModel:self.cashQRCodeModel];
    
    [self.view addSubview:self.cashQRCodeView];

}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    [self hiddenLoadingView];
    NSLog(@"失败 == %@",manager.errorMessage);
    ALERT(manager.errorMessage);
}


- (void)saveButtonAction
{
    UIImageWriteToSavedPhotosAlbum(self.cashQRCodeView.QRCodeIV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil message:@"付款码已保存" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
    [alert showIn];
}

- (APICashQRCodeManager *)cashQRCodeManager
{
    if (_cashQRCodeManager == nil) {
        _cashQRCodeManager = [[APICashQRCodeManager alloc]init];
        _cashQRCodeManager.delegate = self;
        _cashQRCodeManager.payMoney = self.payMoney;
        _cashQRCodeManager.payTypeId = self.payTypeId;
    }
    return _cashQRCodeManager;
}

- (WJCashQRCodeModel *)cashQRCodeModel
{
    if (_cashQRCodeModel == nil) {
        _cashQRCodeModel = [[WJCashQRCodeModel alloc]init];
    }
    return _cashQRCodeModel;
}

- (WJCashQRCodeView *)cashQRCodeView
{
    if (_cashQRCodeView == nil) {
        _cashQRCodeView = [[WJCashQRCodeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        _cashQRCodeView.titleLabel.text = @"扫码支付";
        _cashQRCodeView.backgroundColor = [UIColor whiteColor];
        [_cashQRCodeView.saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:@"￥"];
        NSDictionary * firstAttributes = @{ NSFontAttributeName:WJFont25,NSForegroundColorAttributeName:[UIColor redColor]};
        [firstPart setAttributes:firstAttributes range:NSMakeRange(0,firstPart.length)];
        NSMutableAttributedString * secondPart = [[NSMutableAttributedString alloc] initWithString:self.payMoney];
        NSDictionary * secondAttributes = @{NSFontAttributeName:WJFont35,NSForegroundColorAttributeName:[UIColor redColor]};
        [secondPart setAttributes:secondAttributes range:NSMakeRange(0,secondPart.length)];
        [firstPart appendAttributedString:secondPart];

        _cashQRCodeView.moneyLabel.attributedText = firstPart;
    }
    return _cashQRCodeView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
