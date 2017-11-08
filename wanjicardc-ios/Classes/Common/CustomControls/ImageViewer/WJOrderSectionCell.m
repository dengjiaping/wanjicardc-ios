//
//  WJOrderSectionCell.m
//  WanJiCard
//
//  Created by reborn on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJOrderSectionCell.h"

@interface WJOrderSectionCell ()
{
    UILabel *mLabelLeft;
}
@end

@implementation WJOrderSectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        mLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth, frame.size.height)];
        mLabelLeft.font = WJFont13;
        mLabelLeft.textColor = WJColorLightGray;
        [self addSubview:mLabelLeft];
 
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    mLabelLeft.text = _title;

}

@end
