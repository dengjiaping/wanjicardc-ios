//
//  WJSearchTypeView.h
//  WanJiCard
//
//  Created by Lynn on 15/9/11.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJSearchCellView;
@protocol SearchCellDelegate <NSObject>
- (void)searchCell:(WJSearchCellView *)searchCell didSelectWithIndex:(int)index;

@end


@interface WJSearchCellView : UIView

@property (nonatomic, assign) id<SearchCellDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dic tag:(int)tag;

@end
