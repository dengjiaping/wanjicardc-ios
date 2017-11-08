//
//  WJConsumeModel.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJConsumeModel.h"

@implementation WJConsumeModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.userId = ToString(dic[@"Userid"]);
        self.name = ToString(dic[@"Name"]);
        self.merId = ToString(dic[@"Merid"]);
        self.address = ToString(dic[@"Address"]);
        self.amount = [dic[@"Amount"] floatValue];
        self.createTime = [dic[@"Createtime"] doubleValue];
        self.orderNumber = ToString(dic[@"Orderno"]);
        self.date = ToString(dic[@"Date"]);
    }
    
    return self;
}

@end
