//
//  WJMerchantTableViewCell.h
//  WanJiCard
//
//  Created by Lynn on 15/9/16.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJRecommendStoreModel.h"


@interface WJMerchantTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel       *distanceLabel;
@property (nonatomic, strong) UIImageView   *locationMark;

- (void)configData:(WJRecommendStoreModel *)model;

@end
