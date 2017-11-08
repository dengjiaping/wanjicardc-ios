//
//  WJRechargeAgreementCell.h
//  WanJiCard
//
//  Created by 孙明月 on 16/9/6.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJRechargeAgreementCell;
@protocol WJRechargeAgreementCellDelegate <NSObject>

- (void)chooseAgreement:(WJRechargeAgreementCell *)cell;
@end

@interface WJRechargeAgreementCell : UITableViewCell
@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, weak) id<WJRechargeAgreementCellDelegate>delegate;
@end
