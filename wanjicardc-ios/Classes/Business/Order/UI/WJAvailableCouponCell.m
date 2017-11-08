//
//  WJAvailableCouponCell.m
//  WanJiCard
//
//  Created by 孙琦 on 16/5/26.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJAvailableCouponCell.h"

@implementation WJAvailableCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _unSelectImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45,20, 20)];
        _unSelectImage.image = [UIImage imageNamed:@"toggle_button_nor"];
        [self.contentView addSubview:_unSelectImage];
        
        _selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, 20, 20)];
        _selectImage.image = [UIImage imageNamed:@"toggle_button_selected"];
        _selectImage.hidden = YES;
        [self.contentView addSubview:_selectImage];
        
        _backgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_selectImage.right+10, 15, kScreenWidth-60, 105)];
        //  _backgImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_backgImageView];
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(20), ALD(20), ALD(200), 18)];
        _titleLabel.text = @"味多美电子优惠券";
        _titleLabel.font = WJFont16;
        [_backgImageView addSubview:_titleLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(20), _titleLabel.bottom+5, ALD(200), ALD(14))];
        _detailLabel.text = @"仅限北京门店使用";
        _detailLabel.font = WJFont14;
        [_backgImageView addSubview:_detailLabel];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backgImageView.width-ALD(100), ALD(20), ALD(90), ALD(22))];
        _moneyLabel.text = @"￥50";
        _moneyLabel.font = WJFont20;
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        [_backgImageView addSubview:_moneyLabel];
        NSLog(@"%f",_backgImageView.right);
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backgImageView.width-ALD(200), ALD(60), ALD(190), ALD(12))];
        _timeLabel.text = @"有效期至：2015-12-10";
        _timeLabel.font = WJFont10;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        
        [_backgImageView addSubview:_timeLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
