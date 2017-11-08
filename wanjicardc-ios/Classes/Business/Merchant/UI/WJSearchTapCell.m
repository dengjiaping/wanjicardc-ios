//
//  WJSearchTapCell.m
//  WanJiCard
//
//  Created by Lynn on 15/9/17.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJSearchTapCell.h"

@interface WJSearchTapCell()

@end

@implementation WJSearchTapCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = WJColorWhite;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = WJColorDarkGray;
        self.titleLabel.font = WJFont13;

        self.moreImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Details_screen_tel_nor"]highlightedImage:[UIImage imageNamed:@"Details_screen_tel_sel"]];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.moreImageView];
    }
    return self;
}



- (void)setTapText:(NSString *)text
{
  
    CGSize size = [text     boundingRectWithSize:CGSizeMake(10000000, self.frame.size.height)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font,NSFontAttributeName, nil]
                                         context:nil].size;
    
    CGFloat left = (self.frame.size.width - size.width - ALD(10) ) / 2;
    CGFloat top = (self.frame.size.height - ALD(8)) / 2;
    
    if (left < 0) {
        
        NSString *str = @"";
        if ([text rangeOfString:@"/"].location != NSNotFound) {
            NSRange range = [text rangeOfString:@"/"];
            str = [[text substringToIndex:range.location] stringByAppendingString:@"..."];

        }else{
        
            str = [[text substringToIndex:8] stringByAppendingString:@"..."];
        }
        
        self.titleLabel.text = str;
        CGSize size2 = [str boundingRectWithSize:CGSizeMake(10000000, self.frame.size.height)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font,NSFontAttributeName, nil]
                                         context:nil].size;
        
        left = (self.frame.size.width - size2.width - ALD(10) ) / 2;
        [self.titleLabel setFrame:CGRectMake(left, 0, size2.width, CGRectGetHeight(self.frame))];
        
    }else{
        
        self.titleLabel.text = text;
        [self.titleLabel setFrame:CGRectMake(left, 0, size.width, CGRectGetHeight(self.frame))];
    }
    

    [self.moreImageView setFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+ALD(2), top, ALD(8), ALD(8))];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    int index = (int)self.tag - 30000;
    if( [self.delegate respondsToSelector:@selector(searchTap:didSelectWithindex:)])
    {
        [self.delegate searchTap:self didSelectWithindex:index];
    }
}


@end
