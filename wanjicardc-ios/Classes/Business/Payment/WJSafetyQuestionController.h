//
//  WJSafetyQuestionController.h
//  WanJiCard
//
//  Created by XT Xiong on 15/12/1.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJViewController.h"

@interface WJSafetyQuestionController : WJViewController

typedef NS_ENUM(NSInteger, SafetyQuestionType)
{
    SafetyQuestionTypeNew,
    SafetyQuestionTypeVerify
};

@property (strong, nonatomic) NSArray * oldArray;

- (instancetype)initWithPsdType:(SafetyQuestionType)sqType;

@end
