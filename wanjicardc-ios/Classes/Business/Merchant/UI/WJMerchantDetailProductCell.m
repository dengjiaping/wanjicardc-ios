//
//  WJMerchantDetailProductCell.m
//  WanJiCard
//
//  Created by Angie on 15/9/25.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJMerchantDetailProductCell.h"

#import "WJModelCard.h"

@implementation WJMerchantDetailProductCell{
    UIImageView *iconIV;
    UILabel *nameL;
    UILabel *introduceL;
    UILabel *salePriceL;
    UILabel *hadSaleL;
    UIImageView *logoIV;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, ALD(15), ALD(90), ALD(65))];
        [self.contentView addSubview:iconIV];
        
        logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, ALD(15), ALD(90), ALD(65))];
        [self.contentView addSubview:logoIV];
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right+10, 6, kScreenWidth- 30-ALD(90), 24)];
        nameL.font = WJFont16;
        [self.contentView addSubview:nameL];
        
        introduceL = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right+10, nameL.bottom, kScreenWidth- 30-ALD(90), 20)];
        introduceL.font = WJFont13;
        [self.contentView addSubview:introduceL];
        
        salePriceL = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right+10, introduceL.bottom, kScreenWidth- 130-ALD(90), 20)];
        salePriceL.font = WJFont15;
        salePriceL.textColor = WJColorAmount;
        [self.contentView addSubview:salePriceL];
        
        hadSaleL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 160, introduceL.bottom, 150, 20)];
        hadSaleL.font = WJFont13;
        hadSaleL.textColor = WJColorDardGray9;
        hadSaleL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:hadSaleL];
    }
    return self;
}

- (void)configWithProduct:(WJModelCard *)product{
    
    iconIV.image = [WJGlobalVariable cardBgImageByType:product.colorType];//    iconIV.backgroundColor = [WJUtilityMethod randomColor];
    [logoIV sd_setImageWithURL:[NSURL URLWithString:product.coverURL] placeholderImage:[UIImage imageNamed:@"card_default"]];
    nameL.text = product.name;
    introduceL.text = product.name;
    
    salePriceL.text = [NSString stringWithFormat:@"￥ %@", [WJUtilityMethod floatNumberForMoneyFomatter:product.balance]];//元
    hadSaleL.text = [NSString stringWithFormat:@"已售：%@", @(product.saledNumber)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
