//
//  WJBillListCell.m
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJBillListCell.h"
#import "WJBillModel.h"
@implementation WJBillListCell
{
    UILabel      *billNoL;
    UILabel      *statusL;
    UILabel      *receiveMoneyL;
    UILabel      *feeL;
    UILabel      *deducedChannelL;
    UIImageView  *rightArrowImageView;
    UILabel      *createTimeL;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];

        billNoL = [[UILabel alloc] initWithFrame:CGRectMake(10, ALD(10), kScreenWidth - ALD(70), ALD(30))];
        billNoL.textColor = WJColorDardGray9;
        billNoL.font = WJFont12;
        billNoL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:billNoL];
        
        statusL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(85), ALD(10), ALD(70), ALD(30))];
        statusL.font = WJFont12;
        statusL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:statusL];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ALD(10), billNoL.bottom + ALD(10), kScreenWidth - ALD(20), 0.5)];
        line.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:line];
        
        receiveMoneyL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), line.bottom + ALD(15), ALD(150), ALD(20))];
        receiveMoneyL.font = WJFont15;
        receiveMoneyL.textColor = WJColorDardGray3;
        [self.contentView addSubview:receiveMoneyL];
    
        
//        rightArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(15) - ALD(12), receiveMoneyL.frame.origin.y + ALD(4), ALD(12), ALD(12))];
//        rightArrowImageView.image = [UIImage imageNamed:@"rightArrow"];
//        [self.contentView addSubview:rightArrowImageView];
        
        deducedChannelL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(15) - ALD(130), receiveMoneyL.frame.origin.y, ALD(130), ALD(20))];
        deducedChannelL.textColor = WJColorDardGray3;
        deducedChannelL.textAlignment = NSTextAlignmentRight;
        deducedChannelL.font = WJFont15;
        [self.contentView addSubview:deducedChannelL];
        
        feeL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), receiveMoneyL.bottom + ALD(15), ALD(150), ALD(20))];
        feeL.textColor = WJColorDardGray3;
        feeL.font = WJFont12;
        [self.contentView addSubview:feeL];
        
        createTimeL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(15) - ALD(150), feeL.frame.origin.y, ALD(150), ALD(20))];
        createTimeL.textColor = WJColorLightGray;
        createTimeL.font = WJFont12;
        [self.contentView addSubview:createTimeL];
        
    }
    return self;
}

- (void)configDataWithModel:(WJBillModel *)model
{
    billNoL.text = [NSString stringWithFormat:@"订单编号：%@", model.billNo];
    
    NSArray *statusText = @[@"待支付", @"支付成功", @"已关闭"];
    
    int index = model.billStatus == BillStatusUnfinished ? 0 :(model.billStatus == BillStatusSuccess ? 1 : 2);
    
    statusL.text = statusText[index];
    
    if (model.billStatus == BillStatusUnfinished) {
        statusL.textColor = WJColorNavigationBar;
    } else {
        statusL.textColor = WJColorDardGray9;
    }
    
    receiveMoneyL.text = [NSString stringWithFormat:@"收款：￥ %@", [WJUtilityMethod floatNumberForMoneyFomatter:[model.receiveAmount floatValue]]];

    feeL.text = [NSString stringWithFormat:@"手续费：￥ %@", [WJUtilityMethod floatNumberForMoneyFomatter:[model.fee floatValue]]];
    
    deducedChannelL.text = [NSString stringWithFormat:@"通道:%@扣款",model.deductedChannel];
    
    createTimeL.text = model.createTime;

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
