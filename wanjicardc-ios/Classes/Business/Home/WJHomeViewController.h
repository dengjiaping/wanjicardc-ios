//
//  WJHomeViewController.h
//  WanJiCard
//
//  Created by 孙明月 on 16/5/11.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJViewController.h"
@class WJAdScrollingView;
@interface WJHomeViewController : WJViewController

@property (nonatomic, strong) UIImageView            *tabBarView;
@property (nonatomic, strong) NSMutableArray         *dataArray;
@property (nonatomic, strong) WJAdScrollingView      *scrollingView;

@end
