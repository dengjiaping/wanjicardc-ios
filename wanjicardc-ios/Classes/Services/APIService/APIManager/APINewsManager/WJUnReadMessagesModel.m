//
//  WJUnReadMessagesModel.m
//  WanJiCard
//
//  Created by XT Xiong on 16/7/5.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJUnReadMessagesModel.h"

@implementation WJUnReadMessagesModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.ifRead              = kTrueString(dic[@"ifRead"]);
    }
    return self;
}

@end
