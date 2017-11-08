//
//  UIView+CountDown.h
//  WanJiCard
//
//  Created by Angie on 16/2/4.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CountDown)

- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color;

@end
