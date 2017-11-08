//
//  WJAdScrollingCell.m
//  WanJiCard
//
//  Created by silinman on 16/5/20.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJAdScrollingCell.h"
#import "WJAdScrollingView.h"
#import "WJClickImageView.h"

@interface WJAdScrollingCell()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation WJAdScrollingCell{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.imageView];
        
        self.imageView.frame = self.bounds;
    }
    return self;
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}

-(void)setURLString:(NSString *)URLString
{
    _URLString = URLString;
    //开始下载
    if( URLString )
    {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:URLString]
                  placeholderImage:[UIImage imageNamed:@"home_ad_default"]];
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
