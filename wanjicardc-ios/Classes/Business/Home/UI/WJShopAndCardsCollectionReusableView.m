//
//  WJShopAndCardsCollectionReusableView.m
//  WanJiCard
//
//  Created by silinman on 16/5/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJShopAndCardsCollectionReusableView.h"

@implementation WJShopAndCardsCollectionReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)addTarget:(id)Target action:(SEL)action
{
    myEvent = action;
    obj = Target;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [obj performSelector:myEvent withObject:self afterDelay:0];
}

@end
