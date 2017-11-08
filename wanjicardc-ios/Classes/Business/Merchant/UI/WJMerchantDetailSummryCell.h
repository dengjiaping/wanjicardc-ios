//
//  WJMerchantDetailNameCell.h
//  WanJiCard
//
//  Created by Angie on 15/9/25.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJMerchantDetailModel;
@protocol WJMerchantDetaiCellDelegate <NSObject>
- (void)clickTelButton:(NSString *)telPhone;
@end

@interface WJMerchantDetailSummryCell : UITableViewCell
@property (nonatomic, weak) id<WJMerchantDetaiCellDelegate>delegate;

- (void)configCellWithMerchantModel:(WJMerchantDetailModel *)model;

@end
