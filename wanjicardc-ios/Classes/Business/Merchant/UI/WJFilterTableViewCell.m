//
//  WJFilterTableViewCell.m
//  WanJiCard
//
//  Created by 孙明月 on 16/5/31.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJFilterTableViewCell.h"
#import "WJCategoryModel.h"
#import "WJSearchConditionModel.h"

@implementation WJFilterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = WJColorDarkGray;
        self.titleLabel.font = WJFont15;
        
        self.markView = [[UIView alloc] init];
        self.markView.backgroundColor = WJColorNavigationBar;
        
        self.rightSideLine = [[UIView alloc] init];
        self.rightSideLine.backgroundColor = WJColorSeparatorLine;
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = WJColorSeparatorLine;
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.bottomLine];
        [self.contentView addSubview:self.markView];
        [self.contentView addSubview:self.rightSideLine];
        
    }
    return self;
}

- (void)configData:(id)obj;
{
    NSString * string = nil;
    if ([obj isKindOfClass:[WJCategoryModel class]]) {
        string = ((WJCategoryModel *)obj).name;
    }else if([obj isKindOfClass:[WJSearchConditionModel class]])
    {
        string = ((WJSearchConditionModel *)obj).name;
    }else if ([obj isKindOfClass:[NSString class]])
    {
        string = obj;
    }
    self.titleLabel.text = string;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel setFrame:CGRectMake(0, 0, self.superview.frame.size.width, CGRectGetHeight(self.frame))];
    [self.bottomLine setFrame:CGRectMake(0, CGRectGetHeight(self.frame) -0.5, self.superview.frame.size.width, 0.5)];
    [self.markView setFrame:CGRectMake(0, 0, 5, CGRectGetHeight(self.frame))];
    [self.rightSideLine setFrame:CGRectMake(self.superview.frame.size.width-0.5, 0, 0.5, CGRectGetHeight(self.frame))];
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
