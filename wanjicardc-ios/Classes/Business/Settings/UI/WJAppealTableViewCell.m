//
//  WJAppealTableViewCell.m
//  WanJiCard
//
//  Created by 孙明月 on 15/12/1.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJAppealTableViewCell.h"

@implementation WJAppealTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), ALD(15), ALD(70), ALD(15))];
        _titleLabel.font = WJFont14;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        
        
        _valueTF = [[UITextField alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width + ALD(10), 0, kScreenWidth - ALD(40) - _titleLabel.frame.size.width, ALD(45))];
        
        _valueTF.font = WJFont14;
        [self.contentView addSubview:_valueTF];
        
        self.rightIV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - ALD(16), ALD(34)/2, ALD(6), ALD(11))];
        self.rightIV.image = [UIImage imageNamed:@"details_rightArrowIcon"];
        [self.contentView addSubview:self.rightIV];
 
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
