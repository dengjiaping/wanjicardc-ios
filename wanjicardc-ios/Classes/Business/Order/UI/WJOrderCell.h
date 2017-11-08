//
//  WJOrderCell.h
//  WanJiCard
//
//  Created by Harry Hu on 15/9/18.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJOrderModel.h"

@class WJOrderCell;
@protocol WJOrderCellDelegate <NSObject>
- (void)changeOrderStatus;
@end

@interface WJOrderCell : UITableViewCell
@property (nonatomic, weak) id<WJOrderCellDelegate>delegate;
@property (nonatomic, strong) WJActionBlock paymentRightNow;
@property (nonatomic, strong) WJActionBlock buyAgain;

@property (nonatomic, strong) UILabel *amountL;
@property (nonatomic, assign) BOOL    isOrder;
@property (nonatomic, assign) NSInteger during;
- (void)configCellWithOrder:(WJOrderModel *)data isDetail:(BOOL)state;

@end
