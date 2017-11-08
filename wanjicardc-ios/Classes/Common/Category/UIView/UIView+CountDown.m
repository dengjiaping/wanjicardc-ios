//
//  UIView+CountDown.m
//  WanJiCard
//
//  Created by Angie on 16/2/4.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "UIView+CountDown.h"

@implementation UIView (CountDown)

- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color {
    
    __weak typeof(self) weakSelf = self;
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.backgroundColor = mColor;
                [weakSelf setTitle:title];
                weakSelf.userInteractionEnabled = YES;
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.backgroundColor = color;
                [weakSelf setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle]];
                weakSelf.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

- (void)setTitle:(NSString *)title {
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *buttonSelf = (UIButton *)self;
        [buttonSelf setTitle:title forState:UIControlStateNormal];
    }else if ([self isKindOfClass:[UILabel class]]){
        UILabel *labelSelf = (UILabel *)self;
        labelSelf.text = title;
    }
}

@end
