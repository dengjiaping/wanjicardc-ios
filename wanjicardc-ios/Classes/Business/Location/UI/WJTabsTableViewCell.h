//
//  WJTabsTableViewCell.h
//  WanJiCard
//
//  Created by Lynn on 15/9/21.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJTabsTableViewCell;
@protocol WJTabSelectedDelegate <NSObject>

- (void)tabsTableView:(WJTabsTableViewCell *) cell didSelectedByIndex:(int)index;

@end


@interface WJTabsTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray * tabsArray;
@property (nonatomic, assign) id<WJTabSelectedDelegate> delegate;
@property (nonatomic, assign, readonly) CGFloat    cellHeight;

+ (CGFloat)heightWightArray:(NSArray *)array;

@end
