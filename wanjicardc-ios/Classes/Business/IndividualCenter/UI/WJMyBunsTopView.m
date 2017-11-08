//
//  WJMyBunsTopView.m
//  WanJiCard
//
//  Created by silinman on 16/8/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMyBunsTopView.h"
#define  moreStoreRightEdgeMargin                                 (iPhone6OrThan?(ALD(25)):(ALD(20)))
#define  moreStoreLeftEdgeMargin                                  (iPhone6OrThan?(ALD(30)):(ALD(35)))


@implementation WJMyBunsTopView{
    UIButton           *useBunsBtn;
    UIButton           *payBunsBtn;
    UIView             *line;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        //背景
        _bunsBackIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(200))];
        _bunsBackIV.image = [UIImage imageNamed:@"mybaozi_image_bg"];
        _bunsBackIV.userInteractionEnabled = YES;
        [self addSubview:self.bunsBackIV];
        
        //包子Icon
        _bunsIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(15), ALD(70), ALD(69), ALD(69))];
        _bunsIV.image = [UIImage imageNamed:@"mybaozi_image_baozi"];
        [self.bunsBackIV addSubview:self.bunsIV];
        
        //我的包子
        _bunsTitleL = [[UILabel alloc] initWithFrame:CGRectZero];
        _bunsTitleL.font = WJFont15;
        _bunsTitleL.textColor = WJColorWhite;
        _bunsTitleL.text = @"我的包子：";
        CGFloat bunsTitleLwidth = [UILabel getWidthWithTitle:_bunsTitleL.text font:_bunsTitleL.font];
        _bunsTitleL.frame = CGRectMake(_bunsIV.right + ALD(22), ALD(96), bunsTitleLwidth, ALD(18));
        _bunsTitleL.centerY = _bunsIV.centerY;
        [self.bunsBackIV addSubview:self.bunsTitleL];
        
        //包子个数
        _bunsCountsL = [[UILabel alloc] initWithFrame:CGRectMake(_bunsTitleL.right + ALD(5), ALD(89), ALD(31), ALD(31))];
        _bunsCountsL.font = WJFont28;
        _bunsCountsL.textColor = WJBunsYellowColorAmount;
//        _bunsCountsL.text = @"0";
        _bunsCountsL.shadowColor = [WJColorBlack colorWithAlphaComponent:0.2];
        _bunsCountsL.shadowOffset = CGSizeMake(0, 2.0);
        _bunsCountsL.centerY = _bunsIV.centerY;
        [self.bunsBackIV addSubview:self.bunsCountsL];
        
        //个
        _bunsStrL = [[UILabel alloc] initWithFrame:CGRectMake(_bunsCountsL.right,_bunsCountsL.y +  ALD(11), ALD(30), ALD(15))];
        _bunsStrL.font = WJFont12;
        _bunsStrL.textColor = WJColorWhite;
        _bunsStrL.textAlignment = NSTextAlignmentLeft;
        _bunsStrL.text = @"个";
        [self.bunsBackIV addSubview:self.bunsStrL];
        
        //使用包子
        useBunsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        useBunsBtn.frame = CGRectMake(0, ALD(160), kScreenWidth/2, ALD(40));
        [useBunsBtn setTitle:@"使用包子" forState:UIControlStateNormal];
        [useBunsBtn setTitleColor:WJColorLightGray forState:UIControlStateNormal];
        [useBunsBtn setImage:[UIImage imageNamed:@"mybaozi_ic_baozi"] forState:UIControlStateNormal];
        useBunsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, moreStoreLeftEdgeMargin, 0, moreStoreRightEdgeMargin);
        useBunsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, ALD(5), 0, ALD(10));
        useBunsBtn.titleLabel.font = WJFont14;
        [useBunsBtn setTitleColor:WJColorWhite forState:UIControlStateNormal];
        [useBunsBtn setBackgroundImage:[self createImageWithColor:[[WJUtilityMethod colorWithHexColorString:@"#000000"] colorWithAlphaComponent:0.06]] forState:UIControlStateNormal];
        [useBunsBtn setBackgroundImage:[self createImageWithColor:[[WJUtilityMethod colorWithHexColorString:@"#000000"] colorWithAlphaComponent:0.15]] forState:UIControlStateHighlighted];
        [useBunsBtn addTarget:self action:@selector(useBuns) forControlEvents:UIControlEventTouchUpInside];
        useBunsBtn.userInteractionEnabled = YES;
        [self.bunsBackIV addSubview:useBunsBtn];
        
        //中间线
        line = [[UIView alloc] initWithFrame:CGRectMake(useBunsBtn.right ,useBunsBtn.y + ALD(11), ALD(0.5), ALD(18))];
        line.backgroundColor = WJColorWhite;
        [self addSubview:line];
        
        //立即充值
        payBunsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        payBunsBtn.frame = CGRectMake(kScreenWidth/2, ALD(160), kScreenWidth/2, ALD(40));
        [payBunsBtn setTitle:@"立即充值" forState:UIControlStateNormal];
        [payBunsBtn setTitleColor:WJColorLightGray forState:UIControlStateNormal];
        [payBunsBtn setImage:[UIImage imageNamed:@"mybaozi_ic_pay"] forState:UIControlStateNormal];
        payBunsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, moreStoreLeftEdgeMargin, 0, moreStoreRightEdgeMargin);
        payBunsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, ALD(5), 0, ALD(10));
        payBunsBtn.titleLabel.font = WJFont14;
        [payBunsBtn setTitleColor:WJColorWhite forState:UIControlStateNormal];
        [payBunsBtn setBackgroundImage:[self createImageWithColor:[[WJUtilityMethod colorWithHexColorString:@"#000000"] colorWithAlphaComponent:0.06]] forState:UIControlStateNormal];
        [payBunsBtn setBackgroundImage:[self createImageWithColor:[[WJUtilityMethod colorWithHexColorString:@"#000000"] colorWithAlphaComponent:0.15]] forState:UIControlStateHighlighted];
        [payBunsBtn addTarget:self action:@selector(payBunsCount) forControlEvents:UIControlEventTouchUpInside];
        [self.bunsBackIV addSubview:payBunsBtn];
        
        _recordTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(200), kScreenWidth, ALD(44))];
        _recordTitleView.backgroundColor = WJColorWhite;
        [self addSubview:self.recordTitleView];
        
        _recordTitleL = [[UILabel alloc] initWithFrame:CGRectMake(ALD(12), ALD(13), ALD(100), ALD(17))];
        _recordTitleL.font = WJFont14;
        _recordTitleL.textColor = WJColorDarkGray;
        _recordTitleL.text = @"交易记录";
        [self.recordTitleView addSubview:self.recordTitleL];
        
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(43), kScreenWidth, ALD(0.5))];
        _bottomLineView.backgroundColor = WJColorSeparatorLine;
        [self.recordTitleView addSubview:self.bottomLineView];
    }
    return self;
}

- (UIImage *) createImageWithColor:(UIColor *) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
//使用包子
- (void)useBuns{
    self.useBunsPay();
}

//立即充值
- (void)payBunsCount{
    self.bunsRecharge();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
