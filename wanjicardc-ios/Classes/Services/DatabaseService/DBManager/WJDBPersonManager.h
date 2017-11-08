//
//  WJDBPersonManager.h
//  WanJiCard
//
//  Created by Harry Hu on 15/9/1.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "BaseDBManager.h"
#import "WJModelPerson.h"


@interface WJDBPersonManager : BaseDBManager

- (BOOL)insertPerson:(WJModelPerson*)person;

- (BOOL)updatePerson:(WJModelPerson*)person;

- (BOOL)remove:(WJModelPerson *)person;


/**
 *  根据用户ID获取用户信息
 *
 *  @param userId
 *
 *  @return
 */
- (WJModelPerson *)getPersonById:(NSString *)userId;


/**
 *  根据电话号码获取用户信息
 *
 *  @param phone 电话号码
 *
 *  @return
 */
- (WJModelPerson *)getPersonByPhone:(NSString *)phone;


/**
 *  获得当前登录的用户信息
 *
 *  @return
 */
+ (WJModelPerson *)getDefaultPerson;


/**
 *  更新用户的支付密码秘钥
 *
 *  @param salt   秘钥
 *  @param person 用户
 *
 *  @return 是否更新成功
 */
- (BOOL)updatePersonSalt:(NSString *)salt
               forPerson:(WJModelPerson *)person;


@end
