//
//  WJSqliteBaseManager.m
//  WanJiCard
//
//  Created by Angie on 15/9/22.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJSqliteBaseManager.h"

#define DATABASE_BASEDBNAME               @"Base.db"

static WJSqliteBaseManager *sharedInstance = nil;

@implementation WJSqliteBaseManager

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WJSqliteBaseManager alloc] initWithDBPath:DATABASE_BASEDBNAME];
    });
    
    return sharedInstance;
}

+ (void)copyBaseData{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *soruceDBPath = [[NSBundle mainBundle] pathForResource:@"Base" ofType:@"db"];
    
    if (soruceDBPath) {
        NSString *destDBPath = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), DATABASE_FOLDER, DATABASE_BASEDBNAME];
        
        NSError *error = nil;
        if([WJUtilityMethod createDirectoryIfNotPresent:DATABASE_FOLDER] &&
           [fm fileExistsAtPath:destDBPath]){
            //如果已经存在，则删除已经存在的
            [fm removeItemAtPath:destDBPath error:&error];
        }
        
        BOOL result = [fm copyItemAtPath:soruceDBPath toPath:destDBPath error:&error];

        NSAssert(result, @"error = %@",error);
        
    }else{
        [[WJSqliteBaseManager sharedManager] upgradeTables];
    }

}

- (void)upgradeTables
{
    if ([self.db open]) {
        
        NSString* sqlStr;
        
        if (![self.db tableExists:@"WJKAreaTable"]) {
            sqlStr = @"CREATE TABLE [WJKAreaTable] (\
            [AreaId] TEXT NOT NULL,\
            [Name] TEXT DEFAULT NULL,\
            [Oname] TEXT DEFAULT NULL,\
            [OrderName] TEXT DEFAULT NULL,\
            [Level] INTEGER DEFAULT NULL,\
            [Parentid] TEXT NOT NULL,\
            [Ishot] Boolean NOT NULL,\
            [Lat] FLOAT NOT NULL,\
            [Lng] FLOAT NOT NULL,\
            [Zoom] INTEGER NOT NULL,\
            [Region] INTEGER NOT NULL,\
            [IsUse] Boolean NOT NULL,\
            [Resvered1] TEXT DEFAULT NULL,\
            [Resvered2] TEXT DEFAULT NULL,\
            [Resvered3] TEXT DEFAULT NULL,\
            [Resvered4] INTEGER DEFAULT 0,\
            [Resvered5] INTEGER DEFAULT 0\
            )";
            
            [self.db executeUpdate:sqlStr];
        }
        
        if (![self.db tableExists:@"WJKVersionInfo"]) {
            sqlStr = @"create table [WJKVersionInfo] (\
            [VersionNumber] INTEGER,\
            [UpdateTime] INTEGER )";
            [self.db executeUpdate:sqlStr];
            
        }
    }
}
@end
