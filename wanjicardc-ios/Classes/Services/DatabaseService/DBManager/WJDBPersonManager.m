//
//  WJDBPersonManager.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/1.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJSqliteUserManager.h"

#define InitPersionActively @"update WJKPersonsTable set WJK_COLUMN19 = 0"

@implementation WJDBPersonManager

- (instancetype)init{
    if (self = [super init]) {
        self.sqliteManager = [WJSqliteUserManager sharedManager];
    }
    return self;
}


- (BOOL)insertPerson:(WJModelPerson*)person{
    if (0 == person.userID) {
        NSLog(@"parameter is invalid");
        return NO;
    }
    
 
    [self.sqliteManager executeSQLUpdate:InitPersionActively];
    
    WJModelPerson *oldPerson=[self getPersonById:person.userID];
    if(oldPerson){
        oldPerson.isActively = YES;
        oldPerson.token = person.token;
        oldPerson.payPsdSalt = person.payPsdSalt;
        oldPerson.isSetPayPassword = person.isSetPayPassword;
        oldPerson.payPassword = person.payPassword;
        oldPerson.isNewUser = person.isNewUser;
        oldPerson.appealStatus = person.appealStatus;
        oldPerson.authentication = person.authentication;
        oldPerson.isSetPsdQuestion = person.isSetPsdQuestion;
        oldPerson.userName = person.userName;
        oldPerson.phone = person.phone;
        oldPerson.realName = person.realName;
        return [self updatePerson:oldPerson];
    }
    
    return [self.sqliteManager insert:TABLE_PERSON
                   withColumnsInArray:@[COL_PERSON_ID,              COL_PERSON_Consumer,
                                        COL_PERSON_UserName,        COL_PERSON_RealName,
                                        COL_PERSON_NichName,        COL_PERSON_Phone,
                                        COL_PERSON_UserLevel,       COL_PERSON_HeadImageUrl,
                                        COL_PERSON_IdCard,          COL_PERSON_Gender,
                                        COL_PERSON_BirthdayYear,    COL_PERSON_BirthdayMonth,
                                        COL_PERSON_BirthdayDay,     COL_PERSON_Country,
                                        COL_PERSON_Province,        COL_PERSON_City,
                                        COL_PERSON_Token,           COL_PERSON_PayPassword,
                                        COL_PERSON_IsActively,      COL_PERSON_IsSetPayPassword,
                                        COL_PERSON_Authentication,  COL_PERSON_IsNewUser,
                                        COL_PERSON_HasVerifyPayPsd, COL_PERSON_PayPsdSalt,
                                        COL_PERSON_IsSetPsdQuestion,COL_PERSON_AppealStatus]
                   withValuesInArray:@[person.userID,               person.consumerId?:@"",
                                       person.userName?:@"",        person.realName?:@"",
                                       person.nickName?:@"",        person.phone?:@"",
                                       @(person.userLevel),         person.headImageUrl?:@"",
                                       person.IDCard?:@"",          @(person.gender),
                                       person.birthdayYear?:@"2000", person.birthdayMonth?:@"01",
                                       person.birthdayDay?:@"01",   person.country?:@"中国",
                                       person.province?:@"北京",     person.city?:@"北京",
                                       person.token?:@"",           person.payPassword?:@"",
                                       @(person.isActively),        @(person.isSetPayPassword),
                                       @(person.authentication),    @(person.isNewUser),
                                       @(person.hasVerifyPayPassword), person.payPsdSalt,
                                       @(person.isSetPsdQuestion), @(person.appealStatus)]];
}

- (BOOL)updatePerson:(WJModelPerson*)person{
    NSDictionary *personDic = @{COL_PERSON_Consumer:        person.consumerId?:@"",
                                COL_PERSON_UserName:        person.userName?:@"",
                                COL_PERSON_RealName:        person.realName?:@"",
                                COL_PERSON_NichName:        person.nickName?:@"",
                                COL_PERSON_Phone:           person.phone?:@"",
                                COL_PERSON_UserLevel:       @(person.userLevel),
                                COL_PERSON_HeadImageUrl:    person.headImageUrl?:@"",
                                COL_PERSON_IdCard:          person.IDCard?:@"",
                                COL_PERSON_Gender:          @(person.gender),
                                COL_PERSON_BirthdayYear:    person.birthdayYear?:@"",
                                COL_PERSON_BirthdayMonth:   person.birthdayMonth?:@"",
                                COL_PERSON_BirthdayDay:     person.birthdayDay?:@"",
                                COL_PERSON_Country:         person.country?:@"",
                                COL_PERSON_Province:        person.province?:@"",
                                COL_PERSON_City:            person.city?:@"",
                                COL_PERSON_Token:           person.token?:@"",
                                COL_PERSON_PayPassword:     person.payPassword?:@"",
                                COL_PERSON_IsActively:      @(person.isActively),
                                COL_PERSON_IsSetPayPassword:@(person.isSetPayPassword),
                                COL_PERSON_Authentication:  @(person.authentication),
                                COL_PERSON_IsNewUser:       @(person.isNewUser),
                                COL_PERSON_HasVerifyPayPsd: @(person.hasVerifyPayPassword),
                                COL_PERSON_PayPsdSalt:      person.payPsdSalt?:@"",
                                COL_PERSON_IsSetPsdQuestion:@(person.isSetPsdQuestion),
                                COL_PERSON_AppealStatus:    @(person.appealStatus)};
    
    return [self.sqliteManager update:TABLE_PERSON
                    withSetDictionary:(NSDictionary *)personDic
                      withWhereClause:@"WJK_COLUMN1 = ?"
                   withWhereArguments:@[person.userID?:person.phone]];
}

- (BOOL)updatePersonSalt:(NSString *)salt
               forPerson:(WJModelPerson *)person{
    
    return [self.sqliteManager update:TABLE_PERSON
                    withSetDictionary:@{COL_PERSON_PayPsdSalt:salt}
                      withWhereClause:@"WJK_COLUMN1 = ?"
                   withWhereArguments:@[person.userID]];

}

- (BOOL)remove:(WJModelPerson *)person{
    if (person.userID.length == 0)
    {
        NSLog(@"person manager parameter is invalid");
        return NO;
    }
    
    return [self.sqliteManager remove:TABLE_PERSON
                                withWhereClauses:@"WJK_COLUMN1 = ?"
                              withWhereArguments:@[person.userID]];
}



#pragma mark - 具体API


- (WJModelPerson *)getPersonById:(NSString *)userId{
    FMResultSet *cursor = [self queryInTable:TABLE_PERSON
                            withWhereClauses:@"WJK_COLUMN1 = ?"
                          withWhereArguments:@[userId]
                                 withOrderBy:COL_PERSON_ID
                               withOrderType:ORDER_BY_ASC];
    
    WJModelPerson *person = nil;
    while ([cursor next]) {
        person = [[WJModelPerson alloc] initWithCursor:cursor];
        break;
    }
    [cursor close];

    return person;
}


- (WJModelPerson *)getPersonByPhone:(NSString *)phone{
    FMResultSet *cursor = [self queryInTable:TABLE_PERSON
                            withWhereClauses:@"WJK_COLUMN6 = ?"
                          withWhereArguments:@[phone]
                                 withOrderBy:COL_PERSON_ID
                               withOrderType:ORDER_BY_ASC];
    
    WJModelPerson *person = nil;
    while ([cursor next]) {
        person = [[WJModelPerson alloc] initWithCursor:cursor];
        break;
    }
    [cursor close];

    return person;
}


+ (WJModelPerson *)getDefaultPerson{
    
    WJDBPersonManager *manager = [WJDBPersonManager new];
    
    FMResultSet *cursor = [manager queryInTable:TABLE_PERSON
                               withWhereClauses:@"WJK_COLUMN19 = ?"
                             withWhereArguments:@[@(YES)]
                                    withOrderBy:COL_PERSON_ID
                                  withOrderType:ORDER_BY_NONE];
    
    WJModelPerson *person = nil;
    while ([cursor next]) {
        person = [[WJModelPerson alloc] initWithCursor:cursor];
        break;
    }
    [cursor close];

    return person;
}
@end
