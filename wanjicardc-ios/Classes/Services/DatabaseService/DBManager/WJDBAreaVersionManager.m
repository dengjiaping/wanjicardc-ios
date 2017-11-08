//
//  WJDBAreaVersionManager.m
//  WanJiCard
//
//  Created by Angie on 15/9/23.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJDBAreaVersionManager.h"
#import "WJSqliteBaseManager.h"

@implementation WJDBAreaVersionManager

- (instancetype)init{
    if (self = [super init]) {
        self.sqliteManager = [WJSqliteBaseManager sharedManager];
    }
    return self;
}

- (BOOL)insertAreaVersion:(NSInteger)versionNumber{
    [self.sqliteManager remove:@"WJKVersionInfo"
              withWhereClauses:@"1=1"
            withWhereArguments:nil];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    return [self.sqliteManager insert:@"WJKVersionInfo"
                   withColumnsInArray:@[@"VersionNumber", @"UpdateTime"]
                    withValuesInArray:@[@(versionNumber), @((NSInteger)time)]];
}

- (BOOL)updateAreaVersion:(NSInteger)versionNumber{
    
    return [self insertAreaVersion:versionNumber];
    
}

- (NSInteger)getAreaVersionNumber{
    FMResultSet *cursor = [self.sqliteManager querySql:@"select * from WJKVersionInfo order by VersionNumber desc"];
    NSInteger versionNumber = 0;
    while ([cursor next]) {
        versionNumber = (NSInteger)[cursor intForColumn:@"VersionNumber"];
        break;
    }
    [cursor close];
    return versionNumber;
}


@end
