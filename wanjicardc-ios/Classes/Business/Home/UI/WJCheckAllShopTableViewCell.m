//
//  WJCheckAllShopTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/5/28.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCheckAllShopTableViewCell.h"

@implementation WJCheckAllShopTableViewCell{
    UIView          *backView;
    UILabel         *titleL;
    UIImageView     *arrowIV;
    UILabel         *topLine;
    UILabel         *bottomLine;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = WJColorViewBg2;
        
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(10), kScreenWidth, ALD(45))];
        backView.backgroundColor = WJColorWhite;
        [self.contentView addSubview:backView];
        
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(15), ALD(100), ALD(17))];
        titleL.font = WJFont14;
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.centerX = kScreenWidth/2;
        titleL.textColor = WJColorLightGray;
        titleL.text = @"查看全部商家";
        CGFloat titleLwidth = [UILabel getWidthWithTitle:titleL.text font:titleL.font];
        titleL.frame = CGRectMake((kScreenWidth - titleLwidth)/2, 0, titleLwidth, ALD(45));
        [backView addSubview:titleL];
        
        arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(titleL.right + ALD(10), ALD(16), ALD(6), ALD(12))];
        arrowIV.image = [UIImage imageNamed:@"home_rightArrowsIcon"];
        [backView addSubview:arrowIV];
        
        topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(0.5))];
        topLine.backgroundColor = WJColorDarkGrayLine;
        [backView addSubview:topLine];
        
        bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(44.5), kScreenWidth, ALD(0.5))];
        bottomLine.backgroundColor = WJColorDarkGrayLine;
        [backView addSubview:bottomLine];
    }
    return self;
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
