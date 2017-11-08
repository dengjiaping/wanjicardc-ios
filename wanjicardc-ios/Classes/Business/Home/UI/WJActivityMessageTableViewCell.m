//
//  WJActivityMessageTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/7/7.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJActivityMessageTableViewCell.h"
#import "WJSystemNewsModel.h"

@implementation WJActivityMessageTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), 0, kScreenWidth - ALD(24), ALD(167))];
        _backView.layer.shadowPath = [UIBezierPath  bezierPathWithRect:_backView.bounds].CGPath;
        _backView.layer.cornerRadius = 5.0f;
        _backView.layer.shadowOffset = CGSizeMake(0, 3);
        _backView.layer.shadowOpacity = 0.10;
        _backView.backgroundColor = WJColorWhite;
        [self.contentView addSubview:self.backView];
        
        _backIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _backView.width, ALD(132))];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_backIV.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _backIV.bounds;
        maskLayer.path = maskPath.CGPath;
        _backIV.layer.mask = maskLayer;
        [_backView addSubview:self.backIV];
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), _backIV.bottom + ALD(15), _backView.width - ALD(24), ALD(13))];
        _timeL.font = WJFont12;
        _timeL.textAlignment = NSTextAlignmentRight;
        _timeL.textColor = WJColorLightGray;
        [_backView addSubview:self.timeL];
    }
    return self;
}

- (void)configData:(WJSystemNewsModel *)model{
    
    [self.backIV sd_setImageWithURL:[NSURL URLWithString:model.pcUrl]
                 placeholderImage:[UIImage imageNamed:@"home_banner_default"]];
    self.timeL.text    = [NSString stringWithFormat:@"%@   %@",model.date,model.time];
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
