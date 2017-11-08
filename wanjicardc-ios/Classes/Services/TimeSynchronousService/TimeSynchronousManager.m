//
//  TimeSynchronousManager.m
//  WanJiCard
//
//  Created by Angie on 15/11/13.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "TimeSynchronousManager.h"
#import "APITimeTampManager.h"

#define RefreshCycle        (3600*8)

@interface TimeSynchronousManager ()<APIManagerCallBackDelegate>
{
    NSDate *refreshTime;
}

@end

@implementation TimeSynchronousManager

- (void)synchronousTimeWithServer{
    APITimeTampManager *timerManager = [APITimeTampManager new];
    timerManager.delegate = self;
    [timerManager loadData];
}

#pragma mark - APIManagerCallBackDelegate

- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager{
    
    NSDictionary *dic = [manager fetchDataWithReformer:nil];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSTimeInterval serverTime = [[dic objectForKey:@"time"] doubleValue];
        int subTime = (int)(serverTime - [[NSDate date] timeIntervalSince1970]);
        [[NSUserDefaults standardUserDefaults] setObject:@(subTime) forKey:kServerTimeSubLocal];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager{
    NSLog(@"%@", manager.errorMessage);
}


@end
