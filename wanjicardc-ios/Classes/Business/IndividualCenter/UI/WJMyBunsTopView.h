//
//  WJMyBunsTopView.h
//  WanJiCard
//
//  Created by silinman on 16/8/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJMyBunsTopView : UIView

@property (nonatomic, strong) UIImageView        *bunsBackIV;
@property (nonatomic, strong) UIImageView        *bunsIV;
@property (nonatomic, strong) UILabel            *bunsTitleL;
@property (nonatomic, strong) UILabel            *bunsCountsL;
@property (nonatomic, strong) UILabel            *bunsStrL;
//@property (nonatomic, strong) UIButton           *useBunsBtn;
//@property (nonatomic, strong) UIButton           *payBunsBtn;
@property (nonatomic, strong) UIView             *recordTitleView;
@property (nonatomic, strong) UILabel            *recordTitleL;
@property (nonatomic, strong) UIView             *bottomLineView;

@property (nonatomic, strong) WJActionBlock      useBunsPay;
@property (nonatomic, strong) WJActionBlock      bunsRecharge;

@end
