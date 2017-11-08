//
//  WJCardTableViewCell.h
//  WanJiCard
//
//  Created by Lynn on 15/9/22.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJModelCard;
@interface WJCardTableViewCell : UITableViewCell

- (void)configData:(WJModelCard *)model;

@end
