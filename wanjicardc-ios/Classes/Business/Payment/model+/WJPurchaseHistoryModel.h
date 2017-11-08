//
//  WJPurchaseHistoryModel.h
//  WanJiCard
//
//  Created by Angie on 15/9/25.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJConsumeModel.h"

@interface WJPurchaseHistoryModel : NSObject

@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *historyId;
@property (nonatomic, strong) NSString *merId;
@property (nonatomic, strong) NSString *merName;
@property (nonatomic, strong) NSString *paymentNo;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) OrderStatus historyStatus;
@property (nonatomic, strong) NSString *userName;

//@property (nonatomic, strong) NSString *cover;
//@property (nonatomic, assign) NSInteger consumeCount;
//@property (nonatomic, strong) NSArray *consumeArray;        //WJConsumeModel

- (id)initWithDic:(NSDictionary *)dic;

@end
