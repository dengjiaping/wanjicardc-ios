//
//  WJEleCardHeaderView.h
//  WanJiCard
//
//  Created by 林有亮 on 16/8/18.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJECardModel;

@interface WJEleCardHeaderView : UIView

@property (nonatomic, strong) WJECardModel * eCardModel;

- (void)refreshWithECardModel:(WJECardModel *)eCardModel;

- (CGFloat) headerViewHeight;

@end
