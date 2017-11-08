//
//  WJMessageCenterTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/6/17.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMessageCenterTableViewCell.h"
#import "WJNewsCenterModel.h"

@interface WJMessageCenterTableViewCell()



@end


@implementation WJMessageCenterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _listIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12), ALD(17), ALD(35), ALD(35))];
        _listIV.layer.cornerRadius = _listIV.frame.size.width / 2.0;
        [self.contentView addSubview:self.listIV];
        
        _noticeIV = [[UIImageView alloc] initWithFrame:CGRectMake(_listIV.right - ALD(8), ALD(17), ALD(10), ALD(10))];
        _noticeIV.layer.cornerRadius = _noticeIV.frame.size.width / 2.0;
        _noticeIV.backgroundColor = WJColorAmount;
        [self.contentView addSubview:self.noticeIV];
        _noticeIV.hidden = YES;
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(_listIV.right + ALD(10), ALD(15), ALD(220), ALD(18))];
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.font = WJFont16;
        _titleL.textColor = WJColorDarkGray;
        [self.contentView addSubview:self.titleL];
        
        _contentL = [[UILabel alloc] initWithFrame:CGRectMake(_listIV.right + ALD(10),_titleL.bottom + ALD(5), kScreenWidth - _listIV.right - ALD(140), ALD(16))];
        _contentL.textAlignment = NSTextAlignmentLeft;
        _contentL.font = WJFont14;
        _contentL.textColor = WJColorLightGray;
        [self.contentView addSubview:self.contentL];
        
        _moneyL = [[UILabel alloc] initWithFrame:CGRectMake(_contentL.right + ALD(10),_titleL.bottom + ALD(5), kScreenWidth - _contentL.right - ALD(22), ALD(16))];
        _moneyL.textAlignment = NSTextAlignmentRight;
        _moneyL.font = WJFont14;
        _moneyL.textColor = WJColorLightGray;
        [self.contentView addSubview:self.moneyL];
        _moneyL.hidden = YES;
        
        _lineL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(72), kScreenWidth - ALD(24), ALD(0.5))];
        _lineL.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:self.lineL];
    }
    return self;
}

- (void)configData:(WJNewsCenterModel *)model{
    
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
