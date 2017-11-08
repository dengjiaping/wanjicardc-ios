//
//  AttributedLabel.m
//  WanJiCard
//
//  Created by Lynn on 15/9/15.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "AttributedLabel.h"

@implementation AttributedLabel


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = _attributedString;
    textLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:textLayer];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    if (text == nil) {
        self.attributedString = nil;
    }else{
        self.attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    }
}



// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length
{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                       value:(id)color.CGColor
                       range:NSMakeRange(location, length)];

}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length
{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attributedString addAttribute:(NSString *)kCTFontAttributeName
                       value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)font.fontName,
                                                      font.pointSize,
                                                      NULL))
                       range:NSMakeRange(location, length)];
}

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length
{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                       value:(id)[NSNumber numberWithInt:style]
                       range:NSMakeRange(location, length)];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
