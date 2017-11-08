//
//  WJOrderTypeView.h
//  WanJiCard
//
//  Created by reborn on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJOrderTypeView;
@protocol WJOrderTypeViewDelegate <NSObject>

- (void)orderTypeViewUpdateOrder:(NSInteger)index section:(NSInteger)section;
- (void)hideBackOrderTypeView:(WJOrderTypeView *)orderTypeView;

@end

@interface WJOrderTypeView : UIView
@property (nonatomic, strong) UICollectionView *orderCollectionView;
@property (nonatomic, assign) id<WJOrderTypeViewDelegate> delegate;


@end
