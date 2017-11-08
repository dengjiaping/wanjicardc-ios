//
//  WJCardShowTableViewCell.h
//  WanJiCard
//
//  Created by silinman on 16/6/15.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJMerchantCardDetailModel.h"

@interface WJCardShowTableViewCell : UITableViewCell

- (void)configData:(WJMerchantCardDetailModel *)model cardIndex:(NSInteger )cardIndex cardID:(NSString *)cardID;


@end
