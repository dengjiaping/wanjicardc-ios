//
//  WJHomeCardDetailsViewController.h
//  WanJiCard
//
//  Created by silinman on 16/5/31.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJViewController.h"

@interface WJHomeCardDetailsViewController : WJViewController

@property (nonatomic, assign)NSInteger      cardIndex;
@property (nonatomic, strong)NSString       *cardID;
@property (nonatomic, strong)NSString       *titleStr;
@property (nonatomic, strong)NSString       *merchantID;

@end
