//
//  WJHotBrandCollectionViewCell.h
//  WanJiCard
//
//  Created by silinman on 16/5/28.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJMoreBrandesModel;
@interface WJHotBrandCollectionViewCell : UICollectionViewCell

@property(nonatomic ,strong) UIImageView         *brandIV;
@property(nonatomic ,strong) UILabel             *titleL;

- (void)configData:(WJMoreBrandesModel *)model;

@end
