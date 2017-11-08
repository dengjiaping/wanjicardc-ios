//
//  WJSystemMessageTableViewCell.h
//  WanJiCard
//
//  Created by silinman on 16/6/17.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJSystemNewsModel;
@interface WJSystemMessageTableViewCell : UITableViewCell

@property(nonatomic ,strong) UILabel            *contentL;
@property(nonatomic ,strong) UILabel            *timeL;
@property(nonatomic ,strong) UIView             *lineL;

- (void)configData:(WJSystemNewsModel *)model;

@end
