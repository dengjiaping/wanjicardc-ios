//
//  WJMyBunsRecordsTableViewCell.m
//  WanJiCard
//
//  Created by silinman on 16/8/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMyBunsRecordsTableViewCell.h"
#import "WJBunsTransRecordModel.h"

@implementation WJMyBunsRecordsTableViewCell{
    UIImageView        *bunsIV;
    UILabel            *dayL;
    UILabel            *timeL;
    UILabel            *middleLineL;
    UILabel            *bottomLineL;
    UILabel            *bunsCountL;
    UILabel            *giftCountL;
    UILabel            *typeL;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        dayL = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(14),ALD(80),ALD(18))];
        dayL.font = WJFont15;
        dayL.textColor = WJColorLightGray;
        dayL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:dayL];
        
        timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, dayL.bottom + ALD(6),ALD(80),ALD(13))];
        timeL.font = WJFont10;
        timeL.textColor = WJColorLightGray;
        timeL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:timeL];
        
        middleLineL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(80), ALD(14),ALD(0.5),ALD(32))];
        middleLineL.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:middleLineL];
        
        bunsIV = [[UIImageView alloc] initWithFrame:CGRectMake(middleLineL.right + ALD(12), ALD(13), ALD(34), ALD(34))];
        bunsIV.image = [UIImage imageNamed:@""];
        bunsIV.layer.cornerRadius = bunsCountL.width/2.0;
        [self.contentView addSubview:bunsIV];
        
        bunsCountL = [[UILabel alloc] initWithFrame:CGRectMake(bunsIV.right + ALD(12), ALD(13),ALD(80),ALD(18))];
        bunsCountL.font = WJFont15;
        bunsCountL.textColor = WJColorNavigationBar;
        bunsCountL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:bunsCountL];
        
        giftCountL = [[UILabel alloc] initWithFrame:CGRectMake(bunsCountL.right + ALD(5), ALD(15),ALD(150),ALD(13))];
        giftCountL.font = WJFont11;
        giftCountL.textColor = WJColorDardGray3;
        giftCountL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:giftCountL];
        
        typeL = [[UILabel alloc] initWithFrame:CGRectMake(bunsCountL.x , bunsCountL.bottom + ALD(5),ALD(150),ALD(15))];
        typeL.font = WJFont12;
        typeL.textColor = WJColorDardGray3;
        typeL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:typeL];
        
        bottomLineL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(59.5),kScreenWidth - ALD(24),ALD(0.5))];
        bottomLineL.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:bottomLineL];
    }
    
    return self;
}

- (void)configWithModel:(WJBunsTransRecordModel *)model{
    if (model) {
        dayL.text = model.dayStr;
        
        timeL.text = model.days;
        
        bunsCountL.text = model.bun;
        CGFloat bunsCountLwidth = [UILabel getWidthWithTitle:bunsCountL.text font:bunsCountL.font];
        bunsCountL.frame = CGRectMake(bunsIV.right + ALD(12), ALD(13),bunsCountLwidth,ALD(18));
        
        NSInteger bunsType = [model.type integerValue];
        switch (bunsType) {
            case 1:
                bunsIV.image = nil;
                break;
            case 2:
                bunsIV.image = nil;
                break;
            case 3:
                bunsIV.image = [UIImage imageNamed:@"mybaozi_ic_paybaozi"];
                bunsCountL.textColor = WJColorNavigationBar;
                if ([model.git isEqualToString:@"0"]) {
                    giftCountL.text = @"";
                }else{
                    giftCountL.text = model.git;
                    giftCountL.frame = CGRectMake(bunsCountL.right + ALD(5), ALD(17),kScreenWidth - ALD(17) - bunsCountL.right,ALD(13));
                }
                break;
            case 4:
                bunsIV.image = [UIImage imageNamed:@"mybaozi_ic_card"];
                bunsCountL.textColor = WJColorCardRed;
                giftCountL.text = @"";

                break;
            default:
                break;
        }

        typeL.text = model.typeStr;
        typeL.frame = CGRectMake(bunsCountL.x , bunsCountL.bottom + ALD(3), kScreenWidth - ALD(12) - bunsCountL.x,ALD(15));
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
