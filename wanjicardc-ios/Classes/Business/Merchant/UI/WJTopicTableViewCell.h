//
//  WJTopicTableViewCell.h
//  WanJiCard
//
//  Created by Lynn on 15/9/12.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJTopicTableViewCell;
@protocol TopicDelegate <NSObject>

-(void)topicCell:(WJTopicTableViewCell *)cell didSelectedWithIndex:(int)index;

@end

@interface WJTopicTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TopicDelegate>   delegate;

- (void)setImageWithArray:(NSArray *)topicsArray;

@end
