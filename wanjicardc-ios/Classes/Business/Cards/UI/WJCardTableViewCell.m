//
//  WJCardTableViewCell.m
//  WanJiCard
//
//  Created by Lynn on 15/9/22.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJCardTableViewCell.h"
#import "WJModelCard.h"

@interface WJCardTableViewCell()

@property (nonatomic, strong) UIImageView   *backImageView;
@property (nonatomic, strong) UIImageView   *iconImageView;
@property (nonatomic, strong) UILabel       *cardNameLabel;
@property (nonatomic, strong) UILabel       *priceLabel;
@property (nonatomic, strong) NSDictionary  *colorDic;

@end

@implementation WJCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backImageView = [[UIImageView alloc] init];
        _iconImageView = [[UIImageView alloc] init];
        _cardNameLabel = [[UILabel alloc] init];
        _cardNameLabel.textColor = [UIColor whiteColor];
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:_backImageView];
        [self.contentView addSubview:_iconImageView];
        [self.contentView addSubview:_cardNameLabel];
        [self.contentView addSubview:_priceLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_backImageView setFrame:CGRectMake(0, ALD(15), kScreenWidth, ALD(90))];
    [_iconImageView setFrame:CGRectMake(ALD(30), ALD(30), ALD(55) , ALD(35))];
    [_cardNameLabel setFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + ALD(15), ALD(20), kScreenWidth - ALD(130), ALD(30))];
    
//    [_buttonBackImageView setFrame:CGRectMake(kScreenWidth - ALD(90), ALD(35), ALD(65), ALD(30))];
    [_priceLabel setFrame:CGRectMake(kScreenWidth - ALD(230) , CGRectGetMaxY(_cardNameLabel.frame), ALD(200), CGRectGetHeight(_cardNameLabel.frame))];
        
}

- (void)configData:(WJModelCard *)model
{
    [self.backImageView setImage:[WJGlobalVariable cardBgImageWithBgByType:model.colorType]];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.coverURL] placeholderImage:[UIImage imageNamed:@"card_defauld"]];
    self.cardNameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f", model.balance];
}



- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSDictionary *)colorDic
{
    if (nil == _colorDic) {
        _colorDic = @{@"10":@"blue",@"20":@"green",@"30":@"orange",@"40":@"red"};
    }
    return _colorDic;
}


@end
