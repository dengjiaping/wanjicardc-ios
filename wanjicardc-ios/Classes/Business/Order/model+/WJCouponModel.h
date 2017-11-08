//
//  WJCouponModel.h
//  WanJiCard
//
//  Created by XT Xiong on 16/7/13.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJCouponModel : NSObject

@property (nonatomic, assign) BOOL           available;
@property (nonatomic, strong) NSString     * couponCode;
@property (nonatomic, strong) NSString     * couponEndDate;
@property (nonatomic, strong) NSString     * couponIntroduce;
@property (nonatomic, strong) NSString     * couponName;
@property (nonatomic, assign) CGFloat        couponVal;
@property (nonatomic, assign) BOOL           date_available;
@property (nonatomic, strong) NSString     * userCouponId;


- (id)initWithDic:(NSDictionary *)dic;

@end
