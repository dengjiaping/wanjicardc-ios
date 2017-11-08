//
//  WJTabBarViewController.h
//  WanJiCard
//
//  Created by 孙明月 on 16/5/9.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJTabBarViewController : UITabBarController

- (void)changeTabIndex:(NSInteger)index;

- (void)enterFromTouchWithIndex:(NSInteger)index;

- (void)receiveNotification;

@end
