//
//  WJShopInfoTitleTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/7/15.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJShopInfoTitleTableViewCell.h"


@interface WJShopInfoTitleTableViewCell(){
    UIView          *titleBg;
    UIView          *topLine;
    UIView          *bottomLine_1;
    UILabel         *infoL;
    UIView          *bottomLine;
    UIImageView     *arrowImageView;
    BOOL            hiddenExplain;
}

@end



@implementation WJShopInfoTitleTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(10))];
        titleBg.backgroundColor = WJColorViewBg;
        [self.contentView addSubview:titleBg];
        
        topLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(10), kScreenWidth, ALD(0.5))];
        topLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:topLine];
        
        bottomLine_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(0.5))];
        bottomLine_1.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:bottomLine_1];
        
        infoL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(25), 200, ALD(16))];
        infoL.font = WJFont14;
        infoL.textColor = WJColorDarkGray;
        [self.contentView addSubview:infoL];
        
        bottomLine = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(53), kScreenWidth - ALD(24), ALD(0.5))];
        bottomLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:bottomLine];
        
        arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(23), ALD(30), ALD(11), ALD(6))];
        arrowImageView.image =[UIImage imageNamed:@"details_downArrowIcon"];
        [self.contentView addSubview:arrowImageView];
        
    }
    return self;
}

- (void)configData:(BOOL)hiddenRow cellTitle:(NSString *)title{
    infoL.text = title;
    hiddenExplain = hiddenRow;
    if (hiddenExplain) {
        arrowImageView.image =[UIImage imageNamed:@"details_downArrowIcon"];
        bottomLine.hidden = YES;
    }else{
        arrowImageView.image =[UIImage imageNamed:@"details_upArrowIcon"];
        bottomLine.hidden = NO;
    }
    
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
