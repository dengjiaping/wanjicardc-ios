//
//  WJSearchTapCell.h
//  WanJiCard
//
//  Created by Lynn on 15/9/17.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WJSearchTapCell;

@protocol SearchCellDelegate <NSObject>

- (void)searchTap:(WJSearchTapCell *)cell  didSelectWithindex:(int)index;

@end

@interface WJSearchTapCell : UIView

@property(nonatomic, weak) id<SearchCellDelegate> delegate;
@property (nonatomic, strong)UILabel        * titleLabel;
@property (nonatomic, strong)UIImageView    * moreImageView;

- (void)setTapText:(NSString *)text;

@end
