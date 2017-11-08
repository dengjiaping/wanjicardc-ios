//
//  WJVerificationCodeViewController.h
//  WanJiCard
//
//  Created by reborn on 16/6/24.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJViewController.h"
#import "WJRealNameAuthenticationViewController.h"

@interface WJVerificationCodeViewController : WJViewController
@property(nonatomic,strong) NSString *realName;
@property(nonatomic,strong) NSString *cardNumber;
@property(nonatomic,strong) NSString *BankCard;
@property(nonatomic,strong) NSString *registerPhone;

@property(nonatomic, copy)dispatch_block_t authenticationSuc;
@property(nonatomic, assign)BOOL isjumpOrderConfirmController;
@property(nonatomic, assign)RealNameComeFrom comefrom;

@end
