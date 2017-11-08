//
//  WJFreeCardTableViewCell.h
//  WanJiCard
//
//  Created by Lynn on 15/9/10.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WJModelCard;
@interface WJFreeCardTableViewCell : UITableViewCell

@property (nonatomic, strong)UIButton       *chooseButton;
@property (nonatomic, assign)BOOL           isSelect;

- (void)configData:(WJModelCard *)model;

@end
