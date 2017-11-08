//
//  WJBillTypeView.h
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJBillTypeView;
@protocol WJBillTypeViewDelegate <NSObject>

- (void)billTypeViewUpdateBill:(NSInteger)index section:(NSInteger)section;
- (void)hideBackBillTypeView:(WJBillTypeView *)billTypeView;

@end

@interface WJBillTypeView : UIView
@property (nonatomic, strong) UICollectionView *billCollectionView;
@property (nonatomic, assign) id<WJBillTypeViewDelegate> delegate;
@end
