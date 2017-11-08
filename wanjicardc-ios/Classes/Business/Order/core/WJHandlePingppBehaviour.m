//
//  WJHandlePingppBehaviour.m
//  WanJiCard
//
//  Created by Angie on 15/11/6.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJHandlePingppBehaviour.h"
#import "WJPayCompleteController.h"

@implementation WJHandlePingppBehaviour

- (void) handleResult:(NSString *)result
                error:(PingppError *)error
currentViewController:(UIViewController *)targetViewController {
   
    // result : success, fail, cancel, invalid
    NSString *msg;
    if (error == nil) {
        NSLog(@"PingppError is nil");
        msg = result;
    } else {
        NSLog(@"PingppError: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
        msg = [NSString stringWithFormat:@"result=%@ PingppError: code=%lu msg=%@", result, (unsigned long)error.code, [error getMsg]];
    }
    
    if ([result isEqualToString:@"success"]) {
        ALERT(@"支付成功");

    } else if ([result isEqualToString:@"cancel"]) {
        ALERT(@"已取消付款操作，交易失败！");
        [targetViewController.navigationController popViewControllerAnimated:YES];
        
    } else if ([result isEqualToString:@"fail"]) {
        // handle fail
        ALERT(@"交易失败");

    }
}

@end
