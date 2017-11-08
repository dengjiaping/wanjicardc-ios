//
//  WJTicketModel.m
//  WanJiCard
//
//  Created by maying on 2017/8/12.
//  Copyright © 2017年 WJIKA. All rights reserved.
//

#import "WJTicketModel.h"

@implementation WJTicketModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        
        self.ticketId = ToString(dic[@"userCouponId"]);
    
        self.name =  ToString(dic[@"couponName"]);
        
        self.amount =  [dic[@"couponValue"] integerValue];

        self.couponCode =  ToString(dic[@"couponCode"]);
        
        self.validtime =  ToString(dic[@"couponEndDate"]);
        
        self.modelTicketStatus = None;
        
        if (![dic[@"expiredType"] isEqualToString:@"2"]) {
            
            if (![dic[@"currentStatus"] isEqualToString:@"1"]) {
                self.available = NO;
            } else {
                self.available = YES;
            }
        } else {
            self.available = NO;

        }
        
        self.desc =  ToString(dic[@"couponIntroduce"]);
        self.ticketExpiredType = ToString(dic[@"expiredType"]);
        self.ticketCurrentStatus  = ToString(dic[@"currentStatus"]);



        
        
    }
    return self;
}
@end
