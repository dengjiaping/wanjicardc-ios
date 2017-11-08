//
//  WJSteameReChargeCell.h
//  WanJiCard
//
//  Created by 孙明月 on 16/8/15.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJBaoziRechargeModel.h"
@interface WJSteameReChargeCell : UITableViewCell

@property (nonatomic,strong) UIView *bottomLine;

- (void)configCellWithOrder:(WJBaoziRechargeModel *)moneyModel;

@end
