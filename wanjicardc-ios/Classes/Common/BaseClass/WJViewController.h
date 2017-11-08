//
//  WJViewController.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "APIBaseManager.h"
#import "WJLoadingView.h"
#import "WJStatisticsManager.h"

#define isCorrectedBundleId do{\
    NSString *bundle = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];\
    if (![bundle isEqualToString:KBundleID]) {\
        NSArray *array = [NSArray array];\
        [array objectAtIndex:5];\
    }\
}while(0);


@interface WJViewController : UIViewController<APIManagerCallBackDelegate>{
    BOOL canEgeSpan;
}

@property (strong, nonatomic) NSString *eventID;//事件Id
@property (nonatomic, strong) WJLoadingView *loadingView;
@property (nonatomic, assign) BOOL isNeedToken;


@property (nonatomic, strong, readonly) WJNavigationController *navigationController;
/**
 *  隐藏导航栏左侧返回按钮；
 */
- (void)hiddenBackBarButtonItem;


/**
 *  移除侧滑返回手势
 */
- (void)removeScreenEdgePanGesture;

/**
 *  显示LoadingView
 */
- (void)showLoadingView;


/**
 *  隐藏LoadingView
 */
- (void)hiddenLoadingView;

- (void)backBarButton:(UIButton *)btn;

@end
