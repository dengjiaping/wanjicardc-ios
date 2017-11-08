//
//  WJPaySettingSwtichCell.m
//  WanJiCard
//
//  Created by XT Xiong on 15/11/10.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJPaySettingSwtichCell.h"

@implementation WJPaySettingSwtichCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.switchButton = [[UIButton alloc]initForAutoLayout];
        self.switchButton.frame = CGRectMake(0, 0, 50, 20);
        
        self.switchView = [[UISwitch alloc]initForAutoLayout];
        [self.contentView addSubview:_switchView];
        self.switchView.onTintColor = WJColorNavigationBar;
        [self.contentView addConstraints:[_switchView constraintsRightInContainer:15]];
        [self.contentView addConstraint:[_switchView constraintCenterYEqualToView:self.contentView]];
        [self.switchView addTarget:self action:@selector(turnSwitch) forControlEvents:UIControlEventValueChanged];
        
        _textL  = [[UILabel alloc]initForAutoLayout];
        _textL.font = WJFont15;
        _textL.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
        [self.contentView addSubview:_textL];
//        [self.contentView addConstraints:[_textL constraintsSize:CGSizeMake(180, 30)]];
        [self.contentView addConstraint:[_textL constraintWidth:180]];
        [self.contentView addConstraints:[_textL constraintsLeftInContainer:15]];
        [self.contentView addConstraint:[_textL constraintCenterYEqualToView:self.contentView]];
        
        
    }
    return self;
}

- (void)turnSwitch
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchCell:cellIndex:)]) {
        [self.delegate switchCell:self cellIndex:self.myIndex];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
