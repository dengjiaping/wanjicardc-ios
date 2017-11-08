//
//  WJCardsViewController.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJViewController.h"

@interface WJCardsViewController : WJViewController

@property (nonatomic, strong)NSArray    *cardsIDArray;
@property (nonatomic, strong)NSMutableArray             *dataArray;

- (void)checkView;

//- (void)enterForeground;

@end
