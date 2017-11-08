//
//  WJOrderTypeViewCell.m
//  WanJiCard
//
//  Created by reborn on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJOrderTypeViewCell.h"

@implementation WJOrderTypeViewCell
{
    UILabel *label;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderColor = WJColorSeparatorLine.CGColor;
        label.layer.borderWidth = 0.5;
        label.backgroundColor = WJColorWhite;
        label.font = WJFont13;
        label.textColor = WJColorLightGray;
        [self.contentView addSubview:label];
    }
    return self;

}

- (void)upadate:(NSString *)orderType
{
   label.text = orderType;
}

- (void)changeLabelColor
{
    if (self.isSelected) {
        
        label.textColor = WJColorNavigationBar;
        
    } else {
        
        label.textColor = WJColorLightGray;
        
    }
}

@end
