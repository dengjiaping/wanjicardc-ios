//
//  WJSteameReChargeCell.m
//  WanJiCard
//
//  Created by 孙明月 on 16/8/15.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJSteameReChargeCell.h"

@implementation WJSteameReChargeCell
{
    UILabel *steamChargeMoneyL;
    UILabel *newUserDesL;
    UILabel *descL;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        steamChargeMoneyL= [[UILabel alloc] init];
        steamChargeMoneyL.textColor = WJColorAmount;
        steamChargeMoneyL.font = WJFont15;
        [self.contentView addSubview:steamChargeMoneyL];
        
        newUserDesL = [[UILabel alloc] init];
        newUserDesL.textColor = WJColorAmount;
        newUserDesL.font = WJFont13;
        [self.contentView addSubview:newUserDesL];
        
        descL = [[UILabel alloc] init];
        descL.textColor = WJColorDarkGray;
        descL.font = WJFont13;
        [self.contentView addSubview:descL];
        
        self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), ALD(60) - 0.5, kScreenWidth-ALD(24), 0.5)];
        self.bottomLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:self.bottomLine];

    }
    return self;
}

- (void)configCellWithOrder:(WJBaoziRechargeModel *)moneyModel;
{
    NSString *money = [NSString stringWithFormat:@"￥%@",[WJUtilityMethod floatNumberForMoneyFomatter:moneyModel.rechargeAmount]];
    CGFloat moneyWidth = [UILabel getWidthWithTitle:money font:WJFont15];
    steamChargeMoneyL.frame = CGRectMake(ALD(12), ALD(10), moneyWidth, ALD(20));
    steamChargeMoneyL.text = money;
    
    newUserDesL.frame = CGRectMake(steamChargeMoneyL.right + ALD(10), steamChargeMoneyL.y,
                                   SCREEN_WIDTH - ALD(55) - moneyWidth, steamChargeMoneyL.height);
   
    newUserDesL.text = ([moneyModel.newdescribe length]>0) ? moneyModel.newdescribe : @"";
    descL.frame = CGRectMake(steamChargeMoneyL.x , steamChargeMoneyL.bottom, SCREEN_WIDTH - ALD(55) - moneyWidth, ALD(20));
    descL.text = moneyModel.describe;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
