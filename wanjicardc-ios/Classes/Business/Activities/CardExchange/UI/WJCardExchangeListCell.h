//
//  WJCardExchangeListCell.h
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJCardExchangeModel.h"

@interface WJCardExchangeListCell : UITableViewCell

@property(nonatomic,strong)UIImageView          * cardIV;
@property(nonatomic,strong)UIImageView          * logoIV;
@property(nonatomic,strong)UILabel              * titleLabel;
@property(nonatomic,strong)UILabel              * tipLabel;
@property(nonatomic,strong)UIButton             * sureButton;

- (void)configDataWithModel:(WJCardExchangeModel *)model;

@end
