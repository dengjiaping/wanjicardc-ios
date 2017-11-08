//
//  WJPsdVerifyAlert.h
//  WanJiCard
//
//  Created by 孙明月 on 16/8/16.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIVerifyPayPwdManager.h"

#define kPsdAlertViewTag 100004

@class WJPsdVerifyAlert;
@protocol WJPsdVerifyAlertDelegate <NSObject>

@optional
- (void)successWithVerifyPsdAlert:(WJPsdVerifyAlert *)alertView;
- (void)failedWithVerifyPsdAlert:(WJPsdVerifyAlert *)alertView errerMessage:(NSString * )errerMessage isLocked:(BOOL)isLocked;

- (void)findPasswordWithAlert:(WJPsdVerifyAlert *)alert;
@end


@interface WJPsdVerifyAlert : UIView<UITextFieldDelegate, APIManagerCallBackDelegate>
{
    UIView * enterBg;
    NSMutableArray *enterPsdViews;
    NSInteger selectedIvTag;
    NSString *enterPassword;
    NSMutableDictionary *dataDic;
    NSMutableArray *psdArray;
    UITextField *tf;
}

@property (nonatomic, assign) BOOL canInputPassword;
@property(nonatomic,assign) NSInteger alertTag;
@property (nonatomic, weak)id<WJPsdVerifyAlertDelegate>delegate;
@property (nonatomic ,strong) APIVerifyPayPwdManager *verPayPsdManager;


- (void)showIn;
- (void)dismiss;

@end
