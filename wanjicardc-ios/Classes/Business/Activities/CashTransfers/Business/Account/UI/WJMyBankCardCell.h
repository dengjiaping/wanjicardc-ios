//
//  WJMyBankCardCell.h
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJBankCardModel.h"

@interface WJMyBankCardCell : UITableViewCell
@property (nonatomic, strong) WJActionBlock bankCardSetting;
@property (nonatomic, strong) WJActionBlock deleteCardBinding;

- (void)configDataWithModel:(WJBankCardModel *)model;
@end
