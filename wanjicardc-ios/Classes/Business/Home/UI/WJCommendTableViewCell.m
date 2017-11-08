//
//  WJCommendTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/5/27.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCommendTableViewCell.h"

@implementation WJCommendTableViewCell{
    UILabel *titleL;
    UILabel *bottomLine;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(12), ALD(80), ALD(17))];
        titleL.textAlignment = NSTextAlignmentLeft;
        titleL.text = @"为我推荐";
        titleL.font = WJFont14;
        titleL.textColor = WJColorDarkGray;
        [self.contentView addSubview:titleL];
        
        bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(39), kScreenWidth, ALD(0.5))];
        bottomLine.backgroundColor = WJColorSeparatorLine;
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
