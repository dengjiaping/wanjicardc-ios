//
//  WJECardCollectionViewCell.h
//  WanJiCard
//
//  Created by silinman on 16/8/17.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJECardModel;
@interface WJECardCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign)BOOL isCardShop;
- (void)configData:(WJECardModel *)cardModel;

@end
