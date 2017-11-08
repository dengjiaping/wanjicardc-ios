//
//  WJSearchTableViewCell.m
//  WanJiCard
//
//  Created by Lynn on 15/9/21.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJSearchTableViewCell.h"
#import "WJHotKeysModel.h"

#define kButtonWidth        ALD(80)
#define kButtonHeight       ALD(31)
#define kButtonX            ALD(10)
#define kButtonTop          ALD(15)

@implementation WJSearchTableViewCell
+ (CGFloat)heightWightArray:(NSArray *)array
{
    
    //    return kButtonTop + (kButtonTop + kButtonHeight) * ceil([array count]/4.0);
    return (kButtonTop + kButtonHeight) * ([array count] % 4 > 0 ? [array count]/4 + 1 :[array count]/4) + kButtonTop;
}


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.tabsArray = [NSArray array];
        self.backgroundColor = WJColorWhite;
    }
    return self;
}

- (void)setTabsArray:(NSArray *)tabsArray
{
    _tabsArray = [NSArray arrayWithArray:tabsArray];
    NSArray * views = [self.contentView subviews];
    for (UIView * view in views) {
        [view removeFromSuperview];
    }
    
    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    upLine.backgroundColor = WJColorSeparatorLine;
    [self.contentView addSubview:upLine];

    for (int i = 0; i < [tabsArray count]; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:WJColorWhite];
        [button setFrame:CGRectMake(kButtonX + (kButtonX + kButtonWidth) * (i%4) , kButtonTop + (kButtonTop + kButtonHeight) * (i/4), kButtonWidth, kButtonHeight)];
        button.tag = 10000 + i;
        [button.titleLabel setFont:WJFont14];
        [button addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:WJColorDarkGray forState:UIControlStateNormal];
        button.layer.borderColor = WJColorLightGray.CGColor;
        button.layer.borderWidth = 0.5;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = kButtonHeight/2;
        
        NSString *hotKey = ((WJHotKeysModel *)[_tabsArray objectAtIndex:i]).name;
        [button setTitle:hotKey forState:UIControlStateNormal];
        [self.contentView addSubview:button];
    }
    
    CGFloat cellHeight = [[self class] heightWightArray:tabsArray];

    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight-0.5, SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor = WJColorSeparatorLine;
    [self.contentView addSubview:bottomLine];

}


- (void)tabAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(tabsTableView:didSelectedByIndex:)]) {
        [self.delegate tabsTableView:self didSelectedByIndex:((int)button.tag - 10000)];
    }
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
