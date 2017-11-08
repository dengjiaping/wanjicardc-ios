//
//  WJOrderEcardTableViewCell.h
//  WanJiCard
//
//  Created by 林有亮 on 16/11/14.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJECardModel;
@interface WJOrderEcardTableViewCell : UITableViewCell

- (void)refreshWithModel:(WJECardModel *)model;

@end
