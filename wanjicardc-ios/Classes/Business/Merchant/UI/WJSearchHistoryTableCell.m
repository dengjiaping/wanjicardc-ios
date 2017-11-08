//
//  WJSearchHistoryTableCell.m
//  WanJiCard
//
//  Created by 孙明月 on 16/5/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJSearchHistoryTableCell.h"

@implementation WJSearchHistoryTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), ALD(44-15)/2, ALD(15), ALD(15))];
        timeImage.image = [UIImage imageNamed:@"SearchHistorySearch"];
        [self.contentView addSubview:timeImage];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeImage.frame) + ALD(10), 0, SCREEN_WIDTH - ALD(37), ALD(44))];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.textColor = WJColorLightGray;
        self.nameLabel.font = WJFont15;
        
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(44)-0.5, SCREEN_WIDTH-ALD(12), 0.5)];
        bottomLine.backgroundColor = WJColorSeparatorLine;
        
        
        [self.contentView addSubview:timeImage];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:bottomLine];
        
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
