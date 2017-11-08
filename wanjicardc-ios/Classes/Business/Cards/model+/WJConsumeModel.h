//
//  WJConsumeModel.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJConsumeModel : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *merId;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) NSTimeInterval createTime;

- (id)initWithDic:(NSDictionary *)dic;


@end
