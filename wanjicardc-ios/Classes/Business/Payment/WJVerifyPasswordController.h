//
//  WJVerifyPasswordController.h
//  WanJiCard
//
//  Created by 孙明月 on 16/6/2.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJViewController.h"

@class APIVerifyPayPwdManager;
@class WJPersonModel;

@interface WJVerifyPasswordController : WJViewController
{
    NSMutableArray *psdArray;
    UITextField *tf;
}

@property (nonatomic, assign) ComeFrom from;
@property (nonatomic, assign) BOOL canInputPassword;
@property (nonatomic, strong) NSString *orginPhone;
@property (nonatomic, strong) WJPersonModel *currentPerson;

- (void)cleanPsdView;

@end
