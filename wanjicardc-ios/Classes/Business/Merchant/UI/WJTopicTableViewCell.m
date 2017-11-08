//
//  WJTopicTableViewCell.m
//  WanJiCard
//
//  Created by Lynn on 15/9/12.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJTopicTableViewCell.h"
#import "WJTopicModel.h"
#import <UIImageView+HighlightedWebCache.h>

@interface WJTopicTableViewCell()

@property (nonatomic, strong) UIImageView   * leftImageView;
@property (nonatomic, strong) UIImageView   * rightImageView;

@end

@implementation WJTopicTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e5e5e5"];
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(88))];
        backView.backgroundColor = [UIColor whiteColor];
        self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(10), ALD(10), kScreenWidth /2 -ALD(10), ALD(68))];
        
        self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImageView.frame)+1,
                                                                            CGRectGetMinY(self.leftImageView.frame),
                                                                            CGRectGetWidth(self.leftImageView.frame),
                                                                            CGRectGetHeight(self.leftImageView.frame))];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth /2, ALD(10), 1, ALD(68))];
        line.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e5e5e5"];
        
        
        
        self.leftImageView.userInteractionEnabled = YES;
        self.rightImageView.userInteractionEnabled = YES;
        
        self.leftImageView.tag = 20000+0;
        self.rightImageView.tag = 20000+1;

        UITapGestureRecognizer * lefTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        UITapGestureRecognizer * rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];

        [self.leftImageView addGestureRecognizer:lefTap];
        [self.rightImageView addGestureRecognizer:rightTap];
        
        [self.contentView addSubview:backView];
        [self.contentView addSubview:line];
        [self.contentView addSubview:self.leftImageView];
        [self.contentView addSubview:self.rightImageView];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    int index = (int)tap.view.tag - 20000;
    
    if ([self.delegate respondsToSelector:@selector(topicCell:didSelectedWithIndex:)]) {
        [self.delegate topicCell:self didSelectedWithIndex:index];
    }
//    [self setSelected:NO animated:YES];
}


- (void)setImageWithArray:(NSArray *)topicsArray
{
    if([topicsArray count] < 2) return;
    
    for(int i = 0 ;i < 2;i++)
    {
        UIImageView * imageView = (UIImageView *)[self.contentView viewWithTag:i+20000];
        NSString * str = ((WJTopicModel *)[topicsArray objectAtIndex:i]).imgUrl;
        [imageView sd_setImageWithURL:[NSURL URLWithString:str]
                     placeholderImage:PlaceholderImage];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
