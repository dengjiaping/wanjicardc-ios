//
//  APIRealNameVerificationCodeManager.h
//  WanJiCard
//
//  Created by reborn on 16/6/20.
//  Copyright © 2016年 zOne. All rights reserved.
//

#import "APIBaseManager.h"

@interface APIRealNameVerificationCodeManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property (nonatomic, strong) NSString * realName;
@property (nonatomic, strong) NSString * cardNum;
@property (nonatomic, strong) NSString * bankCardNum;
@property (nonatomic, strong) NSString * phoneNum;




@end
