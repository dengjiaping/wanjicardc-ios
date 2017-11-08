//
//  APIQuestionsCreateManager.m
//  WanJiCard
//
//  Created by Lynn on 15/12/7.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "APIQuestionsCreateManager.h"

@implementation APIQuestionsCreateManager

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.paramSource = self;
        self.validator = self;
    }
    return self;
}

#pragma mark - APIManagerVaildator
/*
 所有的callback数据都应该在这个函数里面进行检查，事实上，到了回调delegate的函数里面是不需要再额外验证返回数据是否为空的。
 因为判断逻辑都在这里做掉了。
 而且本来判断返回数据是否正确的逻辑就应该交给manager去做，不要放到回调到controller的delegate方法里面去做。
 */
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return [data[@"rspCode"] integerValue] == 0;
}

/*
 当调用API的参数是来自用户输入的时候，验证是很必要的。
 当调用API的参数不是来自用户输入的时候，这个方法可以写成直接返回true。反正哪天要真是参数错误，QA那一关肯定过不掉。
 不过我还是建议认真写完这个参数验证，这样能够省去将来代码维护者很多的时间。
 */

- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return [self.questionsArray count] == [self.answersArray count] && ([self.questionsArray count] > 0);
//    return YES;

}

#pragma mark - APIManagerParamSourceDelegate
//让manager能够获取调用API所需要的数据
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager
{
//    NSMutableString * questionsString = [self.questionsArray firstObject];
//    for (int i = 1 ; i < [self.questionsArray count]; i++) {
////        [questionsString appendFormat:@","];
////        [questionsString appendFormat:(NSString *)[self.questionsArray objectAtIndex:i]];
//        
//        NSString * question ;
//        if ([[self.questionsArray objectAtIndex:i] isKindOfClass:[NSString class]]) {
//            question = (NSString *)[self.questionsArray objectAtIndex:i];
//        }
//        
//        questionsString = (NSMutableString *)[questionsString stringByAppendingString:[NSString stringWithFormat:@",%@",question]];
//    }
//    
//    
//    NSMutableString * answersString = [self.answersArray firstObject];
//    for (int i = 1 ; i < [self.answersArray count]; i++) {
////        [ansersString appendFormat:@","];
////        [ansersString appendFormat:(NSString *)[self.answersArray objectAtIndex:i]];
//        
//        NSString * answer;
//        if ([[self.answersArray objectAtIndex:i] isKindOfClass:[NSString class]]) {
//            answer = (NSString *)[self.answersArray objectAtIndex:i];
//        }
//        
//        answersString = (NSMutableString *)[answersString stringByAppendingString:[NSString stringWithFormat:@",%@",answer]];   
//    }
//    
//    return @{@"qids":questionsString,@"answers":answersString};
    

    self.question1 = [self.questionsArray firstObject];
    self.question2 = [self.questionsArray objectAtIndex:1];
    self.question3 = [self.questionsArray lastObject];
    
    self.answer1 = [self.answersArray firstObject];
    self.answer2 = [self.answersArray objectAtIndex:1];
    self.answer3 = [self.answersArray lastObject];
    
    
    return @{@"question1":self.question1,@"question2":self.question2,@"question3":self.question3,@"answer1":self.answer1,@"answer2":self.answer2,@"answer3":self.answer3};

}

#pragma mark - APIManager Methods
- (NSString *)methodName
{
//    return @"/security/new";
    return @"/userSecurityQuestions/saveOrUpdates";
    
}

- (NSString *)serviceType
{
    return kAPIServiceWanJiKa;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypePost;
}

@end
