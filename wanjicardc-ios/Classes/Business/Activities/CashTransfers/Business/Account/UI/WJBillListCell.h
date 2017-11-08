//
//  WJBillListCell.h
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJBillModel.h"

@interface WJBillListCell : UITableViewCell

- (void)configDataWithModel:(WJBillModel *)model;

@end
