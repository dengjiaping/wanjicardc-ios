//
//  WJCardChangeModel.h
//  WanJiCard
//
//  Created by XT Xiong on 16/7/13.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJCouponModel.h"
#import "WJChoiceCardModel.h"

@interface WJCardChangeModel : NSObject

@property (nonatomic, strong) NSArray    *couponArray;          //卡特权集合  WJCouponModel
@property (nonatomic, strong) NSArray    *choiceCardArray;      //卡集合     WJChoiceCardModel
@property (nonatomic, assign) CGFloat     discount;             //折扣
@property (nonatomic, assign) BOOL        ecoEnable;            //是否易联

- (id)initWithDic:(NSDictionary *)dic;

@end
