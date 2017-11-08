//
//  WJCardListTableViewCell.h
//  WanJiCard
//
//  Created by Lynn on 15/10/13.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WJMerchantCard;
@interface WJCardListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView            *bottomLine;

- (void)configWithProduct:(WJMerchantCard *)cardModel;

@end
