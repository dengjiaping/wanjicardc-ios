//
//  WJTabsTableViewCell.m
//  WanJiCard
//
//  Created by Lynn on 15/9/21.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJTabsTableViewCell.h"
#import "WJModelArea.h"


#define kButtonWidth        ALD(80)
#define kButtonHeight       ALD(35)
#define kButtonX            ALD(10)
#define kButtonTop          ALD(10)

@implementation WJTabsTableViewCell

+ (CGFloat)heightWightArray:(NSArray *)array
{
   
//    return kButtonTop + (kButtonTop + kButtonHeight) * ceil([array count]/4.0);
    return (kButtonTop + kButtonHeight) * ([array count] % 4 > 0 ? [array count]/4 + 1 :[array count]/4);
}


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.tabsArray = [NSArray array];
        self.backgroundColor = WJColorViewBg;
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
    
    for (int i = 0; i < [tabsArray count]; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:WJColorWhite];
        [button setFrame:CGRectMake(kButtonX + (kButtonX + kButtonWidth) * (i%4) , (kButtonTop + kButtonHeight) * (i/4), kButtonWidth, kButtonHeight)];
        button.tag = 40000 + i;
        [button.titleLabel setFont:WJFont14];
        [button addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:WJColorDarkGray forState:UIControlStateNormal];
        button.layer.borderColor = WJColorSeparatorLine.CGColor;
        button.layer.borderWidth = 0.5;
       
        NSString *areaName =((WJModelArea *)[_tabsArray objectAtIndex:i]).name;
        if ([areaName hasSuffix:@"市辖区"]) {
            areaName = [areaName stringByReplacingOccurrencesOfString:@"市市辖区" withString:@""];
        }
        if ([areaName hasSuffix:@"市"]) {
            areaName = [areaName stringByReplacingOccurrencesOfString:@"市" withString:@""];
        }

        [button setTitle:areaName forState:UIControlStateNormal];
        [self.contentView addSubview:button];
    }
}


- (void)tabAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(tabsTableView:didSelectedByIndex:)]) {
        [self.delegate tabsTableView:self didSelectedByIndex:((int)button.tag - 40000)];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
