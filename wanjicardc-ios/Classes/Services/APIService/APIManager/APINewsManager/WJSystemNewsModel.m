//
//  WJSystemNewsModel.m
//  WanJiCard
//
//  Created by XT Xiong on 16/7/6.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJSystemNewsModel.h"

@implementation WJSystemNewsModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.activityUrl         = kTrueString(dic[@"activityUrl"]);
        self.content             = kTrueString(dic[@"content"]);
        self.pcUrl               = kTrueString(dic[@"pcUrl"]);
        self.theme               = kTrueString(dic[@"theme"]);
        self.type                = kTrueString(dic[@"type"]);
        self.word                = kTrueString(dic[@"word"]);
        self.date                = kTrueString(dic[@"date"]);
        self.time                = kTrueString(dic[@"time"]);
    }
    return self;
}

@end
