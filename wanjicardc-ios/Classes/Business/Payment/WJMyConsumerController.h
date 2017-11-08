//
//  WJMyConsumerController.h
//  WanJiCard
//
//  Created by reborn on 16/5/18.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "WJViewController.h"

typedef NS_ENUM(NSUInteger, FromType) {
    FromCardDetail
};


@interface WJMyConsumerController : WJViewController

@property(nonatomic, strong)NSString *merchantId;
@property(nonatomic, strong)NSString *merName;
@property(nonatomic, assign)FromType fromType;

@end
