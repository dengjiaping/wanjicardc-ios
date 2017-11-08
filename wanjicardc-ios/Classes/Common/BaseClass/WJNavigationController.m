//
//  WJNavigationController.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJNavigationController.h"

@interface WJNavigationController ()

@end

@implementation WJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewControllerStach = [NSMutableArray array];
    
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = WJColorNavigationBar;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:WJFont18,
                                               NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)replaceCurrentControllerWithController:(UIViewController *)vc{
    [self popViewControllerAnimated:NO];
    [self pushViewController:vc animated:YES];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated whetherJump:(BOOL)jumped{

    if (!jumped) {
        [self.viewControllerStach addObject:self.topViewController];
    }
    [super pushViewController:viewController animated:animated];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self pushViewController:viewController animated:animated whetherJump:NO];
}


- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (self.viewControllerStach.count == 0) {
        return [super popViewControllerAnimated:animated];
    }
    
    NSArray *array = [self popToViewController:[self.viewControllerStach lastObject] animated:animated];
    
    return [array lastObject];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSArray *arr = [super popToViewController:viewController animated:animated];
    
    if ([self.viewControllerStach containsObject:viewController]) {
        NSInteger index = [self.viewControllerStach indexOfObject:viewController];
        [self.viewControllerStach removeObjectsInRange:NSMakeRange(index, self.viewControllerStach.count-index)];
    }else{
        [self.viewControllerStach removeObjectsInArray:arr];
        [self.viewControllerStach removeLastObject];
    }
    
    return arr;
}


- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    [self.viewControllerStach removeAllObjects];
    return [super popToRootViewControllerAnimated:animated];
}

@end
