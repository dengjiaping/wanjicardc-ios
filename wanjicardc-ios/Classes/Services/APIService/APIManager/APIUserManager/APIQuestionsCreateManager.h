//
//  APIQuestionsCreateManager.h
//  WanJiCard
//
//  Created by Lynn on 15/12/7.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIQuestionsCreateManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSArray   *questionsArray;
@property (nonatomic, strong) NSArray   *answersArray;


@property (nonatomic, strong) NSString *question1;
@property (nonatomic, strong) NSString *question2;
@property (nonatomic, strong) NSString *question3;

@property (nonatomic, strong) NSString *answer1;
@property (nonatomic, strong) NSString *answer2;
@property (nonatomic, strong) NSString *answer3;







@end
