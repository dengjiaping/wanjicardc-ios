//
//  WJShopAndCardsCollectionViewself.m
//  WanJiCard
//
//  Created by silinman on 16/5/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJShopAndCardsCollectionViewCell.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "WJHomePageCardsModel.h"
#import "WJHomePageBottomModel.h"

@implementation WJShopAndCardsCollectionViewCell{

}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(ALD(5), ALD(4), ALD(257), ALD(144))];
        _backView.layer.cornerRadius = 5.0f;
        _backView.backgroundColor = WJColorCardBlue;
        [self.contentView addSubview:self.backView];
        
        _brandBackView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(14), ALD(20), ALD(49), ALD(49))];
        _brandBackView.layer.cornerRadius =  _brandBackView.frame.size.height / 2.0f;
        _brandBackView.backgroundColor = WJColorWhite;
        _brandBackView.alpha = 0.3f;
        [_backView addSubview:self.brandBackView];
        
        _brandIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(14), ALD(20), ALD(49), ALD(49))];
        _brandIV.layer.cornerRadius =  _brandIV.frame.size.height / 2.0f;
        _brandIV.contentMode = UIViewContentModeScaleAspectFit;
        _brandIV.clipsToBounds = YES;
        [_backView addSubview:self.brandIV];
        
        
        UILabel *faceBackValueL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(7), ALD(105), ALD(64), ALD(19))];
        faceBackValueL.layer.cornerRadius = faceBackValueL.height/2;
        faceBackValueL.layer.masksToBounds = YES;
        faceBackValueL.backgroundColor = WJColorWhite;
        faceBackValueL.alpha = 0.3f;
        [_backView addSubview:faceBackValueL];
        
        
        _faceValueL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(7), ALD(105), ALD(64), ALD(19))];
        _faceValueL.textAlignment = NSTextAlignmentCenter;
        _faceValueL.font = WJFont11;
        _faceValueL.textColor = WJColorWhite;
        _faceValueL.layer.cornerRadius = _faceValueL.height/2;
        _faceValueL.layer.masksToBounds = YES;
//        _faceValueL.backgroundColor = WJColorWhite;
//        _faceValueL.alpha = 0.3f;
        [_backView addSubview:self.faceValueL];
        
        _lineL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(83), ALD(20), ALD(0.5), ALD(102))];
        _lineL.alpha = 0.4f;
        _lineL.backgroundColor = WJColorWhite;
        [_backView addSubview:self.lineL];
        
        _cardNameL = [[UILabel alloc] initWithFrame:CGRectZero];
        _cardNameL.textAlignment = NSTextAlignmentLeft;
        _cardNameL.font = WJFont14;
        _cardNameL.textColor = WJColorWhite;
        [_backView addSubview:self.cardNameL];
        
        _valueL = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueL.textAlignment = NSTextAlignmentLeft;
        _valueL.font = WJFont17;
        _valueL.textColor = WJColorWhite;

        [_backView addSubview:self.valueL];

        _privilegeL = [[UILabel alloc] initWithFrame:CGRectZero];
        _privilegeL.textAlignment = NSTextAlignmentLeft;
        _privilegeL.font = WJFont11;
        _privilegeL.textColor = WJColorWhite;
        [_backView addSubview:self.privilegeL];
        
        _activityIV = [[UIImageView alloc] initWithFrame:CGRectMake(_backView.frame.size.width - ALD(32.5), 0, ALD(32.5), ALD(32.5))];
        _activityIV.image = [UIImage imageNamed:@"home_buleCardActivity"];
        [_backView addSubview:self.activityIV];
    }
    return self;
}

- (void)configData:(WJHomePageBottomModel *)bottomModel cardData:(WJHomePageCardsModel *)cardModel{
    NSInteger cardsColor = [cardModel.cardColor integerValue];
    self.backView.backgroundColor = [WJGlobalVariable cardBackgroundColorByType:cardsColor];
    if (cardModel.actsArray.count > 0) {
        switch (cardsColor) {
            case 1:
                self.activityIV.image = [UIImage imageNamed:@"home_redCardActivity"];
                break;
            case 2:
                self.activityIV.image = [UIImage imageNamed:@"home_yellowCardActivity"];
                break;
            case 3:
                self.activityIV.image = [UIImage imageNamed:@"home_buleCardActivity"];
                break;
            case 4:
                self.activityIV.image = [UIImage imageNamed:@"home_greenCardActivity"];
                break;
                
            default:
                break;
        }
    }else{
        self.activityIV.image = nil;
    }
    if (cardModel.faceValue) {
        self.faceValueL.text = [NSString stringWithFormat:@"面值%@",cardModel.faceValue];
    }else{
        self.faceValueL.text = @"";
    }
    if (cardModel.cardName) {
        self.cardNameL.text = cardModel.cardName;
        CGFloat _cardNameLwidth = [UILabel getWidthWithTitle:_cardNameL.text font:_cardNameL.font];
        _cardNameL.frame = CGRectMake(_lineL.right + ALD(12), ALD(27),MIN(_cardNameLwidth, ALD(257) - _lineL.right - ALD(12)) , ALD(16));
    }else{
        self.cardNameL.text = @"";
        _cardNameL.frame = CGRectMake(_lineL.right + ALD(12), ALD(27), 0, ALD(16));
    }
    if (cardModel.actsArray.count > 0) {
        if (cardModel.price) {
            self.valueL.text = [NSString stringWithFormat:@"￥%@",cardModel.price];
            CGFloat valueLwidth = [UILabel getWidthWithTitle:_valueL.text font:_valueL.font];
            _valueL.frame = CGRectMake(_lineL.right + ALD(12), _cardNameL.bottom + ALD(13), valueLwidth, ALD(19));
        }else{
            self.valueL.text = @"";
            _valueL.frame = CGRectMake(_lineL.right + ALD(12), _cardNameL.bottom + ALD(13), 0, ALD(19));
        }
    }else{
        if (cardModel.saleValue) {
            self.valueL.text = [NSString stringWithFormat:@"￥%@",cardModel.saleValue];
            CGFloat valueLwidth = [UILabel getWidthWithTitle:_valueL.text font:_valueL.font];
            _valueL.frame = CGRectMake(_lineL.right + ALD(12), _cardNameL.bottom + ALD(13), valueLwidth, ALD(19));
        }else{
            _valueL.frame = CGRectMake(_lineL.right + ALD(12), _cardNameL.bottom + ALD(13), 0, ALD(19));
            self.valueL.text = @"";
        }
    }
    if (![cardModel.privailegeNum isEqualToString:@"0"] && cardModel.privailegeNum != nil) {
        self.privilegeL.text = [NSString stringWithFormat:@"享有%@项会员卡特权",cardModel.privailegeNum];
        CGFloat privilegeLwidth = [UILabel getWidthWithTitle:_privilegeL.text font:_privilegeL.font];
        _privilegeL.frame = CGRectMake(_lineL.right + ALD(12), _valueL.bottom + ALD(33), privilegeLwidth, ALD(13));
    }else{
        self.privilegeL.text = @"";
    }
    [self.brandIV sd_setImageWithURL:[NSURL URLWithString:cardModel.cardLogo] placeholderImage:nil];

}

@end
