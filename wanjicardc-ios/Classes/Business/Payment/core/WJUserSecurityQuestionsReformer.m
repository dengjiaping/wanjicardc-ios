//
//  WJUserSecurityQuestionsReformer.m
//  WanJiCard
//
//  Created by XT Xiong on 16/6/17.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJUserSecurityQuestionsReformer.h"
#import "WJSecurityQuestionModel.h"

@implementation WJUserSecurityQuestionsReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data{
    
    NSMutableArray * result = [NSMutableArray array];
    
    if ([data isKindOfClass:[NSArray class]]) {
        
        NSArray * dataArray = (NSArray *)data;
        
        for (int i = 0; i< [dataArray count]; i++) {
            NSDictionary * dic = [dataArray objectAtIndex:i];
            WJSecurityQuestionModel *question = [[WJSecurityQuestionModel alloc] initWithDictionary:dic];
            
            [result addObject:question];
        }
    }
    
    return result;
    
}

@end
