//
//  WJCashRateCell.m
//  WanJiCard
//
//  Created by reborn on 16/11/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCashRateCell.h"
#import "WJCashRateModel.h"

@interface WJCashRateCell()
{
    UILabel     *arriveMoneyFastL;
    UILabel     *arriveMoneyNormalL;

    UIImageView *deductedMoneyLogol;
    UILabel     *rateL;
    UILabel     *settleL;
    UILabel     *quotaL;
    
    UILabel     *rateFastL;
    UILabel     *rateNormalL;
    
    UILabel     *settleFastL;
    UILabel     *settleNormalL;
    
    UILabel     *quotaFastL;
    UILabel     *quotaNormalL;
    
}
@end

@implementation WJCashRateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        arriveMoneyFastL  = [[UILabel alloc] initWithFrame:CGRectMake(ALD(135), ALD(20), ALD(105), ALD(20))];
        arriveMoneyFastL.text = @"T+0实时到账";
        arriveMoneyFastL.textColor = WJColorDardGray3;
        arriveMoneyFastL.font = WJFont14;
        arriveMoneyFastL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:arriveMoneyFastL];
        
        
//        arriveMoneyNormalL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(268), arriveMoneyFastL.frame.origin.y, ALD(105), ALD(20))];
//        arriveMoneyNormalL.text = @"T+1实时到账";
//        arriveMoneyNormalL.textColor = WJColorDardGray3;
//        arriveMoneyNormalL.font = WJFont14;
//        arriveMoneyNormalL.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:arriveMoneyNormalL];
        
        
        deductedMoneyLogol = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(15), arriveMoneyFastL.bottom + ALD(10) , ALD(60), ALD(60))];
        [self.contentView addSubview:deductedMoneyLogol];
        
        rateL = [[UILabel alloc] initWithFrame:CGRectMake(deductedMoneyLogol.right + ALD(15), arriveMoneyFastL.bottom + ALD(10), ALD(40), ALD(20))];
        rateL.text = @"费率";
        rateL.textColor = WJColorDardGray3;
        rateL.font = WJFont14;
        rateL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:rateL];
        
        
        rateFastL = [[UILabel alloc] initWithFrame:CGRectMake(arriveMoneyFastL.frame.origin.x, arriveMoneyFastL.bottom + ALD(10), ALD(100), ALD(20))];
        rateFastL.textColor = WJColorDardGray3;
        rateFastL.font = WJFont14;
        rateFastL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:rateFastL];
        
        
//        rateNormalL = [[UILabel alloc] initWithFrame:CGRectMake(arriveMoneyNormalL.frame.origin.x, arriveMoneyNormalL.bottom + ALD(10), ALD(100), ALD(20))];
//        rateNormalL.textColor = WJColorDardGray3;
//        rateNormalL.font = WJFont14;
//        rateNormalL.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:rateNormalL];
        
        
        settleL = [[UILabel alloc] initWithFrame:CGRectMake(rateL.frame.origin.x, rateL.bottom + ALD(13), ALD(40), ALD(20))];
        settleL.text = @"结算";
        settleL.textColor = WJColorDardGray3;
        settleL.font = WJFont14;
        settleL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:settleL];
        
        
        settleFastL = [[UILabel alloc] initWithFrame:CGRectMake(rateFastL.frame.origin.x, settleL.frame.origin.y, ALD(100), ALD(20))];
        settleFastL.textColor = WJColorDardGray3;
        settleFastL.font = WJFont14;
        settleFastL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:settleFastL];
        
        
//        settleNormalL = [[UILabel alloc] initWithFrame:CGRectMake(rateNormalL.frame.origin.x, settleFastL.frame.origin.y, ALD(100), ALD(20))];
//        settleNormalL.textColor = WJColorDardGray3;
//        settleNormalL.font = WJFont14;
//        settleNormalL.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:settleNormalL];
        
        
        quotaL = [[UILabel alloc] initWithFrame:CGRectMake(settleL.frame.origin.x, settleL.bottom + ALD(13), ALD(40), ALD(20))];
        quotaL.text = @"额度";
        quotaL.textColor = WJColorDardGray3;
        quotaL.font = WJFont14;
        quotaL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:quotaL];
        
        
        quotaFastL = [[UILabel alloc] initWithFrame:CGRectMake(settleFastL.frame.origin.x, quotaL.frame.origin.y, ALD(100), ALD(20))];
        quotaFastL.textColor = WJColorDardGray3;
        quotaFastL.font = WJFont14;
        quotaFastL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:quotaFastL];
        
//        quotaNormalL = [[UILabel alloc] initWithFrame:CGRectMake(settleNormalL.frame.origin.x, quotaL.frame.origin.y, ALD(100), ALD(20))];
//        quotaNormalL.textColor = WJColorDardGray3;
//        quotaNormalL.font = WJFont14;
//        quotaNormalL.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:quotaNormalL];
        
    }
    return self;
}

- (void)configDataWithModel:(WJCashRateModel *)cashRateModel
{
    if ([cashRateModel.rateFast isEqualToString:@""] ||cashRateModel.rateFast == nil) {
        
        rateFastL.text = @"--";
    } else {
        rateFastL.text = [NSString stringWithFormat:@"%@%%",cashRateModel.rateFast];
    }
    
    if ([cashRateModel.settleFast isEqualToString:@""] || cashRateModel.settleFast == nil) {
        
        settleFastL.text = @"--";
    } else {
        settleFastL.text =[NSString stringWithFormat:@"%.2f元/笔",[cashRateModel.settleFast floatValue]];
    }
    
    if ([cashRateModel.quotaFast isEqualToString:@""] || cashRateModel.quotaFast == nil) {
        
        quotaFastL.text = @"--";
    } else {
        quotaFastL.text = [NSString stringWithFormat:@"%.2f元/笔",[cashRateModel.quotaFast floatValue]];
    }
    
//    rateNormalL.text = [NSString stringWithFormat:@"%@%%",cashRateModel.rateNormal];
//    settleNormalL.text =[NSString stringWithFormat:@"%ld元/笔",[cashRateModel.settleNormal integerValue]];
//    quotaNormalL.text = [NSString stringWithFormat:@"%ld元/笔",(long)[cashRateModel.quotaNormal integerValue]];
    
    if ([cashRateModel.channelName  isEqual: @"支付宝"]) {
        
        deductedMoneyLogol.image = [UIImage imageNamed:@"zhifubao_icon"];

    } else {
        
        deductedMoneyLogol.image = [UIImage imageNamed:@"weixin_icon"];
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
