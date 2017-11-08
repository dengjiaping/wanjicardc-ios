//
//  WJNavigationController.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJNavigationController : UINavigationController

@property (nonatomic, strong) NSMutableArray *viewControllerStach;


- (void)replaceCurrentControllerWithController:(UIViewController *)vc;


/**
 *  <#Description#>
 *
 *  @param viewController 要推出的controller
 *  @param animated       动画效果
 *  @param jumped         当前controller是否跳过不再返回
 */
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
               whetherJump:(BOOL)jumped;

@end
