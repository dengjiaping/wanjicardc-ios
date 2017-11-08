//
//  WJCardDetailPrivilegeCell.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/7.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJCardDetailPrivilegeCell.h"
#import "PayPrivilegeModel.h"

@implementation WJCardDetailPrivilegeCell{
    UILabel *userPriL;
    UILabel *hasPriCountL;
    UIView *privilegeBg;
    UILabel *tipLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(10))];
        headView.backgroundColor = WJColorViewBg;
        [self.contentView addSubview:headView];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(10), kScreenWidth, ALD(0.5))];
        topLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(0.5))];
        bottomLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:bottomLine];
        
        userPriL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(25), ALD(200), ALD(16))];
        userPriL.text = @"商家特权";
        userPriL.textColor = WJColorDarkGray;
        userPriL.font = WJFont14;
        [self.contentView addSubview:userPriL];
        
//        hasPriCountL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-ALD(160), headView.bottom, ALD(150), ALD(30))];
//        hasPriCountL.textColor = WJColorDardGray9;
//        hasPriCountL.font = WJFont12;
//        hasPriCountL.textAlignment = NSTextAlignmentRight;
//        [self.contentView addSubview:hasPriCountL];
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, userPriL.bottom, kScreenWidth, 0.5)];
//        line.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
//        [self.contentView addSubview:line];
        
        privilegeBg = [[UIView alloc] initWithFrame:CGRectMake(0, headView.bottom + ALD(43), kScreenWidth, ALD(63))];
        [self.contentView addSubview:privilegeBg];
        
        UIImageView *detail = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(6) - ALD(12), ALD(45), ALD(6), ALD(11))];
        detail.image = [UIImage imageNamed:@"details_rightArrowIcon"];
//        detail.contentMode = UIViewContentModeCenter;
//        detail.centerY = privilegeBg.centerY;
        [self.contentView addSubview:detail];
        
        tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), userPriL.bottom, kScreenWidth, ALD(43))];
        tipLabel.textColor = WJColorDardGray3;
        tipLabel.font = WJFont16;
        tipLabel.hidden = YES;
        [self.contentView addSubview:tipLabel];
    }
    return self;
}

- (void)configWithPrivileges:(NSArray *)privilegeArray isCard:(BOOL)isCard{
    tipLabel.hidden = YES;
    
    [privilegeBg.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    if (isCard) {
        userPriL.text = [NSString stringWithFormat:@"享有%@项会员卡特权", @(privilegeArray.count)];;
    }else{
        userPriL.text = @"商家特权";
    }
    
    int maxCount = (kScreenWidth - 60)/ALD(40);
    for (int i = 0; i < MIN(maxCount, privilegeArray.count); i++) {
        PayPrivilegeModel *model = privilegeArray[i];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(12) + ALD(40)*i, ALD(0), ALD(30), ALD(30))];
        iv.backgroundColor = WJColorViewBg;
        iv.layer.cornerRadius = iv.frame.size.width/2.0;
        iv.layer.masksToBounds = YES;
        [iv sd_setImageWithURL:[NSURL URLWithString:model.privilegePic?:@""]
              placeholderImage:[UIImage imageNamed:@"privilege_default"]];
        [privilegeBg addSubview:iv];
    }
}

- (void)notHaveValue
{
    tipLabel.hidden = NO;
    tipLabel.text = @"暂无特权";
}


@end
