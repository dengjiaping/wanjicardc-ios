//
//  WJMessageCenterTableViewCell.h
//  WanJiCard
//
//  Created by silinman on 16/6/17.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJNewsCenterModel.h"

@interface WJMessageCenterTableViewCell : UITableViewCell

@property(nonatomic ,strong) UIImageView         *listIV;
@property(nonatomic ,strong) UIImageView         *noticeIV;
@property(nonatomic ,strong) UILabel             *titleL;
@property(nonatomic ,strong) UILabel             *contentL;
@property(nonatomic ,strong) UILabel             *lineL;
@property(nonatomic ,strong) UILabel             *moneyL;

- (void)configData:(WJNewsCenterModel *)model;

@end
