//
//  WJInputKeyBoardView.m
//  WanJiCard
//
//  Created by 林有亮 on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJInputKeyBoardView.h"

@interface WJInputKeyBoardView()
{
    UILabel         * buyNumLabel;
}

@end


@implementation WJInputKeyBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        line.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e6e7e8"];
        
        buyNumLabel = [[UILabel alloc] init];
        buyNumLabel.text = @"购买数量";
        [buyNumLabel setFont:WJFont14];
        [buyNumLabel setTextColor:[WJUtilityMethod colorWithHexColorString:@"2f3338"]];
        [buyNumLabel sizeToFit];
        CGFloat height = buyNumLabel.height;
        [buyNumLabel setFrame:CGRectMake(ALD(12), (ALD(50) - height)/2.0, buyNumLabel.width, height)];
        
        _subtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subtractButton setFrame:CGRectMake(ALD(12) + CGRectGetMaxX(buyNumLabel.frame), ALD(10), ALD(30), ALD(30))];
        [_subtractButton setImage:[UIImage imageNamed:@"inventedcard_ic_jian"] forState:UIControlStateNormal];
        [_subtractButton setImage:[UIImage imageNamed:@"inventedcard_ic_jian_press"] forState:UIControlStateHighlighted];
        [_subtractButton setImage:[UIImage imageNamed:@"inventedcard_ic_jian_null"] forState:UIControlStateDisabled];
        
        //40*30
        _textTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_subtractButton.frame) + ALD(4), ALD(10), ALD(40), ALD(30))];
        _textTF.borderStyle = UITextBorderStyleNone;
        _textTF.text = @"1";
        _textTF.textAlignment = NSTextAlignmentCenter;
        _textTF.backgroundColor = [WJUtilityMethod getColorFromImage:[UIImage imageNamed:@"inventedcard_ic_quantity"]];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setFrame:CGRectMake(ALD(4) + CGRectGetMaxX(_textTF.frame), ALD(10), ALD(30), ALD(30))];
        [_addButton setImage:[UIImage imageNamed:@"inventedcard_ic_jia"] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"inventedcard_ic_jia_press"] forState:UIControlStateHighlighted];
        [_addButton setImage:[UIImage imageNamed:@"inventedcard_ic_jia_null"] forState:UIControlStateDisabled];
        
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyButton setFrame:CGRectMake(kScreenWidth - ALD(112), ALD(8), ALD(100), ALD(35))];
        [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        _buyButton.layer.cornerRadius = 5;
        _buyButton.titleLabel.font = WJFont14;
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyButton setBackgroundColor:[WJUtilityMethod colorWithHexColorString:@"31b0ef"]];
        
        [self addSubview:line];
        [self addSubview:buyNumLabel];
        [self addSubview:_subtractButton];
        [self addSubview:_textTF];
        [self addSubview:_addButton];
        [self addSubview:_buyButton];
    }
    return  self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
