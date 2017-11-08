//
//  WJLoadingView.m
//  WanJiCard
//
//  Created by 孙明月 on 16/1/13.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJLoadingView.h"

@implementation WJLoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isAnimating = NO;
        
        UIImage *loadimage = [UIImage imageNamed:@"Loading01"];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - loadimage.size.width)/2,0, loadimage.size.width,loadimage.size.height)];

//        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, frame.size.width,frame.size.height-20)];
        [self addSubview:imageView];
        //设置动画帧
        imageView.animationImages=[NSArray arrayWithObjects:
                                   [UIImage imageNamed:@"Loading01"],
                                   [UIImage imageNamed:@"Loading02"],
                                   [UIImage imageNamed:@"Loading03"],
                                   [UIImage imageNamed:@"Loading04"],
                                   [UIImage imageNamed:@"Loading05"],
                                   [UIImage imageNamed:@"Loading06"],
                                   [UIImage imageNamed:@"Loading07"],
                                   [UIImage imageNamed:@"Loading08"],
                                   [UIImage imageNamed:@"Loading09"],
                                   [UIImage imageNamed:@"Loading10"],
                                   [UIImage imageNamed:@"Loading11"],
                                   [UIImage imageNamed:@"Loading12"],
                                   nil];
        
        
        Infolabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        Infolabel.backgroundColor = [UIColor clearColor];
        Infolabel.textAlignment = NSTextAlignmentCenter;
        Infolabel.textColor = [UIColor colorWithRed:84.0/255 green:86./255 blue:212./255 alpha:1];
        Infolabel.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:14.0f];
        [self addSubview:Infolabel];
        self.layer.hidden = YES;
    }
    return self;
}


- (void)startAnimation
{
    _isAnimating = YES;
    self.layer.hidden = NO;
    [self doAnimation];
}

- (void)doAnimation{
    
    Infolabel.text = _loadtext;
    //设置动画总时间
    imageView.animationDuration=1.0;
    //设置重复次数,0表示不重复
    imageView.animationRepeatCount=0;
    //开始动画
    [imageView startAnimating];
}

- (void)stopAnimationWithLoadText:(NSString *)text withType:(BOOL)type;
{
    _isAnimating = NO;
    Infolabel.text = text;
    if(type){
        
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [imageView stopAnimating];
            self.layer.hidden = YES;
            self.alpha = 1;
        }];
    }else{
        [imageView stopAnimating];
        [imageView setImage:[UIImage imageNamed:@"Loading06"]];
    }
    
}


- (void)setLoadText:(NSString *)text;
{
    if(text){
        
        _loadtext = text;
    }
}

@end
