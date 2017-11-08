//
//  WJMyOrderControllerDelegate.h
//  WanJiCard
//
//  Created by Angie on 15/10/20.
//  Copyright © 2015年 zOne. All rights reserved.
//

#ifndef WJMyOrderControllerDelegate_h
#define WJMyOrderControllerDelegate_h

@class WJOrderModel;
@protocol WJMyOrderControllerDelegate <NSObject>

- (void)buyAgainWithOrder:(WJOrderModel *)ord baoziNum:(CGFloat)num orderNo:(NSString *)ordNo;

@optional
- (void)requestLoadOrderPayWith:(WJOrderModel *)ord;

@end

#endif /* WJMyOrderControllerDelegate_h */
