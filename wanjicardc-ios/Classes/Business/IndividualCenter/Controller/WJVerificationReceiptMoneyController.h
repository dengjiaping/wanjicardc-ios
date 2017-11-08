//
//  WJVerificationReceiptMoneyController.h
//  WanJiCard
//
//  Created by reborn on 16/9/20.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJViewController.h"
#import "WJRealNameAuthenticationViewController.h"

@interface WJVerificationReceiptMoneyController : WJViewController
@property(nonatomic,strong) NSString *BankCard;

@property(nonatomic, copy)dispatch_block_t authenticationSuc;
@property(nonatomic, assign)BOOL isjumpOrderConfirmController;
@property(nonatomic, assign)RealNameComeFrom comefrom;

@end
