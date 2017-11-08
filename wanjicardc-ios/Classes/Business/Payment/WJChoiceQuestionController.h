//
//  WJChoiceQuestionController.h
//  WanJiCard
//
//  Created by XT Xiong on 15/12/2.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJViewController.h"

typedef void(^ChoiceBlock)(NSMutableArray *);
@interface WJChoiceQuestionController : WJViewController

@property (copy,nonatomic)   ChoiceBlock      choiceBlock;

@property (strong,nonatomic) NSMutableArray * changeArray;
@property (assign,nonatomic) NSInteger        num;

@end
