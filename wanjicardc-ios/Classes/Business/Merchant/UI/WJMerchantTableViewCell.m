//
//  WJMerchantTableViewCell.m
//  WanJiCard
//
//  Created by Lynn on 15/9/16.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJMerchantTableViewCell.h"

@interface WJMerchantTableViewCell()

@property (nonatomic, strong) UIImageView   *merLogoImageView;
@property (nonatomic, strong) UILabel       *merTitleLabel;
@property (nonatomic, strong) UILabel       *categoryLabel;
@property (nonatomic, strong) UILabel       *quotaLabel;
@property (nonatomic, strong) UILabel       *totalSaleNumberLabel;
@property (nonatomic, strong) UIView        *bottomLine;

@end

@implementation WJMerchantTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.merLogoImageView = [[UIImageView alloc] init];
        
        self.merTitleLabel = [[UILabel alloc] init];
        self.merTitleLabel.font = WJFont15;
        self.merTitleLabel.textColor = WJColorDarkGray;
        
        UIColor *textColor = WJColorLightGray;
        UIFont  *textFont  = WJFont12;
        
        self.quotaLabel = [[UILabel alloc] init];
        self.quotaLabel.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"ff4400"];
        self.quotaLabel.textAlignment = NSTextAlignmentCenter;
        self.quotaLabel.textColor = [UIColor whiteColor];
        self.quotaLabel.layer.cornerRadius = 3.5;
        self.quotaLabel.clipsToBounds = YES;
        self.quotaLabel.font = [UIFont systemFontOfSize:10];
        
        self.categoryLabel = [[UILabel alloc] init];
        self.categoryLabel.textColor = textColor;
        self.categoryLabel.font = textFont;
        
        self.totalSaleNumberLabel = [[UILabel alloc] init];
        self.totalSaleNumberLabel.textColor = textColor;
        self.totalSaleNumberLabel.font  = textFont;
        
        self.distanceLabel = [[UILabel alloc] init];
        self.distanceLabel.textColor = textColor;
        self.distanceLabel.font = textFont;
        
        self.locationMark = [[UIImageView alloc] init];
        self.locationMark.image = [UIImage imageNamed:@"Details_icon_distance_dis"];
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = WJColorSeparatorLine;
        
        [self.contentView addSubview:self.merLogoImageView];
        [self.contentView addSubview:self.merTitleLabel];
        [self.contentView addSubview:self.quotaLabel];
        [self.contentView addSubview:self.categoryLabel];
        [self.contentView addSubview:self.totalSaleNumberLabel];
        [self.contentView addSubview:self.distanceLabel];
        [self.contentView addSubview:self.locationMark];
        [self.contentView addSubview:self.bottomLine];
    }
    
    return self;
}


- (void)configData:(WJRecommendStoreModel *)model
{
    
    self.merLogoImageView.frame = CGRectMake(ALD(12), ALD(20), ALD(90), ALD(65));
    NSString *imageUrl = ClippingCenterImageUrl(model.cover, ALD(90), ALD(65));
    [self.merLogoImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                             placeholderImage:[UIImage imageNamed:@"merchant_list_default"]];
    
    
    self.merTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.merLogoImageView.frame) + ALD(15), CGRectGetMinY(self.merLogoImageView.frame), kScreenWidth - ALD(129), ALD(15));
    self.merTitleLabel.text = model.name;
    
    
    self.quotaLabel.frame = CGRectMake(CGRectGetMinX(self.merTitleLabel.frame), CGRectGetMaxY(self.merTitleLabel.frame) + ALD(10), ALD(31), ALD(15));
    if (model.isLimitForSale) {
        self.quotaLabel.hidden = NO;
        self.quotaLabel.text = @"特惠";
        self.categoryLabel.frame =  CGRectMake(CGRectGetMaxX(self.quotaLabel.frame) + ALD(7), CGRectGetMinY(self.quotaLabel.frame), kScreenWidth - ALD(120), CGRectGetHeight(self.quotaLabel.frame));
        
    } else {
        self.quotaLabel.hidden = YES;
        self.categoryLabel.frame = CGRectMake(CGRectGetMinX(self.merTitleLabel.frame), CGRectGetMaxY(self.merTitleLabel.frame)+ALD(10), kScreenWidth - ALD(120), CGRectGetHeight(self.quotaLabel.frame));
        
    }
    self.categoryLabel.text = model.category;
    

    self.totalSaleNumberLabel.frame = CGRectMake(CGRectGetMinX(self.merTitleLabel.frame), CGRectGetMaxY(self.categoryLabel.frame) + ALD(10), ALD(120), ALD(15));
    self.totalSaleNumberLabel.text = [NSString stringWithFormat:@"已售%@",model.totalSale];
    
    CGSize distanceSize = [model.distanceStr boundingRectWithSize:CGSizeMake(10000000, ALD(15))
                                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.distanceLabel.font,NSFontAttributeName, nil]
                                                          context:nil].size;
    
    self.distanceLabel.frame = CGRectMake(SCREEN_WIDTH - ALD(12)- distanceSize.width, self.totalSaleNumberLabel.y, distanceSize.width, self.totalSaleNumberLabel.height);
    self.locationMark.frame = CGRectMake(CGRectGetMinX(self.distanceLabel.frame)- ALD(13)-ALD(5), CGRectGetMinY(self.totalSaleNumberLabel.frame)+ALD(1), ALD(13), ALD(13));
    self.distanceLabel.text = model.distanceStr;
    
    self.bottomLine.frame = CGRectMake(ALD(12), ALD(105)-0.5, SCREEN_WIDTH - ALD(24), 0.5);
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
