//
//  WJCashQRCodeView.h
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/29.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJCashQRCodeModel.h"

@interface WJCashQRCodeView : UIView

@property(nonatomic,strong)UILabel        * titleLabel;
@property(nonatomic,strong)UILabel        * DetailsLabel;
@property(nonatomic,strong)UILabel        * moneyLabel;
@property(nonatomic,strong)UIImageView    * QRCodeIV;
@property(nonatomic,strong)UILabel        * tipsLable;
@property(nonatomic,strong)UILabel        * tipsDetailLabel;
@property(nonatomic,strong)UIButton       * saveButton;

- (void)configDataWithModel:(WJCashQRCodeModel *)model;


@end
