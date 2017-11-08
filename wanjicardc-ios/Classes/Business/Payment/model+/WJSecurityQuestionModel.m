//
//  WJSecurityQuestionModel.m
//  WanJiCard
//
//  Created by 孙明月 on 15/12/18.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJSecurityQuestionModel.h"

@implementation WJSecurityQuestionModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {

        self.questionId = ToString(dic[@"id"]);
        self.question = ToString(dic[@"questionName"]);
    }
    
    return self;
}

@end
