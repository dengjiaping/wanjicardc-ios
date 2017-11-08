//
//  WJSecurityQuestionModel.h
//  WanJiCard
//
//  Created by 孙明月 on 15/12/18.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJSecurityQuestionModel : NSObject

@property (strong,nonatomic) NSString *questionId;
@property (strong,nonatomic) NSString *question;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
