//
//  WJCardsDetailViewController.h
//  WanJiCard
//
//  Created by 孙琦 on 16/5/19.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJViewController.h"

@class WJModelCard;
@interface WJCardsDetailViewController : WJViewController
@property (nonatomic, strong) UIImageView *tabBarView;

@property (nonatomic, strong) WJModelCard  *card;

@end
