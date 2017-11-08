//
//  WJCardDetailsFlowLayout.m
//  WanJiCard
//
//  Created by silinman on 16/6/14.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCardDetailsFlowLayout.h"

@interface WJCardDetailsFlowLayout ()

@property (nonatomic, assign) CGFloat previousOffsetX;

@end

@implementation WJCardDetailsFlowLayout

#pragma mark - Override
- (id)init{
    if (self = [super init]) {
        self.previousOffsetX = -1;
    }
    return self;
}

- (void)prepareLayout {
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = ALD(20);
    self.sectionInset = UIEdgeInsetsMake(0, ALD(40), 0, ALD(40));
    self.itemSize = CGSizeMake(ALD(295),ALD(165));
    [super prepareLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
//    
//    CGRect visibleRect;
//    
//    visibleRect.origin = self.collectionView.contentOffset;
//    
//    visibleRect.size = self.collectionView.bounds.size;
//    
//    for (UICollectionViewLayoutAttributes *attribute in attributes) {
//        
//        if (CGRectIntersectsRect(attribute.frame, rect)) {
//            
//            int page = 0;
//            if (visibleRect.origin.x <= 0) {
//                page = 0;
//            }else if(visibleRect.origin.x + visibleRect.size.width >= self.collectionView.contentSize.width){
//                page = (int)[self.collectionView numberOfItemsInSection:0] - 1;
//            }else{
//                div_t x = div(visibleRect.origin.x,visibleRect.size.width);
//                page = x.rem > visibleRect.size.width/2 ? x.quot+1 : x.quot;
//            }
//            [self.delegate collectionView:self.collectionView layout:self cellCenteredAtIndexPath:attribute.indexPath page:page];
//
//            
//        }
//        
//    }
    return attributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 分页以1/3处
    if (proposedContentOffset.x > self.previousOffsetX + self.itemSize.width / 3.0) {
        self.previousOffsetX += self.collectionView.frame.size.width - self.minimumLineSpacing * 3;
    } else if (proposedContentOffset.x < self.previousOffsetX  - self.itemSize.width / 3.0) {
        self.previousOffsetX -= self.collectionView.frame.size.width - self.minimumLineSpacing * 3;
    }
    
    proposedContentOffset.x = MIN(self.previousOffsetX, self.collectionView.contentSize.width-self.collectionView.width);
    
    return proposedContentOffset;
}

- (void)configPreviseOffX:(CGFloat)offx{
    if (self.previousOffsetX < 0) {
        self.previousOffsetX = offx;
    }
}

@end
