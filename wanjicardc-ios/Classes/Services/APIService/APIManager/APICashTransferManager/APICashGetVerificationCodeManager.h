//
//  APICashGetVerificationCodeManager.h
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APICashGetVerificationCodeManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property(nonatomic,strong)NSString       *phoneNum;

@end
