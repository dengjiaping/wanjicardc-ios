//
//  WJCashQRCodeView.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/29.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCashQRCodeView.h"

@implementation WJCashQRCodeView

- (void)configDataWithModel:(WJCashQRCodeModel *)model
{
    self.QRCodeIV.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.codeImageUrl]]];
    self.DetailsLabel.text = model.payRemender;
    self.tipsDetailLabel.text = model.warmPrompt;
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.DetailsLabel];
        [self addSubview:self.moneyLabel];
        
        [self addSubview:self.QRCodeIV];
        [self addConstraints:[_QRCodeIV constraintsSize:CGSizeMake(132, 132)]];
        [self addConstraints:[_QRCodeIV constraintsTop:ALD(35) FromView:_moneyLabel]];
        [self addConstraint:[_QRCodeIV constraintCenterXInContainer]];
        
//        [self addSubview:self.tipsLable];
        [self addSubview:self.tipsDetailLabel];
        
        [self addSubview:self.saveButton];
    }
    return self;
}


- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ALD(35), kScreenWidth, 12)];
        _titleLabel.textColor = WJColorDardGray3;
        _titleLabel.font = WJFont20;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)DetailsLabel
{
    if (_DetailsLabel == nil) {
        _DetailsLabel = [[UILabel alloc]initWithFrame:CGRectMake(ALD(45), ALD(67), kScreenWidth - ALD(90), 70)];
        _DetailsLabel.textColor = WJColorDardGray3;
        _DetailsLabel.font = WJFont15;
        _DetailsLabel.numberOfLines = 0;
//        _DetailsLabel.text = @"您的好友赵麻子正在向您发起一笔金额为￥5000.00元的微信扫码支付收款，请用微信扫描一下二维码进行支付";
        _DetailsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _DetailsLabel;
}

- (UILabel *)moneyLabel
{
    //    ALD(90) + 82
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ALD(172), kScreenWidth, 25)];
        _moneyLabel.textColor = [UIColor redColor];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

- (UIImageView *)QRCodeIV
{
    if (_QRCodeIV == nil) {
        _QRCodeIV = [[UIImageView alloc]initForAutoLayout];
    }
    return _QRCodeIV;
}

- (NSURL *)creatImageUrl
{
    NSString *urlString = [NSString stringWithFormat:@"http://192.168.1.52:8080/alipay/qrCode?token=%@&timestamp=",cashToken];
    NSString *timeString = [NSString stringWithFormat:@"%f", [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]];
    urlString = [urlString stringByAppendingString:timeString];
    return [NSURL URLWithString:urlString];
}

//- (UILabel *)tipsLable
//{
//    if (_tipsLable == nil) {
//        _tipsLable = [[UILabel alloc]initWithFrame:CGRectMake(45, kScreenHeight - ALD(259), 80, 10)];
//        _tipsLable.textColor = WJColorDardGray9;
//        _tipsLable.font = WJFont12;
//        _tipsLable.text = @"温馨提示";
//    }
//    return _tipsLable;
//}

- (UILabel *)tipsDetailLabel
{
    if (_tipsDetailLabel == nil) {
        _tipsDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, kScreenHeight - ALD(259), kScreenWidth - 90, 50)];
        _tipsDetailLabel.textColor = WJColorDardGray9;
        _tipsDetailLabel.font = WJFont12;
        _tipsDetailLabel.numberOfLines = 0;
//        _tipsDetailLabel.text = @"如果您不认识赵麻子或者不是您的好友，请核实之后再付款。";
    }
    return _tipsDetailLabel;
}

- (UIButton *)saveButton
{
    if (_saveButton == nil) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(12, kScreenHeight - ALD(160), kScreenWidth - 24,44);
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        _saveButton.layer.cornerRadius = 5;
        [_saveButton setBackgroundColor:WJColorNavigationBar];
    }
    return _saveButton;
}



@end
