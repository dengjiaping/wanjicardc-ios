//
//  WJCardDetailsFlowLayout.h
//  WanJiCard
//
//  Created by silinman on 16/6/14.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomViewFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cellCenteredAtIndexPath:(NSIndexPath *)indexPath page:(int)page;

@end

@interface WJCardDetailsFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<CustomViewFlowLayoutDelegate> delegate;

- (void)configPreviseOffX:(CGFloat)offx;

@end
