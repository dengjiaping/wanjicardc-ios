//
//  WJEmptyView.m
//  WanJiCard
//
//  Created by Lynn on 15/9/29.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJEmptyView.h"

#define   kImageWidth       ALD(100)

@implementation WJEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - kImageWidth)/2, 0, kImageWidth, kImageWidth)];
        self.imageView.image = [UIImage imageNamed:@"common_nodata_image"];
        
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + ALD(15), kScreenWidth, ALD(20))];
        self.tipLabel.font = WJFont14;
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.text = @"暂无数据";
        self.tipLabel.textColor = WJColorAlert;
        [self addSubview:self.imageView];
        [self addSubview:self.tipLabel];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
