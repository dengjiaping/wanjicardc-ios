//
//  WJCardsTableViewCell.h
//  WanJiCard
//
//  Created by Lynn on 15/9/10.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJModelCard;

@interface WJCardsTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *cardTitleLabel;
@property (nonatomic, strong) UILabel *balanceMoney;

- (void)refreshCellByCard:(WJModelCard *)cardModel;

@end
