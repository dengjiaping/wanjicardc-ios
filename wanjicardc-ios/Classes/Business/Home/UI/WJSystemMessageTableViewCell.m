//
//  WJSystemMessageTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/6/17.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJSystemMessageTableViewCell.h"
#import "WJSystemNewsModel.h"

@implementation WJSystemMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _contentL = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentL.textAlignment = NSTextAlignmentLeft;
        _contentL.lineBreakMode = NSLineBreakByWordWrapping;
        _contentL.numberOfLines = 0;
        _contentL.font          = WJFont14;
        _contentL.textColor     = WJColorDarkGray;
        [self.contentView addSubview:self.contentL];
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12),_contentL.bottom + ALD(10), ALD(200),  ALD(15))];
        _timeL.textAlignment = NSTextAlignmentLeft;
        _timeL.font = WJFont12;
        _timeL.textColor = WJColorLightGray;
        [self.contentView addSubview:self.timeL];
        
        _lineL = [[UIView alloc] initWithFrame:CGRectMake(ALD(12),_timeL.bottom + ALD(14.5), kScreenWidth - ALD(24), ALD(0.5))];
        _lineL.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:self.lineL];
    }
    return self;
}
- (void)configData:(WJSystemNewsModel *)model{
    self.contentL.text          = model.content;
    NSDictionary *dic           = [NSDictionary dictionaryWithObjectsAndKeys:WJFont14,NSFontAttributeName,nil];
    CGSize sizeText             = [_contentL.text boundingRectWithSize:CGSizeMake(kScreenWidth - ALD(24), MAXFLOAT)
                                                          options:NSStringDrawingUsesLineFragmentOrigin  | NSStringDrawingTruncatesLastVisibleLine
                                                       attributes:dic context:nil].size;
//    CGFloat height          = [UILabel getHeightByWidth:kScreenWidth - ALD(24) title:model.content font:WJFont14];
    self.contentL.frame         = CGRectMake(ALD(12), ALD(10), kScreenWidth - ALD(24), sizeText.height);
    self.timeL.text             = [NSString stringWithFormat:@"%@   %@",model.date,model.time];
    self.timeL.frame            = CGRectMake(ALD(12),_contentL.bottom + ALD(10), ALD(200),  ALD(15));
    self.lineL.frame            = CGRectMake(ALD(12),_timeL.bottom + ALD(14.5), kScreenWidth - ALD(24), ALD(0.5));
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
