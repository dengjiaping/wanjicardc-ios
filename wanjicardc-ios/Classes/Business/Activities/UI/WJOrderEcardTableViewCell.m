//
//  WJOrderEcardTableViewCell.m
//  WanJiCard
//
//  Created by 林有亮 on 16/11/14.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJOrderEcardTableViewCell.h"
#import "WJECardModel.h"

@interface WJOrderEcardTableViewCell()
{
    UIView          * cardBgView;
    UIImageView     * logoImageView;
    UILabel         * faceValueLabel;
    UILabel         * eCardNameLabel;
    UILabel         * numLabel;
    UILabel         * valueLabel;
}

@end

@implementation WJOrderEcardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cardBgView = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(15), ALD(109), ALD(61))];
        cardBgView.layer.cornerRadius = 5;
        
        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(25), ALD(15), ALD(59), ALD(30))];
        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        faceValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(40), ALD(100), ALD(20))
                          ];
        faceValueLabel.textAlignment = NSTextAlignmentRight;
        faceValueLabel.font = [UIFont boldSystemFontOfSize:18];
        faceValueLabel.textColor = WJColorWhite;
        
        
        [cardBgView addSubview:logoImageView];
        [cardBgView addSubview:faceValueLabel];
        
        CGFloat minX = CGRectGetMaxX(cardBgView.frame) + ALD(15);
        
        eCardNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX, ALD(15), kScreenWidth - minX - ALD(12), ALD(20))];
        eCardNameLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
        eCardNameLabel.font = [UIFont systemFontOfSize:15];
        
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX, ALD(35), CGRectGetWidth(eCardNameLabel.frame), ALD(20))];
        numLabel.font = [UIFont systemFontOfSize:12];
        numLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"9099a6"];
        
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX, ALD(55), CGRectGetWidth(eCardNameLabel.frame), ALD(20))];
        valueLabel.font = [UIFont systemFontOfSize:14];
        valueLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"f02b2b"];
        
        [self.contentView addSubview:cardBgView];
        [self.contentView addSubview:eCardNameLabel];
        [self.contentView addSubview:numLabel];
        [self.contentView addSubview:valueLabel];
    }
    return self;
}

- (void)refreshWithModel:(WJECardModel *)model
{
    cardBgView.backgroundColor = [WJUtilityMethod colorWithHexColorString:model.cardColorValue];
    
    [logoImageView sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]];
    faceValueLabel.text = [NSString stringWithFormat:@"%@",model.facePrice];
    
    eCardNameLabel.text = model.commodityName;
    numLabel.text = [NSString stringWithFormat:@"数量: %@",model.soldCount];
    valueLabel.text = [NSString stringWithFormat:@"￥ %@",model.salePriceRmb];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
