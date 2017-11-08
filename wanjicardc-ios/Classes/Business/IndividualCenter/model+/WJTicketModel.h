//
//  WJTicketModel.h
//  WanJiCard
//
//  Created by maying on 2017/8/12.
//  Copyright © 2017年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJTicketModel : NSObject

@property(nonatomic,strong)NSString *ticketId;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)NSInteger amount;
@property(nonatomic,assign)BOOL  available;

@property(nonatomic,strong)NSString *desc;
@property(nonatomic,strong)NSString *validtime;
@property(nonatomic,strong)NSString *couponCode;
@property(nonatomic,strong)NSString *ticketExpiredType; ///**优惠券过期状态-'expiredType'，0 未过期 1：将要过期 2：已过期*/

@property(nonatomic,strong)NSString *ticketCurrentStatus; ///**优惠券使用状态- 1：未使用 2 已使用 3 已占用**/

@property(nonatomic,assign)ticketSelectStatus  modelTicketStatus;
@property(nonatomic,assign)BOOL  modelTicketSelected;


- (id)initWithDic:(NSDictionary *)dic;



@end
