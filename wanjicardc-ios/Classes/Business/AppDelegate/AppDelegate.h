//
//  AppDelegate.h
//  WanJiCard
//
//  Created by zOne on 15/8/26.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (strong, nonatomic) WJTabBarViewController  * myTab;

- (void)changeRootViewController;

@end

