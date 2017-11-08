//
//  WJSearchConditionModel.h
//  WanJiCard
//
//  Created by Lynn on 15/9/18.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJSearchConditionModel : NSObject

@property (nonatomic, strong) NSString  * keyStr;
@property (nonatomic, strong) NSString  * name;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
