//
//  WJFairECardListTableViewCell.h
//  WanJiCard
//
//  Created by silinman on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJECardModel;

typedef void (^SelectECardBlock)(WJECardModel *model);

@interface WJFairECardListTableViewCell : UITableViewCell{
    
}
@property (nonatomic, strong) SelectECardBlock selectECardBlock;
@property (nonatomic, assign)BOOL isCardShop;


- (void)configData:(NSMutableArray *)datasArray;

@end
