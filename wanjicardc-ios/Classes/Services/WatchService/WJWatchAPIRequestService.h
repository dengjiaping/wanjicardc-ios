//
//  WJWatchAPIRequestService.h
//  WanJiCard
//
//  Created by Angie on 15/12/24.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ ReplyHandelBlock) (NSDictionary<NSString *, id> *replyMessage);

@interface WJWatchAPIRequestService : NSObject

@property (nonatomic, copy) ReplyHandelBlock replyHandle;

- (void)getDataWithCategory:(NSString *)category longtitude:(double)longti latitude: (double)lati cityId:(NSString *) cityid;

- (void)getDataWithMerchantId:(NSString *)merchantId;

- (void)getDataWithComplication:(NSString *)token;

@end
