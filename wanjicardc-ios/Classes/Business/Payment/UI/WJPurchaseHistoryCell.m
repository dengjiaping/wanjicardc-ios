//
//  WJPurchaseHistoryCell.m
//  WanJiCard
//
//  Created by Angie on 15/9/25.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJPurchaseHistoryCell.h"
#import "WJPurchaseHistoryModel.h"

@implementation WJPurchaseHistoryCell{

    UILabel *orderNOL;
    UILabel *merNameL;
    UILabel *amountL;
    UILabel *consumeStatus;
    UILabel *timeL;
   
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        orderNOL= [[UILabel alloc] initForAutoLayout];
        orderNOL.textAlignment = NSTextAlignmentLeft;
        orderNOL.textColor = WJColorLightGray;
        orderNOL.font = WJFont12;
        [self.contentView addSubview:orderNOL];
        
        
        merNameL= [[UILabel alloc] initForAutoLayout];
        merNameL.textAlignment = NSTextAlignmentLeft;
        merNameL.textColor = WJColorDarkGray;
        merNameL.font = WJFont15;
        merNameL.numberOfLines = 0;
        [self.contentView addSubview:merNameL];
    
        amountL= [[UILabel alloc] initForAutoLayout];
        amountL.textAlignment = NSTextAlignmentRight;
        amountL.textColor = WJColorDardGray3;
        amountL.font = WJFont15;
        [self.contentView addSubview:amountL];
        
//        consumeStatus= [[UILabel alloc] initForAutoLayout];
//        consumeStatus.textAlignment = NSTextAlignmentRight;
//        consumeStatus.textColor = WJColorDardGray3;
//        consumeStatus.font = WJFont12;
//        [self.contentView addSubview:consumeStatus];
        
        timeL = [[UILabel alloc] initForAutoLayout];
        timeL.textAlignment = NSTextAlignmentLeft;
        timeL.textColor = WJColorLightGray;
        timeL.font = WJFont12;
        timeL.numberOfLines = 0;
        [self.contentView addSubview:timeL];
        

        
        [self.contentView addConstraints:[merNameL constraintsLeftInContainer:ALD(10)]];
        [self.contentView addConstraints:[merNameL constraintsTopInContainer:ALD(10)]];
        [self.contentView addConstraint:[merNameL constraintHeight:ALD(25)]];
        [self.contentView addConstraint:[merNameL constraintWidth:kScreenWidth - ALD(20) - ALD(100)]];
        
        [self.contentView addConstraints:[orderNOL constraintsTop:ALD(5) FromView:merNameL]];
        [self.contentView addConstraints:[orderNOL constraintsLeftInContainer:ALD(10)]];
        [self.contentView addConstraint:[orderNOL constraintHeight:ALD(20)]];
        [self.contentView addConstraint:[orderNOL constraintWidth:kScreenWidth - ALD(10)]];
        
        
        [self.contentView addConstraint:[amountL constraintTopEqualToView:merNameL]];
        [self.contentView addConstraints:[amountL constraintsRightInContainer:ALD(15)]];
        [self.contentView addConstraint:[amountL constraintWidth:ALD(100)]];
        [self.contentView addConstraint:[amountL constraintHeightEqualToView:merNameL]];

        
        [self.contentView addConstraints:[timeL constraintsLeftInContainer:ALD(10)]];
        [self.contentView addConstraints:[timeL constraintsTop:ALD(5) FromView:orderNOL]];
        [self.contentView addConstraint:[timeL constraintWidthEqualToView:merNameL]];
        [self.contentView addConstraint:[timeL constraintHeight:ALD(20)]];
        
        
//        [self.contentView addConstraints:[consumeStatus constraintsTop:ALD(5) FromView:orderNOL]];
//        [self.contentView addConstraints:[consumeStatus constraintsRightInContainer:ALD(10)]];
//        [self.contentView addConstraint:[consumeStatus constraintWidth:ALD(100)]];
//        [self.contentView addConstraint:[consumeStatus constraintHeight:ALD(30)]];

    }
    return self;
}


- (void)configWithHistory:(WJPurchaseHistoryModel *)model{
    
    orderNOL.text = [NSString stringWithFormat:@"订单号: %@",model.paymentNo];
    merNameL.text = model.merName;
    amountL.text = [NSString stringWithFormat:@"-￥%@",[WJUtilityMethod floatNumberForMoneyFomatter:model.amount]];
//    if (model.historyStatus == 1) {
//        consumeStatus.text = @"成功";
//    }else{
//        consumeStatus.text = @"失败";
//    }
    timeL.text = model.createTime;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
