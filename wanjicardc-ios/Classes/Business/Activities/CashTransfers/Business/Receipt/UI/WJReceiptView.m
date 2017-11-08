//
//  WJReceiptView.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/28.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJReceiptView.h"

@interface WJReceiptView()<UITextFieldDelegate>


@end

@implementation WJReceiptView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.sureButton];
        [self addSubview:self.tipLabel];
        [self addSubview:self.textField];
    }
    return self;
}

- (void)configDataWithDictionary:(NSDictionary *)dictionary
{
    self.tipLabel.text = [dictionary objectForKey:@"businessRemender"];
    self.tipRecLabel.text = [dictionary objectForKey:@"gatheringRemender"];
}



#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *textFieldStr = [textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (string.length > 0) {
        self.sureButton.enabled = YES;
        if (textField.text.length > 8) {
            return NO;
        }
        if (![textField.text isEqualToString:textFieldStr]) {
            NSRange range = [textField.text rangeOfString:@"."];
            if ([textField.text substringFromIndex:range.location].length >= 3) {
                return NO;
            }
        }
    }else{
        if (textField.text.length <= 1) {
            self.sureButton.enabled = NO;
        }
    }
    return YES;
}



- (UIView *)backgroundView
{
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 150)];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        UILabel *recepitLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 25, 80, 10)];
        recepitLabel.text = @"收款金额";
        recepitLabel.font = WJFont15;
        recepitLabel.textColor = WJColorDardGray3;
        UILabel *yuanLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 55, 80, 30)];
        yuanLabel.text = @"￥";
        yuanLabel.font = [UIFont systemFontOfSize:35];
        yuanLabel.textColor = WJColorDardGray3;
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(12, 100, kScreenWidth - 24, 1)];
        line.backgroundColor = WJColorSeparatorLine;
        self.tipRecLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 115, kScreenWidth - 24, 20)];
//        _tipRecLabel.text = @"单笔最低限额：10.00元，单笔最高限额100000.00元";
        _tipRecLabel.font = WJFont12;
        _tipRecLabel.textColor =WJColorDardGray9;
        
        [_backgroundView addSubview:recepitLabel];
        [_backgroundView addSubview:yuanLabel];
        [_backgroundView addSubview:line];
        [_backgroundView addSubview:_tipRecLabel];
    }
    return _backgroundView;
}

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(55, 60, 260, 40)];
        _textField.placeholder = @"0.00";
        _textField.font = WJFont45;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.delegate = self;
    }
    return _textField;
}


- (UIButton *)sureButton
{
    if (_sureButton == nil) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(12, 190, kScreenWidth - 24,44);
        [_sureButton setTitle:@"确认收款" forState:UIControlStateNormal];
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 5;
        [_sureButton setTitleColor:WJColorWhite forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorViewNotEditable] forState:UIControlStateDisabled];
        [_sureButton setBackgroundImage:[WJUtilityMethod createImageWithColor:WJColorNavigationBar] forState:UIControlStateNormal];
        _sureButton.enabled = NO;
        _sureButton.adjustsImageWhenHighlighted = NO;
    }
    return _sureButton;
}

- (UILabel *)tipLabel
{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 245, kScreenWidth, 20)];
        _tipLabel.textColor = WJColorDardGray9;
        _tipLabel.font = WJFont12;
//        _tipLabel.text = @"*该服务由金斗科技有限公司提供，请您放心使用！";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

@end
