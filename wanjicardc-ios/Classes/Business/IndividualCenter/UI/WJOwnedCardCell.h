//
//  WJOwnedCardCell.h
//  WanJiCard
//
//  Created by Angie on 15/9/30.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJModelCard.h"

@interface WJOwnedCardCell : UITableViewCell

@property (nonatomic, strong) WJActionBlock chargeRightNow;


- (void)configWithModel:(WJModelCard *)model;

@end
