//
//  WJCardsDetailTitleTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/6/6.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCardsDetailTitleTableViewCell.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "WJCardModel.h"

@implementation WJCardsDetailTitleTableViewCell{
    UIView          *backView;
    UILabel         *titleL;
    UILabel         *activityIV;
    UILabel         *activityL;
    UILabel         *discountL;
    UILabel         *moneyL;
    UILabel         *soldL;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(115))];
        backView.backgroundColor = WJColorWhite;
        [self.contentView addSubview:backView];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectZero];
        titleL.font = WJFont15;
        titleL.textAlignment = NSTextAlignmentLeft;
        titleL.textColor = WJColorDarkGray;
        [backView addSubview:titleL];
        
        activityIV = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), titleL.bottom + ALD(15), ALD(32), ALD(16))];
        activityIV.backgroundColor = WJColorCardRed;
        activityIV.textAlignment = NSTextAlignmentCenter;
        activityIV.font = WJFont10;
        activityIV.textColor = WJColorWhite;
        activityIV.layer.cornerRadius = 3.0f;
        activityIV.layer.masksToBounds = YES;
        [backView addSubview:activityIV];
        
        activityL = [[UILabel alloc] initWithFrame:CGRectZero];
        activityL.font = WJFont13;
        activityL.textColor = WJColorLightGray;
        [backView addSubview:activityL];
        
        discountL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), activityL.bottom + ALD(15), kScreenWidth - ALD(24), ALD(15))];
        discountL.textAlignment = NSTextAlignmentLeft;
        discountL.font = WJFont13;
        discountL.textColor = WJColorLightGray;
        [backView addSubview:discountL];
        
        moneyL = [[UILabel alloc] initWithFrame:CGRectZero];
        moneyL.font = WJFont18;
        moneyL.textColor = WJColorAmount;
        [backView addSubview:moneyL];
        
        soldL = [[UILabel alloc] initWithFrame:CGRectZero];
        soldL.font = WJFont13;
        soldL.textColor = WJColorLightGray;
        soldL.textAlignment = NSTextAlignmentRight;
        [backView addSubview:soldL];
    }
    return self;
}

- (void)configData:(WJCardModel *)cardModel{
    if (cardModel == nil) {
        return;
    }
    titleL.text = cardModel.name;
    CGFloat titleLwidth = [UILabel getWidthWithTitle:titleL.text font:titleL.font];
    titleL.frame = CGRectMake(ALD(12), 0, titleLwidth, ALD(17));
    
    if ([cardModel.isLimitForSale isEqualToString:@"1"]) {
        
        activityIV.hidden = NO;
        activityL.hidden = NO;
        backView.frame = CGRectMake(0, 0, kScreenWidth, ALD(115));
        
        activityIV.text = cardModel.activityName?:@"特惠";
        CGFloat activityIVwidth = [UILabel getWidthWithTitle:activityIV.text font:activityIV.font];
        activityIV.frame = CGRectMake(ALD(12), titleL.bottom + ALD(15), activityIVwidth + ALD(10), ALD(16));
        
        activityL.text = cardModel.activityDescription;
        CGFloat activityLwidth = [UILabel getWidthWithTitle:activityL.text font:activityL.font];
        activityL.frame = CGRectMake(activityIV.right + ALD(10), activityIV.y, activityLwidth, ALD(15));
        
        discountL.text = cardModel.adString;
        discountL.frame = CGRectMake(ALD(12), activityL.bottom + ALD(15), kScreenWidth - ALD(24), ALD(15));
        
        moneyL.text = [NSString stringWithFormat:@"￥%@",cardModel.price];
        CGFloat moneyLwidth = [UILabel getWidthWithTitle:moneyL.text font:moneyL.font];
        moneyL.frame = CGRectMake(ALD(12), discountL.bottom + ALD(12), moneyLwidth, ALD(20));
    }else{
        backView.frame = CGRectMake(0, 0, kScreenWidth, ALD(85));
        
        activityIV.hidden = YES;
        activityL.hidden = YES;
        
        discountL.text = cardModel.adString;
        discountL.frame = CGRectMake(ALD(12), titleL.bottom + ALD(15), kScreenWidth - ALD(24), ALD(15));
        
        moneyL.text = [NSString stringWithFormat:@"￥%@",cardModel.salePrice];
        CGFloat moneyLwidth = [UILabel getWidthWithTitle:moneyL.text font:moneyL.font];
        moneyL.frame = CGRectMake(ALD(12), discountL.bottom + ALD(12), moneyLwidth, ALD(20));
    }

    soldL.text = [NSString stringWithFormat:@"已售%ld",(long)cardModel.saledNumber];
    CGFloat soldLwidth = [UILabel getWidthWithTitle:soldL.text font:soldL.font];
    soldL.frame = CGRectMake(kScreenWidth - ALD(12) - soldLwidth, discountL.bottom + ALD(13), soldLwidth, ALD(20));

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
