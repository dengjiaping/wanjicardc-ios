//
//  WJOrderCardModel.h
//  WanJiCard
//
//  Created by XT Xiong on 16/7/14.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJOrderCardModel : NSObject

@property (nonatomic, strong) NSArray    *couponArray;          //卡特权集合  WJCouponModel
@property (nonatomic, assign) NSUInteger canBuyNum;            //数量
@property (nonatomic, strong) NSString   *code;                 //是否能参加活动，除了000都不参加
@property (nonatomic, assign) CGFloat    discount;             //折扣
@property (nonatomic, assign) BOOL       ecoEnable;            //是否易联

- (instancetype) initWithDic:(NSDictionary *)dic;

@end
