//
//  WJSecurityQuestionReformer.m
//  WanJiCard
//
//  Created by 孙明月 on 15/12/18.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJSecurityQuestionReformer.h"
#import "WJSecurityQuestionModel.h"
@implementation WJSecurityQuestionReformer
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
