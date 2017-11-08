//
//  WJCardShowCollectionViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/6/15.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCardShowCollectionViewCell.h"
#import "WJCardModel.h"

@interface WJCardShowCollectionViewCell()

@property(nonatomic ,strong) UIView              *backView;
@property(nonatomic ,strong) UIImageView         *brandBackIV;
@property(nonatomic ,strong) UIImageView         *brandIV;
@property(nonatomic ,strong) UILabel             *faceValueL;
@property(nonatomic ,strong) UILabel             *cardNameL;
@property(nonatomic ,strong) UILabel             *valueL;
@property(nonatomic ,strong) UILabel             *lineL;

@end


@implementation WJCardShowCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ALD(295), ALD(165))];
        _backView.layer.cornerRadius = 5.0f;
        _backView.backgroundColor = WJColorCardBlue;
        [self addSubview:self.backView];
        
        _brandBackIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(20), ALD(55), ALD(49), ALD(49))];
        _brandBackIV.layer.cornerRadius = _brandBackIV.width / 2.0;
        _brandBackIV.backgroundColor = WJColorWhite;
        _brandBackIV.alpha = 0.3f;
        [_backView addSubview:self.brandBackIV];
        
        _brandIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(20), ALD(55), ALD(49), ALD(49))];
        _brandIV.layer.cornerRadius =  _brandIV.width / 2.0f;
        _brandIV.contentMode = UIViewContentModeScaleAspectFit;
        _brandIV.clipsToBounds = YES;
        [_backView addSubview:self.brandIV];
        
        _cardNameL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(100), ALD(60), ALD(220), ALD(17))];
        _cardNameL.textAlignment = NSTextAlignmentLeft;
        _cardNameL.font = WJFont14;
        _cardNameL.textColor = WJColorWhite;
        [_backView addSubview:self.cardNameL];
        
        _faceValueL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(100), ALD(105), ALD(64), ALD(16))];
        _faceValueL.text = @"面值";
        _faceValueL.textAlignment = NSTextAlignmentLeft;
        _faceValueL.font = WJFont13;
        _faceValueL.textColor = WJColorWhite;
        [_backView addSubview:self.faceValueL];
        
        _valueL = [[UILabel alloc] initWithFrame:CGRectMake(_faceValueL.right + ALD(10), _faceValueL.y - ALD(2), ALD(64), ALD(20))];
        _valueL.textAlignment = NSTextAlignmentLeft;
        _valueL.font = WJFont17;
        _valueL.textColor = WJColorWhite;
        [_backView addSubview:self.valueL];
        
        _lineL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(84), ALD(55), ALD(0.5), ALD(49))];
        _lineL.backgroundColor = WJColorWhite;
        _lineL.alpha = 0.4f;
        [_backView addSubview:self.lineL];
        
    }
    return self;
}

- (void)configData:(WJCardModel *)cardModel{
    if (cardModel == nil) {
        return;
    }
    //卡颜色
    self.backView.backgroundColor = [WJGlobalVariable cardBackgroundColorByType:cardModel.cType];
    //图标
    [self.brandIV sd_setImageWithURL:[NSURL URLWithString:cardModel.cardCoverUrl] placeholderImage:[UIImage imageNamed:@"abc"]];
    //卡名
    _cardNameL.text = cardModel.name;
    CGFloat cardNameLwidth = [UILabel getWidthWithTitle:_cardNameL.text font:_cardNameL.font];
    _cardNameL.frame = CGRectMake(ALD(100), ALD(60), cardNameLwidth, ALD(17));
    //面值
    CGFloat faceValueLwidth = [UILabel getWidthWithTitle:_faceValueL.text font:_faceValueL.font];
    _faceValueL.frame = CGRectMake(ALD(100), _cardNameL.bottom + ALD(12), faceValueLwidth, ALD(16));
    //金额
    _valueL.text = [NSString stringWithFormat:@"%@元",cardModel.faceValue];
    CGFloat valueLwidth = [UILabel getWidthWithTitle:_valueL.text font:_valueL.font];
    _valueL.frame = CGRectMake(_faceValueL.right + ALD(10), _faceValueL.y - ALD(2), valueLwidth, ALD(20));
    
}


@end
