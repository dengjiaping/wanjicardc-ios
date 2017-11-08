//
//  APIUserQuestionManager.h
//  WanJiCard
//
//  Created by Lynn on 15/12/7.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIUserQuestionManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, assign) NSInteger   questionCount;
@property (nonatomic, strong) NSString  * phone;


@end
