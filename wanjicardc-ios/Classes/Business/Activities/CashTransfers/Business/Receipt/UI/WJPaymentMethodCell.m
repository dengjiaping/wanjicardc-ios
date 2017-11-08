//
//  WJPaymentMethodCell.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/29.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJPaymentMethodCell.h"

@implementation WJPaymentMethodCell

- (void)configDataWithModel:(WJCashRateModel *)model
{
    self.tipLabel.text = model.tipCopy;
    self.titleLabel.text = model.channelName;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.iconImage = [[UIImageView alloc]initForAutoLayout];
//        _iconImage.image = [UIImage imageNamed:@"weixin_icon"];
        [self.contentView addSubview:_iconImage];
        [self.contentView addConstraints:[_iconImage constraintsSize:CGSizeMake(48, 48)]];
        [self.contentView addConstraints:[_iconImage constraintsTopInContainer:20]];
        [self.contentView addConstraints:[_iconImage constraintsLeftInContainer:12]];
        
        self.titleLabel = [[UILabel alloc]initForAutoLayout];
//        _titleLabel.text = @"微信扫码";
        _titleLabel.font = WJFont15;
        _titleLabel.textColor = WJColorDardGray3;
        [self.contentView addSubview:_titleLabel];
        [self.contentView addConstraints:[_titleLabel constraintsSize:CGSizeMake(80, 10)]];
        [self.contentView addConstraints:[_titleLabel constraintsTopInContainer:20]];
        [self.contentView addConstraints:[_titleLabel constraintsLeft:15 FromView:_iconImage]];
        
        self.tipLabel = [[UILabel alloc]initForAutoLayout];
        _tipLabel.font = WJFont12;
        _tipLabel.textColor =WJColorDardGray6;
//        _tipLabel.text = @"单笔限额不能高于5000.00，日限额20000.00";
        _tipLabel.numberOfLines = 0;
        [self.contentView addSubview:_tipLabel];
        [self.contentView addConstraints:[_tipLabel constraintsSize:CGSizeMake(ALD(280), 110 - ALD(80))]];
        [self.contentView addConstraints:[_tipLabel constraintsTop:10 FromView:_titleLabel]];
        [self.contentView addConstraints:[_tipLabel constraintsLeft:ALD(15) FromView:_iconImage]];
        
        self.nowButton = [[UIButton alloc]initForAutoLayout];
        [_nowButton setTitle:@"实时到账" forState:UIControlStateNormal];
        _nowButton.titleLabel.font = WJFont12;
        _nowButton.layer.cornerRadius = 4;
        [_nowButton setBackgroundColor:WJColorCardRed];
        [self.contentView addSubview:_nowButton];
        [self.contentView addConstraints:[_nowButton constraintsSize:CGSizeMake(69, 19)]];
        [self.contentView addConstraints:[_nowButton constraintsTop:10 FromView:_tipLabel]];
        [self.contentView addConstraints:[_nowButton constraintsLeft:15 FromView:_iconImage]];
        
//        self.nextButton = [[UIButton alloc]initForAutoLayout];
//        [_nextButton setTitle:@"次日到账" forState:UIControlStateNormal];
//        _nextButton.titleLabel.font = WJFont12;
//        _nextButton.layer.cornerRadius = 4;
//        [_nextButton setBackgroundColor:WJColorCardOrange];
//        [self.contentView addSubview:_nextButton];
//        [self.contentView addConstraints:[_nextButton constraintsSize:CGSizeMake(69, 19)]];
//        [self.contentView addConstraints:[_nextButton constraintsTop:10 FromView:_tipLabel]];
//        [self.contentView addConstraints:[_nextButton constraintsLeft:20 FromView:_nowButton]];
        
    }
    return self;
}

@end
