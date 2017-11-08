//
//  WJEnterPsdView.m
//  WanJiCard
//
//  Created by Angie on 15/9/10.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJEnterPsdView.h"

@implementation WJEnterPsdView{
    UIView *enterBg;
    NSInteger selectedIvTag;
    NSArray *btnArray;
}


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        enterBg = [[UIView alloc] initWithFrame:self.bounds];
        enterBg.layer.cornerRadius = 3;
        enterBg.clipsToBounds = YES;
        [self addSubview:enterBg];
        
        NSMutableArray *arr = [NSMutableArray array];
        int ivWidth = enterBg.width/6;
        for (int i = 0; i < 6; i++) {
            UIImage *normal = [WJUtilityMethod imageFromColor:[UIColor whiteColor] Width:100 Height:100];
            UIImage *hight = [WJUtilityMethod imageFromColor:[UIColor blackColor] Width:20 Height:20];
            
            UIImageView *iv = [[UIImageView alloc] initWithImage:normal highlightedImage:hight];
            iv.frame = CGRectMake(ivWidth*i, 0, ivWidth-1, enterBg.height);
            iv.backgroundColor = [UIColor whiteColor];
            iv.layer.masksToBounds = YES;
            iv.contentMode = UIViewContentModeCenter;
            iv.tag = 200+i;
            iv.layer.shadowColor = WJColorViewBg.CGColor;
            iv.layer.shadowOffset = CGSizeMake(1, 0);
            iv.layer.shadowOpacity = 0;
            iv.layer.shadowRadius = 0.5;
            [enterBg addSubview:iv];
            [arr addObject:iv];
        }
        selectedIvTag = 200;
        CGRect frame = enterBg.frame;
        frame.size.width = ivWidth*6-1;
        enterBg.frame = frame;
        
        enterBg.centerX = self.width/2;
        
        btnArray = [NSArray arrayWithArray:arr] ;
    }

    return self;
}

- (void)changePsdImageCount:(NSInteger)count{
    
    for (UIImageView *iv in btnArray) {
        iv.highlighted = NO;
    }

    for (int i = 0; i < count; i++) {
        UIImageView *iv = btnArray[i];
        iv.highlighted = YES;
    }
    
    if (count == 6) {
        if ([self.delegate respondsToSelector:@selector(hadEnterAllPsdInPsdView:)]) {
            [self.delegate performSelector:@selector(hadEnterAllPsdInPsdView:) withObject:self];
        }
    }
    
}

- (void)dealloc{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end
