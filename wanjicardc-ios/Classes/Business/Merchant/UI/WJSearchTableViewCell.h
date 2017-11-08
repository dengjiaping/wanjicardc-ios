//
//  WJSearchTableViewCell.h
//  WanJiCard
//
//  Created by Lynn on 15/9/21.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJSearchTableViewCell;

@protocol WJSearchTableViewCellDelegate <NSObject>

- (void)tabsTableView:(WJSearchTableViewCell *) cell didSelectedByIndex:(int)index;
@end


@interface WJSearchTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray * tabsArray;
@property (nonatomic, assign) id<WJSearchTableViewCellDelegate> delegate;
@property (nonatomic, assign, readonly) CGFloat cellHeight;

+ (CGFloat)heightWightArray:(NSArray *)array;

@end
