//
//  WJClearHistoryTableCell.m
//  WanJiCard
//
//  Created by 孙明月 on 16/5/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJClearHistoryTableCell.h"

@implementation WJClearHistoryTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGSize textSize = [@"清除历史记录" boundingRectWithSize:CGSizeMake(10000000, 100)
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:[NSDictionary dictionaryWithObjectsAndKeys:WJFont14,NSFontAttributeName, nil]
                                                  context:nil].size;
        
        UIImageView *cleanImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - (ALD(15) + textSize.width) - ALD(5))/2, ALD(44-15)/2, ALD(15), ALD(15))];
        cleanImage.image = [UIImage imageNamed:@"SearchHistoryClean"];
        [self.contentView addSubview:cleanImage];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(CGRectGetMaxX(cleanImage.frame) + ALD(5), 0, textSize.width, ALD(44))];
        [button setTitle:@"清除历史记录" forState:UIControlStateNormal];
        [button setTitleColor:WJColorLightGray forState:UIControlStateNormal];
        button.backgroundColor = WJColorWhite;
        [button.titleLabel setFont:WJFont14];
        [button addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(44)-0.5, SCREEN_WIDTH, 0.5)];
        bottomLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:bottomLine];
        
    }
    return self;
}



- (void)clearHistory
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clearHistoryWithCell:)]) {
        [self.delegate clearHistoryWithCell:self];
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
