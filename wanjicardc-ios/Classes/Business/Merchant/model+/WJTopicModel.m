//
//  WJTopicModel.m
//  WanJiCard
//
//  Created by Lynn on 15/9/12.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJTopicModel.h"

@implementation WJTopicModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _name = dic[@"activityName"];
        _imgUrl = dic[@"img"];
        _link   = dic[@"url"];
        _topicType = (TopicType)[dic[@"activityType"] intValue];
        _height  = [dic[@"Height"] floatValue];
        _width  = [dic[@"Width"] floatValue];
    }
    return self;
}

@end
