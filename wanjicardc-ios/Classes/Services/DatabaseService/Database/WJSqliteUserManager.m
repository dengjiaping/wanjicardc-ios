//
//  WJSqliteUserManager.m
//  WanJiCard
//
//  Created by Angie on 15/9/22.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJSqliteUserManager.h"

#define DATABASE_USERDBNAME               @"User.db"

@implementation WJSqliteUserManager

static WJSqliteUserManager *sharedInstance = nil;

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WJSqliteUserManager alloc] initWithDBPath:DATABASE_USERDBNAME];
    });
    return sharedInstance;
}


- (void)upgradeTables
{
    if ([self.db open]) {
        
        NSString* sqlStr;
        
        if(![self.db tableExists:TABLE_CARD]) {
            sqlStr = @"CREATE TABLE [WJKCardsTable] (\
            [CardId]        text    NOT NULL,\
            [Name]          text    default NULL,\
            [FaceValue]     double  default 0,\
            [Cover]         text    default NULL,\
            [SaleNumber]    integer default 0,\
            [SalePrice]     double  default 0,\
            [CardStatus]    integer default 0,\
            [ColorType]     integer default 0,\
            [MerName]       text    default NULL,\
            [OwnUserId]     text    default NULL\
            )";
            [self.db executeUpdate:sqlStr];
        }
        
        if(![self.db tableExists:TABLE_PERSON]) {
            sqlStr = @"CREATE TABLE [WJKPersonsTable] (\
                [WJK_COLUMN1]   text primary key not null,\
                [WJK_COLUMN2]   text,\
                [WJK_COLUMN3]   text,\
                [WJK_COLUMN4]   text,\
                [WJK_COLUMN5]   text,\
                [WJK_COLUMN6]   text not null,\
                [WJK_COLUMN7]   integer default 0,\
                [WJK_COLUMN8]   text,\
                [WJK_COLUMN9]   text,\
                [WJK_COLUMN10]  integer default 0,\
                [WJK_COLUMN11]  text ,\
                [WJK_COLUMN12]  text ,\
                [WJK_COLUMN13]  text ,\
                [WJK_COLUMN14]  text ,\
                [WJK_COLUMN15]  text ,\
                [WJK_COLUMN16]  text ,\
                [WJK_COLUMN17]  text not null,\
                [WJK_COLUMN18]  text,\
                [WJK_COLUMN19]  integer default 0,\
                [WJK_COLUMN20]  integer default 0,\
                [WJK_COLUMN21]  integer default 0,\
                [WJK_COLUMN22]  integer default 0,\
                [WJK_COLUMN23]  integer default 0,\
                [WJK_COLUMN24]  text,\
                [WJK_COLUMN25]  integer default 0,\
                [WJK_COLUMN26]  integer default 0\
            );";
            [self.db executeUpdate:sqlStr];
            
            //倒数据库
            if ([self.db tableExists:@"WJKPersonTable"]) {
                if ([self.db columnExists:@"IsNewUser" inTableWithName:@"WJKPersonTable"]) {
                    sqlStr = @"insert or replace into WJKPersonsTable(\
                            WJK_COLUMN1, WJK_COLUMN2, WJK_COLUMN3,\
                            WJK_COLUMN4, WJK_COLUMN5, WJK_COLUMN6,\
                            WJK_COLUMN7, WJK_COLUMN8, WJK_COLUMN9,\
                            WJK_COLUMN10, WJK_COLUMN11, WJK_COLUMN12,\
                            WJK_COLUMN13, WJK_COLUMN14, WJK_COLUMN15,\
                            WJK_COLUMN16, WJK_COLUMN17, WJK_COLUMN18,\
                            WJK_COLUMN19, WJK_COLUMN20, WJK_COLUMN21,\
                            WJK_COLUMN22, WJK_COLUMN23, WJK_COLUMN24\
                        ) select \
                            [UserId], [ConsumerId], [UserName],\
                            [Realname], [NickName], [Phone],\
                            [UserLevel], [HeadImageUrl], [IDCard],\
                            [Gender], [BirthdayYear], [BirthdayMonth],\
                            [BirthdayDay], [Country], [Province],\
                            [City], [Token], [PayPassword],\
                            [IsActively], [IsSetPayPassword], [Authentication],\
                            [IsNewUser], [HasVerifyPayPsd], [PayPsdSalt]\
                        from WJKPersonTable;";
                }else{
                    sqlStr = @"insert or replace into WJKPersonsTable(\
                            WJK_COLUMN1, WJK_COLUMN2, WJK_COLUMN3,\
                            WJK_COLUMN4, WJK_COLUMN5, WJK_COLUMN6,\
                            WJK_COLUMN7, WJK_COLUMN8, WJK_COLUMN9,\
                            WJK_COLUMN10, WJK_COLUMN11, WJK_COLUMN12,\
                            WJK_COLUMN13, WJK_COLUMN14, WJK_COLUMN15,\
                            WJK_COLUMN16, WJK_COLUMN17, WJK_COLUMN18,\
                            WJK_COLUMN19, WJK_COLUMN20, WJK_COLUMN21\
                        ) select \
                            [UserId], [ConsumerId], [UserName],\
                            [Realname], [NickName], [Phone],\
                            [UserLevel], [HeadImageUrl], [IDCard],\
                            [Gender], [BirthdayYear], [BirthdayMonth],\
                            [BirthdayDay], [Country], [Province],\
                            [City], [Token], [PayPassword],\
                            [IsActively], [IsSetPayPassword], [Authentication]\
                        from WJKPersonTable;";
                }
                [self.db executeUpdate:sqlStr];

                [self.db executeQuery:@"drop table WJKPersonTable"];
            }
        }
        self.db.userVersion = DBVersion;
    }
}


- (BOOL)status{
    return (self.db.userVersion < DBVersion);
}

@end
