//
//  WJRechargeAgreementCell.m
//  WanJiCard
//
//  Created by 孙明月 on 16/9/6.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJRechargeAgreementCell.h"

@implementation WJRechargeAgreementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.chooseBtn.frame = CGRectMake(ALD(10), ALD(7), ALD(30), ALD(30));
        [self.chooseBtn setImage:[UIImage imageNamed:@"toggle_button_nor"] forState:UIControlStateNormal];
        [self.chooseBtn setImage:[UIImage imageNamed:@"toggle_button_selected"] forState:UIControlStateSelected];
        self.chooseBtn.selected = YES;
        [self.chooseBtn addTarget:self action:@selector(chooseAgreement:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.chooseBtn];
        
        UILabel *agreementL = [[UILabel alloc] initWithFrame:CGRectMake(self.chooseBtn.right, 0, ALD(150), ALD(44))];
        agreementL.text = @"《充值协议》";
        agreementL.textColor = WJColorDarkGray;
        agreementL.font = WJFont14;
        [self.contentView addSubview:agreementL];
        
        UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        upLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:upLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(44) - 0.5, kScreenWidth, 0.5)];
        bottomLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:bottomLine];
        
        UIImageView * rightIV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - ALD(18), ALD(33)/2, ALD(6), ALD(11))];
        rightIV.image = [UIImage imageNamed:@"details_rightArrowIcon"];
        [self.contentView addSubview:rightIV];
        
    }
    return self;
}


- (void)chooseAgreement:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseAgreement:)]) {
        [self.delegate chooseAgreement:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
