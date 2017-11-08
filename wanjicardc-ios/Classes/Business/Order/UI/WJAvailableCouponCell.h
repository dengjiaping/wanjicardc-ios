//
//  WJAvailableCouponCell.h
//  WanJiCard
//
//  Created by 孙琦 on 16/5/26.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJAvailableCouponCell : UITableViewCell
@property (nonatomic,strong)UIButton *selectBtn;
@property (nonatomic,strong)UIImageView *selectImage;
@property (nonatomic,strong)UIImageView *unSelectImage;

@property (nonatomic,strong)UIImageView *backgImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UILabel *moneyLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@end
