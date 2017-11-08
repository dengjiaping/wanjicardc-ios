//
//  WJPicPageControl.m
//  WanJiCard
//
//  Created by silinman on 16/7/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJPicPageControl.h"

@interface WJPicPageControl(private)  // 声明一个私有方法, 该方法不允许对象直接使用

- (void)updateDots;

@end

@implementation WJPicPageControl

- (id)initWithFrame:(CGRect)frame { // 初始化
    self = [super initWithFrame:frame];
    self.activeImage = [UIImage imageNamed:@"home_pageControlIcon_white"];
    self.inactiveImage = [UIImage imageNamed:@"home_pageControlIcon_whiteCircle"] ;
    return self;
}
-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView *dot = [self.subviews objectAtIndex:i];
        UIImageView *dotIV = [dot.subviews objectAtIndex:0];
        if (i == self.currentPage){
            dotIV.image = _activeImage;
        }else {
            dotIV.image = _inactiveImage;
        }
    }
}
-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    //修改图标大小
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        
        UIView* subview = [self.subviews objectAtIndex:subviewIndex];
        
        CGSize size;
        
        size.height = ALD(6);
        
        size.width = ALD(6);
        
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     
                                     size.width,size.height)];
        UIImageView * subIV = [[UIImageView alloc]initWithFrame:subview.frame];
        [subview addSubview:subIV];
        
    }
    
    
    [self updateDots];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
