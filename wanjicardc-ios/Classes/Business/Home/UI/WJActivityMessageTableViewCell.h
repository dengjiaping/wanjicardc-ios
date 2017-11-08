//
//  WJActivityMessageTableViewCell.h
//  WanJiCard
//
//  Created by silinman on 16/7/7.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJSystemNewsModel;
@interface WJActivityMessageTableViewCell : UITableViewCell

@property(nonatomic ,strong) UIView         *backView;
@property(nonatomic ,strong) UIImageView    *backIV;
@property(nonatomic ,strong) UILabel        *timeL;

- (void)configData:(WJSystemNewsModel *)model;

@end
