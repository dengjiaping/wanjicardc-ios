//
//  WJCityView.h
//  WanJiCard
//
//  Created by 孙明月 on 16/5/20.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJCityView;
@protocol WJCityViewDelegate <NSObject>

- (void)updateCity:(WJCityView *)cityView;
- (void)takeBackView:(WJCityView *)cityView;

@end


@interface WJCityView : UIView

@property (nonatomic, strong) UITableView *cityTableView;
@property (nonatomic, strong) NSString  *currentCity;
@property (nonatomic, assign) id<WJCityViewDelegate> delegate;
@property (nonatomic, strong) NSString *eventID;//事件Id

@end
