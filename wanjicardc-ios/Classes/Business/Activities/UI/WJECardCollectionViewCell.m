//
//  WJECardCollectionViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/8/17.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJECardCollectionViewCell.h"
#import "WJECardModel.h"

@interface WJECardCollectionViewCell()

@property(nonatomic ,strong) UIImageView         *eCardIV;
@property(nonatomic ,strong) UIImageView         *logoIV;
@property(nonatomic ,strong) UIImageView         *activityIcon;
@property(nonatomic ,strong) UILabel             *faceValueL;
@property(nonatomic ,strong) UILabel             *cardNameL;
@property(nonatomic ,strong) UIImageView         *baoziIcon;
@property(nonatomic ,strong) UILabel             *valueL;
@property(nonatomic ,strong) UILabel             *soldL;

@end

@implementation WJECardCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WJColorWhite;
        
        _eCardIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ALD(170), ALD(96))];
        _eCardIV.layer.cornerRadius = 5.0f;
        [self addSubview:self.eCardIV];
        
        _logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(45), ALD(21), ALD(80), ALD(50))];
        [self.eCardIV addSubview:self.logoIV];
        
        _activityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.eCardIV.width - ALD(40), 0, ALD(40), ALD(40))];
        _activityIcon.image = [UIImage imageNamed:@"tip"];
        [self.eCardIV addSubview:self.activityIcon];
        _activityIcon.hidden = YES;
        
        _faceValueL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(0), ALD(60), ALD(152), ALD(20))];
        _faceValueL.textAlignment = NSTextAlignmentRight;
        _faceValueL.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        _faceValueL.textColor = WJColorWhite;
        [self.eCardIV addSubview:self.faceValueL];
        
        _cardNameL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(4), _eCardIV.bottom + ALD(12), ALD(170), ALD(17))];
        _cardNameL.textAlignment = NSTextAlignmentLeft;
        _cardNameL.font = WJFont14;
        _cardNameL.textColor = WJColorDarkGray;
        [self addSubview:self.cardNameL];
        
        _baoziIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(4), _cardNameL.bottom + ALD(10), ALD(16), ALD(13))];
        _baoziIcon.image = [UIImage imageNamed:@"fair_ic_baozi"];
        [self addSubview:self.baoziIcon];
        
        _valueL = [[UILabel alloc] initWithFrame:CGRectMake(_baoziIcon.right + ALD(5), _baoziIcon.bottom + ALD(10), ALD(60), ALD(19))];
        _valueL.textAlignment = NSTextAlignmentLeft;
        _valueL.font = WJFont17;
        _valueL.textColor = WJYellowColorAmount;
        [self addSubview:self.valueL];
        
        _soldL = [[UILabel alloc] initWithFrame:CGRectMake(_valueL.right + ALD(15), ALD(55), ALD(100), ALD(13))];
        _soldL.textAlignment = NSTextAlignmentLeft;
        _soldL.font = WJFont11;
        _soldL.textColor = WJColorPurchase;
        [self addSubview:self.soldL];
    }
    return self;
}

- (void)configData:(WJECardModel *)cardModel{
    if (cardModel == nil) {
        return;
    }
    //卡颜色
    if ([cardModel.cardColorValue isEqualToString:@""] || cardModel.cardColorValue == nil) {
        self.eCardIV.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"#487AE0"];
        
    } else {
        self.eCardIV.backgroundColor = [WJUtilityMethod colorWithHexColorString:cardModel.cardColorValue];
    }
    
    //logo

    if ([cardModel.logoUrl isEqualToString:@""] || cardModel.logoUrl == nil) {
        self.logoIV.image = [UIImage imageNamed:@"home_ad_default"];
    } else {
        [self.logoIV sd_setImageWithURL:[NSURL URLWithString:cardModel.logoUrl] placeholderImage:[UIImage imageNamed:@"home_ad_default"]];
    }
    
    //面值
    self.faceValueL.text = [NSString stringWithFormat:@"%@元",[WJGlobalVariable changeMoneyString:cardModel.facePrice]];
    CGFloat faceValueLwidth = [UILabel getWidthWithTitle:_faceValueL.text font:_faceValueL.font];
    self.faceValueL.frame = CGRectMake( ALD(170) - faceValueLwidth - ALD(14), ALD(72), faceValueLwidth, ALD(19));
    //卡名
    self.cardNameL.text = cardModel.commodityName;
    
    if (self.isCardShop) {
        
        _baoziIcon.hidden = YES;
        
        self.valueL.text = [NSString stringWithFormat:@"￥%@",[WJGlobalVariable changeMoneyString:cardModel.salePriceRmb]];
        CGFloat valueLwidth = [UILabel getWidthWithTitle:_valueL.text font:_valueL.font];
        self.valueL.frame = CGRectMake(_cardNameL.frame.origin.x, _cardNameL.bottom + ALD(6), valueLwidth, ALD(19));
        
        self.valueL.textColor = WJColorAmount;
        self.soldL.textColor = WJYellowColorAmount;
        
    } else {
        
        _baoziIcon.hidden = NO;
        
        self.valueL.text = [WJGlobalVariable changeMoneyString:cardModel.salePrice];
        CGFloat valueLwidth = [UILabel getWidthWithTitle:_valueL.text font:_valueL.font];
        self.valueL.frame = CGRectMake(_baoziIcon.right + ALD(5), _cardNameL.bottom + ALD(6), valueLwidth, ALD(19));
        
        self.valueL.textColor = WJYellowColorAmount;
        self.soldL.textColor = WJColorPurchase;
    }
    
    //包子数
    //    self.valueL.text = [WJGlobalVariable changeMoneyString:cardModel.salePrice];
    //    CGFloat valueLwidth = [UILabel getWidthWithTitle:_valueL.text font:_valueL.font];
    //    self.valueL.frame = CGRectMake(_baoziIcon.right + ALD(5), _cardNameL.bottom + ALD(6), valueLwidth, ALD(19));
    //限购
    if (cardModel.activityType != 0) {
        
        self.activityIcon.hidden = NO;
        self.soldL.hidden = NO;
        //        self.soldL.text = [NSString stringWithFormat:@"每人限购%ld张",cardModel.limitCount];
        if (self.isCardShop) {
            self.soldL.text = [NSString stringWithFormat:@"包子支付更优惠"];
            
        } else {
            self.soldL.text = [NSString stringWithFormat:@"每人限购%ld张",cardModel.limitCount];
            
        }
        CGFloat soldLwidth = [UILabel getWidthWithTitle:_soldL.text font:_soldL.font];
        self.soldL.frame = CGRectMake(_valueL.right + ALD(15), _cardNameL.bottom + ALD(11), soldLwidth, ALD(13));
        
    }else{
        self.activityIcon.hidden = YES;
        self.soldL.hidden = YES;
    }
    
}

@end
