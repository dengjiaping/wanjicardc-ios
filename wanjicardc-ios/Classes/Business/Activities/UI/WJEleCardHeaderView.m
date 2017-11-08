//
//  WJEleCardHeaderView.m
//  WanJiCard
//
//  Created by 林有亮 on 16/8/18.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJEleCardHeaderView.h"
#import "WJECardModel.h"

@interface WJEleCardHeaderView ()
{
    
    UIView      * cardView;
    UIImageView * logoImageView;
    UILabel     * faceLabel;
    UIImageView * activeTipImageView;
    UILabel     * cardNameLabel;
    UILabel     * desLabel;
    UIImageView * baoziImageView;
    UILabel     * baoziNumLabel;
    UILabel     * soldLabel;
    UIView      * grayView;
}


@end

@implementation WJEleCardHeaderView

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        cardView = [[UIView alloc] initWithFrame:CGRectMake(ALD(40), ALD(20), kScreenWidth - ALD(80), ALD(158))];
        cardView.layer.cornerRadius = 5;
        
        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((cardView.width - ALD(138))/2, ALD(36), ALD(138), ALD(86))];
        
        faceLabel = [[UILabel alloc] init];
        faceLabel.font = [UIFont boldSystemFontOfSize:18];
        faceLabel.textColor = WJColorWhite;
        
        UIImage *activeImage = [UIImage imageNamed:@"detail_tip"];
        activeTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cardView.width - activeImage.size.width, 0, activeImage.size.width, activeImage.size.height)];
        
        cardNameLabel = [[UILabel alloc] init];
        cardNameLabel.font = WJFont17;
        cardNameLabel.numberOfLines = 2;
        cardNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cardNameLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
        
        desLabel = [[UILabel alloc] init];
        desLabel.font = WJFont14;
        desLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"9099a6"];
        desLabel.numberOfLines = 2;
        desLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        baoziImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fair_ic_baozi"]];
        
        baoziNumLabel = [[UILabel alloc] init];
        baoziNumLabel.font = WJFont20;
        baoziNumLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"d9a109"];
        
        soldLabel = [[UILabel alloc] init];
//        soldLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"9099a6"];
        soldLabel.font = WJFont14;
        soldLabel.textAlignment = NSTextAlignmentRight;
        
        [cardView addSubview:logoImageView];
        [cardView addSubview:faceLabel];
        [cardView addSubview:activeTipImageView];
        
        grayView = [[UIView alloc] init];
        grayView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"f5f8fa"];
        
        [self addSubview:cardView];
        [self addSubview:cardNameLabel];
        [self addSubview:desLabel];
        [self addSubview:baoziImageView];
        [self addSubview:baoziNumLabel];
        [self addSubview:soldLabel];
        [self addSubview:grayView];
//        for (UIView * aView in [self subviews]) {
//            aView.backgroundColor = [WJUtilityMethod randomColor];
//        }
//        
//        for (UIView * aView in [cardView subviews]) {
//            aView.backgroundColor = [WJUtilityMethod randomColor];
//        }
    }
    return self;
}

- (void)refreshWithECardModel:(WJECardModel *)eCardModel
{
//    [cardView setBackgroundColor:[self colorByType:eCardModel.cardColor]];
    [cardView setBackgroundColor:[WJUtilityMethod colorWithHexColorString:eCardModel.cardColorValue]];
    
    [logoImageView sd_setImageWithURL:[NSURL URLWithString:eCardModel.logoUrl]];
    activeTipImageView.image = [UIImage imageNamed:@"detail_tip"];

    faceLabel.text = [NSString stringWithFormat:@"%d元",[eCardModel.facePrice intValue]];
    [faceLabel sizeToFit];
    
    [faceLabel setFrame:CGRectMake(cardView.width - ALD(18) - faceLabel.width, cardView.height - ALD(10) - faceLabel.height, faceLabel.width, faceLabel.height)];
    
    cardNameLabel.text = eCardModel.commodityName;
//    cardNameLabel.text = @"淘宝商城叽叽叽叽叽叽哈哈哈哈h哈哈哈哈h就斤斤计较二人呜呜呜呜呜呜呜";
    CGSize nameSize = [cardNameLabel sizeThatFits:CGSizeMake(kScreenWidth - ALD(24), MAXFLOAT)];
    [cardNameLabel setFrame:CGRectMake(ALD(12), cardView.bottom + ALD(10), nameSize.width, nameSize.height)];

    [desLabel setFrame:CGRectMake(ALD(12), cardNameLabel.bottom + ALD(10), kScreenWidth - ALD(24), ALD(70))];
    desLabel.text = eCardModel.cardDes;
//    desLabel.text = @"djf;lajsdlfja;ldjfal;sdkjfal;kjdfl;ajdfl;askjdf;laskjdfal;sdjfa;sldkjfjas;dlkjfa;ldskjfa;sd";
    CGSize desSize = [desLabel sizeThatFits:CGSizeMake(kScreenWidth - ALD(24), MAXFLOAT)];
    [desLabel setFrame:CGRectMake(ALD(12), cardNameLabel.bottom + ALD(10), kScreenWidth - ALD(24), desSize.height)];

    baoziNumLabel.text = [WJUtilityMethod baoziNumberFormatter:eCardModel.salePrice];
    [baoziNumLabel sizeToFit];
    [baoziNumLabel setFrame:CGRectMake(ALD(33) , desLabel.bottom + ALD(10), baoziNumLabel.width,baoziNumLabel.height)];
    
    [baoziImageView setFrame:CGRectMake(ALD(12), baoziNumLabel.y + (baoziNumLabel.height - ALD(13))/2 , ALD(16), ALD(13))];
    
//    soldLabel.text = [NSString stringWithFormat:@"已售%@",eCardModel.soldCount];
    if (eCardModel.activityType != 0) {
        soldLabel.hidden = NO;
        activeTipImageView.hidden = NO;
    } else {
        soldLabel.hidden = YES;
        activeTipImageView.hidden = YES;

    }
    soldLabel.text = [NSString stringWithFormat:@"每人限购%ld张",eCardModel.limitCount];
    soldLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"ff6554"];
    [soldLabel sizeToFit];
    [soldLabel setFrame:CGRectMake(kScreenWidth - soldLabel.width - ALD(12), CGRectGetMaxY(baoziNumLabel.frame) - soldLabel.height, soldLabel.width, soldLabel.height)];
    
    [grayView setFrame:CGRectMake(0, soldLabel.bottom, kScreenWidth, 10)];
    
//    [self setFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(soldLabel.frame) + ALD(16))];
    [self setFrame:CGRectMake(0, 0, kScreenWidth, grayView.bottom)];

}

- (CGFloat) headerViewHeight
{
    return  grayView.bottom;
}


- (UIColor *)colorByType:(NSInteger)type
{
    UIColor  * color = nil;
    switch (type) {
            
        case 1:
        {
            color= WJColorCardRed;
        }
            break;
        case 2:
        {
            color = WJColorCardOrange;
        }
            break;
        case 3:
        {
            color = WJColorCardBlue;
        }
            break;
        case 4:
        {
            color = WJColorCardGreen;
        }
            break;
        default:
            color = WJColorCardRed;
            break;
    }
    return color;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
