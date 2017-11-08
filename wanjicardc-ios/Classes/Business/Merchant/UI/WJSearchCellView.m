//
//  WJSearchTypeView.m
//  WanJiCard
//
//  Created by Lynn on 15/9/11.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJSearchCellView.h"
#define kImageWidth     44

@interface WJSearchCellView()


@property (nonatomic, strong) UIImageView   * logoImageView;
@property (nonatomic, strong) UILabel       * nameLabel;

@property (nonatomic, strong) UIView        * line;

@end

@implementation WJSearchCellView

- (instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dic tag:(int)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame) - kImageWidth)/2,ALD(15) , kImageWidth, kImageWidth)];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.logoImageView.frame), CGRectGetWidth(frame), ALD(20))];
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - 1, CGRectGetWidth(frame), 1)];
        
        
        self.logoImageView.image = [UIImage imageNamed:dic[@"logo"]];
        self.nameLabel.text = dic[@"name"];
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.line.backgroundColor = [UIColor grayColor];
        
        self.tag = 10000 + tag;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAction:)];
        
        [self addGestureRecognizer:tap];
        [self addSubview:self.logoImageView];
        [self addSubview:self.nameLabel];
//        [self addSubview:self.line];
    }
    return self;
}

- (void)selectAction:(UITapGestureRecognizer *)tap
{
    int index = (int)tap.view.tag - 10000;
    
    if ([self.delegate respondsToSelector:@selector(searchCell:didSelectWithIndex:)]) {
        [self.delegate searchCell:self didSelectWithIndex:index];
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
