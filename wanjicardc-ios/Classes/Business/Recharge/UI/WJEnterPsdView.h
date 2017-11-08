//
//  WJEnterPsdView.h
//  WanJiCard
//
//  Created by Angie on 15/9/10.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJEnterPsdViewDelegate <NSObject>

- (void)hadEnterAllPsdInPsdView:(UIView *)psdView;

@end

@interface WJEnterPsdView : UIView

@property (nonatomic, assign) id<WJEnterPsdViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame;

/**
 *  根据输入密码位数改变视图，目前是六位上限；
 *
 *  @param count <#count description#>
 */
- (void)changePsdImageCount:(NSInteger)count;


@end
