//
//  APICashLoginManager.h
//  WanJiCard
//
//  Created by reborn on 16/11/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface APICashLoginManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>
@property (nonatomic, copy) NSString *loginname;    //  用户名
@property (nonatomic, copy) NSString *password;     //  密码
@property (nonatomic, copy) NSString *inviteCode;   //  邀请码

@end
