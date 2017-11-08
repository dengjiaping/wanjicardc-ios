//
//  WJPaySettingSwtichCell.h
//  WanJiCard
//
//  Created by XT Xiong on 15/11/10.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJPaySettingSwtichCell;
@protocol WJPaySettingSwtichCellDelegate <NSObject>

@optional
- (void)switchCell:(WJPaySettingSwtichCell *)cell cellIndex:(NSIndexPath *)index;

@end


@interface WJPaySettingSwtichCell : UITableViewCell

@property(nonatomic,strong)UISwitch *switchView;
@property(nonatomic,strong)UILabel *textL;
@property(nonatomic,strong)UIButton *switchButton;
@property(nonatomic,strong)NSIndexPath *myIndex;

@property (nonatomic,weak)id<WJPaySettingSwtichCellDelegate>delegate;

@end
