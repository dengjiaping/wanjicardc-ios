//
//  WJAdScrollingView.h
//  WanJiCard
//
//  Created by silinman on 16/5/20.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJAdScrollingView : UIView

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageNames selectImageHandle:(void(^)(NSInteger index))process;
- (void)addTimer;
- (void)removeTimer;

@end
