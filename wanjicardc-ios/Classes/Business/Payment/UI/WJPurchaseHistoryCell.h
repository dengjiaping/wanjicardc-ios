//
//  WJPurchaseHistoryCell.h
//  WanJiCard
//
//  Created by Angie on 15/9/25.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJPurchaseHistoryModel;
@interface WJPurchaseHistoryCell : UITableViewCell

- (void)configWithHistory:(WJPurchaseHistoryModel *)model;

@end
