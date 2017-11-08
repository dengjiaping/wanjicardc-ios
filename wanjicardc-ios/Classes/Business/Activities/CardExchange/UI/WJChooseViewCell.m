//
//  WJChooseViewCell.m
//  WanJiCard
//
//  Created by 林有亮 on 16/12/5.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJChooseViewCell.h"
#import "WJFaceValueModel.h"

@interface WJChooseViewCell()
{
    UILabel     * valueLabel;
    UILabel     * desLabel;
}

@end

@implementation WJChooseViewCell

- (instancetype) initWithPoint:(CGPoint)point value:(NSString *)value des:(NSString *)des
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, ALD(110), ALD(60))];
    if (self) {
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(10), ALD(110), ALD(25))];
        valueLabel.font = [UIFont boldSystemFontOfSize:19];
        valueLabel.textColor = WJColorDardGray3;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = value;
        
        desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ALD(35), ALD(110), ALD(20))];
        desLabel.font = WJFont11;
        desLabel.textColor = WJColorDardGray3;
        desLabel.textAlignment = NSTextAlignmentCenter;
        desLabel.text = [NSString stringWithFormat:@"可兑换:%.2f个包子",[des floatValue]];
//        desLabel.backgroundColor = [WJUtilityMethod randomColor];
//        valueLabel.backgroundColor = [WJUtilityMethod randomColor];
        
        self.layer.cornerRadius = 3;
        self.layer.borderColor = [[WJUtilityMethod colorWithHexColorString:@"e6e7e8"] CGColor];
        self.layer.borderWidth = 1;
        
        [self addSubview:valueLabel];
        [self addSubview:desLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    if (selected) {
        valueLabel.textColor = WJColorCardBlue;
        desLabel.textColor = WJColorCardBlue;
        self.layer.borderColor = [WJColorCardBlue CGColor];
    } else {
        desLabel.textColor = WJColorDardGray3;
        valueLabel.textColor = WJColorDardGray3;
        self.layer.borderColor = [[WJUtilityMethod colorWithHexColorString:@"e6e7e8"] CGColor];
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
