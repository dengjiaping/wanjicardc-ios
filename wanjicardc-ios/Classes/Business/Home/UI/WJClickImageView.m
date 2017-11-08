//
//  WJClickImageView.m
//  WanJiCard
//
//  Created by silinman on 16/5/20.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJClickImageView.h"

@implementation WJClickImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
