//
//  WJClearHistoryTableCell.h
//  WanJiCard
//
//  Created by 孙明月 on 16/5/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJClearHistoryTableCell;

@protocol WJClearHistoryTableCellDelegate <NSObject>

- (void)clearHistoryWithCell:(WJClearHistoryTableCell *)cell;

@end

@interface WJClearHistoryTableCell : UITableViewCell

@property (nonatomic,assign)id<WJClearHistoryTableCellDelegate> delegate;

@end
