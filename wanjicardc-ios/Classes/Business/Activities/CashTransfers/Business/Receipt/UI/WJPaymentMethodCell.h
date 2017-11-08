//
//  WJPaymentMethodCell.h
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/29.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJCashRateModel.h"

@interface WJPaymentMethodCell : UITableViewCell

@property(nonatomic,strong)UIImageView          * iconImage;
@property(nonatomic,strong)UILabel              * titleLabel;
@property(nonatomic,strong)UILabel              * tipLabel;
@property(nonatomic,strong)UIButton             * nowButton;
@property(nonatomic,strong)UIButton             * nextButton;

- (void)configDataWithModel:(WJCashRateModel *)model;

@end
