//
//  WJCardExchangeListCell.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCardExchangeListCell.h"

@implementation WJCardExchangeListCell

- (void)configDataWithModel:(WJCardExchangeModel *)model
{
    self.cardIV.backgroundColor = [WJUtilityMethod colorWithHexColorString:model.cardColorValue];
    [self.logoIV sd_setImageWithURL:[NSURL URLWithString:model.cardLogolUrl] placeholderImage:[UIImage imageNamed:@"home_ad_default"]];
    self.titleLabel.text = model.cardName;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _cardIV = [[UIImageView alloc]initForAutoLayout];
        _cardIV.layer.cornerRadius = 5.0f;
        [self.contentView addSubview:_cardIV];
        [self.contentView addConstraints:[_cardIV constraintsSize:CGSizeMake(ALD(109), ALD(61))]];
        [self.contentView addConstraints:[_cardIV constraintsLeftInContainer:12]];
        [self.contentView addConstraint:[_cardIV constraintCenterYInContainer]];

        
        _logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(29.5), ALD(14), ALD(50), ALD(30))];
        _logoIV.contentMode =  UIViewContentModeScaleAspectFit;
        _logoIV.clipsToBounds  = YES;
        [self.cardIV addSubview:self.logoIV];
        
        _titleLabel = [[UILabel alloc]initForAutoLayout];
        _titleLabel.font = WJFont15;
        _titleLabel.text = @"中国移动话费储值卡";
        _titleLabel.textColor = WJColorDarkGray;
        [self.contentView addSubview:_titleLabel];
        [self.contentView addConstraints:[_titleLabel constraintsLeft:15 FromView:_cardIV]];
        [self.contentView addConstraint:[_titleLabel constraintTopEqualToView:_cardIV]];
        
        _tipLabel = [[UILabel alloc]initForAutoLayout];
        _tipLabel.font = WJFont14;
        _tipLabel.text = @"闲置卡兑换";
        _tipLabel.textColor = WJColorLightGray;
        [self.contentView addSubview:_tipLabel];
        [self.contentView addConstraints:[_tipLabel constraintsLeft:15 FromView:_cardIV]];
        [self.contentView addConstraint:[_tipLabel constraintBottomEqualToView:_cardIV]];
        
        _sureButton = [[UIButton alloc]initForAutoLayout];
        [_sureButton setTitle:@"我拥有这张卡" forState:UIControlStateNormal];
        [_sureButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        _sureButton.titleLabel.font = WJFont12;
        _sureButton.layer.cornerRadius = 5;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.borderWidth = 1;
        _sureButton.layer.borderColor = WJColorNavigationBar.CGColor;
        [self.contentView addSubview:_sureButton];
        [self.contentView addConstraints:[_sureButton constraintsSize:CGSizeMake(92, 30)]];
        [self.contentView addConstraints:[_sureButton constraintsRightInContainer:12]];
        [self.contentView addConstraints:[_sureButton constraintsBottomInContainer:20]];
        
        UIView *line = [[UIView alloc]initForAutoLayout];
        line.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:line];
        [self.contentView addConstraints:[line constraintsSize:CGSizeMake(kScreenWidth , 1)]];
        [self.contentView addConstraints:[line constraintsLeftInContainer:0]];
        [self.contentView addConstraints:[line constraintsBottomInContainer:0]];
        
    }
    return self;
}

@end
