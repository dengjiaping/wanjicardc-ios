//
//  WJConsumeMessageTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/6/17.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJConsumeMessageTableViewCell.h"
#import "WJConsumeNewsModel.h"

@implementation WJConsumeMessageTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(15), ALD(250), ALD(17))];
        _titleL.text = @"京川婆婆骨汤麻辣烫店京川婆婆骨汤麻辣烫店";
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.font = WJFont15;
        _titleL.textColor = WJColorDarkGray;
        [self.contentView addSubview:self.titleL];
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12),_titleL.bottom + ALD(15), ALD(200),  ALD(15))];
        _timeL.text = @"2016-06-18   19:30:05";
        _timeL.textAlignment = NSTextAlignmentLeft;
        _timeL.font = WJFont12;
        _timeL.textColor = WJColorLightGray;
        [self.contentView addSubview:self.timeL];
        
        _moneyL = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.right, ALD(15), kScreenWidth - _titleL.right - ALD(12), ALD(18))];
        _moneyL.text = @"￥250.00";
        _moneyL.textAlignment = NSTextAlignmentRight;
        _moneyL.font = WJFont15;
        _moneyL.textColor = WJColorDarkGray;
        [self.contentView addSubview:self.moneyL];
        
        _lineL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(69), kScreenWidth - ALD(24), ALD(0.5))];
        _lineL.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:self.lineL];
    }
    return self;
}

- (void)configData:(WJConsumeNewsModel *)model cellType:(NSInteger)type{
    if (type == 1) {
        self.moneyL.hidden  = NO;
        self.titleL.text    = model.reqParam;
        self.moneyL.text    = [NSString stringWithFormat:@"￥%@",model.money];
        self.timeL.text     = [NSString stringWithFormat:@"%@   %@",model.date,model.time];
    }else{
        self.moneyL.hidden  = YES;
        self.titleL.text    = model.reqParam;
        self.titleL.frame   = CGRectMake(ALD(12), ALD(15), kScreenWidth - ALD(24), ALD(17));
        self.timeL.text     = [NSString stringWithFormat:@"%@   %@",model.date,model.time];
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
