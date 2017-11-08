//
//  WJConsumeMessageTableViewCell.h
//  WanJiCard
//
//  Created by silinman on 16/6/17.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJConsumeNewsModel;
@interface WJConsumeMessageTableViewCell : UITableViewCell

@property(nonatomic ,strong) UILabel            *titleL;
@property(nonatomic ,strong) UILabel            *timeL;
@property(nonatomic ,strong) UILabel            *moneyL;
@property(nonatomic ,strong) UILabel            *lineL;

- (void)configData:(WJConsumeNewsModel *)model cellType:(NSInteger)type;

@end
