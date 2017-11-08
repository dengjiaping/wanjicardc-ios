//
//  WJTopicModel.h
//  WanJiCard
//
//  Created by Lynn on 15/9/12.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJEnumType.h"

@interface WJTopicModel : NSObject

@property (nonatomic, strong) NSString          *name;
@property (nonatomic, strong) NSString          *imgUrl;
@property (nonatomic, strong) NSString          *link;
@property (nonatomic, assign) TopicType         topicType;
@property (nonatomic, assign) CGFloat           height;
@property (nonatomic, assign) CGFloat           width;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
