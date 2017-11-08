//
//  WJSupportBankCardViewController.h
//  WanJiCard
//
//  Created by reborn on 16/7/14.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJViewController.h"

typedef void (^SelectSupportBankBlock)(NSString *bankName);

@interface WJSupportBankCardViewController : WJViewController

@property (nonatomic,strong)SelectSupportBankBlock selectSupportBankBlock;

@end
