//
//  WJWebTableViewCell.h
//  WanJiCard
//
//  Created by 林有亮 on 16/8/22.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NeedReloadListDelegate <NSObject>

- (void)reloadByHeight:(CGFloat)height;

@end

@interface WJWebTableViewCell : UITableViewCell

@property (nonatomic, assign) id<NeedReloadListDelegate> delegate;

- (void)configWithURL:(NSString *)url;

- (CGFloat)currenCellHeight;

@end
