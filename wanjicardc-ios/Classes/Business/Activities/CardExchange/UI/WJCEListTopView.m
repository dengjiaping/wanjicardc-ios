//
//  WJCEListTopView.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/12/1.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCEListTopView.h"

@implementation WJCEListTopView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"#009cff"];
        
        [self addSubview:self.iconIV];
        [self addConstraints:[_iconIV constraintsSize:CGSizeMake(ALD(48.5), ALD(53.5))]];
        [self addConstraints:[_iconIV constraintsLeftInContainer:ALD(27)]];
        [self addConstraint:[_iconIV constraintCenterYInContainer]];
        
        [self addSubview:self.creditSumLabel];
        [self addConstraints:[_creditSumLabel constraintsLeft:ALD(25) FromView:_iconIV]];
        [self addConstraint:[_creditSumLabel constraintTopEqualToView:_iconIV]];


        [self addSubview:self.canUseSumLabel];
        [self addConstraints:[_canUseSumLabel constraintsLeft:ALD(25) FromView:_iconIV]];
        [self addConstraint:[_canUseSumLabel constraintBottomEqualToView:_iconIV]];
    }
    return self;
}

- (void)configDataWithDictionary:(NSDictionary *)dictionary
{
    NSString *currentString = [dictionary objectForKey:@"currentQuota"];
    NSString *residualString = [dictionary objectForKey:@"residualQuota"];
    
    self.creditSumLabel.text = [NSString stringWithFormat:@"您的信用额度：%@个包子",currentString];
    self.canUseSumLabel.text = [NSString stringWithFormat:@"当前可兑换额度：%@个包子",residualString];
    if (kScreenWidth < 370) {
        _creditSumLabel.font = WJFont12;
        _canUseSumLabel.font = WJFont14;
    }
}

- (UIImageView *)iconIV
{
    if (_iconIV == nil) {
        _iconIV = [[UIImageView alloc]initForAutoLayout];
        _iconIV.image = [UIImage imageNamed:@"mycard_btn_baozi"];
    }
    return _iconIV;
}

- (UILabel *)creditSumLabel
{
    if (_creditSumLabel == nil) {
        _creditSumLabel = [[UILabel alloc]initForAutoLayout];
        _creditSumLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"#ccebff"];
        _creditSumLabel.font = WJFont15;
    }
    return _creditSumLabel;
}

- (UILabel *)canUseSumLabel
{
    if (_canUseSumLabel == nil) {
        _canUseSumLabel = [[UILabel alloc]initForAutoLayout];
        _canUseSumLabel.textColor = WJColorWhite;
        _canUseSumLabel.font = WJFont17;
//        _canUseSumLabel.text = @"当前可兑换额度：100个包子";
    }
    return _canUseSumLabel;
}

@end
