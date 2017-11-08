//
//  WJOrderDetailController.h
//  WanJiCard
//
//  Created by Angie on 15/9/26.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJViewController.h"
typedef NS_ENUM(NSUInteger, TableViewSectionType) {
    SeTypeCardDetail = 0,
    SeTypeMerchantInformation = 1,
    SeTypeOrderDetail = 2,
};

@class WJOrderModel;
@interface WJOrderDetailController : WJViewController

@property (nonatomic, strong) WJOrderModel *orderSummary;
@end
