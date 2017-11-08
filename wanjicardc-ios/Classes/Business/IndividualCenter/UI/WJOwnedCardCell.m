//
//  WJOwnedCardCell.m
//  WanJiCard
//
//  Created by Angie on 15/9/30.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJOwnedCardCell.h"

@implementation WJOwnedCardCell{
    UIImageView *iconIV;
    UILabel     *nameL;
    UILabel     *amountL;
    UIButton    *chargeBtn;
    
    UIImageView *_logoImageView;
    UILabel     *_merNameLabel;
//    UILabel *_merDesLabel;
    UILabel     *_logoFaceL;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
 
        iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, ALD(15), ALD(109), ALD(65))];
        iconIV.layer.cornerRadius = 4;
        [self.contentView addSubview:iconIV];
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right+10, ALD(14), kScreenWidth- 30-ALD(109), 30)];
        nameL.font = WJFont15;
        nameL.textColor = WJColorDarkGray;
        [self.contentView addSubview:nameL];
        
        amountL= [[UILabel alloc] initWithFrame:CGRectMake(nameL.frame.origin.x, nameL.bottom + ALD(5), kScreenWidth - ALD(100), 22)];
        [self.contentView addSubview:amountL];
        
        chargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chargeBtn.frame =  CGRectMake(kScreenWidth-10-ALD(80), ALD(65)-15, ALD(80), ALD(30));
        [chargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        [chargeBtn setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        [chargeBtn setTitleColor:WJColorDardGray6 forState:UIControlStateHighlighted];
        chargeBtn.titleLabel.font = WJFont12;
        chargeBtn.layer.cornerRadius = 4;
        chargeBtn.layer.borderColor = [WJColorNavigationBar CGColor];
        chargeBtn.layer.borderWidth = 0.5;
        [chargeBtn addTarget:self action:@selector(chargeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:chargeBtn];
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(5), (iconIV.height - ALD(21))/2, ALD(21), ALD(21))];
        _logoImageView.layer.cornerRadius = _logoImageView.frame.size.height / 2.0f;
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.backgroundColor = WJColorWhite;
        _logoImageView.alpha = 0.3f;
        [iconIV addSubview:_logoImageView];
        
        UIView *logoBehindLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_logoImageView.frame) + ALD(6), (iconIV.height - ALD(20))/2, ALD(0.5), ALD(20))];
        logoBehindLine.backgroundColor = WJColorSeparatorLine;
        [iconIV addSubview:logoBehindLine];


        _merNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoBehindLine.frame) + ALD(6), CGRectGetMinY(_logoImageView.frame), ALD(70), ALD(8))];
        _merNameLabel.textColor = [UIColor whiteColor];
        _merNameLabel.font = [UIFont systemFontOfSize:6];
        [iconIV addSubview:_merNameLabel];
        
        _logoFaceL = [[UILabel alloc] initWithFrame:CGRectMake(_merNameLabel.frame.origin.x,_merNameLabel.bottom, ALD(60), ALD(10))];
        _logoFaceL.textColor = [UIColor whiteColor];
        _logoFaceL.font = [UIFont systemFontOfSize:6];
        [iconIV addSubview:_logoFaceL];
        
//        _merDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(5), ALD(50), ALD(99), ALD(10))];
//        _merDesLabel.textColor = [UIColor whiteColor];
//        _merDesLabel.font = [UIFont systemFontOfSize:5];
//        [iconIV addSubview:_merDesLabel];
        
    }
    
    return self;
}

- (void)configWithModel:(WJModelCard *)model{
    
    nameL.text = model.name;
//    iconIV.image = [WJGlobalVariable cardBgImageByType:model.colorType];
    
    iconIV.backgroundColor = [WJGlobalVariable cardBackgroundColorByType:model.colorType];
    amountL.attributedText = [self attributedText:[NSString stringWithFormat:@"余额：￥ %@",[WJUtilityMethod floatNumberForMoneyFomatter:model.balance]] firstLength:3];

    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:model.coverURL]
              placeholderImage:[UIImage imageNamed:@"topic_default"]];
    
    _merNameLabel.text = model.name;
//    _merDesLabel.text = model.merName;
    _logoFaceL.text = [NSString stringWithFormat:@"余额：￥ %.2f",model.balance];
}

- (void)chargeAction{
    self.chargeRightNow();
}


- (NSAttributedString *)attributedText:(NSString *)text firstLength:(NSInteger)len{
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]
                                         initWithString:text];
    NSDictionary *attributesForFirstWord = @{
                                             NSFontAttributeName : WJFont12,
                                             NSForegroundColorAttributeName : WJColorDarkGray,
                                             };
    
    NSDictionary *attributesForSecondWord = @{
                                              NSFontAttributeName : WJFont14,
                                              NSForegroundColorAttributeName : WJColorDarkGray,
                                              };
    
    [result setAttributes:attributesForFirstWord
                    range:NSMakeRange(0, len)];
    [result setAttributes:attributesForSecondWord
                    range:NSMakeRange(len, text.length - len)];
    return [[NSAttributedString alloc] initWithAttributedString:result];
}

@end
