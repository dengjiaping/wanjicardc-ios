//
//  WJShopAndCardsCollectionViewCell.h
//  WanJiCard
//
//  Created by silinman on 16/5/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJHomePageBottomModel;
@class WJHomePageCardsModel;
@interface WJShopAndCardsCollectionViewCell : UICollectionViewCell{
    
}

@property (nonatomic, strong) UIView              *backView;
@property (nonatomic, strong) UIImageView         *brandBackView;
@property (nonatomic, strong) UIImageView         *brandIV;
@property (nonatomic, strong) UILabel             *faceValueL;
@property (nonatomic, strong) UILabel             *lineL;
@property (nonatomic, strong) UILabel             *cardNameL;
@property (nonatomic, strong) UILabel             *valueL;
@property (nonatomic, strong) UILabel             *privilegeL;
@property (nonatomic, strong) UIImageView         *activityIV;

- (void)configData:(WJHomePageBottomModel *)bottomModel cardData:(WJHomePageCardsModel *)cardModel;

@end
