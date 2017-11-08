//
//  WJCardsTableViewCell.m
//  WanJiCard
//
//  Created by Lynn on 15/9/10.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJCardsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WJModelCard.h"

@implementation WJCardsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(10,0,kScreenWidth-20,ALD(77))];
        [self.contentView addSubview:_bgView];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _bgView.bounds;
        maskLayer.path = maskPath.CGPath;
        _bgView.layer.mask = maskLayer;
        
        
        CGFloat imageHeight = ALD(51 * 14 / 22.0);
        
        //logo图片
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(15), ALD(10) + ( ALD(51) - imageHeight) / 2.0,ALD(51), imageHeight)];
        
        [_logoImageView.layer setCornerRadius:CGRectGetHeight([_logoImageView bounds]) / 2];
        _logoImageView.layer.masksToBounds = YES;
        //  logoImageView.layer.contents = (id)[[UIImage imageNamed:@"backgroundImage.png"] CGImage];
        
        UIView * alphaView = [[UIView alloc] initWithFrame:CGRectMake(ALD(15), ALD(10), ALD(51), ALD(51))];
        alphaView.backgroundColor = [UIColor whiteColor];
        [alphaView.layer setCornerRadius:CGRectGetHeight([alphaView bounds]) / 2];
        alphaView.alpha = 0.2;
        [_bgView addSubview:alphaView];
        [_bgView addSubview:_logoImageView];
        
        //线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_logoImageView.right+ALD(15), ALD(12), 0.5, _logoImageView.height)];
        lineView.backgroundColor = WJColorViewBg;
        lineView.alpha = 0.4;
        [_bgView addSubview:lineView];
        
        //卡片标题
       _cardTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right+ALD(15), ALD(17), self.width-lineView.right-ALD(15), ALD(16))];
        _cardTitleLabel.font = WJFont14;
        _cardTitleLabel.textColor = [UIColor whiteColor];
        _cardTitleLabel.textAlignment = NSTextAlignmentLeft;
        [_bgView addSubview:_cardTitleLabel];
        
        //卡片余额
        _balanceMoney = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right+ALD(15), ALD(77)-ALD(38), self.width-lineView.right-ALD(15), ALD(19))];
        _balanceMoney.font = WJFont17;
        _balanceMoney.textColor = [UIColor whiteColor];
        _balanceMoney.textAlignment = NSTextAlignmentLeft;
        [_bgView addSubview:_balanceMoney];
      

    }
    return self;
}

- (void)refreshCellByCard:(WJModelCard *)cardModel
{
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:cardModel.coverURL]];
    _cardTitleLabel.text = cardModel.name;
    _balanceMoney.text = [NSString stringWithFormat:@"金额  ￥%@", [WJUtilityMethod floatNumberForMoneyFomatter:cardModel.balance]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_balanceMoney.text];
    [str addAttribute:NSFontAttributeName value:WJFont12 range:NSMakeRange(0,2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(2,str.length-2)];
    
    _balanceMoney.attributedText = str;
    [_balanceMoney sizeToFit];
//    if(indexPath.section == 0)
//    {
//        cell.bgView.backgroundColor = WJColorCardBlue;
//    }
//    if(indexPath.section == 1)
//    {
//        cell.bgView.backgroundColor = WJColorCardRed;
//    }
//    if(indexPath.section == 2)
//    {
//        cell.bgView.backgroundColor = WJColorCardGreen;
//    }
//    if(indexPath.section == 3)
//    {
//        cell.bgView.backgroundColor = WJColorCardOrange;
//    }
    
    switch (cardModel.colorType) {
     
        case 1:
        {
            self.bgView.backgroundColor = WJColorCardRed;
        }
            break;
        case 2:
        {
            self.bgView.backgroundColor = WJColorCardOrange;
        }
            break;
        case 3:
        {
            self.bgView.backgroundColor = WJColorCardBlue;
        }
            break;
        case 4:
        {
            self.bgView.backgroundColor = WJColorCardGreen;
        }
            break;
        default:
            self.bgView.backgroundColor = WJColorCardRed;
            break;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
