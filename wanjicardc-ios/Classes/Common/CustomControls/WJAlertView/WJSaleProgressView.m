//
//  WJSaleProgressView.m
//  WanJiCard
//
//  Created by reborn on 16/5/16.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJSaleProgressView.h"

@interface WJSaleProgressView ()
@property (nonatomic, strong)UIImageView *trackView;    //背景图像
@property (nonatomic, strong)UIImageView *progressView; //填充图像
@property (nonatomic, assign)CGFloat     totalProgress; //总进度
@property (nonatomic, assign)CGFloat     currentProgress; //当前进度
@end

@implementation WJSaleProgressView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _trackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _trackView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e9e9e9"];
        _trackView.clipsToBounds = YES;
        _trackView.layer.cornerRadius = 3;
        [self addSubview:_trackView];
        
        _progressView = [[UIImageView alloc] initWithFrame:CGRectMake(0-frame.size.width, 0, frame.size.width, frame.size.height)];
        _progressView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"ff4400"];
        _progressView.clipsToBounds = YES;
        _progressView.alpha = 0.8;
        _progressView.layer.cornerRadius = 3;
        [_trackView addSubview:_progressView];
        
        _totalProgress =  1.0;
        
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    self.currentProgress = progress;
    [self changeProgressViewFrame];
}

- (void)changeProgressViewFrame
{
    _progressView.frame = CGRectMake(self.frame.size.width * (_currentProgress/_totalProgress) - self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
}

@end
