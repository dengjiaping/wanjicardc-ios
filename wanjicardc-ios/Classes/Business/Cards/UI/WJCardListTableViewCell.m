//
//  WJCardListTableViewCell.m
//  WanJiCard
//
//  Created by Lynn on 15/10/13.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJCardListTableViewCell.h"
#import "WJMerchantCard.h"
#import "WJSaleProgressView.h"

#define  originalLabelWidth                        (iPhone6OrThan ? (ALD(100)):(ALD(90)))
#define  SpaceWidth                                (iPhone6OrThan ? (ALD(10)):(ALD(20)))

@interface WJCardListTableViewCell ()

@property (nonatomic, strong) UIView            *backView;
@property (nonatomic, strong) UIImageView       *cardImageView;
@property (nonatomic, strong) UILabel           *lineL;
@property (nonatomic, strong) UILabel           *cardMoneyL;
@property (nonatomic, strong) UILabel           *quotaLabel;
@property (nonatomic, strong) WJSaleProgressView *saleProgressView;
@property (nonatomic, strong) UILabel           *cardNameLabel;
@property (nonatomic, strong) UILabel           *cardDesLabel;
@property (nonatomic, strong) UILabel           *priceLabel;
@property (nonatomic, strong) UILabel           *originalLabel;
@property (nonatomic, strong) UILabel           *saledNumberLabel;
@property (nonatomic, strong) UIImageView       *logoImageView;
@property (nonatomic, strong) UILabel           *merNameLabel;
@property (nonatomic, strong) UILabel           *merDesLabel;
@property (nonatomic, strong) NSDictionary      *colorDic;

@end

@implementation WJCardListTableViewCell

//height = 105
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(104.5), kScreenWidth - ALD(24), ALD(0.5))];
        _bottomLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:self.bottomLine];
        
        //卡背景
        _cardImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), ALD(20), ALD(109), ALD(65))];
        _cardImageView.layer.cornerRadius = 5.f;
        _cardImageView.layer.masksToBounds  = YES;
        
        //卡名
        _cardNameLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cardImageView.frame) + ALD(15), ALD(21), kScreenWidth - ALD(154), ALD(17))];
        _cardNameLabel.font = WJFont15;
        _cardNameLabel.textColor = WJColorDarkGray;
        
        //活动
        _quotaLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_cardNameLabel.frame), CGRectGetMaxY(_cardNameLabel.frame) + ALD(8), ALD(31), ALD(14))];
        _quotaLabel.backgroundColor = WJColorCardRed;
        _quotaLabel.textAlignment = NSTextAlignmentCenter;
        _quotaLabel.textColor = [UIColor whiteColor];
        _quotaLabel.layer.cornerRadius = 3.5f;
        _quotaLabel.clipsToBounds = YES;
        _quotaLabel.font = [UIFont systemFontOfSize:10];
        
        //面值
        _cardDesLabel   = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_quotaLabel.frame) + ALD(7), CGRectGetMinY(_quotaLabel.frame), CGRectGetWidth(_cardNameLabel.frame),CGRectGetHeight(_quotaLabel.frame))];
        _cardDesLabel.font = WJFont12;
        _cardDesLabel.textColor = WJColorLightGray;
        
        //售价（红色）
        _priceLabel     = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_cardNameLabel.frame), CGRectGetMaxY(_cardDesLabel.frame) + ALD(8), ALD(100), ALD(22))];
        _priceLabel.font = WJFont14;
        _priceLabel.textColor = WJColorAmount;
        
        //原价
        _originalLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame) -    SpaceWidth, CGRectGetMinY(_priceLabel.frame), originalLabelWidth,  CGRectGetHeight(_priceLabel.frame))];
        _originalLabel.font = WJFont10;
        _originalLabel.textColor = WJColorLightGray;
        
        //已售卡数量
        _saledNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(10) - CGRectGetWidth(_cardDesLabel.frame), CGRectGetMaxY(_cardDesLabel.frame), CGRectGetWidth(_cardDesLabel.frame), CGRectGetHeight(_cardDesLabel.frame))];
        _saledNumberLabel.font = WJFont11;
        _saledNumberLabel.textColor = WJColorLightGray;
        _saledNumberLabel.textAlignment = NSTextAlignmentRight;
        
        //已售百分比进度条
        _saleProgressView = [[WJSaleProgressView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(65), CGRectGetMaxY(_saledNumberLabel.frame) + ALD(5), ALD(55), ALD(7))];
        
        //logo背景图
        _backView = [[UIView alloc] initWithFrame:CGRectMake(ALD(5), ALD(20), ALD(21), ALD(21))];
        _backView.layer.cornerRadius =  _backView.frame.size.height / 2.0f;
        _backView.backgroundColor = WJColorWhite;
        _backView.alpha = 0.3f;
        
        //logo图片
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(5), ALD(20), ALD(21), ALD(21))];
        _logoImageView.layer.cornerRadius =  _logoImageView.width / 2.0f;
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.clipsToBounds = YES;
        
        _lineL = [[UILabel alloc] initWithFrame:CGRectMake(_backView.right + ALD(6), ALD(20), ALD(0.5), ALD(21))];
        _lineL.alpha = 0.4f;
        _lineL.backgroundColor = WJColorWhite;
        
        //背景图上卡名
        _merNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_lineL.right + ALD(6), ALD(22), ALD(75), ALD(8))];
        _merNameLabel.textColor = WJColorWhite;
        _merNameLabel.font = [UIFont systemFontOfSize:6];
        
        //背景图上卡面值
        _cardMoneyL = [[UILabel alloc] initWithFrame:CGRectMake(_lineL.right + ALD(6), _merNameLabel.bottom + ALD(5), ALD(75), ALD(7))];
        _cardMoneyL.textColor = WJColorWhite;
        _cardMoneyL.font = [UIFont systemFontOfSize:5];
        
        //背景图上商家名
        _merDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(5), ALD(50), ALD(99), ALD(10))];
        _merDesLabel.textColor = [UIColor whiteColor];
        _merDesLabel.font = [UIFont systemFontOfSize:5];
        
        [self.contentView addSubview:_cardImageView];
        [self.contentView addSubview:_cardNameLabel];
        [self.contentView addSubview:_cardDesLabel];
        [self.contentView addSubview:_priceLabel];
        [self.contentView addSubview:_saledNumberLabel];
        [self.contentView addSubview:_originalLabel];
        [self.contentView addSubview:_saleProgressView];
        [self.contentView addSubview:_quotaLabel];
        
        [_cardImageView addSubview:_lineL];
        [_cardImageView addSubview:_cardMoneyL];
        [_cardImageView addSubview:_backView];
        [_cardImageView addSubview:_logoImageView];
        [_cardImageView addSubview:_merNameLabel];
        [_cardImageView addSubview:_merDesLabel];
        _merDesLabel.hidden = YES;
    }
    return self;
}

- (void)configWithProduct:(WJMerchantCard *)cardModel
{
    self.cardImageView.backgroundColor = [WJGlobalVariable cardBackgroundColorByType:cardModel.colorType];
//    [self.cardImageView setImage:[WJGlobalVariable cardBgImageByType:cardModel.colorType]];
    self.cardNameLabel.text = cardModel.name;
    self.cardMoneyL.text = [NSString stringWithFormat:@"面值￥%ld元", (long)cardModel.faceValue];//元
    self.cardDesLabel.text = [NSString stringWithFormat:@"面值%ld元", (long)cardModel.faceValue];//元
    self.originalLabel.text = [NSString stringWithFormat:@"￥%@",[WJUtilityMethod floatNumberForMoneyFomatter:cardModel.salePrice]];
    self.saledNumberLabel.text = [NSString stringWithFormat:@"已售%ld",(long)cardModel.saledNumber];
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:cardModel.coverURL]
              placeholderImage:[UIImage imageNamed:@"topic_default"]];
    self.merNameLabel.text = cardModel.name;
    self.merDesLabel.text = cardModel.merName;
    
    if (cardModel.isLimitForSale) {
        self.quotaLabel.text = @"特惠";
        self.quotaLabel.hidden = NO;
        self.saleProgressView.hidden = NO;
        self.originalLabel.hidden = NO;
        
        CGFloat salePercent = cardModel.salePercent *0.01;
        [self.saleProgressView setProgress:salePercent];
        
        self.priceLabel.text = [NSString stringWithFormat:@"￥ %@",[WJUtilityMethod floatNumberForMoneyFomatter:cardModel.price]];
        if (cardModel.salePercent < 0) {
            cardModel.salePercent = 0;
        }
        self.saledNumberLabel.text = [NSString stringWithFormat:@"已售%ld%@",(long)cardModel.salePercent,@"%"];
        
        NSString *priceStr = self.priceLabel.text;
        
        CGSize size = [priceStr sizeWithAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        
        _priceLabel.frame =  CGRectMake(CGRectGetMinX(_cardNameLabel.frame), CGRectGetMaxY(_cardDesLabel.frame) + ALD(8), size.width, ALD(22));

        _originalLabel.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame) + ALD(5), CGRectGetMinY(_priceLabel.frame), originalLabelWidth, CGRectGetHeight(_priceLabel.frame));
        
    } else {
        
        self.quotaLabel.hidden = YES;
        self.saleProgressView.hidden = YES;
        self.originalLabel.hidden = YES;
        
        self.priceLabel.text = [NSString stringWithFormat:@"￥ %@",[WJUtilityMethod floatNumberForMoneyFomatter:cardModel.salePrice]];
        
        _cardDesLabel.frame = CGRectMake(CGRectGetMinX(_cardNameLabel.frame), CGRectGetMaxY(_cardNameLabel.frame) + ALD(8),  CGRectGetWidth(_cardNameLabel.frame), CGRectGetHeight(_quotaLabel.frame));
        
        _saledNumberLabel.frame =CGRectMake(kScreenWidth - ALD(110), CGRectGetMaxY(_cardDesLabel.frame) + ALD(15), ALD(100), ALD(14));
        
    }
    //为originalLabel加删除线
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_originalLabel.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, [_originalLabel.text length])];
    [attri addAttribute:NSStrikethroughColorAttributeName value:_originalLabel.textColor range:NSMakeRange(0, [_originalLabel.text length])];
    [_originalLabel setAttributedText:attri];
    
}


- (NSDictionary *)colorDic
{
    if (nil == _colorDic) {
        _colorDic = @{@"10":@"blue",@"20":@"green",@"30":@"orange",@"40":@"red"};
    }
    return _colorDic;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
